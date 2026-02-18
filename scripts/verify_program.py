
import sys
import os

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise

def verify_program():
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.full_name == "Yolanda Saeb López").first()
        if not user:
            print("User not found")
            return

        print(f"Checking programs for {user.full_name}...")
        
        # Get latest Macrocycle
        macro = db.query(Macrocycle).filter(Macrocycle.client_id == user.id).order_by(Macrocycle.created_at.desc()).first()
        if not macro:
            print("No macrocycle found.")
            return

        print(f"Macrocycle: {macro.name} ({macro.status})")
        
        for meso in macro.mesocycles:
            print(f"  Mesocycle: {meso.name}")
            for micro in meso.microcycles:
                print(f"    Microcycle: {micro.name} (Week {micro.week_number})")
                for day in micro.training_days:
                    print(f"      Day {day.day_number}: {day.name}")
                    for ex in day.exercises:
                        ex_name = ex.exercise.name_es if ex.exercise.name_es else ex.exercise.name_en
                        print(f"        - {ex_name}: {ex.sets}x{ex.reps_min}-{ex.reps_max}")
    finally:
        db.close()

if __name__ == "__main__":
    verify_program()
