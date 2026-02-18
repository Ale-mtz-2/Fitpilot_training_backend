
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.mesocycle import Macrocycle

def check_yolanda_program():
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.full_name == "Yolanda Saeb López").first()
        if not user:
            print("Yolanda not found")
            return

        print(f"Yolanda ID: {user.id}")

        program = db.query(Macrocycle).filter(Macrocycle.client_id == user.id).first()
        if program:
            print(f"Program Found: {program.name}")
            print(f"  ID: {program.id}")
            print(f"  Trainer ID: {program.trainer_id}")
            print(f"  Client ID: {program.client_id}")
            print(f"  Status: {program.status}")
            
            trainer = db.query(User).filter(User.id == program.trainer_id).first()
            if trainer:
                print(f"  Trainer Name: {trainer.full_name}, Role: {trainer.role}")
            else:
                print("  Trainer user not found in DB!")
        else:
            print("No program found for Yolanda.")

    finally:
        db.close()

if __name__ == "__main__":
    check_yolanda_program()
