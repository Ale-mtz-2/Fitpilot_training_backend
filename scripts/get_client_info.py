
import sys
import os

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User
from models.client_interview import ClientInterview
from models.client_metric import ClientMetric

def get_client_info():
    db = SessionLocal()
    try:
        user = db.query(User).filter(User.full_name == "Yolanda Saeb López").first()
        if not user:
            print("User 'Yolanda Saeb López' not found.")
            return

        print(f"User Found: {user.full_name} (ID: {user.id})")
        
        interview = db.query(ClientInterview).filter(ClientInterview.client_id == user.id).first()
        if interview:
            print("\n=== INTERVIEW DATA ===")
            print(f"Goal: {interview.primary_goal}")
            print(f"Experience: {interview.experience_level}")
            print(f"Days/Week: {interview.days_per_week}")
            print(f"Session Duration: {interview.session_duration_minutes} mins")
            print(f"Injuries: {interview.injury_areas}")
            print(f"Equipment: {interview.available_equipment}")
            print(f"Music Groups: {interview.target_muscle_groups}")
            print(f"Specific Goals: {interview.specific_goals_text}")
        else:
            print("\nNo Interview Data Found.")

        metrics = db.query(ClientMetric).filter(ClientMetric.client_id == user.id).order_by(ClientMetric.date.desc()).all()
        if metrics:
            print("\n=== METRICS (Latest) ===")
            seen_types = set()
            for m in metrics:
                if m.metric_type not in seen_types:
                    print(f"{m.metric_type}: {m.value} {m.unit} ({m.date})")
                    seen_types.add(m.metric_type)
        else:
            print("\nNo Metrics Found.")

    finally:
        db.close()

if __name__ == "__main__":
    get_client_info()
