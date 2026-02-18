import sys
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.user import User
from models.mesocycle import Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise

# Database connection details from docker-compose.yml
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

try:
    print("Verifying Program for Yahir...")
    yahir = db.query(User).filter(User.full_name.ilike("%Yahir Leal Zamago%")).first()
    
    if not yahir:
        print("❌ Yahir not found")
        sys.exit(1)
        
    macro = db.query(Macrocycle).filter(Macrocycle.client_id == yahir.id, Macrocycle.name == "Plan Hipertrofia 2024").first()
    
    if not macro:
        print("❌ Macrocycle 'Plan Hipertrofia 2024' not found")
        sys.exit(1)
        
    print(f"✅ Found Macrocycle: {macro.name} ({macro.id})")
    
    meso = db.query(Mesocycle).filter(Mesocycle.macrocycle_id == macro.id).first()
    if not meso:
        print("❌ Mesocycle not found")
    else:
        print(f"✅ Found Mesocycle: {meso.name}")
        
    micro = db.query(Microcycle).filter(Microcycle.mesocycle_id == meso.id).first()
    if not micro:
        print("❌ Microcycle not found")
    else:
        print(f"✅ Found Microcycle: {micro.name}")
        
        days = db.query(TrainingDay).filter(TrainingDay.microcycle_id == micro.id).order_by(TrainingDay.day_number).all()
        print(f"✅ Found {len(days)} Training Days")
        
        for day in days:
            ex_count = db.query(DayExercise).filter(DayExercise.training_day_id == day.id).count()
            print(f"  - Day {day.day_number}: {day.name} ({ex_count} exercises)")
            
    print("\nVerification Complete.")

except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
