from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime
from enum import Enum
from typing import Any, Optional

from sqlalchemy import desc
from sqlalchemy.orm import Session

from repositories.training_compat.models import TrainingClientMetricCompat
from repositories.training_compat.users import parse_user_id


def _to_plain(value: Any) -> Any:
    if isinstance(value, Enum):
        return value.value
    return value


@dataclass
class CompatClientMetric:
    id: str
    client_id: str
    metric_type: str
    value: float
    unit: str
    date: date
    created_at: datetime
    updated_at: datetime


def to_metric(record: TrainingClientMetricCompat) -> CompatClientMetric:
    created_at = record.created_at or datetime.utcnow()
    updated_at = record.updated_at or created_at
    return CompatClientMetric(
        id=str(record.id),
        client_id=str(record.client_id),
        metric_type=record.metric_type,
        value=float(record.value),
        unit=record.unit,
        date=record.date,
        created_at=created_at,
        updated_at=updated_at,
    )


def list_metrics(
    db: Session,
    *,
    client_id: str | int,
    metric_type: str | None = None,
    start_date: date | None = None,
    end_date: date | None = None,
    skip: int = 0,
    limit: int = 100,
) -> tuple[int, list[CompatClientMetric]]:
    client_int = parse_user_id(client_id)
    if client_int is None:
        return (0, [])

    query = db.query(TrainingClientMetricCompat).filter(TrainingClientMetricCompat.client_id == client_int)
    if metric_type:
        query = query.filter(TrainingClientMetricCompat.metric_type == metric_type)
    if start_date:
        query = query.filter(TrainingClientMetricCompat.date >= start_date)
    if end_date:
        query = query.filter(TrainingClientMetricCompat.date <= end_date)

    total = query.count()
    rows = query.order_by(desc(TrainingClientMetricCompat.date)).offset(skip).limit(limit).all()
    return (total, [to_metric(row) for row in rows])


def create_metric(
    db: Session,
    *,
    client_id: str | int,
    metric_type: str,
    value: float,
    unit: str,
    metric_date: date,
) -> CompatClientMetric:
    client_int = parse_user_id(client_id)
    if client_int is None:
        raise ValueError("Invalid client_id")
    now = datetime.utcnow()
    row = TrainingClientMetricCompat(
        client_id=client_int,
        metric_type=metric_type,
        value=value,
        unit=unit,
        date=metric_date,
        created_at=now,
        updated_at=now,
    )
    db.add(row)
    db.flush()
    return to_metric(row)


def get_metric(db: Session, metric_id: str | int) -> Optional[CompatClientMetric]:
    metric_int = parse_user_id(metric_id)
    if metric_int is None:
        return None
    row = db.query(TrainingClientMetricCompat).filter(TrainingClientMetricCompat.id == metric_int).first()
    return to_metric(row) if row else None


def update_metric(
    db: Session,
    *,
    metric_id: str | int,
    payload: dict[str, Any],
) -> Optional[CompatClientMetric]:
    metric_int = parse_user_id(metric_id)
    if metric_int is None:
        return None
    row = db.query(TrainingClientMetricCompat).filter(TrainingClientMetricCompat.id == metric_int).first()
    if not row:
        return None

    if "metric_type" in payload and payload["metric_type"] is not None:
        row.metric_type = _to_plain(payload["metric_type"])
    if "value" in payload and payload["value"] is not None:
        row.value = float(payload["value"])
    if "unit" in payload and payload["unit"] is not None:
        row.unit = str(payload["unit"])
    if "date" in payload and payload["date"] is not None:
        row.date = payload["date"]
    row.updated_at = datetime.utcnow()
    db.flush()
    return to_metric(row)


def delete_metric(db: Session, metric_id: str | int) -> bool:
    metric_int = parse_user_id(metric_id)
    if metric_int is None:
        return False
    row = db.query(TrainingClientMetricCompat).filter(TrainingClientMetricCompat.id == metric_int).first()
    if not row:
        return False
    db.delete(row)
    return True
