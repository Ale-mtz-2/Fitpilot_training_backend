"""
Script to complete Britney Itzel's training program with mesocycles, microcycles, days, and exercises.
Based on her interview data and program goals.
"""
import sys
import os
from datetime import datetime, timedelta

# Add parent directory to path to import models
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from sqlalchemy.orm import Session
from models.base import SessionLocal
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise, ExercisePhase
from models.exercise import Exercise
import uuid

# IDs from database
CLIENT_ID = "d0ca34fc-10e0-4501-933d-90e6937dd2fa"  # Itzel Britney
MACROCYCLE_ID = "7b1fb1ad-2c53-4a25-bd89-c32e2c42bb00"  # Glute Growth & Posture Correction

def get_exercise_by_name(db: Session, name_part: str) -> Exercise | None:
    """Find exercise by partial name match"""
    return db.query(Exercise).filter(Exercise.name.ilike(f"%{name_part}%")).first()

def create_warmup_exercises(db: Session, training_day_id: str, order_start: int = 1):
    """Create standard warmup exercises"""
    warmup_exercises = [
        {"name": "jump", "sets": 1, "duration": 300},  # 5 min cardio
        {"name": "squat", "sets": 2, "reps": (10, 15)},  # Bodyweight squats
        {"name": "glute bridge", "sets": 2, "reps": (12, 15)},  # Glute activation
    ]
    
    exercises_created = []
    for idx, ex_config in enumerate(warmup_exercises):
        exercise = get_exercise_by_name(db, ex_config["name"])
        if exercise:
            day_ex = DayExercise(
                id=str(uuid.uuid4()),
                training_day_id=training_day_id,
                exercise_id=exercise.id,
                order_index=order_start + idx,
                phase=ExercisePhase.WARMUP,
                sets=ex_config["sets"],
                reps_min=ex_config.get("reps", (0, 0))[0] if "reps" in ex_config else None,
                reps_max=ex_config.get("reps", (0, 0))[1] if "reps" in ex_config else None,
                rest_seconds=60,
                effort_type="RPE",
                effort_value=5.0,
                tempo="standard",
                set_type="straight",
                duration_seconds=ex_config.get("duration"),
                notes="Calentamiento"
            )
            exercises_created.append(day_ex)
    
    return exercises_created

def create_cooldown_exercises(db: Session, training_day_id: str, order_start: int):
    """Create standard cooldown/stretching exercises"""
    cooldown_exercises = [
        {"name": "stretch", "sets": 1, "duration": 300},  # 5 min stretching
    ]
    
    exercises_created = []
    for idx, ex_config in enumerate(cooldown_exercises):
        exercise = get_exercise_by_name(db, ex_config["name"])
        if exercise:
            day_ex = DayExercise(
                id=str(uuid.uuid4()),
                training_day_id=training_day_id,
                exercise_id=exercise.id,
                order_index=order_start + idx,
                phase=ExercisePhase.COOLDOWN,
                sets=ex_config["sets"],
                reps_min=None,
                reps_max=None,
                rest_seconds=0,
                effort_type="RPE",
                effort_value=3.0,
                tempo=None,
                set_type="straight",
                duration_seconds=ex_config.get("duration"),
                notes="Enfriamiento y estiramiento"
            )
            exercises_created.append(day_ex)
    
    return exercises_created

def create_program_structure(db: Session):
    """Create complete program structure for Britney"""
    
    # Get macrocycle
    print(f"Looking for macrocycle with ID: {MACROCYCLE_ID}")
    all_macrocycles = db.query(Macrocycle).all()
    print(f"Found {len(all_macrocycles)} total macrocycles in database")
    for m in all_macrocycles:
        print(f"  - {m.id}: {m.name}")
    
    macrocycle = db.query(Macrocycle).filter(Macrocycle.id == MACROCYCLE_ID).first()
    if not macrocycle:
        print("Macrocycle not found!")
        print(f"Tried to find ID: {MACROCYCLE_ID}")
        return
    
    print(f"Found macrocycle: {macrocycle.name}")
    print(f"Duration: {macrocycle.start_date} to {macrocycle.end_date}")
    
    # Calculate weeks
    duration_days = (macrocycle.end_date - macrocycle.start_date).days
    total_weeks = duration_days // 7
    
    print(f"Total weeks: {total_weeks}")
    
    # Create 1 Mesocycle (6 weeks - beginner program)
    mesocycle_start = macrocycle.start_date
    mesocycle_end = mesocycle_start + timedelta(weeks=6)
    
    mesocycle = Mesocycle(
        id=str(uuid.uuid4()),
        macrocycle_id=MACROCYCLE_ID,
        block_number=1,
        name="Bloque Fundacional - Desarrollo de Glúteos",
        description="Fase inicial de hipertrofia enfocada en activación de glúteos, base de fuerza y corrección postural",
        start_date=mesocycle_start,
        end_date=mesocycle_end,
        focus="Hipertrofia - Fundación",
        notes="Enfoque en técnica, conexión mente-músculo y sobrecarga progresiva. Énfasis en hip thrust y patrones de sentadilla."
    )
    db.add(mesocycle)
    db.flush()
    print(f"Created mesocycle: {mesocycle.name}")
    
    # Create 6 Microcycles (weeks)
    current_date = mesocycle_start
    
    for week_num in range(1, 7):
        week_start = current_date
        week_end = week_start + timedelta(days=6)
        
        # Determine intensity based on week
        if week_num <= 2:
            intensity = "medium"
            intensity_note = "Fase de aprendizaje - pesos moderados"
        elif week_num <= 4:
            intensity = "high"
            intensity_note = "Fase de construcción - incrementar pesos"
        elif week_num == 5:
            intensity = "high"
            intensity_note = "Semana pico - pesos más pesados"
        else:  # week 6
            intensity = "low"
            intensity_note = "Semana de descarga - reducir volumen e intensidad"
        
        microcycle = Microcycle(
            id=str(uuid.uuid4()),
            mesocycle_id=mesocycle.id,
            week_number=week_num,
            name=f"Week {week_num}",
            start_date=week_start,
            end_date=week_end,
            intensity_level=intensity,
            notes=intensity_note
        )
        db.add(microcycle)
        db.flush()
        print(f"Created week {week_num}: {microcycle.name}")
        
        # Create 5 training days (Mon, Tue, Thu, Fri, Sat)
        training_days_config = [
            {"day_num": 1, "name": "Tren Inferior A - Enfoque Glúteos", "focus": "Glúteos e Isquiotibiales"},
            {"day_num": 2, "name": "Tren Superior A - Empuje y Jalón", "focus": "Pecho, Espalda, Hombros"},
            {"day_num": 4, "name": "Tren Inferior B - Cuádriceps y Glúteos", "focus": "Cuádriceps, Glúteos, Pantorrillas"},
            {"day_num": 5, "name": "Tren Superior B - Postura", "focus": "Espalda, Deltoides Posteriores, Core"},
            {"day_num": 6, "name": "Tren Inferior C - Dominante de Cadera", "focus": "Glúteos, Isquiotibiales, Abductores"},
        ]
        
        for day_config in training_days_config:
            day_date = week_start + timedelta(days=day_config["day_num"] - 1)
            
            training_day = TrainingDay(
                id=str(uuid.uuid4()),
                microcycle_id=microcycle.id,
                day_number=day_config["day_num"],
                date=day_date,
                name=day_config["name"],
                focus=day_config["focus"],
                rest_day=False,
                notes=""
            )
            db.add(training_day)
            db.flush()
            print(f"  Created day {day_config['day_num']}: {training_day.name}")
            
            # Add exercises based on day type
            day_exercises = []
            
            # Add warmup (3 exercises)
            warmup_exs = create_warmup_exercises(db, training_day.id, order_start=1)
            day_exercises.extend(warmup_exs)
            
            order_index = len(warmup_exs) + 1
            
            # Main exercises based on day
            if "Lower A" in day_config["name"]:
                # Glute-focused day
                main_exercises = create_lower_a_exercises(db, training_day.id, order_index, week_num)
            elif "Upper A" in day_config["name"]:
                main_exercises = create_upper_a_exercises(db, training_day.id, order_index, week_num)
            elif "Lower B" in day_config["name"]:
                main_exercises = create_lower_b_exercises(db, training_day.id, order_index, week_num)
            elif "Upper B" in day_config["name"]:
                main_exercises = create_upper_b_exercises(db, training_day.id, order_index, week_num)
            else:  # Lower C
                main_exercises = create_lower_c_exercises(db, training_day.id, order_index, week_num)
            
            day_exercises.extend(main_exercises)
            order_index += len(main_exercises)
            
            # Add cooldown
            cooldown_exs = create_cooldown_exercises(db, training_day.id, order_index)
            day_exercises.extend(cooldown_exs)
            
            # Save all exercises
            for ex in day_exercises:
                db.add(ex)
            
            print(f"    Added {len(day_exercises)} exercises ({len(warmup_exs)} warmup, {len(main_exercises)} main, {len(cooldown_exs)} cooldown)")
        
        current_date = week_end + timedelta(days=1)
    
    db.commit()
    print("\nProgram structure created successfully!")

def create_lower_a_exercises(db: Session, training_day_id: str, start_order: int, week_num: int):
    """Lower A - G lute Focus exercises"""
    # Adjust sets/reps based on week (deload on week 6)
    sets_main = 3 if week_num < 6 else 2
    sets_accessory = 3 if week_num < 6 else 2
    
    exercises_config = [
        {"name": "hip thrust", "sets": 4 if week_num < 6 else 3, "reps": (8, 12), "rest": 120, "effort": 8.0},
        {"name": "bulgarian split squat", "sets": sets_main, "reps": (10, 12), "rest": 90, "effort": 7.5},
        {"name": "romanian deadlift", "sets": sets_main, "reps": (10, 12), "rest": 90, "effort": 7.5},
        {"name": "leg curl", "sets": sets_accessory, "reps": (12, 15), "rest": 60, "effort": 8.0},
        {"name": "cable kickback", "sets": sets_accessory, "reps": (12, 15), "rest": 60, "effort": 7.0},
    ]
    
    return create_main_exercises(db, training_day_id, start_order, exercises_config)

def create_upper_a_exercises(db: Session, training_day_id: str, start_order: int, week_num: int):
    """Upper A - Push & Pull exercises"""
    sets_main = 3 if week_num < 6 else 2
    sets_accessory = 3 if week_num < 6 else 2
    
    exercises_config = [
        {"name": "bench press", "sets": sets_main, "reps": (8, 10), "rest": 120, "effort": 7.5},
        {"name": "lat pulldown", "sets": sets_main, "reps": (10, 12), "rest": 90, "effort": 7.5},
        {"name": "shoulder press", "sets": sets_main, "reps": (10, 12), "rest": 90, "effort": 7.0},
        {"name": "cable row", "sets": sets_accessory, "reps": (12, 15), "rest": 60, "effort": 7.5},
        {"name": "lateral raise", "sets": sets_accessory, "reps": (12, 15), "rest": 45, "effort": 7.0},
    ]
    
    return create_main_exercises(db, training_day_id, start_order, exercises_config)

def create_lower_b_exercises(db: Session, training_day_id: str, start_order: int, week_num: int):
    """Lower B - Quad & Glute exercises"""
    sets_main = 3 if week_num < 6 else 2
    sets_accessory = 3 if week_num < 6 else 2
    
    exercises_config = [
        {"name": "squat", "sets": 4 if week_num < 6 else 3, "reps": (8, 10), "rest": 150, "effort": 8.0},
        {"name": "lunge", "sets": sets_main, "reps": (10, 12), "rest": 90, "effort": 7.5},
        {"name": "leg press", "sets": sets_main, "reps": (12, 15), "rest": 90, "effort": 7.5},
        {"name": "leg extension", "sets": sets_accessory, "reps": (12, 15), "rest": 60, "effort": 7.0},
        {"name": "calf raise", "sets": sets_accessory, "reps": (15, 20), "rest": 45, "effort": 8.0},
    ]
    
    return create_main_exercises(db, training_day_id, start_order, exercises_config)

def create_upper_b_exercises(db: Session, training_day_id: str, start_order: int, week_num: int):
    """Upper B - Posture & Back Focus exercises"""
    sets_main = 3 if week_num < 6 else 2
    sets_accessory = 3 if week_num < 6 else 2
    
    exercises_config = [
        {"name": "row", "sets": 4 if week_num < 6 else 3, "reps": (8, 10), "rest": 120, "effort": 7.5},
        {"name": "pull up", "sets": sets_main, "reps": (6, 10), "rest": 120, "effort": 8.0},
        {"name": "face pull", "sets": sets_accessory, "reps": (15, 20), "rest": 60, "effort": 7.0},
        {"name": "reverse fly", "sets": sets_accessory, "reps": (12, 15), "rest": 60, "effort": 7.0},
        {"name": "plank", "sets": 3, "reps": (30, 60), "rest": 60, "effort": 7.0},  # Time in seconds
    ]
    
    return create_main_exercises(db, training_day_id, start_order, exercises_config)

def create_lower_c_exercises(db: Session, training_day_id: str, start_order: int, week_num: int):
    """Lower C - Hip Dominant exercises"""
    sets_main = 3 if week_num < 6 else 2
    sets_accessory = 3 if week_num < 6 else 2
    
    exercises_config = [
        {"name": "deadlift", "sets": 3 if week_num < 6 else 2, "reps": (6, 8), "rest": 180, "effort": 8.5},
        {"name": "step up", "sets": sets_main, "reps": (10, 12), "rest": 90, "effort": 7.5},
        {"name": "cable pull through", "sets": sets_main, "reps": (12, 15), "rest": 75, "effort": 7.0},
        {"name": "hip abduction", "sets": sets_accessory, "reps": (15, 20), "rest": 60, "effort": 7.5},
        {"name": "seated leg curl", "sets": sets_accessory, "reps": (12, 15), "rest": 60, "effort": 7.5},
    ]
    
    return create_main_exercises(db, training_day_id, start_order, exercises_config)

def create_main_exercises(db: Session, training_day_id: str, start_order: int, exercises_config: list):
    """Generic function to create main workout exercises"""
    exercises_created = []
    
    for idx, ex_config in enumerate(exercises_config):
        exercise = get_exercise_by_name(db, ex_config["name"])
        if not exercise:
            print(f"    WARNING: Exercise '{ex_config['name']}' not found in database")
            continue
        
        day_ex = DayExercise(
            id=str(uuid.uuid4()),
            training_day_id=training_day_id,
            exercise_id=exercise.id,
            order_index=start_order + idx,
            phase=ExercisePhase.MAIN,
            sets=ex_config["sets"],
            reps_min=ex_config["reps"][0],
            reps_max=ex_config["reps"][1],
            rest_seconds=ex_config["rest"],
            effort_type="RIR",
            effort_value=10.0 - ex_config["effort"],  # Convert RPE to RIR
            tempo="standard",
            set_type="straight",
            notes=""
        )
        exercises_created.append(day_ex)
    
    return exercises_created

if __name__ == "__main__":
    print("Starting to complete Britney's training program...")
    print("=" * 60)
    
    db = SessionLocal()
    try:
        create_program_structure(db)
    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
        raise
    finally:
        db.close()
    
    print("=" * 60)
    print("Done!")
