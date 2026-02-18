import sys
import os
import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.mesocycle import Macrocycle
from schemas.mesocycle import MacrocycleResponse

# Database connection details from docker-compose.yml
DATABASE_URL = "postgresql+psycopg://admin:secretpass@postgres:5432/fitpilot_db"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
db = SessionLocal()

try:
    print("--- DEBUG API RESPONSE ---")
    # Fetch Yahir's macrocycle
    macro = db.query(Macrocycle).filter(Macrocycle.name == "Plan Hipertrofia 2024").first()
    
    if not macro:
        print("Macrocycle not found")
        sys.exit(1)
        
    print(f"Found Macro: {macro.name} (ID: {macro.id})")
    print(f"DB Client ID: {macro.client_id}")
    
    # Serialize using Pydantic
    try:
        response_model = MacrocycleResponse.model_validate(macro)
        json_output = response_model.model_dump_json()
        print("\n--- JSON OUTPUT ---")
        print(json_output)
        
        # Verify client_id in JSON
        data = json.loads(json_output)
        if "client_id" in data:
            print(f"\n✅ client_id is present in JSON: {data['client_id']}")
        else:
            print("\n❌ client_id is MISSING in JSON")
            
    except Exception as e:
        print(f"\n❌ Serialization Error: {e}")

finally:
    db.close()
