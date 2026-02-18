import sys
import os
import uuid
import datetime
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.user import User
from models.mesocycle import (
    Macrocycle,
    Mesocycle, MesocycleStatus,
    Microcycle, IntensityLevel,
    TrainingDay,
    DayExercise, ExercisePhase, EffortType
)
from models.exercise import Exercise

# Database connection details from docker-compose.yml
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

def find_exercise(name_query):
    """Find an exercise by name (case-insensitive fuzzy matchish)"""
    # Try exact match first (es)
    ex = db.query(Exercise).filter(Exercise.name_es.ilike(f"%{name_query}%")).first()
    if ex: return ex
    
    # Try exact match (en)
    ex = db.query(Exercise).filter(Exercise.name_en.ilike(f"%{name_query}%")).first()
    if ex: return ex
    
    # Try partial
    ex = db.query(Exercise).filter(Exercise.name_es.ilike(f"%{name_query}%")).first()
    if ex: return ex
    ex = db.query(Exercise).filter(Exercise.name_en.ilike(f"%{name_query}%")).first()
    
    return ex

def create_program():
    try:
        # 1. Find Yahir
        print("Searching for Yahir...")
        yahir = db.query(User).filter(User.full_name.ilike("%Yahir Leal Zamago%")).first()
        if not yahir:
            print("❌ User 'Yahir Leal Zamago' not found.")
            return
        
        # Find Trainer (assign to first admin/trainer found or just hardcode if needed, 
        # but let's try to find an admin or trainer)
        trainer = db.query(User).filter(User.email.ilike("%admin%")).first() or yahir # Fallback to self if no trainer
        
        print(f"✅ Found Client: {yahir.full_name} ({yahir.id})")

        # 2. Create Macrocycle
        macro = Macrocycle(
            id=str(uuid.uuid4()),
            name="Plan Hipertrofia 2024",
            description="Programa enfocado en desarrollo muscular general. Frecuencia 4 (Upper/Lower).",
            objective="hypertrophy",
            start_date=datetime.date.today(),
            end_date=datetime.date.today() + datetime.timedelta(weeks=12),
            status=MesocycleStatus.ACTIVE,
            trainer_id=trainer.id,
            client_id=yahir.id
        )
        db.add(macro)
        db.commit()
        print(f"✅ Created Macrocycle: {macro.name}")

        # 3. Create Mesocycle
        meso = Mesocycle(
            id=str(uuid.uuid4()),
            macrocycle_id=macro.id,
            block_number=1,
            name="Mesociclo 1 - Acumulación",
            description="Foco en volumen y técnica. RIR 2-3.",
            start_date=datetime.date.today(),
            end_date=datetime.date.today() + datetime.timedelta(weeks=4),
            focus="Hypertrophy",
        )
        db.add(meso)
        db.commit()
        print(f"✅ Created Mesocycle: {meso.name}")

        # 4. Create Microcycle
        micro = Microcycle(
            id=str(uuid.uuid4()),
            mesocycle_id=meso.id,
            week_number=1,
            name="Semana 1",
            start_date=datetime.date.today(),
            end_date=datetime.date.today() + datetime.timedelta(days=7),
            intensity_level=IntensityLevel.MEDIUM
        )
        db.add(micro)
        db.commit()
        print(f"✅ Created Microcycle: {micro.name}")

        # 5. Create Days and Exercises
        
        days_config = [
            # Day 1: Upper A
            {
                "day_num": 1, "name": "Upper Body Strength", "focus": "Torso Fuerza", 
                "exercises": [
                    {"name": "Bench Press", "sets": 3, "reps_min": 6, "reps_max": 8, "rir": 2}, # Press Banca
                    {"name": "Barbell Row", "sets": 3, "reps_min": 8, "reps_max": 10, "rir": 2}, # Remo Barra
                    {"name": "Overhead Press", "sets": 3, "reps_min": 8, "reps_max": 10, "rir": 2}, # Press Militar (buscar partial)
                    {"name": "Pull-up", "sets": 3, "reps_min": 0, "reps_max": 0, "rir": 1, "notes": "Al fallo o RIR 1"}, # Dominadas
                    {"name": "Dumbbell Curl", "sets": 3, "reps_min": 10, "reps_max": 12, "rir": 1}, # Biceps
                    {"name": "Triceps", "sets": 3, "reps_min": 10, "reps_max": 12, "rir": 1}, # Triceps (general search)
                ]
            },
            # Day 2: Lower A
            {
                "day_num": 2, "name": "Lower Body Squat Focus", "focus": "Pierna Enfasis Sentadilla",
                "exercises": [
                    {"name": "Squat", "sets": 3, "reps_min": 6, "reps_max": 8, "rir": 2}, # Sentadilla
                    {"name": "Romanian Deadlift", "sets": 3, "reps_min": 8, "reps_max": 10, "rir": 2}, # Peso Muerto Rumano
                    {"name": "Leg Press", "sets": 3, "reps_min": 10, "reps_max": 12, "rir": 2}, # Prensa
                    {"name": "Leg Curl", "sets": 3, "reps_min": 12, "reps_max": 15, "rir": 1}, # Curl Femoral
                    {"name": "Calf Raise", "sets": 4, "reps_min": 15, "reps_max": 20, "rir": 1}, # Gemelo
                ]
            },
            # Day 3: Rest
            { "day_num": 3, "name": "Descanso", "focus": "Recuperación", "rest": True, "exercises": [] },
            # Day 4: Upper B
            {
                "day_num": 4, "name": "Upper Body Hypertrophy", "focus": "Torso Hipertrofia",
                "exercises": [
                    {"name": "Incline Dumbbell Press", "sets": 3, "reps_min": 10, "reps_max": 12, "rir": 2}, # Inclinado Mancuernas
                    {"name": "Cable Row", "sets": 3, "reps_min": 10, "reps_max": 12, "rir": 2}, # Remo Polea
                    {"name": "Lateral Raise", "sets": 4, "reps_min": 12, "reps_max": 15, "rir": 1}, # Laterales
                    {"name": "Fly", "sets": 3, "reps_min": 12, "reps_max": 15, "rir": 1}, # Aperturas
                    {"name": "Face Pull", "sets": 3, "reps_min": 15, "reps_max": 20, "rir": 1}, # Facepull
                ]
            },
            # Day 5: Lower B
            {
                "day_num": 5, "name": "Lower Body Hinge Focus", "focus": "Pierna Cadena Posterior",
                "exercises": [
                    {"name": "Deadlift", "sets": 3, "reps_min": 5, "reps_max": 6, "rir": 2}, # Peso Muerto
                    {"name": "Lunge", "sets": 3, "reps_min": 10, "reps_max": 12, "rir": 2}, # Zancadas
                    {"name": "Leg Extension", "sets": 3, "reps_min": 12, "reps_max": 15, "rir": 1}, # Extensión Cuadriceps
                    {"name": "Seated Leg Curl", "sets": 3, "reps_min": 12, "reps_max": 15, "rir": 1}, # Curl Femoral Sentado
                    {"name": "Calf", "sets": 4, "reps_min": 15, "reps_max": 20, "rir": 1}, # Gemelo
                ]
            },
            # Day 6: Rest
            { "day_num": 6, "name": "Descanso", "focus": "Recuperación", "rest": True, "exercises": [] },
            # Day 7: Rest
            { "day_num": 7, "name": "Descanso", "focus": "Recuperación", "rest": True, "exercises": [] },
        ]

        for day_data in days_config:
            # Create Day
            day = TrainingDay(
                id=str(uuid.uuid4()),
                microcycle_id=micro.id,
                day_number=day_data["day_num"],
                date=micro.start_date + datetime.timedelta(days=day_data["day_num"]-1),
                name=day_data["name"],
                focus=day_data["focus"],
                rest_day=day_data.get("rest", False)
            )
            db.add(day)
            db.commit()
            print(f"  📅 Day {day.day_number}: {day.name} (Rest: {day.rest_day})")

            # Insert Exercises
            order = 1
            for ex_data in day_data["exercises"]:
                found_ex = find_exercise(ex_data["name"])
                
                if not found_ex:
                    print(f"    ⚠️ Warning: Could not find exercise matching '{ex_data['name']}'. Skipping.")
                    continue
                
                day_ex = DayExercise(
                    id=str(uuid.uuid4()),
                    training_day_id=day.id,
                    exercise_id=found_ex.id,
                    order_index=order,
                    phase=ExercisePhase.MAIN,
                    sets=ex_data["sets"],
                    reps_min=ex_data["reps_min"],
                    reps_max=ex_data["reps_max"],
                    rest_seconds=90, # Default rest
                    effort_type=EffortType.RIR,
                    effort_value=float(ex_data["rir"]),
                    notes=ex_data.get("notes")
                )
                db.add(day_ex)
                order += 1
                print(f"    ➕ Added: {found_ex.get_name()}")
            
            db.commit() # Commit exercises for this day

        print("\n✨ Program successfully created!")

    except Exception as e:
        print(f"❌ Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    create_program()
