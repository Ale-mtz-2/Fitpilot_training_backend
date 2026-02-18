from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from sqlalchemy import desc
from typing import Optional
from datetime import date
from models.base import get_db
from models.user import User, UserRole
from models.client_metric import ClientMetric, MetricType
from schemas.client_metric import (
    ClientMetricCreate,
    ClientMetricUpdate,
    ClientMetricResponse,
    ClientMetricListResponse,
    ClientMetricSummary,
)
from core.dependencies import get_current_user

router = APIRouter()


@router.get("/me/summary")
def get_my_metrics_summary(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get summary of own metrics (for clients viewing their own data)"""

    # Only clients can use this endpoint
    if current_user.role != UserRole.CLIENT:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="This endpoint is only for clients"
        )

    summaries = []
    unit_map = {
        MetricType.WEIGHT: "kg",
        MetricType.BODY_FAT: "%",
        MetricType.CHEST: "cm",
        MetricType.WAIST: "cm",
        MetricType.HIPS: "cm",
        MetricType.ARMS: "cm",
        MetricType.THIGHS: "cm",
    }

    for metric_type in MetricType:
        # Get latest metric
        latest = db.query(ClientMetric).filter(
            ClientMetric.client_id == current_user.id,
            ClientMetric.metric_type == metric_type
        ).order_by(desc(ClientMetric.date)).first()

        # Get previous metric for change calculation
        change = None
        if latest:
            previous = db.query(ClientMetric).filter(
                ClientMetric.client_id == current_user.id,
                ClientMetric.metric_type == metric_type,
                ClientMetric.date < latest.date
            ).order_by(desc(ClientMetric.date)).first()

            if previous:
                change = round(latest.value - previous.value, 2)

        # Only include metrics that have data
        if latest:
            summaries.append({
                "metric_type": metric_type.value,
                "latest_value": latest.value,
                "latest_date": latest.date.isoformat() if latest.date else None,
                "unit": unit_map.get(metric_type, ""),
                "change_from_previous": change
            })

    return summaries


@router.get("/{client_id}", response_model=ClientMetricListResponse)
def get_client_metrics(
    client_id: str,
    metric_type: Optional[MetricType] = None,
    start_date: Optional[date] = None,
    end_date: Optional[date] = None,
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all metrics for a specific client"""

    # Only trainers and admins can view client metrics
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can view client metrics"
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

    query = db.query(ClientMetric).filter(ClientMetric.client_id == client_id)

    if metric_type:
        query = query.filter(ClientMetric.metric_type == metric_type)
    if start_date:
        query = query.filter(ClientMetric.date >= start_date)
    if end_date:
        query = query.filter(ClientMetric.date <= end_date)

    total = query.count()
    metrics = query.order_by(desc(ClientMetric.date)).offset(skip).limit(limit).all()

    return ClientMetricListResponse(metrics=metrics, total=total)


@router.get("/{client_id}/summary")
def get_client_metrics_summary(
    client_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get summary of latest metrics for a client"""

    # Only trainers and admins can view client metrics
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can view client metrics"
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

    summaries = []
    unit_map = {
        MetricType.WEIGHT: "kg",
        MetricType.BODY_FAT: "%",
        MetricType.CHEST: "cm",
        MetricType.WAIST: "cm",
        MetricType.HIPS: "cm",
        MetricType.ARMS: "cm",
        MetricType.THIGHS: "cm",
    }

    for metric_type in MetricType:
        # Get latest metric
        latest = db.query(ClientMetric).filter(
            ClientMetric.client_id == client_id,
            ClientMetric.metric_type == metric_type
        ).order_by(desc(ClientMetric.date)).first()

        # Get previous metric for change calculation
        change = None
        if latest:
            previous = db.query(ClientMetric).filter(
                ClientMetric.client_id == client_id,
                ClientMetric.metric_type == metric_type,
                ClientMetric.date < latest.date
            ).order_by(desc(ClientMetric.date)).first()

            if previous:
                change = latest.value - previous.value

        summaries.append({
            "metric_type": metric_type,
            "latest_value": latest.value if latest else None,
            "latest_date": latest.date if latest else None,
            "unit": unit_map.get(metric_type, ""),
            "change_from_previous": change
        })

    return summaries


@router.post("/{client_id}", response_model=ClientMetricResponse, status_code=status.HTTP_201_CREATED)
def create_client_metric(
    client_id: str,
    metric_data: ClientMetricCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new metric for a client"""

    # Only trainers and admins can create client metrics
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can create client metrics"
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

    # Create new metric
    metric = ClientMetric(
        client_id=client_id,
        **metric_data.model_dump()
    )

    db.add(metric)
    db.commit()
    db.refresh(metric)

    return metric


@router.put("/{metric_id}", response_model=ClientMetricResponse)
def update_client_metric(
    metric_id: str,
    metric_data: ClientMetricUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update a specific metric"""

    # Only trainers and admins can update client metrics
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can update client metrics"
        )

    metric = db.query(ClientMetric).filter(ClientMetric.id == metric_id).first()

    if not metric:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Metric not found"
        )

    # Update fields
    update_data = metric_data.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(metric, field, value)

    db.commit()
    db.refresh(metric)

    return metric


@router.delete("/{metric_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_client_metric(
    metric_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete a specific metric"""

    # Only trainers and admins can delete client metrics
    if current_user.role not in [UserRole.TRAINER, UserRole.ADMIN]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only trainers and admins can delete client metrics"
        )

    metric = db.query(ClientMetric).filter(ClientMetric.id == metric_id).first()

    if not metric:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Metric not found"
        )

    db.delete(metric)
    db.commit()

    return None
