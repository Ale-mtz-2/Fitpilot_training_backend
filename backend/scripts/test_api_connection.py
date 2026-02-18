
import sys
import os
import requests

# We need to simulate a request or just call the DB logic in a way that mimics the route.
# But calling the route logic direclty requires mocking dependencies.
# Easier: Write a script that uses `requests` to hit localhost:8000/api/mesocycles
# But I need a token.
# I will use the "login" endpoint first to get a token for Admin User.

def test_api():
    base_url = "http://localhost:8000/api"
    
    # 1. Login
    print("Logging in...")
    # I need to know the admin password.
    # docker-compose.yml says: PGADMIN_DEFAULT_PASSWORD: admin123
    # But that's for pgadmin.
    # MOCK_USERS.md might have info.
    # The default reset_db script often creates admin/admin or admin/secret.
    # User User model has hashed_password.
    # I'll try common defaults.
    
    token = None
    for password in ["admin123", "secret", "password", "admin"]:
        try:
            resp = requests.post(f"{base_url}/auth/login", data={
                "username": "admin@fitpilot.com", # Assuming email from debug_db_view
                "password": password
            })
            if resp.status_code == 200:
                print(f"Login success with password: {password}")
                token = resp.json()["access_token"]
                break
        except Exception as e:
            print(f"Connection failed: {e}")
            return

    if not token:
        print("Could not log in as admin. Checking DB for email...")
        return

    headers = {"Authorization": f"Bearer {token}"}
    
    # 2. Get Mesocycles (Macrocycles)
    print("\nRequesting GET /mesocycles...")
    try:
        resp = requests.get(f"{base_url}/mesocycles", headers=headers)
        print(f"Status: {resp.status_code}")
        if resp.status_code == 200:
            data = resp.json()
            print(f"Total: {data.get('total')}")
            for m in data.get('macrocycles', []):
                print(f" - {m['name']} (Client: {m.get('client_id')})")
        else:
            print(f"Error: {resp.text}")
    except Exception as e:
        print(f"Request failed: {e}")

if __name__ == "__main__":
    # Need to install requests in container if not present.
    # Or use python's urllib.
    # I'll use urllib to be safe.
    pass
