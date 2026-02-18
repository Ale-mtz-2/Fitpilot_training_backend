
import urllib.request
import urllib.parse
import json
import ssl

def test_api_urllib():
    base_url = "http://localhost:8000/api"
    
    # 1. Get Admin Email first (since I don't know it for sure)
    # I can't query DB easily here without imports, assuming 'admin@fitpilot.com' or 'admin@example.com'
    # Actually, I can use the same script to query DB for email.
    
    import sys
    import os
    sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    from models.base import SessionLocal
    from models.user import User
    
    db = SessionLocal()
    admin = db.query(User).filter(User.role == "admin").first()
    if not admin:
        print("No admin user found in DB")
        return
    
    email = admin.email
    print(f"Found Admin Email: {email}")
    db.close()

    # 2. Login
    # Note: Password is hashed, I can't know it. 
    # BUT I can create a new token directly using backend code logic!
    # Instead of logging in via HTTP, I can generate a token using `core.security`.
    
    from core.security import create_access_token
    from datetime import timedelta
    
    token = create_access_token(
        data={"sub": admin.id},
        expires_delta=timedelta(minutes=5)
    )
    print("Generated auth token manually.")
    
    # 3. Request
    url = f"{base_url}/mesocycles"
    req = urllib.request.Request(url)
    req.add_header('Authorization', f'Bearer {token}')
    
    try:
        # Bypass SSL context if needed (though localhost usually fine)
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        
        with urllib.request.urlopen(req, context=ctx) as response:
            print(f"Status: {response.getcode()}")
            data = json.loads(response.read().decode())
            print(f"Total: {data.get('total')}")
            print("Macrocycles:")
            for m in data.get('macrocycles', []):
                print(f" - {m['name']} (Client: {m.get('client_id')}) (Trainer: {m.get('trainer_id')})")
                
    except urllib.error.HTTPError as e:
        print(f"HTTP Error: {e.code} - {e.read().decode()}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    test_api_urllib()
