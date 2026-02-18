"""
Delete and recreate Britney's program with Spanish names and updated exercises
"""
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from models.base import SessionLocal
from models.mesocycle import Mesocycle, Microcycle, TrainingDay, DayExercise
from sqlalchemy import delete

def clean_program():
    """Delete existing program structure"""
    db = SessionLocal()
    
    MACROCYCLE_ID = "7b1fb1ad-2c53-4a25-bd89-c32e2c42bb00"
    
    # Get mesocycle
    mesocycle = db.query(Mesocycle).filter(Mesocycle.macrocycle_id == MACROCYCLE_ID).first()
    
    if mesocycle:
        # Get all microcycles
        microcycles = db.query(Microcycle).filter(Microcycle.mesocycle_id == mesocycle.id).all()
        
        for microcycle in microcycles:
            # Get all training days
            training_days = db.query(TrainingDay).filter(TrainingDay.microcycle_id == microcycle.id).all()
            
            for training_day in training_days:
                # Delete all exercises
                db.execute(delete(DayExercise).where(DayExercise.training_day_id == training_day.id))
            
            # Delete training days
            db.execute(delete(TrainingDay).where(TrainingDay.microcycle_id == microcycle.id))
        
        # Delete microcycles
        db.execute(delete(Microcycle).where(Microcycle.mesocycle_id == mesocycle.id))
        
        # Delete mesocycle
        db.execute(delete(Mesocycle).where(Mesocycle.id == mesocycle.id))
        
        db.commit()
        print("✅ Old program structure deleted successfully")
    else:
        print("No existing program found")
    
    db.close()

if __name__ == "__main__":
    print("Cleaning old program structure...")
    print("=" * 60)
    clean_program()
    print("=" * 60)
    print("Done!")
