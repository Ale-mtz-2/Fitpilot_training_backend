from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import Optional


class Settings(BaseSettings):
    """Application settings"""

    # Database
    DATABASE_URL: str = "postgresql://user:password@localhost:5432/fitpilot_db"
    REDIS_URL: str = "redis://localhost:6379"

    # API Keys
    OPENAI_API_KEY: Optional[str] = None
    ANTHROPIC_API_KEY: Optional[str] = None

    # JWT
    SECRET_KEY: str = "your-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # AWS S3
    AWS_ACCESS_KEY_ID: Optional[str] = None
    AWS_SECRET_ACCESS_KEY: Optional[str] = None
    AWS_BUCKET_NAME: str = "fitpilot-videos"

    # Email
    SMTP_HOST: str = "smtp.gmail.com"
    SMTP_PORT: int = 587
    SMTP_USER: Optional[str] = None
    SMTP_PASSWORD: Optional[str] = None

    # Frontend
    FRONTEND_URL: str = "http://localhost:3000"
    MOBILE_SCHEME: str = "fitpilot://"

    # Ollama (LLM local para traducción)
    OLLAMA_HOST: str = "http://localhost:11434"
    OLLAMA_MODEL: str = "llama3.2:3b"

    # AI Optimization Settings
    AI_USE_PROMPT_CACHING: bool = True
    AI_USE_COMPRESSED_OUTPUT: bool = True
    AI_FILTER_CATALOG: bool = True
    AI_USE_PHASED_GENERATION: bool = True

    model_config = SettingsConfigDict(
        env_file=".env",
        extra="ignore"  # allow keys in .env that we don't explicitly model
    )


settings = Settings()
