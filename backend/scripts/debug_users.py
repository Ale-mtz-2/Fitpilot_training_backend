import sys
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.user import User
from models.mesocycle import Macrocycle

# Database connection details from docker-compose.yml
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

try:
    print("\n--- USERS ---")
    users = db.query(User).all()
    for u in users:
        print(f"ID: {u.id} | Name: {u.full_name} | Email: {u.email} | Role: {u.role}")

    print("\n--- YAHIR'S MACROCYCLE ---")
    print("\n--- FINDING YAHIR ---")
    yahirs = db.query(User).filter(User.full_name.ilike("%Yahir%")).all()
    for y in yahirs:
        print(f"Found User: {y.full_name} ({y.id}) Role: {y.role}")

    if not yahirs:
        print("No user found matching 'Yahir'")
    else:
        # Check programs for ALL keys
        for yahir in yahirs:
            print(f"\nChecking programs for {yahir.full_name} ({yahir.id}):")
            macros = db.query(Macrocycle).filter(Macrocycle.client_id == yahir.id).all()
            for m in macros:
                 print(f" - Program: {m.name} (ID: {m.id}, Status: {m.status})")

        macro = db.query(Macrocycle).filter(Macrocycle.client_id == yahir.id).first()
        if macro:
            print(f"Macro ID: {macro.id}")
            print(f"Name: {macro.name}")
            print(f"Status: {macro.status}")
            print(f"Client ID: {macro.client_id}")
            print(f"Trainer ID: {macro.trainer_id}")
            
            # Find trainer info
            trainer = db.query(User).filter(User.id == macro.trainer_id).first()
            if trainer:
                print(f"Created By: {trainer.full_name} ({trainer.email}) Role: {trainer.role}")
            else:
                print("Created By: Unknown User ID")
        else:
            print("No macrocycle found for Yahir.")
    else:
        print("Yahir not found.")

finally:
    db.close()
