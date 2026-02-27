from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

from sqlalchemy.dialects.postgresql import insert
from sqlalchemy.orm import Session

from repositories.training_compat.models import TrainingCompatOverride


def get_override_data(db: Session, entity_type: str, entity_id: str) -> dict[str, Any]:
    row = db.query(TrainingCompatOverride).filter(
        TrainingCompatOverride.entity_type == entity_type,
        TrainingCompatOverride.entity_id == entity_id,
    ).first()
    return dict(row.data or {}) if row else {}


def upsert_override_data(
    db: Session,
    entity_type: str,
    entity_id: str,
    data: dict[str, Any],
    merge: bool = True,
) -> None:
    if merge:
        existing = get_override_data(db, entity_type=entity_type, entity_id=entity_id)
        payload = {**existing, **data}
    else:
        payload = dict(data)

    stmt = insert(TrainingCompatOverride).values(
        entity_type=entity_type,
        entity_id=entity_id,
        data=payload,
        updated_at=datetime.now(timezone.utc),
    )
    stmt = stmt.on_conflict_do_update(
        index_elements=[TrainingCompatOverride.entity_type, TrainingCompatOverride.entity_id],
        set_={
            "data": stmt.excluded.data,
            "updated_at": stmt.excluded.updated_at,
        },
    )
    db.execute(stmt)


def delete_override_data(db: Session, entity_type: str, entity_id: str) -> bool:
    deleted = (
        db.query(TrainingCompatOverride)
        .filter(
            TrainingCompatOverride.entity_type == entity_type,
            TrainingCompatOverride.entity_id == entity_id,
        )
        .delete(synchronize_session=False)
    )
    return bool(deleted)
