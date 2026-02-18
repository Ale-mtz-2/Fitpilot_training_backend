from sqlalchemy import Column, String, Boolean, DateTime, Enum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
import uuid
from models.base import Base


class UserRole(str, enum.Enum):
    ADMIN = "admin"
    TRAINER = "trainer"
    CLIENT = "client"


class User(Base):
    __tablename__ = "users"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    full_name = Column(String, nullable=False)
    role = Column(Enum(UserRole), default=UserRole.CLIENT, nullable=False)
    preferred_language = Column(String(5), default="es", nullable=False)
    profile_image_url = Column(String, nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)
    is_verified = Column(Boolean, default=False, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    # Relationships
    created_macrocycles = relationship("Macrocycle", back_populates="trainer", foreign_keys="Macrocycle.trainer_id")
    assigned_macrocycles = relationship("Macrocycle", back_populates="client", foreign_keys="Macrocycle.client_id")

    def __repr__(self):
        return f"<User {self.email} ({self.role})>"
