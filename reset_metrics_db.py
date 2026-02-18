from models.base import engine
from sqlalchemy import text
from models.client_metric import ClientMetric

def reset_metrics_table():
    print("Resetting client_metrics table and enum...")
    with engine.connect() as conn:
        # We need to execute outside transaction for DROP TYPE sometimes? 
        # But SQLAlchemy usually handles this if we commit.
        # However, if other tables depend on metrictype (unlikely), CASCADE handles it.
        
        try:
            conn.execute(text("DROP TABLE IF EXISTS client_metrics CASCADE"))
            print("Dropped table client_metrics")
        except Exception as e:
            print(f"Error dropping table: {e}")
            
        try:
            conn.execute(text("DROP TYPE IF EXISTS metrictype"))
            print("Dropped type metrictype")
        except Exception as e:
            print(f"Error dropping type: {e}")
            
        conn.commit()
    
    print("Reset complete.")

if __name__ == "__main__":
    reset_metrics_table()
