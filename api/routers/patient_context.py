from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime

from core.dependencies import get_current_user
from models.base import get_db
from models.user import User, UserRole
from services.patient_context import build_patient_context, save_patient_context_snapshot
from schemas.ai_generator import PatientContext

router = APIRouter()


@router.get("/patients/{client_id}/context", response_model=PatientContext)
def get_patient_context(
    client_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Obtiene un PatientContext construido desde la entrevista y métricas del cliente.

    No persiste datos nuevos; sirve para IA y revisión clínica rápida.
    """
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo entrenadores o admins pueden consultar el contexto de pacientes"
        )

    context = build_patient_context(db, client_id)
    if not context:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No hay datos suficientes para construir el contexto del paciente"
        )
    return context


@router.post("/patients/{client_id}/context", response_model=PatientContext, status_code=status.HTTP_201_CREATED)
def create_patient_context_snapshot(
    client_id: str,
    payload: PatientContext,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Guarda un snapshot versionado de PatientContext.
    """
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo entrenadores o admins pueden guardar el contexto de pacientes"
        )

    snapshot = save_patient_context_snapshot(
        db=db,
        client_id=client_id,
        data=payload,
        created_by=current_user.id,
        source="api",
        effective_at=datetime.utcnow(),
    )
    # Devolver payload con context_version asignada
    payload.context_version = snapshot.version
    return payload


@router.get("/patients/me/context", response_model=PatientContext)
def get_my_patient_context(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Permite que un cliente vea su propio contexto (sin exponer PII a otros).
    """
    if current_user.role != UserRole.CLIENT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo clientes pueden consultar su propio contexto"
        )

    context = build_patient_context(db, current_user.id)
    if not context:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No hay datos suficientes para construir tu contexto"
        )
    return context
