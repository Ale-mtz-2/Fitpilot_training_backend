from __future__ import annotations

from datetime import date, datetime
from typing import Any

from sqlalchemy import (
    BigInteger,
    Boolean,
    Date,
    DateTime,
    Float,
    ForeignKey,
    Integer,
    String,
    Text,
)
from sqlalchemy.dialects.postgresql import ARRAY, JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column

from core.config import settings
from models.base import Base


TRAINING_SCHEMA = settings.TRAINING_SCHEMA
PUBLIC_SCHEMA = settings.PUBLIC_SCHEMA


class PublicUserCompat(Base):
    __tablename__ = "users"
    __table_args__ = {"schema": PUBLIC_SCHEMA}

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String, nullable=False)
    lastname: Mapped[str | None] = mapped_column(String, nullable=True)
    email: Mapped[str] = mapped_column(String, nullable=False)
    password: Mapped[str] = mapped_column(String, nullable=False)
    role: Mapped[str] = mapped_column(String, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    created_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)


class TrainingCompatOverride(Base):
    __tablename__ = "compat_overrides"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    entity_type: Mapped[str] = mapped_column(String, primary_key=True)
    entity_id: Mapped[str] = mapped_column(String, primary_key=True)
    data: Mapped[dict[str, Any]] = mapped_column(JSONB, nullable=False, default=dict)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=datetime.utcnow
    )


class TrainingMacrocycleCompat(Base):
    __tablename__ = "macrocycles"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    trainer_id: Mapped[int | None] = mapped_column(
        Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=True
    )
    client_id: Mapped[int | None] = mapped_column(
        Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=True
    )
    name: Mapped[str] = mapped_column(String, nullable=False)
    start_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    end_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    status: Mapped[str] = mapped_column(String, nullable=False, default="ACTIVE")


class TrainingMesocycleCompat(Base):
    __tablename__ = "mesocycles"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    macrocycle_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.macrocycles.id"), nullable=False
    )
    name: Mapped[str] = mapped_column(String, nullable=False)
    start_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    end_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    focus: Mapped[str | None] = mapped_column(String, nullable=True)


class TrainingMicrocycleCompat(Base):
    __tablename__ = "microcycles"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    mesocycle_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.mesocycles.id"), nullable=False
    )
    week_number: Mapped[int] = mapped_column(Integer, nullable=False)
    intensity_level: Mapped[str] = mapped_column(String, nullable=False, default="MEDIUM")


class TrainingDayCompat(Base):
    __tablename__ = "training_days"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    microcycle_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.microcycles.id"), nullable=False
    )
    day_number: Mapped[int] = mapped_column(Integer, nullable=False)
    name: Mapped[str | None] = mapped_column(String, nullable=True)
    is_rest_day: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)


class TrainingDayExerciseCompat(Base):
    __tablename__ = "day_exercises"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    training_day_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.training_days.id"), nullable=False
    )
    exercise_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    order_index: Mapped[int] = mapped_column(Integer, nullable=False)
    phase: Mapped[str] = mapped_column(String, nullable=False, default="MAIN")
    sets: Mapped[int] = mapped_column(Integer, nullable=False)
    reps_min: Mapped[int | None] = mapped_column(Integer, nullable=True)
    reps_max: Mapped[int | None] = mapped_column(Integer, nullable=True)
    rest_seconds: Mapped[int] = mapped_column(Integer, nullable=False, default=90)
    rpe_target: Mapped[float | None] = mapped_column(Float, nullable=True)
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)


class TrainingWorkoutLogCompat(Base):
    __tablename__ = "workout_logs"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    client_id: Mapped[int] = mapped_column(Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=False)
    training_day_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.training_days.id"), nullable=True
    )
    started_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    status: Mapped[str] = mapped_column(String, nullable=False, default="in_progress")
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)


class TrainingExerciseSetLogCompat(Base):
    __tablename__ = "exercise_set_logs"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    workout_log_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.workout_logs.id"), nullable=False
    )
    exercise_id: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    day_exercise_id: Mapped[int | None] = mapped_column(
        BigInteger, ForeignKey(f"{TRAINING_SCHEMA}.day_exercises.id"), nullable=True
    )
    set_number: Mapped[int] = mapped_column(Integer, nullable=False)
    reps: Mapped[int | None] = mapped_column(Integer, nullable=True)
    weight_kg: Mapped[float | None] = mapped_column(Float, nullable=True)
    rpe: Mapped[float | None] = mapped_column(Float, nullable=True)
    completed_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)


class TrainingClientInterviewCompat(Base):
    __tablename__ = "client_interviews"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    client_id: Mapped[int] = mapped_column(
        Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=False
    )
    experience_level: Mapped[str | None] = mapped_column(String, nullable=True)
    primary_goal: Mapped[str | None] = mapped_column(String, nullable=True)
    days_available: Mapped[int | None] = mapped_column(Integer, nullable=True)
    injuries: Mapped[str | None] = mapped_column(Text, nullable=True)
    equipment_available: Mapped[list[str] | None] = mapped_column(ARRAY(String), nullable=True)
    created_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)


class TrainingClientMetricCompat(Base):
    __tablename__ = "client_metrics"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    client_id: Mapped[int] = mapped_column(
        Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=False
    )
    metric_type: Mapped[str] = mapped_column(String, nullable=False)
    value: Mapped[float] = mapped_column(Float, nullable=False)
    unit: Mapped[str] = mapped_column(String, nullable=False)
    date: Mapped[date] = mapped_column(Date, nullable=False)
    created_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)
    updated_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)


class TrainingPatientContextSnapshotCompat(Base):
    __tablename__ = "patient_context_snapshots"
    __table_args__ = {"schema": TRAINING_SCHEMA}

    id: Mapped[str] = mapped_column(UUID(as_uuid=False), primary_key=True)
    client_id: Mapped[int] = mapped_column(
        Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=False
    )
    version: Mapped[str] = mapped_column(String, nullable=False)
    effective_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    source: Mapped[str | None] = mapped_column(String(50), nullable=True)
    data: Mapped[dict[str, Any]] = mapped_column(JSONB, nullable=False, default=dict)
    created_by: Mapped[int | None] = mapped_column(
        Integer, ForeignKey(f"{PUBLIC_SCHEMA}.users.id"), nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)

