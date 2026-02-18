
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.mesocycle import Macrocycle

def fix_trainer_id():
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.full_name == "Yolanda Saeb López").first()
        admin = db.query(User).filter(User.full_name == "Admin User").first()
        
        if not user or not admin:
            print("User or Admin not found")
            return

        program = db.query(Macrocycle).filter(Macrocycle.client_id == user.id).first()
        if program:
            print(f"Updating trainer for {program.name} from {program.trainer_id} to {admin.id}")
            program.trainer_id = admin.id
            db.commit()
            print("Updated successfully")
        else:
            print("Program not found")

    finally:
        db.close()

if __name__ == "__main__":
    fix_trainer_id()
