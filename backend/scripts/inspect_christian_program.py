"""
Script to inspect Christian Cruz's training program structure.
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from sqlalchemy.orm import Session, joinedload
from models.base import SessionLocal
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise
from models.user import User
from models.exercise import Exercise

def inspect_program():
    db = SessionLocal()
    try:
        # Find Christian Cruz
        users = db.query(User).filter(User.full_name.ilike("%christian%")).all()
        print("=== Users matching 'christian' ===")
        for u in users:
            print(f"  ID: {u.id}, Name: {u.full_name}, Email: {u.email}, Role: {u.role}")
        
        if not users:
            print("No user named 'Christian' found!")
            return
        
        client = users[0]
        print(f"\n=== Macrocycles for {client.full_name} ===")
        macrocycles = db.query(Macrocycle).filter(
            Macrocycle.client_id == client.id
        ).all()
        
        for macro in macrocycles:
            print(f"\nMacrocycle: {macro.name} (ID: {macro.id})")
            print(f"  Objective: {macro.objective}")
            print(f"  Status: {macro.status}")
            print(f"  Dates: {macro.start_date} to {macro.end_date}")
            
            mesocycles = db.query(Mesocycle).filter(
                Mesocycle.macrocycle_id == macro.id
            ).order_by(Mesocycle.block_number).all()
            
            for meso in mesocycles:
                print(f"\n  Mesocycle Block {meso.block_number}: {meso.name} (ID: {meso.id})")
                print(f"    Focus: {meso.focus}")
                print(f"    Dates: {meso.start_date} to {meso.end_date}")
                
                microcycles = db.query(Microcycle).filter(
                    Microcycle.mesocycle_id == meso.id
                ).order_by(Microcycle.week_number).all()
                
                for micro in microcycles:
                    print(f"\n    Microcycle Week {micro.week_number}: {micro.name} (ID: {micro.id})")
                    print(f"      Dates: {micro.start_date} to {micro.end_date}")
                    
                    days = db.query(TrainingDay).filter(
                        TrainingDay.microcycle_id == micro.id
                    ).order_by(TrainingDay.day_number).all()
                    
                    for day in days:
                        rest_label = " [REST DAY]" if day.rest_day else ""
                        print(f"\n      Day {day.day_number}: {day.name}{rest_label} (ID: {day.id})")
                        print(f"        Date: {day.date}, Focus: {day.focus}")
                        
                        exercises = db.query(DayExercise).options(
                            joinedload(DayExercise.exercise)
                        ).filter(
                            DayExercise.training_day_id == day.id
                        ).order_by(DayExercise.order_index).all()
                        
                        for ex in exercises:
                            exercise_name = ex.exercise.name_es or ex.exercise.name_en if ex.exercise else "Unknown"
                            if ex.duration_seconds:
                                print(f"        [{ex.phase.value}] {ex.order_index}. {exercise_name}: {ex.sets}x{ex.duration_seconds}s, Rest:{ex.rest_seconds}s")
                            else:
                                print(f"        [{ex.phase.value}] {ex.order_index}. {exercise_name}: {ex.sets}x{ex.reps_min}-{ex.reps_max}, Rest:{ex.rest_seconds}s, {ex.effort_type.value}:{ex.effort_value}")

        # List exercises suitable for warmup
        print("\n\n=== Exercises with class 'warmup' ===")
        warmup_exercises = db.query(Exercise).filter(
            Exercise.exercise_class == 'warmup'
        ).all()
        for e in warmup_exercises:
            print(f"  ID: {e.id}, Name EN: {e.name_en}, Name ES: {e.name_es}")
        
        # List exercises suitable for mobility
        print("\n=== Exercises with class 'mobility' ===")
        mobility_exercises = db.query(Exercise).filter(
            Exercise.exercise_class == 'mobility'
        ).all()
        for e in mobility_exercises:
            print(f"  ID: {e.id}, Name EN: {e.name_en}, Name ES: {e.name_es}")
        
        # List exercises suitable for core (search by category or name)
        print("\n=== Exercises with 'core' in name or category ===")
        core_exercises = db.query(Exercise).filter(
            (Exercise.name_en.ilike("%core%")) | 
            (Exercise.name_es.ilike("%core%")) |
            (Exercise.category.ilike("%core%")) |
            (Exercise.name_en.ilike("%plank%")) |
            (Exercise.name_en.ilike("%crunch%")) |
            (Exercise.name_en.ilike("%russian twist%")) |
            (Exercise.name_en.ilike("%dead bug%")) |
            (Exercise.name_en.ilike("%bird dog%")) |
            (Exercise.name_en.ilike("%ab %")) |
            (Exercise.name_en.ilike("%abdominal%"))
        ).all()
        for e in core_exercises:
            print(f"  ID: {e.id}, Name EN: {e.name_en}, Name ES: {e.name_es}, Class: {e.exercise_class}, Category: {e.category}")
            
        # Also search for cardio exercises (for warmup)
        print("\n=== Exercises with class 'cardio' ===")
        cardio_exercises = db.query(Exercise).filter(
            Exercise.exercise_class == 'cardio'
        ).limit(10).all()
        for e in cardio_exercises:
            print(f"  ID: {e.id}, Name EN: {e.name_en}, Name ES: {e.name_es}, Subclass: {e.cardio_subclass}")

        # List conditioning exercises
        print("\n=== Exercises with class 'conditioning' ===")
        conditioning_exercises = db.query(Exercise).filter(
            Exercise.exercise_class == 'conditioning'
        ).all()
        for e in conditioning_exercises:
            print(f"  ID: {e.id}, Name EN: {e.name_en}, Name ES: {e.name_es}")
            
        # List flexibility exercises
        print("\n=== Exercises with class 'flexibility' ===")
        flexibility_exercises = db.query(Exercise).filter(
            Exercise.exercise_class == 'flexibility'
        ).all()
        for e in flexibility_exercises:
            print(f"  ID: {e.id}, Name EN: {e.name_en}, Name ES: {e.name_es}")

    finally:
        db.close()

if __name__ == "__main__":
    inspect_program()
