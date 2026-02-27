from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from enum import Enum
from typing import Any, Optional

from sqlalchemy.orm import Session

from repositories.training_compat.models import TrainingClientInterviewCompat
from repositories.training_compat.overrides import (
    delete_override_data,
    get_override_data,
    upsert_override_data,
)
from repositories.training_compat.users import parse_user_id


def _to_plain(value: Any) -> Any:
    if isinstance(value, Enum):
        return value.value
    if isinstance(value, list):
        return [_to_plain(v) for v in value]
    if isinstance(value, dict):
        return {k: _to_plain(v) for k, v in value.items()}
    return value


def _parse_datetime(value: Any) -> datetime | None:
    if isinstance(value, datetime):
        return value
    if isinstance(value, str) and value:
        try:
            return datetime.fromisoformat(value.replace("Z", "+00:00"))
        except ValueError:
            return None
    return None


@dataclass
class CompatInterview:
    id: str
    client_id: str
    document_id: str | None = None
    age: int | None = None
    gender: str | None = None
    occupation: str | None = None
    phone: str | None = None
    address: str | None = None
    emergency_contact_name: str | None = None
    emergency_contact_phone: str | None = None
    insurance_provider: str | None = None
    policy_number: str | None = None
    weight_kg: float | None = None
    height_cm: float | None = None
    training_experience_months: int | None = None
    experience_level: str | None = None
    primary_goal: str | None = None
    target_muscle_groups: list[str] | None = None
    specific_goals_text: str | None = None
    days_per_week: int | None = None
    session_duration_minutes: int | None = None
    preferred_days: list[int] | None = None
    has_gym_access: bool | None = None
    available_equipment: list[str] | None = None
    equipment_notes: str | None = None
    injury_areas: list[str] | None = None
    injury_details: str | None = None
    excluded_exercises: list[str] | None = None
    medical_conditions: list[str] | None = None
    mobility_limitations: str | None = None
    notes: str | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None

    def is_complete_for_ai(self) -> tuple[bool, list[str]]:
        missing: list[str] = []
        if not self.experience_level:
            missing.append("experience_level")
        if not self.primary_goal:
            missing.append("primary_goal")
        if not self.days_per_week:
            missing.append("days_per_week")
        if not self.session_duration_minutes:
            missing.append("session_duration_minutes")
        if self.has_gym_access is None:
            missing.append("has_gym_access")
        if not self.available_equipment:
            missing.append("available_equipment")
        return (len(missing) == 0, missing)


def _base_interview_payload(row: TrainingClientInterviewCompat) -> dict[str, Any]:
    return {
        "id": str(row.id),
        "client_id": str(row.client_id),
        "experience_level": row.experience_level,
        "primary_goal": row.primary_goal,
        "days_per_week": row.days_available,
        "injury_details": row.injuries,
        "available_equipment": row.equipment_available or [],
        "created_at": row.created_at,
    }


def _payload_to_override(payload: dict[str, Any]) -> dict[str, Any]:
    now = datetime.utcnow().isoformat()
    plain = {k: _to_plain(v) for k, v in payload.items() if k != "client_id"}
    plain["updated_at"] = now
    return plain


def get_interview_by_client_id(db: Session, client_id: str | int) -> Optional[CompatInterview]:
    client_int = parse_user_id(client_id)
    if client_int is None:
        return None
    row = db.query(TrainingClientInterviewCompat).filter(
        TrainingClientInterviewCompat.client_id == client_int
    ).first()
    if not row:
        return None

    entity_id = str(client_int)
    payload = _base_interview_payload(row)
    payload.update(get_override_data(db, "client_interview", entity_id))

    payload.setdefault("id", str(row.id))
    payload.setdefault("client_id", str(client_int))
    payload.setdefault("created_at", row.created_at)
    payload.setdefault("updated_at", payload.get("created_at"))

    created = _parse_datetime(payload.get("created_at")) or row.created_at or datetime.utcnow()
    updated = _parse_datetime(payload.get("updated_at")) or created
    payload["created_at"] = created
    payload["updated_at"] = updated

    return CompatInterview(**payload)


def upsert_interview(
    db: Session,
    *,
    client_id: str | int,
    payload: dict[str, Any],
) -> CompatInterview:
    client_int = parse_user_id(client_id)
    if client_int is None:
        raise ValueError("Invalid client_id")

    row = db.query(TrainingClientInterviewCompat).filter(
        TrainingClientInterviewCompat.client_id == client_int
    ).first()
    if not row:
        row = TrainingClientInterviewCompat(client_id=client_int, created_at=datetime.utcnow())
        db.add(row)
        db.flush()

    row.experience_level = _to_plain(payload.get("experience_level"))
    row.primary_goal = _to_plain(payload.get("primary_goal"))
    row.days_available = payload.get("days_per_week")

    injury_details = payload.get("injury_details")
    injury_areas = payload.get("injury_areas") or []
    if injury_details:
        row.injuries = str(injury_details)
    elif injury_areas:
        row.injuries = ", ".join(str(a) for a in injury_areas if a is not None)
    else:
        row.injuries = None

    equipment = payload.get("available_equipment")
    row.equipment_available = [_to_plain(v) for v in equipment] if equipment else None
    db.flush()

    upsert_override_data(
        db,
        entity_type="client_interview",
        entity_id=str(client_int),
        data=_payload_to_override(payload),
        merge=True,
    )
    db.flush()
    interview = get_interview_by_client_id(db, client_int)
    if interview is None:
        raise RuntimeError("Unable to read interview after upsert")
    return interview


def delete_interview(db: Session, *, client_id: str | int) -> bool:
    client_int = parse_user_id(client_id)
    if client_int is None:
        return False
    row = db.query(TrainingClientInterviewCompat).filter(
        TrainingClientInterviewCompat.client_id == client_int
    ).first()
    if not row:
        return False
    db.delete(row)
    delete_override_data(db, entity_type="client_interview", entity_id=str(client_int))
    return True
