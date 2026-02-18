from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from models.base import get_db
from models.user import User, UserRole
from models.client_interview import ClientInterview
from schemas.client_interview import (
    ClientInterviewCreate,
    ClientInterviewUpdate,
    ClientInterviewResponse,
)
from core.dependencies import get_current_user

router = APIRouter()


@router.get("/{client_id}", response_model=ClientInterviewResponse)
def get_client_interview(
    client_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get interview data for a specific client"""

    # Only trainers and admins can view client interviews
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can view client interviews"
        )

    # Verify client exists
    client = db.query(User).filter(
        User.id == client_id,
        User.role == UserRole.CLIENT
    ).first()

    if not client:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found"
        )

    interview = db.query(ClientInterview).filter(
        ClientInterview.client_id == client_id
    ).first()

    if not interview:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Interview not found for this client"
        )

    return interview


@router.post("/{client_id}", response_model=ClientInterviewResponse, status_code=status.HTTP_201_CREATED)
def create_client_interview(
    client_id: str,
    interview_data: ClientInterviewCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create interview data for a client"""

    # Only trainers and admins can create client interviews
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can create client interviews"
        )

    # Verify client exists
    client = db.query(User).filter(
        User.id == client_id,
        User.role == UserRole.CLIENT
    ).first()

    if not client:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found"
        )

    # Check if interview already exists
    existing = db.query(ClientInterview).filter(
        ClientInterview.client_id == client_id
    ).first()

    if existing:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Interview already exists for this client. Use PUT to update."
        )

    # Create new interview
    interview = ClientInterview(
        client_id=client_id,
        **interview_data.model_dump(exclude_unset=True)
    )

    db.add(interview)
    db.commit()
    db.refresh(interview)

    return interview


@router.put("/{client_id}", response_model=ClientInterviewResponse)
def update_client_interview(
    client_id: str,
    interview_data: ClientInterviewUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update interview data for a client (creates if doesn't exist)"""

    # Only trainers and admins can update client interviews
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can update client interviews"
        )

    # Verify client exists
    client = db.query(User).filter(
        User.id == client_id,
        User.role == UserRole.CLIENT
    ).first()

    if not client:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found"
        )

    interview = db.query(ClientInterview).filter(
        ClientInterview.client_id == client_id
    ).first()

    if not interview:
        # Create new interview if doesn't exist (upsert behavior)
        interview = ClientInterview(
            client_id=client_id,
            **interview_data.model_dump(exclude_unset=True)
        )
        db.add(interview)
    else:
        # Update existing interview
        update_data = interview_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(interview, field, value)

    db.commit()
    db.refresh(interview)

    return interview


@router.delete("/{client_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_client_interview(
    client_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete interview data for a client"""

    # Only trainers and admins can delete client interviews
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can delete client interviews"
        )

    interview = db.query(ClientInterview).filter(
        ClientInterview.client_id == client_id
    ).first()

    if not interview:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Interview not found"
        )

    db.delete(interview)
    db.commit()

    return None
