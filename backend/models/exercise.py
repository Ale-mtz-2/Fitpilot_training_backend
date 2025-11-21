from sqlalchemy import Column, String, Text, Enum, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from backend.models.base import Base


class ExerciseType(str, enum.Enum):
    MULTIARTICULAR = "multiarticular"
    MONOARTICULAR = "monoarticular"


class ResistanceProfile(str, enum.Enum):
    ASCENDING = "ascending"
    DESCENDING = "descending"
    FLAT = "flat"
    BELL_SHAPED = "bell_shaped"


class MuscleGroup(str, enum.Enum):
    CHEST = "chest"
    BACK = "back"
    SHOULDERS = "shoulders"
    ARMS = "arms"
    LEGS = "legs"
    CORE = "core"
    CARDIO = "cardio"


class Exercise(Base):
    __tablename__ = "exercises"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False, index=True)
    type = Column(Enum(ExerciseType), nullable=False)
    resistance_profile = Column(Enum(ResistanceProfile), nullable=False)
    muscle_group = Column(Enum(MuscleGroup), nullable=False)
    category = Column(String, nullable=False)
    description = Column(Text)
    video_url = Column(String)
    thumbnail_url = Column(String)
    equipment_needed = Column(String)
    difficulty_level = Column(String)  # beginner, intermediate, advanced
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    day_exercises = relationship("DayExercise", back_populates="exercise", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Exercise {self.name} ({self.muscle_group})>"
