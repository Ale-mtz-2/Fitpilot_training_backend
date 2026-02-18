"""
Router para traducción de contenido usando Ollama/Llama 3.2.
"""
from fastapi import APIRouter, HTTPException, Depends, BackgroundTasks
from pydantic import BaseModel, Field
from typing import Optional, List
from sqlalchemy.orm import Session

from models.base import get_db
from core.dependencies import get_current_user, require_trainer
from models.user import User
from models.exercise import Exercise
from services.translation import translation_service

router = APIRouter()


class TranslateRequest(BaseModel):
    """Schema para solicitud de traducción."""
    text: str = Field(..., min_length=1, max_length=5000)
    source_lang: str = Field(default="en", pattern="^(es|en)$")
    target_lang: str = Field(default="es", pattern="^(es|en)$")


class TranslateResponse(BaseModel):
    """Schema para respuesta de traducción."""
    original: str
    translated: str
    source_lang: str
    target_lang: str


class TranslateExerciseResponse(BaseModel):
    """Schema para respuesta de traducción de ejercicio."""
    exercise_id: str
    name_es: Optional[str]
    name_en: Optional[str]
    description_es: Optional[str]
    description_en: Optional[str]
    success: bool
    message: str


class TranslationStatusResponse(BaseModel):
    """Schema para estado del servicio de traducción."""
    available: bool
    model: str
    host: str


@router.get("/status", response_model=TranslationStatusResponse)
async def get_translation_status():
    """
    Verifica si el servicio de traducción (Ollama) está disponible.
    """
    available = await translation_service.is_available()
    return TranslationStatusResponse(
        available=available,
        model=translation_service.model,
        host=translation_service.ollama_host
    )


@router.post("/translate", response_model=TranslateResponse)
async def translate_text(
    request: TranslateRequest,
    current_user: User = Depends(get_current_user)
):
    """
    Traduce un texto entre idiomas soportados (es/en).
    """
    if request.source_lang == request.target_lang:
        return TranslateResponse(
            original=request.text,
            translated=request.text,
            source_lang=request.source_lang,
            target_lang=request.target_lang
        )

    translated = await translation_service.translate(
        text=request.text,
        source_lang=request.source_lang,
        target_lang=request.target_lang
    )

    if translated is None:
        raise HTTPException(
            status_code=503,
            detail="Servicio de traducción no disponible"
        )

    return TranslateResponse(
        original=request.text,
        translated=translated,
        source_lang=request.source_lang,
        target_lang=request.target_lang
    )


@router.post("/exercises/{exercise_id}/translate", response_model=TranslateExerciseResponse)
async def translate_exercise(
    exercise_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Traduce un ejercicio específico a ambos idiomas.
    Detecta el idioma original y genera las traducciones faltantes.
    """
    exercise = db.query(Exercise).filter(Exercise.id == exercise_id).first()
    if not exercise:
        raise HTTPException(status_code=404, detail="Ejercicio no encontrado")

    # Verificar disponibilidad del servicio
    if not await translation_service.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servicio de traducción no disponible. Verifica que Ollama esté corriendo."
        )

    try:
        # Detectar idioma original basado en el nombre
        # Por defecto asumimos que el contenido original está en inglés
        source_lang = "en"

        # Si no tiene name_es, traducir de en -> es
        if not exercise.name_es:
            result_es = await translation_service.translate_exercise(
                name=exercise.name_en,
                description=exercise.description_en,
                source_lang="en",
                target_lang="es"
            )
            exercise.name_es = result_es["name"]
            exercise.description_es = result_es["description"]

        db.commit()
        db.refresh(exercise)

        return TranslateExerciseResponse(
            exercise_id=exercise.id,
            name_es=exercise.name_es,
            name_en=exercise.name_en,
            description_es=exercise.description_es,
            description_en=exercise.description_en,
            success=True,
            message="Ejercicio traducido exitosamente"
        )

    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=500,
            detail=f"Error al traducir ejercicio: {str(e)}"
        )


@router.post("/exercises/translate-all")
async def translate_all_exercises(
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_trainer)
):
    """
    Inicia la traducción de todos los ejercicios que no tienen traducciones.
    Se ejecuta en segundo plano.
    """
    # Verificar disponibilidad del servicio
    if not await translation_service.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servicio de traducción no disponible. Verifica que Ollama esté corriendo."
        )

    # Contar ejercicios sin traducción
    exercises_without_translation = db.query(Exercise).filter(
        (Exercise.name_es.is_(None)) | (Exercise.name_en.is_(None))
    ).count()

    if exercises_without_translation == 0:
        return {
            "message": "Todos los ejercicios ya tienen traducciones",
            "pending": 0
        }

    # Iniciar traducción en segundo plano
    background_tasks.add_task(
        translate_exercises_background,
        db
    )

    return {
        "message": "Traducción iniciada en segundo plano",
        "pending": exercises_without_translation
    }


async def translate_exercises_background(db: Session):
    """
    Tarea en segundo plano para traducir todos los ejercicios.
    """
    import logging
    logger = logging.getLogger(__name__)

    exercises = db.query(Exercise).filter(
        (Exercise.name_es.is_(None)) | (Exercise.name_en.is_(None))
    ).all()

    total = len(exercises)
    translated = 0
    errors = 0

    for exercise in exercises:
        try:
            # Traducir a español si falta
            if not exercise.name_es:
                result = await translation_service.translate_exercise(
                    name=exercise.name_en,
                    description=exercise.description_en,
                    source_lang="en",
                    target_lang="es"
                )
                exercise.name_es = result["name"]
                exercise.description_es = result["description"]

            db.commit()
            translated += 1
            logger.info(f"Traducido {translated}/{total}: {exercise.name_en}")

        except Exception as e:
            errors += 1
            logger.error(f"Error traduciendo {exercise.name_en}: {e}")
            db.rollback()

    logger.info(f"Traducción completada: {translated} exitosos, {errors} errores")


@router.delete("/cache")
async def clear_translation_cache(
    current_user: User = Depends(require_trainer)
):
    """
    Limpia el cache de traducciones.
    """
    translation_service.clear_cache()
    return {"message": "Cache de traducciones limpiado"}
