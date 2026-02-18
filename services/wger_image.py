"""
Service for fetching exercise movement images from Wger.de API
Wger.de is a free, open-source workout manager with exercise images
"""
import requests
from pathlib import Path
from typing import Optional, Dict

# Directory to save downloaded images
IMAGES_DIR = Path(__file__).parent.parent / "static" / "exercises" / "movement"
IMAGES_DIR.mkdir(parents=True, exist_ok=True)

# Wger API base URL
WGER_API_URL = "https://wger.de/api/v2"
WGER_BASE_URL = "https://wger.de"


def search_wger_exercise(exercise_name: str) -> Optional[Dict]:
    """
    Search for an exercise in Wger.de using the search endpoint.
    Returns the best matching exercise with image info or None if not found.
    """
    try:
        response = requests.get(
            f"{WGER_API_URL}/exercise/search/",
            params={
                "term": exercise_name,
                "language": "en"
            },
            timeout=15
        )
        response.raise_for_status()
        data = response.json()

        suggestions = data.get("suggestions", [])
        if not suggestions:
            print(f"  [NOT FOUND] No results for '{exercise_name}'")
            return None

        # Return first suggestion (best match)
        best_match = suggestions[0].get("data", {})
        print(f"  [FOUND] {best_match.get('name')} (id: {best_match.get('id')})")
        return best_match

    except Exception as e:
        print(f"Error searching Wger exercise: {e}")
        return None


def download_wger_image(image_path: str, exercise_name: str) -> Optional[str]:
    """
    Download an image from Wger and save it locally.
    Returns the local path or None if failed.
    """
    try:
        # Create safe filename
        safe_name = exercise_name.lower().replace(" ", "_").replace("-", "_")
        safe_name = "".join(c for c in safe_name if c.isalnum() or c == "_")

        # Build full URL
        if image_path.startswith("/"):
            image_url = f"{WGER_BASE_URL}{image_path}"
        else:
            image_url = image_path

        # Get file extension from URL
        ext = image_path.split(".")[-1].split("?")[0].lower()
        if ext not in ["jpg", "jpeg", "png", "gif", "webp"]:
            ext = "png"

        filename = f"{safe_name}_movement.{ext}"
        filepath = IMAGES_DIR / filename

        # Skip if already exists
        if filepath.exists():
            print(f"  [CACHED] {filename}")
            return f"/static/exercises/movement/{filename}"

        # Download image
        print(f"  [DOWNLOADING] {image_url}")
        response = requests.get(image_url, timeout=15)
        response.raise_for_status()

        with open(filepath, "wb") as f:
            f.write(response.content)

        print(f"  [OK] Downloaded: {filename}")
        return f"/static/exercises/movement/{filename}"

    except Exception as e:
        print(f"  [FAIL] Error downloading image: {e}")
        return None


def fetch_movement_image(exercise_name: str) -> Optional[str]:
    """
    Main function to fetch a movement image for an exercise.
    1. Search for the exercise in Wger using search endpoint
    2. Download the image if available

    Returns the local URL path or None if not found.
    """
    # Check if already downloaded
    safe_name = exercise_name.lower().replace(" ", "_").replace("-", "_")
    safe_name = "".join(c for c in safe_name if c.isalnum() or c == "_")

    # Check existing files
    for ext in ["jpg", "jpeg", "png", "gif", "webp"]:
        filepath = IMAGES_DIR / f"{safe_name}_movement.{ext}"
        if filepath.exists():
            print(f"  [CACHED] Found existing: {safe_name}_movement.{ext}")
            return f"/static/exercises/movement/{safe_name}_movement.{ext}"

    print(f"Searching Wger for: {exercise_name}")

    # Search for exercise using new search endpoint
    exercise = search_wger_exercise(exercise_name)
    if not exercise:
        return None

    # Check if exercise has image
    image_path = exercise.get("image")
    if not image_path:
        print(f"  [NO IMAGE] Exercise found but no image available")
        return None

    # Download the image
    return download_wger_image(image_path, exercise_name)


def fetch_all_movement_images_sync(exercises: list) -> dict:
    """
    Fetch movement images for multiple exercises.
    Returns dict with exercise name -> image URL mapping.
    """
    results = {}

    for exercise in exercises:
        name = exercise.get("name") if isinstance(exercise, dict) else exercise.name
        image_url = fetch_movement_image(name)
        results[name] = image_url

    return results


# Mapping of common exercise names to Wger search terms
# (helps with exercises that have different names in Wger)
EXERCISE_NAME_MAPPING = {
    "Barbell Bench Press": "bench press",
    "Barbell Back Squat": "squat",
    "Barbell Deadlift": "deadlift",
    "Pull-ups": "pull up",
    "Push-ups": "push up",
    "Military Press": "shoulder press",
    "Lat Pulldown": "lat pulldown",
    "Cable Row": "seated row",
    "Barbell Row": "bent over row",
    "Dumbbell Lateral Raise": "lateral raise",
    "Barbell Curl": "bicep curl",
    "Tricep Dips": "dips",
    "Leg Press": "leg press",
    "Leg Extension": "leg extension",
    "Leg Curl": "leg curl",
    "Calf Raises": "calf raise",
    "Plank": "plank",
}


def get_mapped_name(exercise_name: str) -> str:
    """Get the Wger-friendly name for an exercise"""
    return EXERCISE_NAME_MAPPING.get(exercise_name, exercise_name)
