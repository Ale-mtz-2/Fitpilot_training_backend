from datetime import datetime, timedelta
from typing import Any, Optional, Union
from jose import JWTError, jwt
from passlib.context import CryptContext
import requests
from core.config import settings

# Password hashing - using argon2 (more secure and no length limitations)
pwd_context = CryptContext(schemes=["argon2"], deprecated="auto")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against its hash"""
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password: str) -> str:
    """Hash a password"""
    return pwd_context.hash(password)


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """Create a JWT access token"""
    to_encode = data.copy()

    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)

    return encoded_jwt


def decode_access_token(token: str) -> Union[dict, None]:
    """Decode and verify a JWT token"""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except JWTError:
        return None


def normalize_auth_role(role: Optional[str]) -> Optional[str]:
    """Normalize role names from local JWT/db and Nutrition API payloads."""
    if not role:
        return None

    role_key = str(role).strip().lower()
    role_map = {
        "admin": "admin",
        "administrator": "admin",
        "super_admin": "admin",
        "trainer": "trainer",
        "professional": "trainer",
        "coach": "trainer",
        "client": "client",
        "patient": "client",
        "user": "client",
    }
    return role_map.get(role_key, role_key)


def introspect_nutrition_token(token: str) -> Optional[dict[str, Any]]:
    """
    Validate a token against the Nutrition API (/v1/auth/me).
    Returns user-like payload dict when valid, otherwise None.
    """
    if not settings.NUTRITION_API_URL:
        return None

    base_url = settings.NUTRITION_API_URL.rstrip("/")
    auth_me_path = settings.NUTRITION_AUTH_ME_PATH.strip() or "/v1/auth/me"
    if not auth_me_path.startswith("/"):
        auth_me_path = f"/{auth_me_path}"

    url = f"{base_url}{auth_me_path}"

    try:
        response = requests.get(
            url,
            headers={"Authorization": f"Bearer {token}"},
            timeout=settings.NUTRITION_AUTH_TIMEOUT_SECONDS,
        )
    except requests.RequestException:
        return None

    if response.status_code != 200:
        return None

    try:
        data = response.json()
    except ValueError:
        return None

    if not isinstance(data, dict):
        return None

    # Common response wrappers
    if isinstance(data.get("user"), dict):
        return data["user"]
    if isinstance(data.get("data"), dict) and isinstance(data["data"].get("user"), dict):
        return data["data"]["user"]
    if isinstance(data.get("data"), dict):
        return data["data"]
    return data
