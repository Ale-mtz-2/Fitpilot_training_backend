"""
Script to modify Christian Cruz's training program:
1. Add a rest day (Day 3) after Day 2
2. Add a warmup exercise to each training day
3. Add a Core & Mobility day (Day 6) after the 4th training day

Database: postgresql://admin:secretpass@localhost:5433/fitpilot_db
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from datetime import date
from sqlalchemy.orm import Session, joinedload
from models.base import SessionLocal
from models.mesocycle import (
    Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise,
    ExercisePhase, EffortType
)
from models.user import User
from models.exercise import Exercise


# === Exercise IDs from the database ===
# Warmup exercises
WARMUP_EXERCISES = {
    "arm_circles": "0e27b27f-1558-48e0-9e09-6a950d63d6f7",
    "leg_swings": "7027654b-575d-49b8-8e26-e70bc76966b1",
    "band_pull_apart": "3fb2ab04-137c-44ce-a16b-d4b12c818172",
    "hip_circles": "f89614fb-f6ed-4733-877f-e357906c4925",
}

# Core exercises
CORE_EXERCISES = {
    "dead_bug": "dfb6bdf3-9a78-496c-9eb3-0cb2f91a2182",
    "side_plank": "cded2f69-f3aa-4414-9898-966bc650e5d6",
    "reverse_crunch": "c03d86b7-2c86-45fe-bbee-5bdc2f7b1fb4",
}

# Mobility exercises
MOBILITY_EXERCISES = {
    "thoracic_rotation": "e25515d5-4d65-446d-869e-cfb2cab39ff1",
    "cat_cow": "bad51b6d-2654-4c25-b69e-ba9c5f094449",
}

# === Known Day IDs ===
MICROCYCLE_ID = "8da3e94a-8a69-4d7b-909e-44cd01e1f199"
DAY_IDS = {
    "torso_a": "88a45567-f8d4-4601-b21f-4d17f63a88fb",      # Day 1
    "pierna_a": "66cc34a2-4b87-4502-a2e1-c48af617d6b5",      # Day 2
    "torso_b": "82ce9d38-a1d2-467f-bc62-5419544e78bd",        # Day 4
    "pierna_b": "ed28e37f-d670-4697-ade3-4b6ee66f898a",        # Day 5
    "descanso_6": "d51df3d3-d69e-43d4-aca3-44c2afc67e4a",     # Day 6 (rest)
    "descanso_7": "4d54136e-d9f8-4390-a6df-32c4eae42a3e",     # Day 7 (rest)
}


def add_rest_day_3(db: Session):
    """1. Add a rest day after Day 2 (Pierna A)"""
    print("\n--- 1. Adding Rest Day 3 ---")

    # Check if Day 3 already exists
    existing = db.query(TrainingDay).filter(
        TrainingDay.microcycle_id == MICROCYCLE_ID,
        TrainingDay.day_number == 3
    ).first()

    if existing:
        print(f"  Day 3 already exists: {existing.name} (ID: {existing.id})")
        return

    rest_day = TrainingDay(
        microcycle_id=MICROCYCLE_ID,
        day_number=3,
        date=date(2026, 2, 25),  # Wednesday after Mon/Tue training
        name="Descanso",
        focus="Recuperación",
        rest_day=True,
        notes="Día de descanso activo. Caminar 20-30 min si se desea."
    )
    db.add(rest_day)
    db.flush()
    print(f"  Created Rest Day 3 (ID: {rest_day.id})")


def add_warmup_exercises(db: Session):
    """2. Add a warmup exercise to each training day"""
    print("\n--- 2. Adding Warmup Exercises ---")

    warmup_config = [
        {
            "day_id": DAY_IDS["torso_a"],
            "day_name": "Torso A",
            "exercise_id": WARMUP_EXERCISES["arm_circles"],
            "exercise_name": "Círculos de Brazos",
            "reps_min": 15,
            "reps_max": 15,
        },
        {
            "day_id": DAY_IDS["pierna_a"],
            "day_name": "Pierna A",
            "exercise_id": WARMUP_EXERCISES["leg_swings"],
            "exercise_name": "Balanceo de Piernas",
            "reps_min": 15,
            "reps_max": 15,
        },
        {
            "day_id": DAY_IDS["torso_b"],
            "day_name": "Torso B",
            "exercise_id": WARMUP_EXERCISES["band_pull_apart"],
            "exercise_name": "Separación de Banda",
            "reps_min": 15,
            "reps_max": 15,
        },
        {
            "day_id": DAY_IDS["pierna_b"],
            "day_name": "Pierna B",
            "exercise_id": WARMUP_EXERCISES["hip_circles"],
            "exercise_name": "Círculos de Cadera",
            "reps_min": 15,
            "reps_max": 15,
        },
    ]

    for cfg in warmup_config:
        # Check if warmup already exists for this day
        existing_warmup = db.query(DayExercise).filter(
            DayExercise.training_day_id == cfg["day_id"],
            DayExercise.phase == ExercisePhase.WARMUP
        ).first()

        if existing_warmup:
            print(f"  {cfg['day_name']}: Warmup already exists, skipping")
            continue

        # Shift existing exercise order_index by +1
        existing_exercises = db.query(DayExercise).filter(
            DayExercise.training_day_id == cfg["day_id"]
        ).order_by(DayExercise.order_index).all()

        for ex in existing_exercises:
            ex.order_index += 1

        # Add warmup exercise at order_index 0
        warmup = DayExercise(
            training_day_id=cfg["day_id"],
            exercise_id=cfg["exercise_id"],
            order_index=0,
            phase=ExercisePhase.WARMUP,
            sets=2,
            reps_min=cfg["reps_min"],
            reps_max=cfg["reps_max"],
            rest_seconds=30,
            effort_type=EffortType.RIR,
            effort_value=4.0,
            tempo="controlled",
            set_type="straight",
            notes=f"Calentamiento - {cfg['exercise_name']}"
        )
        db.add(warmup)
        db.flush()
        print(f"  {cfg['day_name']}: Added {cfg['exercise_name']} as warmup (ID: {warmup.id})")


def add_core_mobility_day(db: Session):
    """3. Add a Core & Mobility day after Day 5 (Pierna B), replacing Day 6 rest"""
    print("\n--- 3. Adding Core & Mobility Day ---")

    # Convert existing Day 6 (Descanso) to Core & Mobility
    day_6 = db.query(TrainingDay).filter(
        TrainingDay.id == DAY_IDS["descanso_6"]
    ).first()

    if not day_6:
        print("  ERROR: Day 6 not found!")
        return

    if not day_6.rest_day:
        print(f"  Day 6 is already not a rest day: {day_6.name}")
        # Check if exercises already exist
        existing = db.query(DayExercise).filter(
            DayExercise.training_day_id == day_6.id
        ).count()
        if existing > 0:
            print(f"  Day 6 already has {existing} exercises, skipping")
            return

    # Update day 6 from rest to Core & Mobility
    day_6.name = "Core y Movilidad"
    day_6.focus = "Core, estabilidad y movilidad articular"
    day_6.rest_day = False
    day_6.notes = "Sesión ligera enfocada en fortalecimiento de core y mejora de movilidad."

    # Add exercises for Core & Mobility day
    core_mobility_exercises = [
        {
            "exercise_id": CORE_EXERCISES["dead_bug"],
            "order_index": 0,
            "phase": ExercisePhase.MAIN,
            "sets": 3,
            "reps_min": 10,
            "reps_max": 12,
            "rest_seconds": 45,
            "effort_type": EffortType.RIR,
            "effort_value": 3.0,
            "tempo": "controlled",
            "notes": "Mantener espalda baja pegada al suelo",
        },
        {
            "exercise_id": CORE_EXERCISES["side_plank"],
            "order_index": 1,
            "phase": ExercisePhase.MAIN,
            "sets": 2,
            "reps_min": None,  # Time-based
            "reps_max": None,
            "rest_seconds": 45,
            "effort_type": EffortType.RIR,
            "effort_value": 3.0,
            "tempo": "standard",
            "duration_seconds": 30,
            "notes": "30 segundos por lado",
        },
        {
            "exercise_id": CORE_EXERCISES["reverse_crunch"],
            "order_index": 2,
            "phase": ExercisePhase.MAIN,
            "sets": 3,
            "reps_min": 12,
            "reps_max": 15,
            "rest_seconds": 45,
            "effort_type": EffortType.RIR,
            "effort_value": 2.0,
            "tempo": "controlled",
            "notes": "Controlar la fase excéntrica",
        },
        {
            "exercise_id": MOBILITY_EXERCISES["thoracic_rotation"],
            "order_index": 3,
            "phase": ExercisePhase.COOLDOWN,
            "sets": 2,
            "reps_min": 10,
            "reps_max": 10,
            "rest_seconds": 30,
            "effort_type": EffortType.RIR,
            "effort_value": 4.0,
            "tempo": "controlled",
            "notes": "10 repeticiones por lado, movimiento suave",
        },
        {
            "exercise_id": MOBILITY_EXERCISES["cat_cow"],
            "order_index": 4,
            "phase": ExercisePhase.COOLDOWN,
            "sets": 2,
            "reps_min": 10,
            "reps_max": 10,
            "rest_seconds": 30,
            "effort_type": EffortType.RIR,
            "effort_value": 4.0,
            "tempo": "controlled",
            "notes": "Respiración profunda en cada repetición",
        },
    ]

    for ex_config in core_mobility_exercises:
        day_exercise = DayExercise(
            training_day_id=day_6.id,
            exercise_id=ex_config["exercise_id"],
            order_index=ex_config["order_index"],
            phase=ex_config["phase"],
            sets=ex_config["sets"],
            reps_min=ex_config.get("reps_min"),
            reps_max=ex_config.get("reps_max"),
            rest_seconds=ex_config["rest_seconds"],
            effort_type=ex_config["effort_type"],
            effort_value=ex_config["effort_value"],
            tempo=ex_config.get("tempo"),
            set_type="straight",
            duration_seconds=ex_config.get("duration_seconds"),
            notes=ex_config.get("notes"),
        )
        db.add(day_exercise)

    db.flush()
    print(f"  Converted Day 6 to 'Core y Movilidad' with 5 exercises")


def main():
    print("=" * 60)
    print("  Modifying Christian Cruz's Training Program")
    print("=" * 60)

    db = SessionLocal()
    try:
        # Verify we can find the program
        macrocycle = db.query(Macrocycle).filter(
            Macrocycle.id == "266f6ad1-e221-4b97-901c-d5b747f936d6"
        ).first()

        if not macrocycle:
            print("ERROR: Macrocycle not found!")
            return

        print(f"\nProgram: {macrocycle.name}")
        print(f"Client ID: {macrocycle.client_id}")

        # Apply modifications
        add_rest_day_3(db)
        add_warmup_exercises(db)
        add_core_mobility_day(db)

        # Commit all changes
        db.commit()
        print("\n" + "=" * 60)
        print("  ALL CHANGES COMMITTED SUCCESSFULLY")
        print("=" * 60)

        # Verify final structure
        print("\n--- Final Program Structure ---")
        days = db.query(TrainingDay).filter(
            TrainingDay.microcycle_id == MICROCYCLE_ID
        ).order_by(TrainingDay.day_number).all()

        for day in days:
            rest_label = " [REST]" if day.rest_day else ""
            exercises = db.query(DayExercise).options(
                joinedload(DayExercise.exercise)
            ).filter(
                DayExercise.training_day_id == day.id
            ).order_by(DayExercise.order_index).all()

            print(f"\n  Day {day.day_number}: {day.name}{rest_label}")
            for ex in exercises:
                name = ex.exercise.name_es or ex.exercise.name_en if ex.exercise else "Unknown"
                if ex.duration_seconds:
                    print(f"    [{ex.phase.value}] {ex.order_index}. {name}: {ex.sets}x{ex.duration_seconds}s")
                else:
                    print(f"    [{ex.phase.value}] {ex.order_index}. {name}: {ex.sets}x{ex.reps_min}-{ex.reps_max}")

    except Exception as e:
        db.rollback()
        print(f"\nERROR: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()


if __name__ == "__main__":
    main()
