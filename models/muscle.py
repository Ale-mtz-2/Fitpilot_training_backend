"""
Muscle model for FitPilot.
Represents individual muscle groups that can be targeted by exercises.
"""
from sqlalchemy import Column, String, Integer, DateTime
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
import enum
from models.base import Base


class BodyRegion(str, enum.Enum):
    """Body regions for muscle categorization."""
    UPPER_BODY = "upper_body"
    LOWER_BODY = "lower_body"
    CORE = "core"


class MuscleCategory(str, enum.Enum):
    """Simplified muscle categories for grouping."""
    CHEST = "chest"
    BACK = "back"
    SHOULDERS = "shoulders"
    ARMS = "arms"
    LEGS = "legs"
    CORE = "core"


class Muscle(Base):
    """
    Represents a muscle group that exercises can target.

    Each muscle has:
    - A unique name (e.g., 'chest', 'biceps', 'quadriceps')
    - Display names in Spanish and English
    - Body region classification
    - Category for simplified grouping
    - SVG element IDs for BodyMap visualization
    """
    __tablename__ = "muscles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String(50), nullable=False, unique=True, index=True)
    display_name_es = Column(String(100), nullable=False)
    display_name_en = Column(String(100), nullable=False)
    body_region = Column(String(50), nullable=False)
    muscle_category = Column(String(50), nullable=False)
    svg_ids = Column(ARRAY(String), nullable=True)  # Array of SVG element IDs for BodyMap
    sort_order = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    exercise_muscles = relationship("ExerciseMuscle", back_populates="muscle")

    def __repr__(self):
        return f"<Muscle {self.name} ({self.muscle_category})>"
