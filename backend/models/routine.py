from sqlalchemy import Column, String, Text, Integer, Boolean, Date, DateTime, ForeignKey, Enum, Float
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from backend.models.base import Base


class RoutineStatus(str, enum.Enum):
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


class Macrocycle(Base):
    __tablename__ = "macrocycles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    description = Column(Text)
    objective = Column(String, nullable=False)  # hypertrophy, strength, endurance, etc.
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    status = Column(Enum(RoutineStatus), default=RoutineStatus.DRAFT, nullable=False)
    trainer_id = Column(String, ForeignKey("users.id"), nullable=False)
    client_id = Column(String, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    trainer = relationship("User", foreign_keys=[trainer_id], back_populates="created_macrocycles")
    client = relationship("User", foreign_keys=[client_id], back_populates="assigned_macrocycles")
    microcycles = relationship("Microcycle", back_populates="macrocycle", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Macrocycle {self.name} ({self.status})>"


class Microcycle(Base):
    __tablename__ = "microcycles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    macrocycle_id = Column(String, ForeignKey("macrocycles.id"), nullable=False)
    week_number = Column(Integer, nullable=False)
    name = Column(String, nullable=False)
    start_date = Column(Date, nullable=False)
    end_date = Column(Date, nullable=False)
    intensity_level = Column(Enum(IntensityLevel), default=IntensityLevel.MEDIUM, nullable=False)
    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    macrocycle = relationship("Macrocycle", back_populates="microcycles")
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
    sets = Column(Integer, nullable=False)
    reps_min = Column(Integer, nullable=False)
    reps_max = Column(Integer, nullable=False)
    rest_seconds = Column(Integer, nullable=False)
    effort_type = Column(Enum(EffortType), nullable=False)
    effort_value = Column(Float, nullable=False)  # RIR value, RPE value, or percentage
    tempo = Column(String)  # e.g., "3-1-1-0" (eccentric-pause-concentric-pause)
    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    training_day = relationship("TrainingDay", back_populates="exercises")
    exercise = relationship("Exercise", back_populates="day_exercises")

    def __repr__(self):
        return f"<DayExercise {self.exercise.name if self.exercise else 'Unknown'}: {self.sets}x{self.reps_min}-{self.reps_max}>"
