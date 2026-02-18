"""
Add Spanish names to all exercises in the database
"""
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from models.base import SessionLocal
from models.exercise import Exercise

def add_spanish_names():
    """Add Spanish names to exercises"""
    db = SessionLocal()
    
    # Mapping of English to Spanish names
    spanish_names = {
        # Warmup exercises
        "Jumping Jacks": "Saltos de Tijera",
        "Jump Rope": "Saltar la Cuerda",
        "Bodyweight Squat": "Sentadilla con Peso Corporal",
        "Glute Bridge": "Puente de Glúteos",
        "Stretch": "Estiramiento",
        
        # Lower body
        "Hip Thrust": "Empuje de Cadera",
        "Barbell Hip Thrust": "Empuje de Cadera con Barra",
        "Bulgarian Split Squat": "Sentadilla Búlgara",
        "Romanian Deadlift": "Peso Muerto Rumano",
        "Leg Curl": "Curl de Pierna",
        "Lying Leg Curl": "Curl de Pierna Acostado",
        "Seated Leg Curl": "Curl de Pierna Sentado",
        "Cable Kickback": "Patada de Cable",
        "Squat": "Sentadilla",
        "Barbell Squat": "Sentadilla con Barra",
        "Lunge": "Zancada",
        "Walking Lunge": "Zancada Caminando",
        "Leg Press": "Prensa de Pierna",
        "Leg Extension": "Extensión de Pierna",
        "Calf Raise": "Elevación de Pantorrillas",
        "Standing Calf Raise": "Elevación de Pantorrillas de Pie",
        "Deadlift": "Peso Muerto",
        "Barbell Deadlift": "Peso Muerto con Barra",
        "Step Up": "Subida al Banco",
        "Cable Pull Through": "Jalón de Cable Entre Piernas",
        "Hip Abduction": "Abducción de Cadera",
        "Hip Abduction Machine": "Abducción de Cadera en Máquina",
        
        # Upper body
        "Bench Press": "Press de Banca",
        "Barbell Bench Press": "Press de Banca con Barra",
        "Lat Pulldown": "Jalón al Pecho",
        "Shoulder Press": "Press de Hombros",
        "Dumbbell Shoulder Press": "Press de Hombros con Mancuernas",
        "Cable Row": "Remo en Polea",
        "Seated Cable Row": "Remo en Polea Sentado",
        "Lateral Raise": "Elevaciones Laterales",
        "Dumbbell Lateral Raise": "Elevaciones Laterales con Mancuernas",
        "Row": "Remo",
        "Barbell Row": "Remo con Barra",
        "Pull Up": "Dominadas",
        "Face Pull": "Jalón Facial",
        "Reverse Fly": "Aperturas Posteriores",
        "Dumbbell Reverse Fly": "Aperturas Posteriores con Mancuernas",
        "Plank": "Plancha",
        
        # Cardio
        "Treadmill": "Caminadora",
        "Elliptical": "Elíptica",
        "Stationary Bike": "Bicicleta Estática",
        "Rowing Machine": "Máquina de Remo",
    }
    
    updated_count = 0
    
    for english_name, spanish_name in spanish_names.items():
        # Find exercise by English name (case insensitive, partial match)
        exercises = db.query(Exercise).filter(Exercise.name.ilike(f"%{english_name}%")).all()
        
        for exercise in exercises:
            if not exercise.name_es or exercise.name_es == "":
                exercise.name_es = spanish_name
                updated_count += 1
                print(f"✓ Updated: {exercise.name} → {spanish_name}")
    
    db.commit()
    db.close()
    
    print(f"\n✅ Successfully updated {updated_count} exercises with Spanish names")

if __name__ == "__main__":
    print("Adding Spanish names to exercises...")
    print("=" * 60)
    add_spanish_names()
    print("=" * 60)
    print("Done!")
