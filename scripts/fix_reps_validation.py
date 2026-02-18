
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.mesocycle import DayExercise

def fix_zero_reps():
    db = SessionLocal()
    try:
        # Find exercises with 0 reps
        exercises = db.query(DayExercise).filter(
            (DayExercise.reps_min == 0) | (DayExercise.reps_max == 0)
        ).all()
        
        print(f"Found {len(exercises)} exercises with 0 reps.")
        
        for ex in exercises:
            print(f"Fixing exercise ID: {ex.id}")
            if ex.reps_min == 0:
                ex.reps_min = None
            if ex.reps_max == 0:
                ex.reps_max = None
                
        db.commit()
        print("Fixed successfully.")

    finally:
        db.close()

if __name__ == "__main__":
    fix_zero_reps()
