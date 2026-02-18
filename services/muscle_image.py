"""
Service for generating anatomical muscle images using the Muscle Group Image Generator API
"""
import os
import httpx
from pathlib import Path
from typing import Optional

# URL del servicio muscle-image-api (interno en Docker)
MUSCLE_API_URL = os.getenv("MUSCLE_API_URL", "http://muscle-image-api:80")

# Directorio para guardar las imágenes
IMAGES_DIR = Path(__file__).parent.parent / "static" / "exercises" / "anatomy"
IMAGES_DIR.mkdir(parents=True, exist_ok=True)

# Mapeo de muscle_group de la aplicación a músculos anatómicos del API
MUSCLE_GROUP_MAPPING = {
    "chest": {
        "primary": ["chest"],
        "secondary": ["triceps", "shoulders_front"],
        "color": "220,53,69",  # Rojo
    },
    "back": {
        "primary": ["back", "latissimus"],
        "secondary": ["biceps", "shoulders_back"],
        "color": "0,123,255",  # Azul
    },
    "shoulders": {
        "primary": ["shoulders"],
        "secondary": ["triceps", "chest"],
        "color": "255,193,7",  # Amarillo
    },
    "arms": {
        "primary": ["biceps", "triceps", "forearms"],
        "secondary": [],
        "color": "111,66,193",  # Morado
    },
    "legs": {
        "primary": ["quadriceps", "hamstring", "gluteus", "calfs"],
        "secondary": ["adductors", "abductors"],
        "color": "40,167,69",  # Verde
    },
    "core": {
        "primary": ["abs", "core"],
        "secondary": ["back_lower"],
        "color": "253,126,20",  # Naranja
    },
    "cardio": {
        "primary": ["all"],
        "secondary": [],
        "color": "232,62,140",  # Rosa
    },
}

# Colores para músculos primarios y secundarios
PRIMARY_COLOR = "220,53,69"    # Rojo intenso
SECONDARY_COLOR = "255,193,7"   # Amarillo/dorado


async def generate_muscle_image(
    muscle_group: str,
    exercise_name: str,
    use_multicolor: bool = True
) -> Optional[str]:
    """
    Genera una imagen anatómica para un grupo muscular específico.

    Args:
        muscle_group: El grupo muscular (chest, back, shoulders, etc.)
        exercise_name: Nombre del ejercicio (para nombrar el archivo)
        use_multicolor: Si usar colores diferentes para músculos primarios/secundarios

    Returns:
        La ruta relativa de la imagen generada, o None si falla
    """
    if muscle_group not in MUSCLE_GROUP_MAPPING:
        print(f"Grupo muscular desconocido: {muscle_group}")
        return None

    mapping = MUSCLE_GROUP_MAPPING[muscle_group]
    primary_muscles = mapping["primary"]
    secondary_muscles = mapping["secondary"]
    primary_color = mapping["color"]

    # Crear nombre de archivo seguro
    safe_name = exercise_name.lower().replace(" ", "_").replace("-", "_")
    safe_name = "".join(c for c in safe_name if c.isalnum() or c == "_")
    filename = f"{safe_name}_anatomy.png"
    filepath = IMAGES_DIR / filename

    # Si ya existe, devolver la ruta
    if filepath.exists():
        return f"/static/exercises/anatomy/{filename}"

    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            if use_multicolor and secondary_muscles:
                # Usar endpoint multicolor para primarios y secundarios
                params = {
                    "primaryMuscleGroups": ",".join(primary_muscles),
                    "secondaryMuscleGroups": ",".join(secondary_muscles),
                    "primaryColor": primary_color,
                    "secondaryColor": "180,180,180",  # Gris para secundarios
                    "transparentBackground": "0"
                }
                url = f"{MUSCLE_API_URL}/getMulticolorImage"
            else:
                # Usar endpoint simple con un solo color
                all_muscles = primary_muscles + secondary_muscles
                params = {
                    "muscleGroups": ",".join(all_muscles),
                    "color": primary_color,
                    "transparentBackground": "0"
                }
                url = f"{MUSCLE_API_URL}/getImage"

            response = await client.get(url, params=params)

            if response.status_code == 200 and response.headers.get("content-type", "").startswith("image/"):
                with open(filepath, "wb") as f:
                    f.write(response.content)
                print(f"Imagen generada: {filename}")
                return f"/static/exercises/anatomy/{filename}"
            else:
                print(f"Error generando imagen: {response.status_code}")
                return None

    except Exception as e:
        print(f"Error conectando al API de imágenes: {e}")
        return None


def generate_muscle_image_sync(
    muscle_group: str,
    exercise_name: str,
    use_multicolor: bool = True
) -> Optional[str]:
    """
    Versión síncrona para scripts de seed.
    """
    import requests

    if muscle_group not in MUSCLE_GROUP_MAPPING:
        print(f"Grupo muscular desconocido: {muscle_group}")
        return None

    mapping = MUSCLE_GROUP_MAPPING[muscle_group]
    primary_muscles = mapping["primary"]
    secondary_muscles = mapping["secondary"]
    primary_color = mapping["color"]

    # Crear nombre de archivo seguro
    safe_name = exercise_name.lower().replace(" ", "_").replace("-", "_")
    safe_name = "".join(c for c in safe_name if c.isalnum() or c == "_")
    filename = f"{safe_name}_anatomy.png"
    filepath = IMAGES_DIR / filename

    # Si ya existe, devolver la ruta
    if filepath.exists():
        return f"/static/exercises/anatomy/{filename}"

    # Dentro de Docker usar el nombre del servicio, fuera usar localhost
    api_url = os.getenv("MUSCLE_API_URL", "http://muscle-image-api:80")

    try:
        if use_multicolor and secondary_muscles:
            params = {
                "primaryMuscleGroups": ",".join(primary_muscles),
                "secondaryMuscleGroups": ",".join(secondary_muscles),
                "primaryColor": primary_color,
                "secondaryColor": "180,180,180",
                "transparentBackground": "0"
            }
            url = f"{api_url}/getMulticolorImage"
        else:
            all_muscles = primary_muscles + secondary_muscles
            params = {
                "muscleGroups": ",".join(all_muscles),
                "color": primary_color,
                "transparentBackground": "0"
            }
            url = f"{api_url}/getImage"

        response = requests.get(url, params=params, timeout=30)

        if response.status_code == 200 and "image" in response.headers.get("content-type", ""):
            with open(filepath, "wb") as f:
                f.write(response.content)
            print(f"  [OK] {filename}")
            return f"/static/exercises/anatomy/{filename}"
        else:
            print(f"  [FAIL] Status: {response.status_code}")
            return None

    except Exception as e:
        print(f"  [ERROR] {str(e)[:50]}")
        return None


def get_anatomy_image_url(muscle_group: str) -> str:
    """
    Obtiene la URL de una imagen anatómica genérica para un grupo muscular.
    Útil para mostrar en cards cuando no hay imagen específica del ejercicio.
    """
    if muscle_group not in MUSCLE_GROUP_MAPPING:
        return ""

    filename = f"{muscle_group}_anatomy.png"
    filepath = IMAGES_DIR / filename

    if filepath.exists():
        return f"/static/exercises/anatomy/{filename}"

    # Si no existe, intentar generarla
    return generate_muscle_image_sync(muscle_group, muscle_group, use_multicolor=False) or ""
