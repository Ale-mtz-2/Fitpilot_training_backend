from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Optional

from models.user import UserRole


@dataclass
class CompatUserContext:
    id: str
    email: str
    hashed_password: str
    full_name: str
    role: UserRole
    is_active: bool
    is_verified: bool = False
    preferred_language: str = "es"
    profile_image_url: Optional[str] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

