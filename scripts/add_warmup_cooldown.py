import sys
import os
import uuid
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.user import User
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise, ExercisePhase, EffortType
from models.exercise import Exercise

# Database connection details from docker-compose.yml
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

def find_exercise(db, search_terms):
    """Find exercise by searching multiple terms"""
    for term in search_terms:
        # Try exact first
        ex = db.query(Exercise).filter(Exercise.name_es.ilike(f"{term}")).first()
        if ex: return ex
        # Try contains
        ex = db.query(Exercise).filter(Exercise.name_es.ilike(f"%{term}%")).first()
        if ex: return ex
        ex = db.query(Exercise).filter(Exercise.name_en.ilike(f"%{term}%")).first()
        if ex: return ex
    return None

try:
    print("Adding Warm-up and Cool-down for Yahir...")
    
    # 1. Find Yahir's active program
    yahir = db.query(User).filter(User.full_name.ilike("%Yahir Leal Zamago%")).first()
    if not yahir:
        print("❌ Yahir not found")
        sys.exit(1)
        
    macro = db.query(Macrocycle).filter(Macrocycle.client_id == yahir.id, Macrocycle.name == "Plan Hipertrofia 2024").first()
    if not macro:
        print("❌ Macrocycle not found")
        sys.exit(1)

    # Assume 1 meso, 1 micro
    meso = macro.mesocycles[0]
    micro = meso.microcycles[0]
    days = micro.training_days

    # 2. Define Exercises to Add
    # Tuple: (SearchTerms, Phase)
    upper_warmup = [
        (["Cinta", "Treadmill", "Elíptica"], ExercisePhase.WARMUP),
        (["Gato", "Cat", "Movilidad"], ExercisePhase.WARMUP)
    ]
    upper_cooldown = [
        (["Estiramiento Pectoral", "Chest Stretch"], ExercisePhase.COOLDOWN),
        (["Niño", "Child"], ExercisePhase.COOLDOWN)
    ]
    
    lower_warmup = [
        (["Bici", "Bike", "Cinta"], ExercisePhase.WARMUP),
        (["Sentadilla", "Squat"], ExercisePhase.WARMUP) # Bodyweight
    ]
    lower_cooldown = [
        (["Isquio", "Hamstring"], ExercisePhase.COOLDOWN),
        (["Cuádriceps", "Quad"], ExercisePhase.COOLDOWN)
    ]

    # 3. Iterate Days
    for day in days:
        if day.rest_day:
            continue
            
        print(f"\nProcessing Day {day.day_number}: {day.name}")
        
        is_upper = "Upper" in day.name or "Torso" in day.name
        
        warmups = upper_warmup if is_upper else lower_warmup
        cooldowns = upper_cooldown if is_upper else lower_cooldown
        
        # Add Warmups (at index 0, 1)
        # Shift existing exercises
        existing_exercises = db.query(DayExercise).filter(DayExercise.training_day_id == day.id).order_by(DayExercise.order_index).all()
        for ex in existing_exercises:
            ex.order_index += len(warmups)
        
        for i, (terms, phase) in enumerate(warmups):
            ex_obj = find_exercise(db, terms)
            if not ex_obj:
                print(f"  ⚠️ Could not find exercise for {terms}")
                continue
                
            new_ex = DayExercise(
                id=str(uuid.uuid4()),
                training_day_id=day.id,
                exercise_id=ex_obj.id,
                order_index=i,
                phase=phase,
                sets=1,
                reps_min=None,
                reps_max=None,
                duration_seconds=300 if "Cinta" in ex_obj.name_es or "Bici" in ex_obj.name_es else None,
                rest_seconds=0,
                effort_type=EffortType.RPE,
                effort_value=5,
                notes="Light intensity"
            )
            db.add(new_ex)
            print(f"  ➕ Added Warmup: {ex_obj.name_es}")

        # Add Cooldowns (at end)
        current_max_index = max([e.order_index for e in existing_exercises]) if existing_exercises else -1
        current_max_index += len(warmups) # Because we shifted them in memory but not DB commit yet? No, ORM tracks it.
        # Actually simplest is just append.
        
        # Wait, if I updated order_index above, I should rely on that.
        # existing_exercises are the MAIN ones.
        last_index = existing_exercises[-1].order_index if existing_exercises else len(warmups) - 1
        
        for i, (terms, phase) in enumerate(cooldowns):
            ex_obj = find_exercise(db, terms)
             # Fallback if specific stretch not found
            if not ex_obj and "Estiramiento" in terms[0]:
                 ex_obj = find_exercise(db, ["Estiramiento", "Stretch"])
            
            if not ex_obj:
                 print(f"  ⚠️ Could not find exercise for {terms}")
                 continue

            new_ex = DayExercise(
                id=str(uuid.uuid4()),
                training_day_id=day.id,
                exercise_id=ex_obj.id,
                order_index=last_index + 1 + i,
                phase=phase,
                sets=2,
                duration_seconds=60, # 60s stretch
                rest_seconds=30,
                effort_type=EffortType.RPE,
                effort_value=3,
                notes="Static stretch"
            )
            db.add(new_ex)
            print(f"  ➕ Added Cooldown: {ex_obj.name_es}")

    db.commit()
    print("\n✅ Warm-up and Cool-down added successfully!")

except Exception as e:
    print(f"❌ Error: {e}")
    db.rollback()
finally:
    db.close()
