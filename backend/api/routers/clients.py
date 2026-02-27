from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import Optional
from models.base import get_db
from models.user import User, UserRole
from schemas.client import ClientCreate, ClientUpdate, ClientResponse, ClientListResponse
from core.security import get_password_hash
from core.dependencies import get_current_user
from core.config import settings
from repositories.training_compat.types import CompatUserContext
from repositories.training_compat.users import (
    create_user as compat_create_user,
    delete_user as compat_delete_user,
    get_user_context_by_email,
    get_user_context_by_id,
    list_clients as compat_list_clients,
    update_user_profile as compat_update_user_profile,
)

router = APIRouter()


@router.get("/", response_model=ClientListResponse)
def get_clients(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    search: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user: User | CompatUserContext = Depends(get_current_user)
):
    """Get all clients (users with role=client)"""

    # Only trainers and admins can view clients
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can view clients"
        )

    if settings.DB_MODE == "training_compat":
        total, clients = compat_list_clients(
            db,
            skip=skip,
            limit=limit,
            search=search,
        )
        return ClientListResponse(clients=clients, total=total)

    query = db.query(User).filter(User.role == UserRole.CLIENT)

    if search:
        search_filter = f"%{search}%"
        query = query.filter(
            (User.full_name.ilike(search_filter)) |
            (User.email.ilike(search_filter))
        )

    total = query.count()
    clients = query.order_by(User.full_name).offset(skip).limit(limit).all()

    return ClientListResponse(clients=clients, total=total)


@router.post("/", response_model=ClientResponse, status_code=status.HTTP_201_CREATED)
def create_client(
    client_data: ClientCreate,
    db: Session = Depends(get_db),
    current_user: User | CompatUserContext = Depends(get_current_user)
):
    """Create a new client"""

    # Only trainers and admins can create clients
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can create clients"
        )

    # Check if email already exists
    if settings.DB_MODE == "training_compat":
        existing_user = get_user_context_by_email(db, client_data.email)
    else:
        existing_user = db.query(User).filter(User.email == client_data.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )

    # Create new client (user with role=client)
    hashed_password = get_password_hash(client_data.password)
    if settings.DB_MODE == "training_compat":
        new_client = compat_create_user(
            db,
            email=client_data.email,
            password_hash=hashed_password,
            full_name=client_data.full_name,
            role=UserRole.CLIENT,
            is_active=True,
            is_verified=False,
        )
        db.commit()
    else:
        new_client = User(
            email=client_data.email,
            full_name=client_data.full_name,
            hashed_password=hashed_password,
            role=UserRole.CLIENT,
            is_active=True,
            is_verified=False
        )

        db.add(new_client)
        db.commit()
        db.refresh(new_client)

    return new_client


@router.get("/{client_id}", response_model=ClientResponse)
def get_client(
    client_id: str,
    db: Session = Depends(get_db),
    current_user: User | CompatUserContext = Depends(get_current_user)
):
    """Get a specific client by ID"""

    # Only trainers and admins can view clients
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can view clients"
        )

    if settings.DB_MODE == "training_compat":
        client = get_user_context_by_id(db, client_id)
        if client and client.role != UserRole.CLIENT:
            client = None
    else:
        client = db.query(User).filter(
            User.id == client_id,
            User.role == UserRole.CLIENT
        ).first()

    if not client:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found"
        )

    return client


@router.put("/{client_id}", response_model=ClientResponse)
def update_client(
    client_id: str,
    client_data: ClientUpdate,
    db: Session = Depends(get_db),
    current_user: User | CompatUserContext = Depends(get_current_user)
):
    """Update a client's information"""

    # Only trainers and admins can update clients
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can update clients"
        )

    if settings.DB_MODE == "training_compat":
        client = get_user_context_by_id(db, client_id)
        if client and client.role != UserRole.CLIENT:
            client = None
    else:
        client = db.query(User).filter(
            User.id == client_id,
            User.role == UserRole.CLIENT
        ).first()

    if not client:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Client not found"
        )

    if settings.DB_MODE == "training_compat":
        updated_client = compat_update_user_profile(
            db,
            user_id=client_id,
            full_name=client_data.full_name,
            is_active=client_data.is_active,
        )
        if not updated_client:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Client not found"
            )
        db.commit()
        return updated_client

    # Update fields
    if client_data.full_name is not None:
        client.full_name = client_data.full_name
    if client_data.is_active is not None:
        client.is_active = client_data.is_active

    db.commit()
    db.refresh(client)

    return client


@router.delete("/{client_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_client(
    client_id: str,
    db: Session = Depends(get_db),
    current_user: User | CompatUserContext = Depends(get_current_user)
):
    """Delete a client"""

    # Only trainers and admins can delete clients
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can delete clients"
        )

    if settings.DB_MODE == "training_compat":
        client = get_user_context_by_id(db, client_id)
        if not client or client.role != UserRole.CLIENT:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Client not found"
            )
        deleted = compat_delete_user(db, client_id)
        if not deleted:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Client not found"
            )
        db.commit()
    else:
        client = db.query(User).filter(
            User.id == client_id,
            User.role == UserRole.CLIENT
        ).first()

        if not client:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Client not found"
            )

        db.delete(client)
        db.commit()

    return None
