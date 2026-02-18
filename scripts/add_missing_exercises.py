"""
Add missing exercises to the database for Britney's program
"""
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from models.base import SessionLocal
from models.exercise import Exercise, ExerciseType, ResistanceProfile
import uuid

def add_missing_exercises():
    """Add exercises that were missing from the database"""
    db = SessionLocal()
    
    missing_exercises = [
        {
            "name": "Cable Kickback",
            "name_es": "Patada de Cable",
            "type": ExerciseType.MONOARTICULAR,
            "resistance_profile": ResistanceProfile.ASCENDING,
            "category": "glute_isolation",
            "description": "Isolated glute exercise using cable machine",
            "description_es": "Ejercicio de aislamiento de glúteos utilizando máquina de cable",
            "equipment_needed": "Cable Machine",
            "difficulty_level": "intermediate"
        },
        {
            "name": "Pull Up",
            "name_es": "Dominadas",
            "type": ExerciseType.MULTIARTICULAR,
            "resistance_profile": ResistanceProfile.ASCENDING,
            "category": "compound_pull",
            "description": "Bodyweight pulling exercise for back and biceps",
            "description_es": "Ejercicio de tracción con peso corporal para espalda y bíceps",
            "equipment_needed": "Pull-up Bar",
            "difficulty_level": "advanced"
        },
        {
            "name": "Reverse Fly",
            "name_es": "Aperturas Posteriores",
            "type": ExerciseType.MONOARTICULAR,
            "resistance_profile": ResistanceProfile.BELL_SHAPED,
            "category": "shoulder_isolation",
            "description": "Rear deltoid isolation exercise",
            "description_es": "Ejercicio de aislamiento para deltoides posterior",
            "equipment_needed": "Dumbbells",
            "difficulty_level": "intermediate"
        },
        {
            "name": "Step Up",
            "name_es": "Subida al Banco",
            "type": ExerciseType.MULTIARTICULAR,
            "resistance_profile": ResistanceProfile.FLAT,
            "category": "compound_lower",
            "description": "Unilateral leg exercise focusing on quads and glutes",
            "description_es": "Ejercicio unilateral de pierna enfocado en cuádriceps y glúteos",
            "equipment_needed": "Bench, Dumbbells",
            "difficulty_level": "intermediate"
        },
        {
            "name": "Cable Pull Through",
            "name_es": "Jalón de Cable Entre Piernas",
            "type": ExerciseType.MULTIARTICULAR,
            "resistance_profile": ResistanceProfile.ASCENDING,
            "category": "hip_hinge",
            "description": "Hip hinge movement pattern using cable",
            "description_es": "Patrón de bisagra de cadera utilizando cable",
            "equipment_needed": "Cable Machine",
            "difficulty_level": "intermediate"
        },
        {
            "name": "Hip Abduction Machine",
            "name_es": "Abducción de Cadera en Máquina",
            "type": ExerciseType.MONOARTICULAR,
            "resistance_profile": ResistanceProfile.FLAT,
            "category": "glute_isolation",
            "description": "Isolated glute medius exercise",
            "description_es": "Ejercicio de aislamiento para glúteo medio",
            "equipment_needed": "Hip Abduction Machine",
            "difficulty_level": "beginner"
        }
    ]
    
    added_count = 0
    
    for ex_data in missing_exercises:
        # Check if exercise already exists
        existing = db.query(Exercise).filter(Exercise.name == ex_data["name"]).first()
        if existing:
            print(f"Exercise '{ex_data['name']}' already exists, skipping...")
            continue
        
        # Create new exercise
        exercise = Exercise(
            id=str(uuid.uuid4()),
            name=ex_data["name"],
            name_es=ex_data.get("name_es"),
            type=ex_data["type"],
            resistance_profile=ex_data["resistance_profile"],
            category=ex_data["category"],
            description=ex_data.get("description"),
            description_es=ex_data.get("description_es"),
            equipment_needed=ex_data.get("equipment_needed"),
            difficulty_level=ex_data.get("difficulty_level")
        )
        
        db.add(exercise)
        added_count += 1
        print(f"✓ Added: {ex_data['name']} ({ex_data['name_es']})")
    
    db.commit()
    db.close()
    
    print(f"\n✅ Successfully added {added_count} exercises to the database")

if __name__ == "__main__":
    print("Adding missing exercises to database...")
    print("=" * 60)
    add_missing_exercises()
    print("=" * 60)
    print("Done!")
