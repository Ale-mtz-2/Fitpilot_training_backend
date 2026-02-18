from sqlalchemy import Column, String, Text, Integer, DateTime, ForeignKey, Enum, Float, Date
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from models.base import Base


class WorkoutStatus(str, enum.Enum):
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    ABANDONED = "abandoned"


class AbandonReason(str, enum.Enum):
    """Razones por las que un entrenamiento fue abandonado"""
    TIME = "time"              # No tuvo tiempo
    INJURY = "injury"          # Lesión/dolor
    FATIGUE = "fatigue"        # Fatiga acumulada
    MOTIVATION = "motivation"  # Falta de motivación
    SCHEDULE = "schedule"      # Conflicto de horario
    OTHER = "other"            # Otro


class WorkoutLog(Base):
    """Registro de una sesión de entrenamiento realizada por un cliente"""
    __tablename__ = "workout_logs"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    client_id = Column(String, ForeignKey("users.id"), nullable=False, index=True)
    training_day_id = Column(String, ForeignKey("training_days.id"), nullable=False, index=True)
    started_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    completed_at = Column(DateTime, nullable=True)
    # values_callable para usar los valores del enum (lowercase) en vez de los nombres (UPPERCASE)
    status = Column(
        Enum(WorkoutStatus, values_callable=lambda e: [member.value for member in e]),
        default=WorkoutStatus.IN_PROGRESS,
        nullable=False
    )
    notes = Column(Text, nullable=True)

    # Campos para tracking de abandono
    abandon_reason = Column(
        Enum(AbandonReason, values_callable=lambda e: [member.value for member in e]),
        nullable=True
    )
    abandon_notes = Column(Text, nullable=True)  # Notas adicionales sobre el abandono

    # Campos para reagendamiento
    rescheduled_to_date = Column(Date, nullable=True)  # Nueva fecha si se reagendó

    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    client = relationship("User", foreign_keys=[client_id])
    training_day = relationship("TrainingDay", foreign_keys=[training_day_id])
    exercise_sets = relationship("ExerciseSetLog", back_populates="workout_log", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<WorkoutLog {self.id[:8]} - {self.status}>"


class ExerciseSetLog(Base):
    """Registro de cada serie realizada durante un entrenamiento"""
    __tablename__ = "exercise_set_logs"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    workout_log_id = Column(String, ForeignKey("workout_logs.id"), nullable=False, index=True)
    day_exercise_id = Column(String, ForeignKey("day_exercises.id"), nullable=False, index=True)
    set_number = Column(Integer, nullable=False)  # 1, 2, 3... (número de serie)
    reps_completed = Column(Integer, nullable=False)  # Repeticiones completadas
    weight_kg = Column(Float, nullable=True)  # Peso usado (nullable para ejercicios con peso corporal)
    effort_value = Column(Float, nullable=True)  # RIR/RPE registrado por el usuario
    completed_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    workout_log = relationship("WorkoutLog", back_populates="exercise_sets")
    day_exercise = relationship("DayExercise", foreign_keys=[day_exercise_id])

    def __repr__(self):
        return f"<ExerciseSetLog Set {self.set_number}: {self.reps_completed} reps @ {self.weight_kg}kg>"
