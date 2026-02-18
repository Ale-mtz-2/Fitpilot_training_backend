from pydantic import BaseModel, EmailStr, Field
from datetime import datetime
from typing import Optional, Literal
from models.user import UserRole

# Supported languages
Language = Literal["es", "en"]


class UserBase(BaseModel):
    email: EmailStr
    full_name: str


class UserCreate(UserBase):
    password: str = Field(min_length=8)
    role: UserRole = UserRole.CLIENT


class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = Field(None, min_length=8)
    is_active: Optional[bool] = None
    preferred_language: Optional[Language] = None


class PasswordChange(BaseModel):
    """Schema para cambiar contraseña con validación de contraseña actual"""
    current_password: str
    new_password: str = Field(min_length=8)


class UserResponse(UserBase):
    id: str
    role: UserRole
    preferred_language: Language = "es"
    profile_image_url: Optional[str] = None
    is_active: bool
    is_verified: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class UserInDB(UserResponse):
    hashed_password: str
