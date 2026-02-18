
import sys
import os

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.mesocycle import Macrocycle

def debug_db():
    db = SessionLocal()
    try:
        print("\n=== MACROCYCLES ===")
        macros = db.query(Macrocycle).all()
        for m in macros:
            print(f"Macro: {m.name}")
            print(f"  ID: {m.id}")
            print(f"  Client: {m.client_id}")
            print(f"  Trainer: {m.trainer_id}")
            
        print("\n=== USERS ===")
        users = db.query(User).all()
        for u in users:
            print(f"User: {u.full_name} ({u.role})")
            print(f"  ID: {u.id}")
            
    finally:
        db.close()

if __name__ == "__main__":
    debug_db()
