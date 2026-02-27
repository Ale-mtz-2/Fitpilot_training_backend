import sys
import os
from sqlalchemy import create_engine, text

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from core.config import settings

def check_translations():
    # Use the database URL from settings or default
    db_url = settings.DATABASE_URL
    # Adjust port if needed (user mentioned 5433 in doc)
    if "5432" in db_url and "5433" not in db_url:
        db_url = db_url.replace("5432", "5433")
    
    print(f"Connecting to {db_url}...")
    engine = create_engine(db_url)
    
    with engine.connect() as conn:
        result = conn.execute(text("SELECT name, name_es FROM exercises LIMIT 5"))
        print("\n--- Exercise Translations Check ---")
        for row in result:
            print(f"Name: {row[0]}, Name ES: {row[1]}")
            
if __name__ == "__main__":
    check_translations()
