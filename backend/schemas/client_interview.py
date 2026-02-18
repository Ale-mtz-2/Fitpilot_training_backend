from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum


class Gender(str, Enum):
    male = "male"
    female = "female"
    other = "other"
    prefer_not_to_say = "prefer_not_to_say"


class ExperienceLevel(str, Enum):
    beginner = "beginner"
    intermediate = "intermediate"
    advanced = "advanced"


class PrimaryGoal(str, Enum):
    hypertrophy = "hypertrophy"
    strength = "strength"
    power = "power"
    endurance = "endurance"
    fat_loss = "fat_loss"
    general_fitness = "general_fitness"


class EquipmentType(str, Enum):
    barbell = "barbell"
    dumbbells = "dumbbells"
    cables = "cables"
    machines = "machines"
    kettlebells = "kettlebells"
    resistance_bands = "resistance_bands"
    pull_up_bar = "pull_up_bar"
    bench = "bench"
    squat_rack = "squat_rack"
    bodyweight = "bodyweight"


class InjuryArea(str, Enum):
    shoulder = "shoulder"
    knee = "knee"
    lower_back = "lower_back"
    upper_back = "upper_back"
    hip = "hip"
    ankle = "ankle"
    wrist = "wrist"
    elbow = "elbow"
    neck = "neck"
    other = "other"


class MuscleGroup(str, Enum):
    chest = "chest"
    back = "back"
    shoulders = "shoulders"
    biceps = "biceps"
    triceps = "triceps"
    legs = "legs"
    core = "core"
    glutes = "glutes"


class ClientInterviewBase(BaseModel):
    # Personal Information
    document_id: Optional[str] = Field(None, max_length=100)
    age: Optional[int] = Field(None, ge=14, le=100)
    gender: Optional[Gender] = None
    occupation: Optional[str] = Field(None, max_length=200)
    phone: Optional[str] = Field(None, max_length=50)
    address: Optional[str] = Field(None, max_length=500)
    emergency_contact_name: Optional[str] = Field(None, max_length=200)
    emergency_contact_phone: Optional[str] = Field(None, max_length=50)
    insurance_provider: Optional[str] = Field(None, max_length=200)
    policy_number: Optional[str] = Field(None, max_length=100)
    weight_kg: Optional[float] = Field(None, ge=30, le=300)
    height_cm: Optional[float] = Field(None, ge=100, le=250)
    training_experience_months: Optional[int] = Field(None, ge=0, le=600)

    # Training Profile
    experience_level: Optional[ExperienceLevel] = ExperienceLevel.beginner

    # Goals (structured)
    primary_goal: Optional[PrimaryGoal] = None
    target_muscle_groups: Optional[List[MuscleGroup]] = None
    specific_goals_text: Optional[str] = Field(None, max_length=500)

    # Availability (structured)
    days_per_week: Optional[int] = Field(None, ge=1, le=7)
    session_duration_minutes: Optional[int] = Field(None, ge=20, le=180)
    preferred_days: Optional[List[int]] = Field(None, description="1-7 (Mon-Sun)")

    # Equipment (structured)
    has_gym_access: Optional[bool] = None
    available_equipment: Optional[List[EquipmentType]] = None
    equipment_notes: Optional[str] = Field(None, max_length=500)

    # Restrictions (structured)
    # injury_areas acepta strings libres para permitir descripciones detalladas
    # El enum InjuryArea se mantiene para referencia pero no se usa en validación
    injury_areas: Optional[List[str]] = Field(None, max_length=20)
    injury_details: Optional[str] = Field(None, max_length=1000)
    excluded_exercises: Optional[List[str]] = Field(None, max_length=20)
    medical_conditions: Optional[List[str]] = Field(None, max_length=10)
    mobility_limitations: Optional[str] = Field(None, max_length=500)

    # Additional Notes
    notes: Optional[str] = Field(None, max_length=2000)


class ClientInterviewCreate(ClientInterviewBase):
    pass


class ClientInterviewUpdate(ClientInterviewBase):
    pass


class ClientInterviewResponse(ClientInterviewBase):
    id: str
    client_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class InterviewValidationResponse(BaseModel):
    """Response for interview validation endpoint"""
    is_complete: bool
    missing_fields: List[str]
    client_name: Optional[str] = None
    has_interview: bool
