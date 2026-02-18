from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime
from enum import Enum


class MetricType(str, Enum):
    # Basic Measurements
    weight = "weight"
    height = "height"
    
    # Body Composition
    body_fat = "body_fat"
    muscle_mass = "muscle_mass"
    body_water = "body_water"
    bone_mass = "bone_mass"
    visceral_fat = "visceral_fat"
    bmi = "bmi"
    
    # Circumferences
    chest = "chest"
    waist = "waist"
    hips = "hips"
    arms = "arms"
    thighs = "thighs"
    neck = "neck"
    calf = "calf"
    shoulders = "shoulders"
    forearm = "forearm"
    abdominal = "abdominal"
    upper_arm = "upper_arm"
    lower_arm = "lower_arm"
    
    # Health Metrics
    resting_hr = "resting_hr"
    blood_pressure_sys = "blood_pressure_sys"
    blood_pressure_dia = "blood_pressure_dia"
    
    # Nutritional Metrics
    bmr = "bmr"
    tdee = "tdee"
    target_calories = "target_calories"
    protein_intake = "protein_intake"
    carb_intake = "carb_intake"
    fat_intake = "fat_intake"
    
    # Skinfold Measurements
    triceps_skinfold = "triceps_skinfold"
    subscapular_skinfold = "subscapular_skinfold"
    suprailiac_skinfold = "suprailiac_skinfold"
    abdominal_skinfold = "abdominal_skinfold"
    thigh_skinfold = "thigh_skinfold"


class ClientMetricBase(BaseModel):
    metric_type: MetricType
    value: float
    unit: str
    date: date


class ClientMetricCreate(ClientMetricBase):
    pass


class ClientMetricUpdate(BaseModel):
    metric_type: Optional[MetricType] = None
    value: Optional[float] = None
    unit: Optional[str] = None
    date: Optional[date] = None


class ClientMetricResponse(ClientMetricBase):
    id: str
    client_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ClientMetricListResponse(BaseModel):
    metrics: List[ClientMetricResponse]
    total: int


class ClientMetricSummary(BaseModel):
    metric_type: MetricType
    latest_value: Optional[float]
    latest_date: Optional[date]
    unit: str
    change_from_previous: Optional[float] = None
