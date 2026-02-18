from sqlalchemy import Column, String, Float, Date, DateTime, ForeignKey, Enum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from models.base import Base


class MetricType(str, enum.Enum):
    # Basic Measurements
    WEIGHT = "weight"
    HEIGHT = "height"
    
    # Body Composition
    BODY_FAT = "body_fat"
    MUSCLE_MASS = "muscle_mass"
    BODY_WATER = "body_water"
    BONE_MASS = "bone_mass"
    VISCERAL_FAT = "visceral_fat"
    BMI = "bmi"
    
    # Circumferences
    CHEST = "chest"
    WAIST = "waist"
    HIPS = "hips"
    ARMS = "arms"
    THIGHS = "thighs"
    NECK = "neck"
    CALF = "calf"
    SHOULDERS = "shoulders"
    FOREARM = "forearm"
    ABDOMINAL = "abdominal"
    UPPER_ARM = "upper_arm"
    LOWER_ARM = "lower_arm"
    
    # Health Metrics
    RESTING_HR = "resting_hr"
    BLOOD_PRESSURE_SYS = "blood_pressure_sys"
    BLOOD_PRESSURE_DIA = "blood_pressure_dia"
    
    # Nutritional Metrics
    BMR = "bmr"
    TDEE = "tdee"
    TARGET_CALORIES = "target_calories"
    PROTEIN_INTAKE = "protein_intake"
    CARB_INTAKE = "carb_intake"
    FAT_INTAKE = "fat_intake"
    
    # Skinfold Measurements
    TRICEPS_SKINFOLD = "triceps_skinfold"
    SUBSCAPULAR_SKINFOLD = "subscapular_skinfold"
    SUPRAILIAC_SKINFOLD = "suprailiac_skinfold"
    ABDOMINAL_SKINFOLD = "abdominal_skinfold"
    THIGH_SKINFOLD = "thigh_skinfold"


class ClientMetric(Base):
    __tablename__ = "client_metrics"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    client_id = Column(String, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)

    metric_type = Column(Enum(MetricType), nullable=False)
    value = Column(Float, nullable=False)
    unit = Column(String(20), nullable=False)
    date = Column(Date, nullable=False)

    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    client = relationship("User", backref="metrics")

    def __repr__(self):
        return f"<ClientMetric {self.metric_type}={self.value}{self.unit} for client_id={self.client_id}>"
