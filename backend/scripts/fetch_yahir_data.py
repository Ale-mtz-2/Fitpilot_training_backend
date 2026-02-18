import sys
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.user import User
from models.client_interview import ClientInterview
from models.exercise import Exercise

# Database connection details from docker-compose.yml
# Use 'postgresql+psycopg' for psycopg 3 driver
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

try:
    # Find Yahir
    print("Searching for Yahir...")
    users = db.query(User).filter(User.full_name.ilike("%Yahir Leal Zamago%")).all()
    if not users:
        print("User 'Yahir Leal Zamago' not found.")
        # Try finding all users to see if names are different
        all_users = db.query(User).limit(5).all()
        print("First 5 users:", [u.full_name for u in all_users])
        sys.exit(1)

    yahir = users[0]
    print(f"Found Yahir: ID={yahir.id}, Name={yahir.full_name}")

    # Get interview
    interview = db.query(ClientInterview).filter(ClientInterview.client_id == yahir.id).first()
    if interview:
        print("\n--- Interview Data ---")
        print(f"Goal: {interview.primary_goal}")
        print(f"Experience: {interview.experience_level}")
        print(f"Days/Week: {interview.days_per_week}")
        print(f"Session Duration: {interview.session_duration_minutes} min")
        
        # Equipment - handle list vs string issues if any
        print(f"Equipment: {interview.available_equipment}")
        
        print(f"Injuries: {interview.injury_areas}")
        print(f"Target Muscles: {interview.target_muscle_groups}")
        print(f"Excluded Exercises: {interview.excluded_exercises}")
        
        # Also print detailed injury text if available
        if interview.injury_details:
             print(f"Injury Details: {interview.injury_details}")
    else:
        print("No interview found for Yahir.")

    # Get Exercises
    # We need to see what exercises are available to select from
    print("\n--- Available Exercises Sample ---")
    exercises = db.query(Exercise).limit(20).all()
    for ex in exercises:
        print(f"ID: {ex.id}, Name: {ex.name_es} / {ex.name_en}, Class: {ex.exercise_class}")

finally:
    db.close()
