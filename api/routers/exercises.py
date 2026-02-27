"""
API router for Exercise endpoints.
Provides CRUD operations for exercises with muscle relationships.
"""
from fastapi import APIRouter, Depends, HTTPException, status, Query, UploadFile, File
from sqlalchemy.orm import Session, joinedload
from typing import Optional, List
from pathlib import Path

from models.base import get_db
from models.user import User
from models.exercise import Exercise, ExerciseType, ResistanceProfile, ExerciseClass, CardioSubclass
from models.muscle import Muscle
from models.exercise_muscle import ExerciseMuscle
from schemas.exercise import ExerciseCreate, ExerciseUpdate, ExerciseResponse, ExerciseListResponse
from schemas.muscle import ExerciseMuscleResponse
from core.dependencies import get_current_user, require_trainer
from services.exercise_media_storage import (
    StorageError,
    upload_exercise_media,
    delete_exercise_media,
)

router = APIRouter()

ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"}
MAX_FILE_SIZE_MB = 5
MAX_FILE_SIZE_BYTES = MAX_FILE_SIZE_MB * 1024 * 1024


def build_exercise_response(exercise: Exercise) -> dict:
    """
    Build an exercise response with muscle relationships.
    """
    primary_muscles = []
    secondary_muscles = []

    for em in exercise.exercise_muscles:
        muscle_response = ExerciseMuscleResponse(
            muscle_id=em.muscle.id,
            muscle_name=em.muscle.name,
            muscle_display_name=em.muscle.display_name_es,
            muscle_category=em.muscle.muscle_category,
            role=em.muscle_role
        )
        if em.muscle_role == "primary":
            primary_muscles.append(muscle_response)
        else:
            secondary_muscles.append(muscle_response)

    return {
        "id": exercise.id,
        "name_en": exercise.name_en,
        "name_es": exercise.name_es,
        "type": exercise.type,
        "resistance_profile": exercise.resistance_profile,
        "category": exercise.category,
        "description_en": exercise.description_en,
        "description_es": exercise.description_es,
        "video_url": exercise.video_url,
        "thumbnail_url": exercise.thumbnail_url,
        "image_url": exercise.image_url,
        "anatomy_image_url": exercise.anatomy_image_url,
        "equipment_needed": exercise.equipment_needed,
        "difficulty_level": exercise.difficulty_level,
        # Clasificación de ejercicio
        "exercise_class": exercise.exercise_class,
        "cardio_subclass": exercise.cardio_subclass,
        # Campos de cardio
        "intensity_zone": exercise.intensity_zone,
        "target_heart_rate_min": exercise.target_heart_rate_min,
        "target_heart_rate_max": exercise.target_heart_rate_max,
        "calories_per_minute": exercise.calories_per_minute,
        # Músculos
        "primary_muscles": primary_muscles,
        "secondary_muscles": secondary_muscles,
        "created_at": exercise.created_at,
        "updated_at": exercise.updated_at,
    }


@router.get("", response_model=ExerciseListResponse)
def list_exercises(
    db: Session = Depends(get_db),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=500),
    muscle_id: Optional[str] = Query(None, description="Filter by specific muscle ID"),
    muscle_category: Optional[str] = Query(None, description="Filter by muscle category (chest, back, shoulders, arms, legs, core)"),
    muscle_role: Optional[str] = Query(None, description="Filter by muscle role (primary, secondary)"),
    exercise_type: Optional[ExerciseType] = None,
    exercise_class: Optional[ExerciseClass] = Query(None, description="Filter by exercise class (strength, cardio, plyometric, etc.)"),
    cardio_subclass: Optional[CardioSubclass] = Query(None, description="Filter by cardio subclass (liss, hiit, miss)"),
    resistance_profile: Optional[ResistanceProfile] = Query(None, description="Filter by resistance profile"),
    difficulty_level: Optional[str] = None,
    search: Optional[str] = None
):
    """
    Get list of exercises with optional filters.

    - **skip**: Number of records to skip (pagination)
    - **limit**: Maximum number of records to return
    - **muscle_id**: Filter by specific muscle ID
    - **muscle_category**: Filter by muscle category (chest, back, shoulders, arms, legs, core)
    - **muscle_role**: Filter by muscle role when muscle_id is specified (primary, secondary)
    - **exercise_type**: Filter by exercise type (multiarticular/monoarticular)
    - **exercise_class**: Filter by exercise class (strength, cardio, plyometric, flexibility, mobility, warmup, conditioning, balance)
    - **cardio_subclass**: Filter by cardio subclass (liss, hiit, miss) - only applies when exercise_class is cardio
    - **resistance_profile**: Filter by resistance profile (ascending, descending, flat, bell_shaped)
    - **difficulty_level**: Filter by difficulty (beginner/intermediate/advanced)
    - **search**: Search in exercise name and description
    """
    # Base query with eager loading of muscles
    query = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    )

    # Filter by muscle_id or muscle_category
    if muscle_id or muscle_category:
        query = query.join(ExerciseMuscle)
        if muscle_id:
            query = query.filter(ExerciseMuscle.muscle_id == muscle_id)
            if muscle_role:
                query = query.filter(ExerciseMuscle.muscle_role == muscle_role)
        if muscle_category:
            query = query.join(Muscle).filter(Muscle.muscle_category == muscle_category)
            if muscle_role:
                query = query.filter(ExerciseMuscle.muscle_role == muscle_role)

    if exercise_type:
        query = query.filter(Exercise.type == exercise_type)

    # Filtrar por clase de ejercicio
    if exercise_class:
        query = query.filter(Exercise.exercise_class == exercise_class)

    # Filtrar por sub-clase de cardio
    if cardio_subclass:
        query = query.filter(Exercise.cardio_subclass == cardio_subclass)

    if resistance_profile:
        query = query.filter(Exercise.resistance_profile == resistance_profile)

    if difficulty_level:
        query = query.filter(Exercise.difficulty_level == difficulty_level)

    if search:
        search_pattern = f"%{search}%"
        query = query.filter(
            (Exercise.name_en.ilike(search_pattern)) |
            (Exercise.name_es.ilike(search_pattern)) |
            (Exercise.description_en.ilike(search_pattern)) |
            (Exercise.description_es.ilike(search_pattern))
        )

    # Get total count (before pagination)
    # Need to use distinct to avoid counting duplicates from joins
    total = query.distinct().count()

    # Apply pagination
    exercises = query.distinct().offset(skip).limit(limit).all()

    # Build response with muscle relationships
    exercise_responses = [build_exercise_response(ex) for ex in exercises]

    return {
        "total": total,
        "exercises": exercise_responses
    }


@router.get("/{exercise_id}", response_model=ExerciseResponse)
def get_exercise(exercise_id: str, db: Session = Depends(get_db)):
    """Get a specific exercise by ID."""
    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    return build_exercise_response(exercise)


@router.post("", response_model=ExerciseResponse, status_code=status.HTTP_201_CREATED)
def create_exercise(
    exercise_data: ExerciseCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Create a new exercise with muscle relationships.
    Requires trainer or admin role.

    - **primary_muscle_ids**: List of muscle IDs that are primary targets (at least one required)
    - **secondary_muscle_ids**: List of muscle IDs that are secondary/synergist targets
    """
    from services.muscle_image import generate_muscle_image_sync

    # Check if exercise with same name already exists
    existing_exercise = db.query(Exercise).filter(Exercise.name_en == exercise_data.name_en).first()
    if existing_exercise:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Ya existe un ejercicio con el nombre '{exercise_data.name_en}'"
        )

    # Validate muscle IDs exist
    primary_muscle_ids = exercise_data.primary_muscle_ids
    secondary_muscle_ids = exercise_data.secondary_muscle_ids or []

    all_muscle_ids = set(primary_muscle_ids + secondary_muscle_ids)
    existing_muscles = db.query(Muscle).filter(Muscle.id.in_(all_muscle_ids)).all()
    existing_muscle_ids = {m.id for m in existing_muscles}

    missing_ids = all_muscle_ids - existing_muscle_ids
    if missing_ids:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Músculos no encontrados: {', '.join(missing_ids)}"
        )

    # Create new exercise (without muscle_group)
    exercise_dict = exercise_data.model_dump(exclude={"primary_muscle_ids", "secondary_muscle_ids"})
    new_exercise = Exercise(**exercise_dict)
    db.add(new_exercise)
    db.flush()  # Get the ID

    # Create muscle relationships
    for muscle_id in primary_muscle_ids:
        em = ExerciseMuscle(
            exercise_id=new_exercise.id,
            muscle_id=muscle_id,
            muscle_role="primary"
        )
        db.add(em)

    for muscle_id in secondary_muscle_ids:
        if muscle_id not in primary_muscle_ids:  # Avoid duplicates
            em = ExerciseMuscle(
                exercise_id=new_exercise.id,
                muscle_id=muscle_id,
                muscle_role="secondary"
            )
            db.add(em)

    db.commit()

    # Reload with relationships
    new_exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == new_exercise.id).first()

    # Generate anatomical image using primary muscle
    try:
        if new_exercise.primary_muscles:
            primary_muscle_name = new_exercise.primary_muscles[0].name
            anatomy_image_url = generate_muscle_image_sync(
                muscle_group=primary_muscle_name,
                exercise_name=new_exercise.name_en,
                use_multicolor=True
            )
            if anatomy_image_url:
                new_exercise.anatomy_image_url = anatomy_image_url
                db.commit()
    except Exception as e:
        print(f"Warning: Failed to generate anatomy image for {new_exercise.name_en}: {e}")

    return build_exercise_response(new_exercise)


@router.put("/{exercise_id}", response_model=ExerciseResponse)
def update_exercise(
    exercise_id: str,
    exercise_data: ExerciseUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Update an existing exercise.
    Requires trainer or admin role.
    """
    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    # Check if updating name would create a duplicate
    if exercise_data.name_en and exercise_data.name_en != exercise.name_en:
        existing = db.query(Exercise).filter(Exercise.name_en == exercise_data.name_en).first()
        if existing:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Ya existe un ejercicio con el nombre '{exercise_data.name_en}'"
            )

    # Update basic fields
    update_data = exercise_data.model_dump(exclude_unset=True, exclude={"primary_muscle_ids", "secondary_muscle_ids"})
    for field, value in update_data.items():
        setattr(exercise, field, value)

    # Update muscle relationships if provided
    if exercise_data.primary_muscle_ids is not None:
        primary_muscle_ids = exercise_data.primary_muscle_ids
        secondary_muscle_ids = exercise_data.secondary_muscle_ids or []

        # Validate muscle IDs exist
        all_muscle_ids = set(primary_muscle_ids + secondary_muscle_ids)
        existing_muscles = db.query(Muscle).filter(Muscle.id.in_(all_muscle_ids)).all()
        existing_muscle_ids = {m.id for m in existing_muscles}

        missing_ids = all_muscle_ids - existing_muscle_ids
        if missing_ids:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Músculos no encontrados: {', '.join(missing_ids)}"
            )

        # Delete existing relationships
        db.query(ExerciseMuscle).filter(ExerciseMuscle.exercise_id == exercise_id).delete()

        # Create new relationships
        for muscle_id in primary_muscle_ids:
            em = ExerciseMuscle(
                exercise_id=exercise_id,
                muscle_id=muscle_id,
                muscle_role="primary"
            )
            db.add(em)

        for muscle_id in secondary_muscle_ids:
            if muscle_id not in primary_muscle_ids:
                em = ExerciseMuscle(
                    exercise_id=exercise_id,
                    muscle_id=muscle_id,
                    muscle_role="secondary"
                )
                db.add(em)

    db.commit()

    # Reload with relationships
    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    return build_exercise_response(exercise)


@router.delete("/{exercise_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_exercise(
    exercise_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Delete an exercise.
    Requires trainer or admin role.
    """
    exercise = db.query(Exercise).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    db.delete(exercise)
    db.commit()

    return None


@router.post("/{exercise_id}/upload-image", response_model=ExerciseResponse)
async def upload_exercise_image(
    exercise_id: str,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Upload a custom image for an exercise.
    Requires trainer or admin role.
    Supported formats: JPG, JPEG, PNG, GIF, WEBP
    """
    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    # Validate file extension
    file_ext = Path(file.filename).suffix.lower()
    if file_ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Tipo de archivo no permitido. Tipos permitidos: {', '.join(ALLOWED_EXTENSIONS)}"
        )

    # Validate file size
    file.file.seek(0, 2)
    file_size = file.file.tell()
    file.file.seek(0)

    if file_size > MAX_FILE_SIZE_BYTES:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"El archivo ({file_size / 1024 / 1024:.2f}MB) excede el tamaño máximo ({MAX_FILE_SIZE_MB}MB)"
        )

    if file_size == 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El archivo está vacío"
        )

    old_image_url = exercise.image_url

    # Upload new media first; never delete old reference before successful upload.
    try:
        new_image_url = upload_exercise_media(exercise_id=exercise_id, file=file)
    except StorageError as e:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=f"Error al subir la imagen del ejercicio: {str(e)}"
        )

    # Persist new URL
    exercise.image_url = new_image_url
    db.commit()

    # Best-effort cleanup of previous image after successful update
    if old_image_url and old_image_url != new_image_url:
        try:
            delete_exercise_media(old_image_url)
        except StorageError:
            # Do not fail request after successful update
            pass

    return build_exercise_response(exercise)


@router.delete("/{exercise_id}/image", response_model=ExerciseResponse)
def delete_exercise_image(
    exercise_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Delete the custom image of an exercise.
    Requires trainer or admin role.
    """
    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    if not exercise.image_url:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El ejercicio no tiene una imagen personalizada"
        )

    try:
        delete_exercise_media(exercise.image_url)
    except StorageError as e:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=f"No se pudo eliminar la imagen en storage: {str(e)}"
        )

    # Clear image URL
    exercise.image_url = None
    db.commit()

    return build_exercise_response(exercise)


@router.post("/{exercise_id}/fetch-movement-image", response_model=ExerciseResponse)
async def fetch_movement_image(
    exercise_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Fetch a movement pattern image for an exercise from Wger.de.
    Requires trainer or admin role.
    """
    from services.wger_image import fetch_movement_image as fetch_wger_image, get_mapped_name

    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    # Try to fetch from Wger with mapped name
    search_name = get_mapped_name(exercise.name_en)
    image_url = fetch_wger_image(search_name)

    if not image_url:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail=f"No se encontró imagen de movimiento para '{exercise.name_en}' en Wger.de. Intenta subir una imagen personalizada."
        )

    # Update exercise with movement image URL
    exercise.thumbnail_url = image_url
    db.commit()

    return build_exercise_response(exercise)


@router.post("/{exercise_id}/generate-anatomy-image", response_model=ExerciseResponse)
async def generate_anatomy_image(
    exercise_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Generate an anatomical image for an exercise using the primary muscle.
    Requires trainer or admin role.
    """
    from services.muscle_image import generate_muscle_image_sync

    exercise = db.query(Exercise).options(
        joinedload(Exercise.exercise_muscles).joinedload(ExerciseMuscle.muscle)
    ).filter(Exercise.id == exercise_id).first()

    if not exercise:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Ejercicio con id {exercise_id} no encontrado"
        )

    if not exercise.primary_muscles:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El ejercicio no tiene músculos primarios asignados"
        )

    # Generate the anatomical image using primary muscle
    primary_muscle_name = exercise.primary_muscles[0].name
    image_url = generate_muscle_image_sync(
        muscle_group=primary_muscle_name,
        exercise_name=exercise.name_en,
        use_multicolor=True
    )

    if not image_url:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Error al generar la imagen anatómica. Por favor, intenta de nuevo."
        )

    # Update exercise with new anatomy image URL
    exercise.anatomy_image_url = image_url
    db.commit()

    return build_exercise_response(exercise)
