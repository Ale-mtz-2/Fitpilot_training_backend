from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from models.base import get_db
from models.user import User
from core.security import decode_access_token, introspect_nutrition_token, normalize_auth_role

security = HTTPBearer()


def _extract_identity(payload: dict | None) -> tuple[str | None, str | None, str | None]:
    """Extract (user_id, email, role) from either local JWT or Nutrition /auth/me payloads."""
    if not payload:
        return None, None, None

    user_id = (
        payload.get("sub")
        or payload.get("id")
        or payload.get("user_id")
        or payload.get("uuid")
    )
    email = payload.get("email") or payload.get("user_email")
    role = payload.get("role") or payload.get("user_role")

    return user_id, email, normalize_auth_role(role)


def _resolve_user(db: Session, user_id: str | None, email: str | None) -> User | None:
    user = None

    if user_id:
        user = db.query(User).filter(User.id == str(user_id)).first()

    if user is None and email:
        user = db.query(User).filter(User.email.ilike(str(email))).first()

    return user


def get_effective_user_role(user: User) -> str:
    """
    Resolve role for authorization checks.
    Prefers role coming from the auth token introspection when present.
    """
    external_role = getattr(user, "_effective_auth_role", None)
    if external_role:
        return external_role

    db_role = getattr(user.role, "value", user.role)
    normalized = normalize_auth_role(str(db_role))
    return normalized or str(db_role).lower()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User:
    """Get the current authenticated user"""

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    token = credentials.credentials
    local_payload = decode_access_token(token)
    user_id, email, token_role = _extract_identity(local_payload)

    user = _resolve_user(db, user_id, email)

    # Fallback path: validate token against Nutrition API and resolve by sub/email
    if user is None:
        nutrition_payload = introspect_nutrition_token(token)
        if nutrition_payload:
            user_id, email, nutrition_role = _extract_identity(nutrition_payload)
            token_role = nutrition_role or token_role
            user = _resolve_user(db, user_id, email)

    if user is None:
        raise credentials_exception

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Inactive user"
        )

    if token_role:
        setattr(user, "_effective_auth_role", token_role)

    return user


def get_current_active_user(current_user: User = Depends(get_current_user)) -> User:
    """Get the current active user"""
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


def require_trainer(current_user: User = Depends(get_current_user)) -> User:
    """Require the current user to be a trainer or admin"""
    effective_role = get_effective_user_role(current_user)
    if effective_role not in {"trainer", "admin"}:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires trainer privileges"
        )
    return current_user


def require_admin(current_user: User = Depends(get_current_user)) -> User:
    """Require the current user to be an admin"""
    effective_role = get_effective_user_role(current_user)
    if effective_role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires admin privileges"
        )
    return current_user
