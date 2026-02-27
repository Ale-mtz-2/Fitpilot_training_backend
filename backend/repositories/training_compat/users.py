from __future__ import annotations

from datetime import datetime
from typing import Optional

from sqlalchemy import or_
from sqlalchemy.orm import Session

from models.user import UserRole
from repositories.training_compat.models import PublicUserCompat
from repositories.training_compat.overrides import (
    delete_override_data,
    get_override_data,
    upsert_override_data,
)
from repositories.training_compat.types import CompatUserContext


ROLE_DB_TO_APP: dict[str, UserRole] = {
    "ADMIN": UserRole.ADMIN,
    "PROFESSIONAL": UserRole.TRAINER,
    "TRAINER": UserRole.TRAINER,
    "CLIENT": UserRole.CLIENT,
}

ROLE_APP_TO_DB: dict[UserRole, str] = {
    UserRole.ADMIN: "ADMIN",
    UserRole.TRAINER: "PROFESSIONAL",
    UserRole.CLIENT: "CLIENT",
}

_UNSET = object()


def parse_user_id(user_id: str | int | None) -> Optional[int]:
    if user_id is None:
        return None
    if isinstance(user_id, int):
        return user_id
    text = str(user_id).strip()
    if not text:
        return None
    try:
        return int(text)
    except ValueError:
        return None


def split_full_name(full_name: str) -> tuple[str, str | None]:
    parts = (full_name or "").strip().split()
    if not parts:
        return ("Unknown", None)
    first = parts[0]
    last = " ".join(parts[1:]) if len(parts) > 1 else None
    return (first, last)


def join_full_name(name: str | None, lastname: str | None) -> str:
    parts = [p for p in [(name or "").strip(), (lastname or "").strip()] if p]
    return " ".join(parts) if parts else "Unknown"


def map_role_db_to_app(value: str | None) -> UserRole:
    if not value:
        return UserRole.CLIENT
    return ROLE_DB_TO_APP.get(value.upper(), UserRole.CLIENT)


def map_role_app_to_db(role: UserRole) -> str:
    return ROLE_APP_TO_DB.get(role, "CLIENT")


def to_context(user: PublicUserCompat, extra: dict | None = None) -> CompatUserContext:
    extra = extra or {}
    created_at = user.created_at or datetime.utcnow()
    updated_at = user.updated_at or created_at
    return CompatUserContext(
        id=str(user.id),
        email=user.email,
        hashed_password=user.password,
        full_name=join_full_name(user.name, user.lastname),
        role=map_role_db_to_app(user.role),
        is_active=bool(user.is_active),
        is_verified=bool(extra.get("is_verified", False)),
        preferred_language=str(extra.get("preferred_language", "es")),
        profile_image_url=extra.get("profile_image_url"),
        created_at=created_at,
        updated_at=updated_at,
    )


def get_user_context_by_id(db: Session, user_id: str | int) -> Optional[CompatUserContext]:
    parsed = parse_user_id(user_id)
    if parsed is None:
        return None
    user = db.query(PublicUserCompat).filter(PublicUserCompat.id == parsed).first()
    if not user:
        return None
    extra = get_override_data(db, "user", str(user.id))
    return to_context(user, extra)


def get_user_context_by_email(db: Session, email: str) -> Optional[CompatUserContext]:
    user = db.query(PublicUserCompat).filter(PublicUserCompat.email == email).first()
    if not user:
        return None
    extra = get_override_data(db, "user", str(user.id))
    return to_context(user, extra)


def create_user(
    db: Session,
    *,
    email: str,
    password_hash: str,
    full_name: str,
    role: UserRole,
    is_active: bool = True,
    is_verified: bool = False,
    preferred_language: str = "es",
) -> CompatUserContext:
    name, lastname = split_full_name(full_name)
    now = datetime.utcnow()
    user = PublicUserCompat(
        email=email,
        password=password_hash,
        name=name,
        lastname=lastname,
        role=map_role_app_to_db(role),
        is_active=is_active,
        created_at=now,
        updated_at=now,
    )
    db.add(user)
    db.flush()

    upsert_override_data(
        db,
        entity_type="user",
        entity_id=str(user.id),
        data={
            "is_verified": bool(is_verified),
            "preferred_language": preferred_language or "es",
            "profile_image_url": None,
        },
        merge=True,
    )
    db.flush()
    return to_context(user, get_override_data(db, "user", str(user.id)))


def update_user_profile(
    db: Session,
    *,
    user_id: str,
    full_name: str | None = None,
    email: str | None = None,
    password_hash: str | None = None,
    is_active: bool | None = None,
    preferred_language: str | None = None,
    profile_image_url: str | None | object = _UNSET,
    is_verified: bool | None = None,
) -> Optional[CompatUserContext]:
    parsed = parse_user_id(user_id)
    if parsed is None:
        return None

    user = db.query(PublicUserCompat).filter(PublicUserCompat.id == parsed).first()
    if not user:
        return None

    if full_name is not None:
        first, last = split_full_name(full_name)
        user.name = first
        user.lastname = last
    if email is not None:
        user.email = email
    if password_hash is not None:
        user.password = password_hash
    if is_active is not None:
        user.is_active = bool(is_active)

    override_patch: dict = {}
    if preferred_language is not None:
        override_patch["preferred_language"] = preferred_language
    if profile_image_url is not _UNSET:
        override_patch["profile_image_url"] = profile_image_url
    if is_verified is not None:
        override_patch["is_verified"] = bool(is_verified)
    if override_patch:
        upsert_override_data(
            db,
            entity_type="user",
            entity_id=str(user.id),
            data=override_patch,
            merge=True,
        )

    user.updated_at = datetime.utcnow()
    db.flush()
    return to_context(user, get_override_data(db, "user", str(user.id)))


def delete_user(db: Session, user_id: str | int) -> bool:
    parsed = parse_user_id(user_id)
    if parsed is None:
        return False

    user = db.query(PublicUserCompat).filter(PublicUserCompat.id == parsed).first()
    if not user:
        return False

    delete_override_data(db, entity_type="user", entity_id=str(parsed))
    db.delete(user)
    return True


def list_clients(
    db: Session,
    *,
    skip: int = 0,
    limit: int = 100,
    search: str | None = None,
) -> tuple[int, list[CompatUserContext]]:
    query = db.query(PublicUserCompat).filter(PublicUserCompat.role == "CLIENT")
    if search:
        pattern = f"%{search}%"
        query = query.filter(
            or_(
                PublicUserCompat.email.ilike(pattern),
                PublicUserCompat.name.ilike(pattern),
                PublicUserCompat.lastname.ilike(pattern),
            )
        )

    total = query.count()
    rows = query.order_by(PublicUserCompat.name).offset(skip).limit(limit).all()
    clients = [to_context(row, get_override_data(db, "user", str(row.id))) for row in rows]
    return total, clients
