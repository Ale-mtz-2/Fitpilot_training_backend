from sqlalchemy import Column, String, Integer, Text, DateTime, ForeignKey, Enum, Boolean, Float
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from models.base import Base


class Gender(str, enum.Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"
    PREFER_NOT_TO_SAY = "prefer_not_to_say"


class ExperienceLevel(str, enum.Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"


class PrimaryGoal(str, enum.Enum):
    HYPERTROPHY = "hypertrophy"
    STRENGTH = "strength"
    POWER = "power"
    ENDURANCE = "endurance"
    FAT_LOSS = "fat_loss"
    GENERAL_FITNESS = "general_fitness"


class EquipmentType(str, enum.Enum):
    BARBELL = "barbell"
    DUMBBELLS = "dumbbells"
    CABLES = "cables"
    MACHINES = "machines"
    KETTLEBELLS = "kettlebells"
    RESISTANCE_BANDS = "resistance_bands"
    PULL_UP_BAR = "pull_up_bar"
    BENCH = "bench"
    SQUAT_RACK = "squat_rack"
    BODYWEIGHT = "bodyweight"


class InjuryArea(str, enum.Enum):
    SHOULDER = "shoulder"
    KNEE = "knee"
    LOWER_BACK = "lower_back"
    UPPER_BACK = "upper_back"
    HIP = "hip"
    ANKLE = "ankle"
    WRIST = "wrist"
    ELBOW = "elbow"
    NECK = "neck"
    OTHER = "other"


class MuscleGroup(str, enum.Enum):
    CHEST = "chest"
    BACK = "back"
    SHOULDERS = "shoulders"
    BICEPS = "biceps"
    TRICEPS = "triceps"
    LEGS = "legs"
    CORE = "core"
    GLUTES = "glutes"


class ClientInterview(Base):
    __tablename__ = "client_interviews"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    client_id = Column(String, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, unique=True)

    # === PERSONAL INFORMATION ===
    document_id = Column(String(100), nullable=True)
    age = Column(Integer, nullable=True)
    gender = Column(Enum(Gender), nullable=True)
    occupation = Column(String(200), nullable=True)
    phone = Column(String(50), nullable=True)
    address = Column(Text, nullable=True)
    emergency_contact_name = Column(String(200), nullable=True)
    emergency_contact_phone = Column(String(50), nullable=True)
    insurance_provider = Column(String(200), nullable=True)
    policy_number = Column(String(100), nullable=True)
    weight_kg = Column(Float, nullable=True)
    height_cm = Column(Float, nullable=True)
    training_experience_months = Column(Integer, nullable=True)

    # === TRAINING PROFILE ===
    experience_level = Column(Enum(ExperienceLevel), default=ExperienceLevel.BEGINNER)

    # === GOALS (structured) ===
    primary_goal = Column(Enum(PrimaryGoal), nullable=True)
    target_muscle_groups = Column(ARRAY(String), nullable=True)  # MuscleGroup values
    specific_goals_text = Column(Text, nullable=True)  # Optional free text for additional goals

    # === AVAILABILITY (structured) ===
    days_per_week = Column(Integer, nullable=True)  # 1-7
    session_duration_minutes = Column(Integer, nullable=True)  # 20-180
    preferred_days = Column(ARRAY(Integer), nullable=True)  # 1-7 (Mon-Sun)

    # === EQUIPMENT (structured) ===
    has_gym_access = Column(Boolean, nullable=True)
    available_equipment = Column(ARRAY(String), nullable=True)  # EquipmentType values
    equipment_notes = Column(Text, nullable=True)  # Optional notes

    # === RESTRICTIONS (structured) ===
    injury_areas = Column(ARRAY(String), nullable=True)  # InjuryArea values
    injury_details = Column(Text, nullable=True)  # Detailed injury description
    excluded_exercises = Column(ARRAY(String), nullable=True)  # Exercises to avoid
    medical_conditions = Column(ARRAY(String), nullable=True)  # Health conditions
    mobility_limitations = Column(Text, nullable=True)  # Mobility issues

    # === ADDITIONAL NOTES ===
    notes = Column(Text, nullable=True)

    # === TIMESTAMPS ===
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    client = relationship("User", backref="interview")

    def __repr__(self):
        return f"<ClientInterview for client_id={self.client_id}>"

    def is_complete_for_ai(self) -> tuple[bool, list[str]]:
        """
        Check if the interview has all required fields for AI generation.
        Returns (is_complete, missing_fields).
        """
        missing = []

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
        if not self.available_equipment or len(self.available_equipment) == 0:
            missing.append("available_equipment")

        return (len(missing) == 0, missing)
