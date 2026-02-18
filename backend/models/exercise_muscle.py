"""
ExerciseMuscle model for FitPilot.
Junction table linking exercises to muscles with role specification.
"""
from sqlalchemy import Column, String, DateTime, ForeignKey, UniqueConstraint, CheckConstraint
from sqlalchemy.orm import relationship
from datetime import datetime
import uuid
import enum
from models.base import Base


class MuscleRole(str, enum.Enum):
    """Role of a muscle in an exercise."""
    PRIMARY = "primary"
    SECONDARY = "secondary"


class ExerciseMuscle(Base):
    """
    Junction table linking exercises to muscles.

    Specifies whether a muscle is:
    - PRIMARY: The main target muscle (counts as 1 full set)
    - SECONDARY: A supporting/synergist muscle (counts as 0.5 sets)

    Each exercise must have at least one primary muscle.
    """
    __tablename__ = "exercise_muscles"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    exercise_id = Column(
        String,
        ForeignKey("exercises.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    muscle_id = Column(
        String,
        ForeignKey("muscles.id", ondelete="RESTRICT"),
        nullable=False,
        index=True
    )
    muscle_role = Column(String(20), nullable=False)  # 'primary' or 'secondary'
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    exercise = relationship("Exercise", back_populates="exercise_muscles")
    muscle = relationship("Muscle", back_populates="exercise_muscles")

    __table_args__ = (
        UniqueConstraint('exercise_id', 'muscle_id', name='uq_exercise_muscle'),
        CheckConstraint(
            "muscle_role IN ('primary', 'secondary')",
            name='ck_muscle_role'
        ),
    )

    def __repr__(self):
        return f"<ExerciseMuscle exercise={self.exercise_id} muscle={self.muscle_id} role={self.muscle_role}>"
