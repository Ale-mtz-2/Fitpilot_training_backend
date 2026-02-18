from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import JSONB
from datetime import datetime
import uuid
from models.base import Base


class PatientContextSnapshot(Base):
    __tablename__ = "patient_context_snapshots"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    client_id = Column(String, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    version = Column(String, nullable=False, index=True)
    effective_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    source = Column(String(50), nullable=True)
    data = Column(JSONB, nullable=False)
    created_by = Column(String, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    def __repr__(self):
        return f"<PatientContextSnapshot client_id={self.client_id} version={self.version}>"
