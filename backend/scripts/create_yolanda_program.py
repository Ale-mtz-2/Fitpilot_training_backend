import sys
import os
from datetime import date, timedelta
import logging

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.client_interview import ClientInterview
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise, MesocycleStatus, IntensityLevel, ExercisePhase, EffortType
from models.exercise import Exercise

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def find_exercise(db, name_query):
    """Helper to locate an exercise by English or Spanish name."""
    # Try exact match first (case insensitive)
    ex = db.query(Exercise).filter(Exercise.name_es.ilike(name_query)).first()
    if ex:
        return ex
    ex = db.query(Exercise).filter(Exercise.name_en.ilike(name_query)).first()
    if ex:
        return ex

    # Try partial match
    ex = db.query(Exercise).filter(Exercise.name_es.ilike(f"%{name_query}%")).first()
    if ex:
        return ex
    ex = db.query(Exercise).filter(Exercise.name_en.ilike(f"%{name_query}%")).first()
    return ex

def add_day_exercise(db, training_day_id, exercise_name, order_index, phase, sets, reps_min, reps_max, rest_seconds, rir, set_type="straight"):
    """Add an exercise to a training day with defaults and warnings when missing."""
    exercise = find_exercise(db, exercise_name)
    if not exercise:
        logger.warning(f"Exercise '{exercise_name}' not found. Skipping.")
        return order_index

    day_ex = DayExercise(
        training_day_id=training_day_id,
        exercise_id=exercise.id,
        order_index=order_index,
        phase=phase,
        sets=sets,
        reps_min=reps_min,
        reps_max=reps_max,
        rest_seconds=rest_seconds,
        effort_type=EffortType.RIR,
        effort_value=rir,
        set_type=set_type
    )
    db.add(day_ex)
    return order_index + 1

def create_program():
    db = SessionLocal()
    try:
        # 1. Get User (robust to encoding)
        user = db.query(User).filter(User.full_name == "Yolanda Saeb Lopez").first()
        if not user:
            user = db.query(User).filter(User.full_name.ilike("%Yolanda Saeb%")).first()
        if not user:
            logger.error("User 'Yolanda Saeb Lopez' not found.")
            return

        logger.info(f"Creating program for {user.full_name} ({user.id})")

        # Get Interview for checks
        interview = db.query(ClientInterview).filter(ClientInterview.client_id == user.id).first()
        days_per_week = interview.days_per_week if interview and interview.days_per_week else 5
        # Enforce 4 training days to fit lifestyle (cap even if interview suggests more)
        target_training_days = min(4, days_per_week, 5)
        logger.info(f"Interview suggested {days_per_week} days; enforcing {target_training_days} training days for lifestyle.")

        # 2. Create Macrocycle
        start_date = date.today()
        end_date = start_date + timedelta(weeks=12)

        macro = Macrocycle(
            name="Glute Focus Hypertrophy",
            description="Programa enfocado en desarrollo de gluteos y piernas, manteniendo tren superior con recuperacion programada.",
            objective="Hypertrophy",
            start_date=start_date,
            end_date=end_date,
            status=MesocycleStatus.ACTIVE,
            trainer_id=user.id,
            client_id=user.id
        )

        # Try to find a trainer
        trainer = db.query(User).filter(User.role == "trainer").first()
        if trainer:
            macro.trainer_id = trainer.id
        else:
            admin = db.query(User).filter(User.role == "admin").first()
            macro.trainer_id = admin.id if admin else user.id

        db.add(macro)
        db.flush()  # Get ID

        # 3. Create Mesocycle (Block 1)
        meso_start = start_date
        meso_end = start_date + timedelta(weeks=4)
        meso = Mesocycle(
            macrocycle_id=macro.id,
            block_number=1,
            name="Acumulacion - Bloque 1",
            description="Foco en volumen, tecnica y distribucion de fatiga.",
            start_date=meso_start,
            end_date=meso_end,
            focus="Hypertrophy",
            notes="Priorizar rango de movimiento completo con calentamiento y enfriamiento obligatorios."
        )
        db.add(meso)
        db.flush()

        # 4. Create Microcycle (Week 1)
        micro_start = meso_start
        micro = Microcycle(
            mesocycle_id=meso.id,
            week_number=1,
            name="Semana 1 - Intro con Recuperacion",
            start_date=micro_start,
            end_date=micro_start + timedelta(days=6),  # will be updated once days are added
            intensity_level=IntensityLevel.MEDIUM,
            notes="Semana de ajuste de cargas. RIR 2-3. Incluye calentamientos, enfriamientos y dias de descanso. Split fijado en 4 dias de entrenamiento."
        )
        db.add(micro)
        db.flush()

        # 5. Define Workout Split with warm-up and cooldown, plus planned rest days
        # Exercises use tuples: (Name Query, Sets, Reps Min, Reps Max, RIR, Rest Seconds)
        workouts = [
            {
                "name": "Glute Drive & Isquios",
                "focus": "Gluteos e isquios (fuerza)",
                "notes": "Priorizar ejecucion; evitar fatiga lumbar duplicada.",
                "warmup": [
                    ("Cat-Cow Stretch", 2, 8, 10, 5, 30),
                    ("Glute Bridge", 2, 12, 15, 4, 45)
                ],
                "main": [
                    ("Hip Thrust (Barbell)", 4, 6, 10, 2, 120),
                    ("Romanian Deadlift", 3, 8, 10, 2, 120),
                    ("Seated Leg Curl", 3, 12, 15, 2, 90),
                    ("Reverse Hyperextension", 2, 12, 15, 3, 90),
                    ("Hip Abduction Machine", 3, 15, 20, 2, 75)
                ],
                "cooldown": [
                    ("Pigeon Stretch", 2, 30, 40, 9, 30),
                    ("Couch Stretch", 2, 30, 40, 9, 30)
                ]
            },
            {
                "name": "Push & Core",
                "focus": "Hombro, pecho y core",
                "notes": "Pulso controlado y estabilidad escapular.",
                "warmup": [
                    ("World Greatest Stretch", 1, 6, 8, 6, 30),
                    ("Wall Angels", 2, 10, 12, 6, 30)
                ],
                "main": [
                    ("Overhead Press", 4, 8, 10, 2, 90),
                    ("Incline Dumbbell Press", 3, 10, 12, 2, 90),
                    ("Lateral Raise (Dumbbell)", 3, 12, 15, 2, 60),
                    ("Reverse Pec Deck", 3, 12, 15, 2, 60),
                    ("Tricep Pushdown (Rope)", 3, 12, 15, 2, 60),
                    ("Pallof Press", 3, 10, 12, 3, 45),
                    ("Bicycle Crunch", 3, 15, 20, 3, 45)
                ],
                "cooldown": [
                    ("Cat-Cow Stretch", 2, 8, 10, 7, 30),
                    ("Hip 90/90 Stretch", 2, 30, 40, 9, 30)
                ]
            },
            {
                "name": "Pierna Anterior & Gluteo Medio",
                "focus": "Cuadriceps y gluteos",
                "notes": "Reducir carga de rodilla agregando patrones de cadera y unilateral.",
                "warmup": [
                    ("Goblet Squat", 2, 12, 15, 4, 60),
                    ("Hip 90/90 Stretch", 2, 30, 40, 9, 30)
                ],
                "main": [
                    ("Back Squat", 4, 6, 8, 2, 150),
                    ("Bulgarian Split Squat", 3, 10, 12, 3, 120),
                    ("Step-ups", 3, 10, 12, 3, 90),
                    ("Leg Extension", 3, 12, 15, 1, 75),
                    ("Leg Press Calf Raise", 4, 15, 20, 2, 60)
                ],
                "cooldown": [
                    ("Frog Stretch", 2, 30, 40, 9, 30),
                    ("Couch Stretch", 2, 30, 40, 9, 30)
                ]
            },
            {
                "name": "Espalda & Brazos",
                "focus": "Pull y estabilidad",
                "notes": "Control escapular y trabajo horizontal extra.",
                "warmup": [
                    ("Scorpion Stretch", 2, 8, 10, 7, 30),
                    ("Cat-Cow Stretch", 1, 8, 10, 7, 30)
                ],
                "main": [
                    ("Lat Pulldown", 4, 10, 12, 2, 90),
                    ("Chest Supported Row", 3, 10, 12, 2, 90),
                    ("Inverted Row", 3, 10, 12, 3, 75),
                    ("Face Pull", 3, 15, 20, 2, 60),
                    ("Hammer Curl", 3, 12, 15, 2, 60),
                    ("Overhead Tricep Extension", 3, 12, 15, 2, 60),
                    ("Side Plank", 2, 20, 30, 7, 45)
                ],
                "cooldown": [
                    ("Pigeon Stretch", 2, 30, 40, 9, 30),
                    ("Hip 90/90 Stretch", 1, 30, 40, 9, 30)
                ]
            }
        ]

        # Limit training days to 4 to align with lifestyle while preserving rest days
        max_training_days = min(target_training_days, len(workouts), 4)
        rest_day_templates = [
            {"name": "Descanso y movilidad", "focus": "Recuperacion", "notes": "Paseo 20-30 min + respiracion diafragmatica."},
            {"name": "Descanso total", "focus": "Recuperacion", "notes": "Sueno y nutricion. Estiramientos suaves opcionales."}
        ]

        # Pattern to distribute rest for 4-day split: T, T, R, T, R, T, R
        schedule_pattern = ["train", "train", "rest", "train", "rest", "train", "rest"]
        training_idx = 0
        rest_idx = 0

        week_plan = []
        for slot in schedule_pattern:
            if slot == "train" and training_idx < max_training_days:
                week_plan.append(workouts[training_idx])
                training_idx += 1
            else:
                template = rest_day_templates[rest_idx % len(rest_day_templates)]
                week_plan.append({**template, "rest_day": True})
                rest_idx += 1

        # If we still have fewer than 7 days (e.g., days_per_week < 5), pad with rest
        while len(week_plan) < 7:
            template = rest_day_templates[rest_idx % len(rest_day_templates)]
            week_plan.append({**template, "rest_day": True})
            rest_idx += 1

        # Adjust microcycle end date based on actual week length
        micro.end_date = micro_start + timedelta(days=len(week_plan) - 1)

        for i, workout_data in enumerate(week_plan):
            day_num = i + 1
            day_date = micro_start + timedelta(days=i)

            is_rest_day = workout_data.get("rest_day", False)
            t_day = TrainingDay(
                microcycle_id=micro.id,
                day_number=day_num,
                date=day_date,
                name=workout_data["name"],
                focus=workout_data.get("focus", ""),
                rest_day=is_rest_day,
                notes=workout_data.get("notes", "")
            )
            db.add(t_day)
            db.flush()

            if is_rest_day:
                continue

            order_index = 1
            for phase_name, phase_enum in [
                ("warmup", ExercisePhase.WARMUP),
                ("main", ExercisePhase.MAIN),
                ("cooldown", ExercisePhase.COOLDOWN),
            ]:
                for ex_name, sets, r_min, r_max, rir, rest_secs in workout_data.get(phase_name, []):
                    order_index = add_day_exercise(
                        db,
                        training_day_id=t_day.id,
                        exercise_name=ex_name,
                        order_index=order_index,
                        phase=phase_enum,
                        sets=sets,
                        reps_min=r_min,
                        reps_max=r_max,
                        rest_seconds=rest_secs,
                        rir=rir
                    )

        db.commit()
        logger.info("Program created successfully!")

    except Exception as e:
        logger.error(f"Error creating program: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    create_program()
