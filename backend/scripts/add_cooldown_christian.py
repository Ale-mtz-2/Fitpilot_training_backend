"""
Script to add cooldown exercises (Elliptical at moderate pace) to each
of the 4 main training days in Christian Cruz's program.
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from sqlalchemy.orm import Session, joinedload
from models.base import SessionLocal
from models.mesocycle import TrainingDay, DayExercise, ExercisePhase, EffortType

# Elliptical exercise ID
ELLIPTICAL_ID = "18f621cb-7f79-4a95-9fa4-4067bfa5a1f9"

# Training day IDs (the 4 main training days)
TRAINING_DAY_IDS = {
    "Torso A": "88a45567-f8d4-4601-b21f-4d17f63a88fb",
    "Pierna A": "66cc34a2-4b87-4502-a2e1-c48af617d6b5",
    "Torso B": "82ce9d38-a1d2-467f-bc62-5419544e78bd",
    "Pierna B": "ed28e37f-d670-4697-ade3-4b6ee66f898a",
}


def add_cooldown_exercises(db: Session):
    print("=" * 60)
    print("  Adding Cooldown Exercises (Elíptica)")
    print("=" * 60)

    for day_name, day_id in TRAINING_DAY_IDS.items():
        # Check if cooldown already exists
        existing = db.query(DayExercise).filter(
            DayExercise.training_day_id == day_id,
            DayExercise.phase == ExercisePhase.COOLDOWN
        ).first()

        if existing:
            print(f"  {day_name}: Cooldown already exists, skipping")
            continue

        # Get the highest order_index for this day
        last_exercise = db.query(DayExercise).filter(
            DayExercise.training_day_id == day_id
        ).order_by(DayExercise.order_index.desc()).first()

        next_index = (last_exercise.order_index + 1) if last_exercise else 0

        # Add elliptical as cooldown (5 min at moderate pace)
        cooldown = DayExercise(
            training_day_id=day_id,
            exercise_id=ELLIPTICAL_ID,
            order_index=next_index,
            phase=ExercisePhase.COOLDOWN,
            sets=1,
            reps_min=None,
            reps_max=None,
            rest_seconds=0,
            effort_type=EffortType.RPE,
            effort_value=4.0,  # RPE 4 = moderate/easy
            tempo="standard",
            set_type="straight",
            duration_seconds=300,  # 5 minutes
            intensity_zone=2,  # Zone 2 = moderate
            notes="Elíptica a ritmo moderado para enfriamiento (5 min, zona 2)"
        )
        db.add(cooldown)
        db.flush()
        print(f"  {day_name}: Added Elíptica cooldown (order {next_index}, ID: {cooldown.id})")

    db.commit()
    print("\n  ALL COOLDOWN EXERCISES ADDED SUCCESSFULLY")

    # Print final structure
    print("\n--- Final Structure ---")
    for day_name, day_id in TRAINING_DAY_IDS.items():
        exercises = db.query(DayExercise).options(
            joinedload(DayExercise.exercise)
        ).filter(
            DayExercise.training_day_id == day_id
        ).order_by(DayExercise.order_index).all()

        print(f"\n  {day_name}:")
        for ex in exercises:
            name = ex.exercise.name_es or ex.exercise.name_en if ex.exercise else "Unknown"
            if ex.duration_seconds:
                print(f"    [{ex.phase.value}] {ex.order_index}. {name}: {ex.sets}x{ex.duration_seconds}s")
            else:
                print(f"    [{ex.phase.value}] {ex.order_index}. {name}: {ex.sets}x{ex.reps_min}-{ex.reps_max}")


if __name__ == "__main__":
    db = SessionLocal()
    try:
        add_cooldown_exercises(db)
    except Exception as e:
        db.rollback()
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()
