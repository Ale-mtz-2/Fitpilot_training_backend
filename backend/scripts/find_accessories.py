
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.exercise import Exercise

def find_accessories():
    db = SessionLocal()
    try:
        keywords = ['stretch', 'estiramiento', 'warm', 'calentamiento', 'box', 'jump', 'rope', 'cinta', 'eliptica', 'bicicleta', 'movilidad', 'foam', 'yoga']
        
        exercises = db.query(Exercise).all()
        found = []
        for ex in exercises:
            name_en = ex.name_en.lower()
            name_es = (ex.name_es or "").lower()
            if any(k in name_en for k in keywords) or any(k in name_es for k in keywords):
                found.append(ex)
                
        print(f"Found {len(found)} accessory exercises:")
        for ex in found:
            print(f"ID: {ex.id}")
            print(f"  EN: {ex.name_en}")
            print(f"  ES: {ex.name_es}")
            print("-" * 20)

    finally:
        db.close()

if __name__ == "__main__":
    find_accessories()
