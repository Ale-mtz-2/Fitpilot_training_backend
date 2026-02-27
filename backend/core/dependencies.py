from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from core.config import settings
from models.base import get_db
from models.user import User
from core.security import decode_access_token
from repositories.training_compat.types import CompatUserContext
from repositories.training_compat.users import get_user_context_by_id

security = HTTPBearer()


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
) -> User | CompatUserContext:
    """Get the current authenticated user"""

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    token = credentials.credentials
    payload = decode_access_token(token)

    if payload is None:
        raise credentials_exception

    user_id: str = payload.get("sub")
    if user_id is None:
        raise credentials_exception

    if settings.DB_MODE == "training_compat":
        user = get_user_context_by_id(db, user_id)
    else:
        user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise credentials_exception

    if not user.is_active:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Inactive user"
        )

    return user


def get_current_active_user(current_user: User | CompatUserContext = Depends(get_current_user)) -> User | CompatUserContext:
    """Get the current active user"""
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user


def require_trainer(current_user: User | CompatUserContext = Depends(get_current_user)) -> User | CompatUserContext:
    """Require the current user to be a trainer or admin"""
    from models.user import UserRole

    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires trainer privileges"
        )
    return current_user


def require_admin(current_user: User | CompatUserContext = Depends(get_current_user)) -> User | CompatUserContext:
    """Require the current user to be an admin"""
    from models.user import UserRole

    if current_user.role != UserRole.ADMIN:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This action requires admin privileges"
        )
    return current_user
