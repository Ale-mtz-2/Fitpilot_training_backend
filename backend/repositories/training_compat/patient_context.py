from __future__ import annotations

from datetime import datetime
from typing import Optional
from uuid import uuid4

from sqlalchemy.orm import Session

from repositories.training_compat.client_interviews import get_interview_by_client_id
from repositories.training_compat.client_metrics import list_metrics
from repositories.training_compat.models import TrainingPatientContextSnapshotCompat
from repositories.training_compat.users import parse_user_id
from schemas.ai_generator import (
    AllergyItem,
    Anthropometrics,
    PatientConstraints,
    PatientContact,
    PatientContext,
    PatientIdentity,
    PatientInjury,
    PatientLifestyle,
    PatientMedicalHistory,
    PatientPreferences,
)


METRIC_KEY_MAP = {
    "weight": "weight_kg",
    "body_fat": "body_fat_pct",
    "chest": "chest_cm",
    "waist": "waist_cm",
    "hips": "hips_cm",
    "arms": "arms_cm",
    "thighs": "thighs_cm",
}


def _build_anthropometrics(client_id: str, db: Session) -> Anthropometrics | None:
    _, metrics = list_metrics(db, client_id=client_id, limit=1000)
    if not metrics:
        return None

    grouped: dict[str, list] = {}
    for metric in metrics:
        grouped.setdefault(metric.metric_type, []).append(metric)

    latest = {}
    trend = {}
    for metric_type, rows in grouped.items():
        ordered = sorted(rows, key=lambda m: m.date, reverse=True)
        key = METRIC_KEY_MAP.get(metric_type, metric_type)
        row_latest = ordered[0]
        latest[key] = {
            "value": row_latest.value,
            "unit": row_latest.unit,
            "date": row_latest.date.isoformat() if row_latest.date else None,
        }
        trend[key] = [
            {"date": r.date.isoformat() if r.date else None, "value": r.value}
            for r in ordered[:3]
        ]

    return Anthropometrics(latest=latest or None, trend=trend or None)


def build_patient_context(db: Session, client_id: str) -> Optional[PatientContext]:
    client_int = parse_user_id(client_id)
    if client_int is None:
        return None

    snapshot = (
        db.query(TrainingPatientContextSnapshotCompat)
        .filter(TrainingPatientContextSnapshotCompat.client_id == client_int)
        .order_by(TrainingPatientContextSnapshotCompat.effective_at.desc())
        .first()
    )
    if snapshot and snapshot.data:
        try:
            context = PatientContext(**snapshot.data)
            context.context_version = snapshot.version
            return context
        except Exception:
            pass

    interview = get_interview_by_client_id(db, client_int)
    anthropometrics = _build_anthropometrics(str(client_int), db)
    if not interview and not anthropometrics:
        return None

    payload = {
        "context_version": datetime.utcnow().isoformat(),
    }
    if interview:
        payload["identity"] = PatientIdentity(
            full_name=None,
            document_id=interview.document_id,
            sex=interview.gender,
            gender=interview.gender,
        )
        payload["contact"] = PatientContact(
            phone=interview.phone,
            email=None,
            emergency_contact_name=interview.emergency_contact_name,
            emergency_contact_phone=interview.emergency_contact_phone,
            address=interview.address,
        )
        payload["injuries"] = [
            PatientInjury(area=str(area), status="reported")
            for area in (interview.injury_areas or [])
            if area
        ]
        if interview.injury_details:
            payload["injuries"].append(
                PatientInjury(area="details", status="note", notes=interview.injury_details)
            )
        payload["lifestyle"] = PatientLifestyle(occupation=interview.occupation)
        payload["preferences"] = PatientPreferences(
            training_style=None,
            avoid_exercises=interview.excluded_exercises or [],
            environment=None,
        )
        payload["constraints"] = PatientConstraints(
            session_time_min=interview.session_duration_minutes,
            days_per_week=interview.days_per_week,
            equipment=interview.available_equipment or [],
            mobility_limitations=interview.mobility_limitations,
            notes=interview.notes,
        )
        if interview.specific_goals_text:
            payload["goals"] = [interview.specific_goals_text]
        payload["medical_history"] = PatientMedicalHistory(
            conditions=[{"name": cond} for cond in (interview.medical_conditions or [])],
            medications=[],
            allergies=[AllergyItem(substance=area) for area in (interview.injury_areas or []) if area],
            contraindications=[],
        )

    if anthropometrics:
        payload["anthropometrics"] = anthropometrics

    return PatientContext(**payload)


def save_patient_context_snapshot(
    db: Session,
    *,
    client_id: str,
    data: PatientContext,
    created_by: str | None = None,
    source: str = "api",
    effective_at: datetime | None = None,
) -> TrainingPatientContextSnapshotCompat:
    client_int = parse_user_id(client_id)
    if client_int is None:
        raise ValueError("Invalid client_id")
    created_by_int = parse_user_id(created_by) if created_by is not None else None

    snapshot = TrainingPatientContextSnapshotCompat(
        id=str(uuid4()),
        client_id=client_int,
        version=str(uuid4()),
        effective_at=effective_at or datetime.utcnow(),
        source=source,
        data=data.model_dump(),
        created_by=created_by_int,
        created_at=datetime.utcnow(),
    )
    db.add(snapshot)
    db.flush()
    return snapshot

