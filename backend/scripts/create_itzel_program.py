"""
Script para crear programa de entrenamiento personalizado para Itzel Britney Rodríguez Brahams.
Basado en su entrevista:
- Objetivo: Pérdida de grasa + desarrollo de glúteos (recomposición corporal)
- Días: 5 días/semana (Lun-Vie)
- Duración sesión: 90 minutos
- Nivel: Intermedio
- Equipo: Gimnasio completo
- Nota especial: Corregir postura cifótica
"""
import uuid
from datetime import date, timedelta
from sqlalchemy.orm import Session
from models.base import get_db, engine
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise, MesocycleStatus
from models.exercise import Exercise

# IDs de ejercicios (obtenidos de la DB)
EXERCISES = {
    # Glúteos y piernas
    "hip_thrust_barbell": "43a9b1fe-8f85-4126-8690-e55410aa022c",
    "hip_thrust_dumbbell": "ac7717a4-4e37-4cc2-9050-b4185af9c34c",
    "glute_bridge": "35be3e87-2c9d-454c-9c7b-5ec6ca0c9625",
    "back_squat": "1dd47ff8-ab0e-4468-89b5-ef58218fb071",
    "front_squat": "b71bc548-189e-40a3-84dc-a826b521b5d4",
    "goblet_squat": "6cd9c5f9-38db-401d-8099-b64a7e580c5f",
    "bulgarian_split": "bcc75aab-390b-4e8d-be43-b76bf5ff3466",
    "romanian_deadlift": "a65dc37c-13ad-448d-8ef7-a31d938c7ead",
    "sumo_deadlift": "85a6425e-8ff0-40c2-b171-d6c404c9ee40",
    "walking_lunge": "4eafd2c5-8de8-422c-9f27-90289f970e16",
    "reverse_lunge": "155ee3c5-a401-4644-a6c5-06bed7a187a8",
    "leg_press": "06ca48f5-bfcc-4ffa-964b-48eddafab389",
    "leg_extension": "dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34",
    "hip_abduction": "1da215b2-666a-4246-b7eb-f72c98de082d",
    "cable_kickback": "bccfa9f4-6148-495e-acb3-721da14e9721",
    "cable_pull_through": "9538101e-512b-41a2-aec6-831b9f35780e",

    # Espalda y corrección postural
    "face_pull": "9da2b8ad-0895-4665-987f-7b3b4cbd8cb1",
    "cable_face_pull": "cdaa6012-b647-4168-aadc-58c1d033b3bb",
    "rear_delt_fly": "945a062b-0bfd-49b4-9bfc-3617fe1fad76",
    "lat_pulldown": "490a8870-e9f7-4a54-8444-6679403cd12c",
    "seated_cable_row": "2b384748-2af0-4941-88fe-2a589bd3aeb4",
    "barbell_row": "9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb",
    "dumbbell_row": "e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463",
    "pullups": "f884891b-550e-46db-bb76-d5e2709e075c",
    "chest_supported_row": "a7e34918-49a4-47ef-aeba-69c4fb324fe8",

    # Pecho y hombros
    "bench_press": "93523bc4-42be-47da-8286-fb628887bf5f",
    "incline_db_press": "18d50e17-4bce-4d39-8071-c93d969b7696",
    "db_bench_press": "c58171e7-74bb-485e-827e-51df76a444e1",
    "overhead_press": "e575c180-fd48-4cde-8c67-86b784dc5220",
    "db_shoulder_press": "13135caf-d1bf-4be5-bc08-c3287dc4b7b6",
    "lateral_raise": "e08d2b37-cdf9-4285-8307-6d4a2a60492b",
    "cable_fly_low_high": "45ffd819-86b1-4f9f-998c-d0707edb1b8c",

    # Core
    "plank": "d483a4b4-9b78-4135-ae09-348de96db487",
}

# Datos del cliente
CLIENT_ID = "ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c"
TRAINER_ID = "e4244715-20b9-4103-beca-6da91ce89338"  # trainer1@fitpilot.com

def create_program():
    db = next(get_db())

    try:
        start_date = date(2025, 12, 2)  # Lunes 2 de diciembre

        # Crear Macrocycle
        macrocycle = Macrocycle(
            id=str(uuid.uuid4()),
            name="Programa Recomposición Corporal - Itzel",
            description="Programa de 8 semanas enfocado en desarrollo de glúteos, pérdida de grasa y corrección de postura cifótica. División Lower/Upper con énfasis en frecuencia de glúteos.",
            objective="fat_loss",
            start_date=start_date,
            end_date=start_date + timedelta(weeks=8),
            client_id=CLIENT_ID,
            trainer_id=TRAINER_ID,
            status=MesocycleStatus.DRAFT
        )
        db.add(macrocycle)
        db.flush()
        print(f"✓ Macrocycle creado: {macrocycle.id}")

        # Crear 2 Mesocycles (4 semanas cada uno)
        mesocycle_configs = [
            {"block": 1, "name": "Fase de Acumulación", "focus": "Volumen y técnica"},
            {"block": 2, "name": "Fase de Intensificación", "focus": "Fuerza y definición"},
        ]

        for meso_config in mesocycle_configs:
            meso_start = start_date + timedelta(weeks=(meso_config["block"] - 1) * 4)
            meso_end = meso_start + timedelta(weeks=4) - timedelta(days=1)

            mesocycle = Mesocycle(
                id=str(uuid.uuid4()),
                macrocycle_id=macrocycle.id,
                block_number=meso_config["block"],
                name=meso_config["name"],
                description=f"Bloque {meso_config['block']}: {meso_config['focus']}",
                start_date=meso_start,
                end_date=meso_end,
                focus=meso_config["focus"],
            )
            db.add(mesocycle)
            db.flush()
            print(f"  ✓ Mesocycle {meso_config['block']}: {meso_config['name']}")

            # Crear 4 Microcycles por mesocycle
            for week_offset in range(4):
                week_num = (meso_config["block"] - 1) * 4 + week_offset + 1
                is_deload = week_num in [4, 8]  # Semanas de descarga

                micro_start = meso_start + timedelta(weeks=week_offset)
                micro_end = micro_start + timedelta(days=6)

                if is_deload:
                    intensity = "deload"
                    week_name = f"Semana {week_num} - Descarga"
                elif week_offset == 0:
                    intensity = "low"
                    week_name = f"Semana {week_num} - Adaptación"
                elif week_offset == 1:
                    intensity = "medium"
                    week_name = f"Semana {week_num} - Progresión"
                else:
                    intensity = "high"
                    week_name = f"Semana {week_num} - Intensificación"

                microcycle = Microcycle(
                    id=str(uuid.uuid4()),
                    mesocycle_id=mesocycle.id,
                    week_number=week_num,
                    name=week_name,
                    start_date=micro_start,
                    end_date=micro_end,
                    intensity_level=intensity,
                )
                db.add(microcycle)
                db.flush()
                print(f"    ✓ Semana {week_num}: {intensity}")

                # Crear 5 días de entrenamiento
                create_training_days(db, microcycle, is_deload, micro_start)

        db.commit()
        print(f"\n✅ Programa creado exitosamente!")
        print(f"   Macrocycle ID: {macrocycle.id}")
        print(f"   Cliente: Itzel Britney Rodríguez Brahams")
        print(f"   Duración: 8 semanas")
        print(f"   Inicio: {start_date}")

        return macrocycle.id

    except Exception as e:
        db.rollback()
        print(f"❌ Error: {e}")
        raise
    finally:
        db.close()


def create_training_days(db: Session, microcycle: Microcycle, is_deload: bool, week_start: date):
    """Crea los 5 días de entrenamiento para una semana."""

    # Multiplicador de volumen según intensidad
    if is_deload:
        sets_mult = 0.6  # 60% del volumen normal
        rir = 4
    elif microcycle.intensity_level == "low":
        sets_mult = 0.8
        rir = 3
    elif microcycle.intensity_level == "medium":
        sets_mult = 1.0
        rir = 2
    else:  # high
        sets_mult = 1.1
        rir = 1

    day_configs = [
        {
            "day": 1,
            "name": "Lower Body - Énfasis Glúteos",
            "focus": "Glúteos, Isquiotibiales",
            "exercises": [
                {"id": EXERCISES["hip_thrust_barbell"], "sets": 4, "reps_min": 8, "reps_max": 12, "rest": 120},
                {"id": EXERCISES["romanian_deadlift"], "sets": 4, "reps_min": 8, "reps_max": 10, "rest": 120},
                {"id": EXERCISES["bulgarian_split"], "sets": 3, "reps_min": 10, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["hip_abduction"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
                {"id": EXERCISES["cable_kickback"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
                {"id": EXERCISES["cable_pull_through"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
            ]
        },
        {
            "day": 2,
            "name": "Upper Body - Push + Corrección Postural",
            "focus": "Pecho, Hombros, Postura",
            "exercises": [
                {"id": EXERCISES["incline_db_press"], "sets": 4, "reps_min": 8, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["db_shoulder_press"], "sets": 3, "reps_min": 10, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["cable_fly_low_high"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
                {"id": EXERCISES["face_pull"], "sets": 4, "reps_min": 15, "reps_max": 20, "rest": 60},
                {"id": EXERCISES["rear_delt_fly"], "sets": 3, "reps_min": 15, "reps_max": 20, "rest": 60},
                {"id": EXERCISES["lateral_raise"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
            ]
        },
        {
            "day": 3,
            "name": "Lower Body - Cuádriceps/Glúteos",
            "focus": "Cuádriceps, Glúteos",
            "exercises": [
                {"id": EXERCISES["back_squat"], "sets": 4, "reps_min": 6, "reps_max": 8, "rest": 150},
                {"id": EXERCISES["leg_press"], "sets": 4, "reps_min": 10, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["walking_lunge"], "sets": 3, "reps_min": 10, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["leg_extension"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
                {"id": EXERCISES["glute_bridge"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 60},
                {"id": EXERCISES["hip_abduction"], "sets": 3, "reps_min": 15, "reps_max": 20, "rest": 45},
            ]
        },
        {
            "day": 4,
            "name": "Upper Body - Pull + Corrección Postural",
            "focus": "Espalda, Bíceps, Postura",
            "exercises": [
                {"id": EXERCISES["lat_pulldown"], "sets": 4, "reps_min": 8, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["seated_cable_row"], "sets": 4, "reps_min": 10, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["chest_supported_row"], "sets": 3, "reps_min": 10, "reps_max": 12, "rest": 90},
                {"id": EXERCISES["face_pull"], "sets": 4, "reps_min": 15, "reps_max": 20, "rest": 60},
                {"id": EXERCISES["rear_delt_fly"], "sets": 3, "reps_min": 15, "reps_max": 20, "rest": 60},
                {"id": EXERCISES["dumbbell_row"], "sets": 3, "reps_min": 10, "reps_max": 12, "rest": 60},
            ]
        },
        {
            "day": 5,
            "name": "Full Body - Glúteos + Core",
            "focus": "Glúteos, Core, Cardio metabólico",
            "exercises": [
                {"id": EXERCISES["hip_thrust_dumbbell"], "sets": 4, "reps_min": 12, "reps_max": 15, "rest": 90},
                {"id": EXERCISES["goblet_squat"], "sets": 3, "reps_min": 12, "reps_max": 15, "rest": 75},
                {"id": EXERCISES["reverse_lunge"], "sets": 3, "reps_min": 10, "reps_max": 12, "rest": 75},
                {"id": EXERCISES["sumo_deadlift"], "sets": 3, "reps_min": 8, "reps_max": 10, "rest": 90},
                {"id": EXERCISES["plank"], "sets": 3, "reps_min": 30, "reps_max": 60, "rest": 45, "is_time": True},
                {"id": EXERCISES["cable_face_pull"], "sets": 3, "reps_min": 15, "reps_max": 20, "rest": 45},
            ]
        },
    ]

    for config in day_configs:
        day_date = week_start + timedelta(days=config["day"] - 1)

        training_day = TrainingDay(
            id=str(uuid.uuid4()),
            microcycle_id=microcycle.id,
            day_number=config["day"],
            name=config["name"],
            focus=config["focus"],
            date=day_date,
            rest_day=False,
        )
        db.add(training_day)
        db.flush()

        # Agregar ejercicios
        for idx, ex in enumerate(config["exercises"]):
            adjusted_sets = max(2, int(ex["sets"] * sets_mult))

            day_exercise = DayExercise(
                id=str(uuid.uuid4()),
                training_day_id=training_day.id,
                exercise_id=ex["id"],
                order_index=idx,
                sets=adjusted_sets,
                reps_min=ex["reps_min"],
                reps_max=ex["reps_max"],
                rest_seconds=ex["rest"],
                effort_type="RIR",
                effort_value=rir,
                duration_seconds=ex.get("reps_max") if ex.get("is_time") else None,
            )
            db.add(day_exercise)


if __name__ == "__main__":
    create_program()
