import sys
import os
from sqlalchemy import create_engine, text

def check_translations():
    # Use psycopg3 driver
    db_url = "postgresql+psycopg://fitpilot:fitpilot123@localhost:5433/fitpilot_db"
    
    print(f"Connecting to {db_url}...")
    try:
        engine = create_engine(db_url)
        with engine.connect() as conn:
            result = conn.execute(text("SELECT name, name_es FROM exercises LIMIT 5"))
            print("\n--- Exercise Translations Check ---")
            for row in result:
                print(f"Name: {row[0]}, Name ES: {row[1]}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_translations()
