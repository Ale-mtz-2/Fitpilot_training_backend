from sqlalchemy import Column, String, Text, Integer, Boolean, Date, DateTime, ForeignKey, Enum, Float
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from models.base import Base


class MesocycleStatus(str, enum.Enum):
    DRAFT = "draft"
    ACTIVE = "active"
    COMPLETED = "completed"
    ARCHIVED = "archived"


class IntensityLevel(str, enum.Enum):
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    DELOAD = "deload"


class EffortType(str, enum.Enum):
    RIR = "RIR"  # Reps in Reserve
    RPE = "RPE"  # Rate of Perceived Exertion
    PERCENTAGE = "percentage"  # Percentage of 1RM


class TempoType(str, enum.Enum):
    CONTROLLED = "controlled"  # 3-1-2-0 - Emphasis on eccentric
    EXPLOSIVE = "explosive"    # 2-0-1-0 - Maximum speed on concentric
    TUT = "tut"                # 4-1-3-1 - Time Under Tension
    STANDARD = "standard"      # 2-0-2-0 - Balanced rhythm
    PAUSE_REP = "pause_rep"    # 2-2-2-0 - Pause at max tension


class SetType(str, enum.Enum):
    STRAIGHT = "straight"      # Standard sets with full rest
    REST_PAUSE = "rest_pause"  # Brief pauses to extend the set
    DROP_SET = "drop_set"      # Weight reduction without rest
    TOP_SET = "top_set"        # Main set with maximum effort
    BACKOFF = "backoff"        # Unloading sets with less weight
    MYO_REPS = "myo_reps"      # Activation set + mini-sets
    CLUSTER = "cluster"        # Intra-set micro-pauses


class ExercisePhase(str, enum.Enum):
    WARMUP = "warmup"      # Calentamiento
    MAIN = "main"          # Entrenamiento principal
    COOLDOWN = "cooldown"  # Enfriamiento


class Macrocycle(Base):
    __tablename__ = "macrocycles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    description = Column(Text)
    objective = Column(String, nullable=False)  # hypertrophy, strength, endurance, etc.
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    status = Column(Enum(MesocycleStatus), default=MesocycleStatus.DRAFT, nullable=False)
    trainer_id = Column(String, ForeignKey("users.id"), nullable=False)
    client_id = Column(String, ForeignKey("users.id"), nullable=True)  # NULL = template, not assigned to client
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    trainer = relationship("User", foreign_keys=[trainer_id], back_populates="created_macrocycles")
    client = relationship("User", foreign_keys=[client_id], back_populates="assigned_macrocycles")
    mesocycles = relationship("Mesocycle", back_populates="macrocycle", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Macrocycle {self.name} ({self.status})>"


class Mesocycle(Base):
    """A mesocycle represents a training block within a macrocycle (typically 3-6 weeks)"""
    __tablename__ = "mesocycles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    macrocycle_id = Column(String, ForeignKey("macrocycles.id"), nullable=False)
    block_number = Column(Integer, nullable=False)  # Order within the macrocycle
    name = Column(String, nullable=False)
    description = Column(Text)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    focus = Column(String)  # e.g., "Hypertrophy", "Strength", "Peaking", "Deload"
    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    macrocycle = relationship("Macrocycle", back_populates="mesocycles")
    microcycles = relationship("Microcycle", back_populates="mesocycle", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Mesocycle Block {self.block_number}: {self.name}>"


class Microcycle(Base):
    __tablename__ = "microcycles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    mesocycle_id = Column(String, ForeignKey("mesocycles.id"), nullable=False)
    week_number = Column(Integer, nullable=False)
    name = Column(String, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    intensity_level = Column(Enum(IntensityLevel), default=IntensityLevel.MEDIUM, nullable=False)
    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    mesocycle = relationship("Mesocycle", back_populates="microcycles")
    training_days = relationship("TrainingDay", back_populates="microcycle", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Microcycle Week {self.week_number}: {self.name}>"


class TrainingDay(Base):
    __tablename__ = "training_days"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    microcycle_id = Column(String, ForeignKey("microcycles.id"), nullable=False)
    day_number = Column(Integer, nullable=False)  # 1-7 (Monday-Sunday)
    date = Column(Date, nullable=False)
    name = Column(String, nullable=False)  # e.g., "Upper Body Push", "Leg Day"
    focus = Column(String)  # e.g., "Chest & Triceps"
    rest_day = Column(Boolean, default=False, nullable=False)
    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    microcycle = relationship("Microcycle", back_populates="training_days")
    exercises = relationship("DayExercise", back_populates="training_day", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<TrainingDay {self.name} on {self.date}>"


class DayExercise(Base):
    __tablename__ = "day_exercises"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    training_day_id = Column(String, ForeignKey("training_days.id"), nullable=False)
    exercise_id = Column(String, ForeignKey("exercises.id"), nullable=False)
    order_index = Column(Integer, nullable=False)  # Order within the day
    phase = Column(Enum(ExercisePhase), default=ExercisePhase.MAIN, nullable=False)  # warmup, main, cooldown

    # Campos para ejercicios de FUERZA
    sets = Column(Integer, nullable=False)
    reps_min = Column(Integer, nullable=True)  # Nullable para ejercicios basados en tiempo
    reps_max = Column(Integer, nullable=True)  # Nullable para ejercicios basados en tiempo
    rest_seconds = Column(Integer, nullable=False)
    effort_type = Column(Enum(EffortType), nullable=False)
    effort_value = Column(Float, nullable=False)  # RIR value, RPE value, or percentage
    tempo = Column(String)  # TempoType value or legacy tempo string (e.g., "3-1-1-0")
    set_type = Column(String)  # SetType value (e.g., "straight", "drop_set")

    # Campos para ejercicios de CARDIO (LISS/MISS/HIIT)
    duration_seconds = Column(Integer, nullable=True)  # Duración total (30-3600 segundos)
    intensity_zone = Column(Integer, nullable=True)  # Zona de frecuencia cardíaca (1-5)
    distance_meters = Column(Integer, nullable=True)  # Distancia objetivo en metros
    target_calories = Column(Integer, nullable=True)  # Calorías objetivo

    # Campos específicos para HIIT
    intervals = Column(Integer, nullable=True)  # Número de intervalos
    work_seconds = Column(Integer, nullable=True)  # Duración del intervalo de trabajo
    interval_rest_seconds = Column(Integer, nullable=True)  # Descanso entre intervalos

    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    training_day = relationship("TrainingDay", back_populates="exercises")
    exercise = relationship("Exercise", back_populates="day_exercises")

    def __repr__(self):
        exercise_name = self.exercise.name_en if self.exercise else 'Unknown'
        if self.duration_seconds:
            return f"<DayExercise {exercise_name}: {self.sets}x{self.duration_seconds}s>"
        return f"<DayExercise {exercise_name}: {self.sets}x{self.reps_min}-{self.reps_max}>"
