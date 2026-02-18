import sys
import os
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Database connection details from docker-compose.yml
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

try:
    print("Fixing invalid reps (0) to NULL...")
    
    # Update reps_min = 0 to NULL
    result_min = db.execute(text("UPDATE day_exercises SET reps_min = NULL WHERE reps_min = 0"))
    print(f"Updated {result_min.rowcount} rows (reps_min=0 -> NULL)")
    
    # Update reps_max = 0 to NULL
    result_max = db.execute(text("UPDATE day_exercises SET reps_max = NULL WHERE reps_max = 0"))
    print(f"Updated {result_max.rowcount} rows (reps_max=0 -> NULL)")
    
    db.commit()
    print("✅ Fix applied successfully.")

except Exception as e:
    print(f"❌ Error: {e}")
    db.rollback()
finally:
    db.close()
