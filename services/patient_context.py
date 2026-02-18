"""
Servicio para ensamblar un PatientContext compacto a partir de los datos existentes
(entrevista y métricas) sin requerir cambios de base de datos.
"""
from __future__ import annotations

from typing import Optional, Dict, List
from datetime import datetime
from uuid import uuid4
from sqlalchemy.orm import Session

from models.client_interview import ClientInterview
from models.client_metric import ClientMetric, MetricType
from models.patient_context import PatientContextSnapshot
from schemas.ai_generator import (
    PatientContext,
    PatientIdentity,
    PatientContact,
    Anthropometrics,
    PatientMedicalHistory,
    AllergyItem,
    PatientInjury,
    PatientLifestyle,
    PatientPreferences,
    PatientConstraints,
)

# Número máximo de puntos por métrica para evitar inflar el prompt
MAX_TREND_POINTS = 3


METRIC_KEY_MAP: Dict[MetricType, str] = {
    MetricType.WEIGHT: "weight_kg",
    MetricType.BODY_FAT: "body_fat_pct",
    MetricType.CHEST: "chest_cm",
    MetricType.WAIST: "waist_cm",
    MetricType.HIPS: "hips_cm",
    MetricType.ARMS: "arms_cm",
    MetricType.THIGHS: "thighs_cm",
}


def _build_anthropometrics(metrics: List[ClientMetric]) -> Optional[Anthropometrics]:
    if not metrics:
        return None

    latest_values: Dict[str, Dict[str, object]] = {}
    trend: Dict[str, List[Dict[str, object]]] = {}

    for metric_type in MetricType:
        typed = [m for m in metrics if m.metric_type == metric_type]
        if not typed:
            continue

        typed.sort(key=lambda m: m.date, reverse=True)
        key = METRIC_KEY_MAP.get(metric_type, metric_type.value)

        latest = typed[0]
        latest_values[key] = {
            "value": latest.value,
            "unit": latest.unit,
            "date": latest.date.isoformat() if latest.date else None,
        }

        trend[key] = [
            {"date": m.date.isoformat() if m.date else None, "value": m.value}
            for m in typed[:MAX_TREND_POINTS]
        ]

    return Anthropometrics(latest=latest_values or None, trend=trend or None)


def _build_injuries(interview: ClientInterview) -> List[PatientInjury]:
    injuries: List[PatientInjury] = []
    if interview.injury_areas:
        for area in interview.injury_areas:
            injuries.append(PatientInjury(area=area, status="reported"))
    if interview.injury_details:
        injuries.append(PatientInjury(area="details", notes=interview.injury_details, status="note"))
    return injuries


def build_patient_context(db: Session, client_id: str) -> Optional[PatientContext]:
    """
    Ensambla PatientContext priorizando el último snapshot persistido.
    Si no existe snapshot, lo construye desde entrevista + métricas.
    Retorna None si no hay datos disponibles.
    """
    # 1) Intentar snapshot persistido
    snapshot = (
        db.query(PatientContextSnapshot)
        .filter(PatientContextSnapshot.client_id == client_id)
        .order_by(PatientContextSnapshot.effective_at.desc())
        .first()
    )
    if snapshot and snapshot.data:
        try:
            ctx = PatientContext(**snapshot.data)
            ctx.context_version = snapshot.version
            return ctx
        except Exception:
            # Si falla parseo, continuar con fallback
            pass

    # 2) Fallback: entrevista + métricas
    interview = db.query(ClientInterview).filter(ClientInterview.client_id == client_id).first()
    metrics = db.query(ClientMetric).filter(ClientMetric.client_id == client_id).all()

    if not interview and not metrics:
        return None

    context: Dict[str, object] = {
        "context_version": datetime.utcnow().isoformat(),
    }

    if interview:
        context["identity"] = PatientIdentity(
            full_name=None,  # Evitamos PII innecesaria en el prompt
            document_id=None,
            sex=interview.gender.value if interview.gender else None,
        )
        context["contact"] = PatientContact(
            phone=None,
            emergency_contact_name=None,
            emergency_contact_phone=None,
        )
        context["injuries"] = _build_injuries(interview)
        context["lifestyle"] = PatientLifestyle(
            occupation=interview.occupation,
        )
        context["preferences"] = PatientPreferences(
            training_style=None,
            avoid_exercises=interview.excluded_exercises or [],
        )
        context["constraints"] = PatientConstraints(
            session_time_min=interview.session_duration_minutes,
            days_per_week=interview.days_per_week,
            mobility_limitations=interview.mobility_limitations,
            equipment=interview.available_equipment or [],
        )
        context["goals"] = [interview.specific_goals_text] if interview.specific_goals_text else None

        # Antecedentes básicos desde entrevista
        context["medical_history"] = PatientMedicalHistory(
            conditions=[{"name": cond} for cond in (interview.medical_conditions or [])],
            medications=[],
            allergies=[AllergyItem(substance=a) for a in (interview.injury_areas or []) if a],
            contraindications=[],
        )

    if metrics:
        context["anthropometrics"] = _build_anthropometrics(metrics)

    # Limpieza para evitar nulos vacíos
    patient_context = PatientContext(**{k: v for k, v in context.items() if v})
    return patient_context


def save_patient_context_snapshot(
    db: Session,
    client_id: str,
    data: PatientContext,
    created_by: Optional[str] = None,
    source: str = "api",
    effective_at: Optional[datetime] = None,
) -> PatientContextSnapshot:
    """
    Persiste un snapshot de PatientContext para trazabilidad/versionado.
    """
    version = str(uuid4())
    effective = effective_at or datetime.utcnow()
    snapshot = PatientContextSnapshot(
        client_id=client_id,
        version=version,
        effective_at=effective,
        source=source,
        data=data.model_dump(),
        created_by=created_by,
    )
    db.add(snapshot)
    db.commit()
    db.refresh(snapshot)
    return snapshot
