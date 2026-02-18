
import sys
import os
from sqlalchemy import func

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise, ExercisePhase, EffortType
from models.exercise import Exercise
from datetime import date, timedelta

def update_program():
    db = SessionLocal()
    try:
        # 1. Get Yolanda's current active program
        user = db.query(User).filter(User.full_name == "Yolanda Saeb López").first()
        if not user:
            print("Yolanda not found")
            return

        macro = db.query(Macrocycle).filter(
            Macrocycle.client_id == user.id
        ).order_by(Macrocycle.created_at.desc()).first()
        
        if not macro:
            print("No active macrocycle found.")
            return
            
        print(f"Updating Macrocycle: {macro.name}")
        
        # Get the first microcycle (assuming only one exists for now or we update the current one)
        # In a real scenario, we might iterate all microcycles.
        # For this task, "Week 1 - Intro" is what we created.
        
        # We need to traverse: Macro -> Meso -> Micro
        micro = None
        for meso in macro.mesocycles:
            for m in meso.microcycles:
                micro = m
                break
            if micro: break
        
        if not micro:
            print("No microcycle found.")
            return

        print(f"Targeting Microcycle: {micro.name}")
        
        # 2. Shift Days and Add Rest Days
        # Current Days: 1, 2, 3, 4
        # Desired: 1, 2, 4, 5 (Training) | 3, 6, 7 (Rest)
        
        training_days = db.query(TrainingDay).filter(
            TrainingDay.microcycle_id == micro.id
        ).order_by(TrainingDay.day_number).all()
        
        # Create a map of day_number to day object
        day_map = {d.day_number: d for d in training_days}
        
        # We need to shift Day 4 -> 5, Day 3 -> 4.
        # Process in reverse order to avoid collision if we simply increment?
        # Actually, best to just reassign.
        
        if 4 in day_map:
            print("Shifting Day 4 to Day 5")
            day_map[4].day_number = 5
            # Update date if needed? logic for date is complex, skipping date update for simple structure fix
            
        if 3 in day_map:
            print("Shifting Day 3 to Day 4")
            day_map[3].day_number = 4
            
        db.flush() # Persist shifts
        
        # Create Rest Days
        rest_days_config = [
            (3, "Descanso Activo / Recovery"),
            (6, "Descanso / Rest"),
            (7, "Descanso / Rest")
        ]
        
        for d_num, name in rest_days_config:
            # Check if exists (idempotency)
            exists = db.query(TrainingDay).filter(
                TrainingDay.microcycle_id == micro.id,
                TrainingDay.day_number == d_num
            ).first()
            
            if not exists:
                print(f"Creating Rest Day {d_num}")
                new_day = TrainingDay(
                    microcycle_id=micro.id,
                    day_number=d_num,
                    date=date.today(), # Placeholder date
                    name=name,
                    focus="Recovery",
                    rest_day=True
                )
                db.add(new_day)
        
        db.commit() # Commit day structure changes
        
        # 3. Add Warmup and Cooldown to Training Days (now 1, 2, 4, 5)
        # Refetch days
        current_days = db.query(TrainingDay).filter(
            TrainingDay.microcycle_id == micro.id,
            TrainingDay.rest_day == False
        ).all()
        
        # IDs for exercises
        WU1_ID = "2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d" # Incline Treadmill
        WU2_ID = "ade38363-28c5-43c3-8f9e-711a997b0683" # World Greatest Stretch
        CD1_ID = "bad51b6d-2654-4c25-b69e-ba9c5f094449" # Cat-Cow
        CD2_ID = "8f77ef33-bbb3-40ff-963d-b0d34a12652c" # Pigeon
        
        for day in current_days:
            print(f"Processing Day {day.day_number}: {day.name}")
            
            # Shift existing exercises orders by +2 (for 2 warmups)
            # Find existing exercises
            exercises = db.query(DayExercise).filter(
                DayExercise.training_day_id == day.id
            ).order_by(DayExercise.order_index).all()
            
            # Check if warmup/cooldown already exists (to avoid duplicates on re-run)
            has_warmup = any(e.phase == ExercisePhase.WARMUP for e in exercises)
            
            if not has_warmup:
                print("  Adding Warmup...")
                # Shift existing
                for ex in exercises:
                    ex.order_index += 2
                
                # Add Warmups
                wu1 = DayExercise(
                    training_day_id=day.id,
                    exercise_id=WU1_ID,
                    order_index=0,
                    phase=ExercisePhase.WARMUP,
                    sets=1,
                    duration_seconds=300, # 5 mins
                    rest_seconds=0,
                    effort_type=EffortType.RPE,
                    effort_value=3.0,
                    notes="Caminata suave"
                )
                wu2 = DayExercise(
                    training_day_id=day.id,
                    exercise_id=WU2_ID,
                    order_index=1,
                    phase=ExercisePhase.WARMUP,
                    sets=2,
                    reps_min=10,
                    reps_max=12,
                    rest_seconds=30,
                    effort_type=EffortType.RPE,
                    effort_value=4.0
                )
                db.add(wu1)
                db.add(wu2)
            
            # Add Cooldown
            # Calc new max index
            # Refetch or calc? If we shifted, max index increased by 2.
            # current exercises count + 2 (warmups)
            
            exercises = db.query(DayExercise).filter(DayExercise.training_day_id == day.id).all()
            has_cooldown = any(e.phase == ExercisePhase.COOLDOWN for e in exercises)
            
            if not has_cooldown:
                print("  Adding Cooldown...")
                # Get max index
                max_idx = db.query(func.max(DayExercise.order_index)).filter(
                    DayExercise.training_day_id == day.id
                ).scalar() or 0
                
                cd1 = DayExercise(
                    training_day_id=day.id,
                    exercise_id=CD1_ID,
                    order_index=max_idx + 1,
                    phase=ExercisePhase.COOLDOWN,
                    sets=2,
                    reps_min=15, # Seconds hold? or reps? Cat cow is reps.
                    reps_max=20,
                    rest_seconds=30,
                    effort_type=EffortType.RPE,
                    effort_value=3.0
                )
                cd2 = DayExercise(
                    training_day_id=day.id,
                    exercise_id=CD2_ID,
                    order_index=max_idx + 2,
                    phase=ExercisePhase.COOLDOWN,
                    sets=2,
                    duration_seconds=60, # 1 min hold per side
                    rest_seconds=30,
                    effort_type=EffortType.RPE,
                    effort_value=3.0
                )
                db.add(cd1)
                db.add(cd2)
                
        db.commit()
        print("Update Complete!")

    except Exception as e:
        print(f"Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    update_program()
