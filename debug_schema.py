
import sys
import os
from datetime import date

# Add backend to path
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from typing import Optional
from pydantic import BaseModel, ValidationError

# Mocking dependencies
from schemas.mesocycle import TrainingDayUpdate

print(f"TrainingDayUpdate.date type: {TrainingDayUpdate.model_fields['date'].annotation}")

try:
    TrainingDayUpdate(date="2025-12-10")
    print("Validation successful")
except ValidationError as e:
    print(e.json())
