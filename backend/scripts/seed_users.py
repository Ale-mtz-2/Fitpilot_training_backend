"""
Script to seed mock users for development and testing.
Run with: docker exec -i fitpilot_backend python scripts/seed_users.py <<< "yes"
"""
import sys
import os

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from models.base import SessionLocal
from models.user import User, UserRole
from core.security import get_password_hash


# Mock users configuration
MOCK_USERS = [
    {
        "email": "admin@fitpilot.com",
        "full_name": "Admin User",
        "password": "password123",
        "role": UserRole.ADMIN,
        "is_verified": True,
        "is_active": True,
    },
    {
        "email": "trainer1@fitpilot.com",
        "full_name": "Carlos Rodriguez",
        "password": "password123",
        "role": UserRole.TRAINER,
        "is_verified": True,
        "is_active": True,
    },
    {
        "email": "trainer2@fitpilot.com",
        "full_name": "Maria Garcia",
        "password": "password123",
        "role": UserRole.TRAINER,
        "is_verified": True,
        "is_active": True,
    },
    {
        "email": "client1@fitpilot.com",
        "full_name": "Juan Perez",
        "password": "password123",
        "role": UserRole.CLIENT,
        "is_verified": True,
        "is_active": True,
    },
    {
        "email": "client2@fitpilot.com",
        "full_name": "Ana Martinez",
        "password": "password123",
        "role": UserRole.CLIENT,
        "is_verified": True,
        "is_active": True,
    },
    {
        "email": "client3@fitpilot.com",
        "full_name": "Luis Sanchez",
        "password": "password123",
        "role": UserRole.CLIENT,
        "is_verified": False,  # Not verified for testing
        "is_active": True,
    },
]


def seed_users():
    """Create mock users in the database."""
    db = SessionLocal()
    created = 0
    skipped = 0

    try:
        for user_data in MOCK_USERS:
            # Check if user already exists
            existing = db.query(User).filter(User.email == user_data["email"]).first()

            if existing:
                print(f"  ⏭️  User {user_data['email']} already exists, skipping...")
                skipped += 1
                continue

            # Create new user
            user = User(
                email=user_data["email"],
                full_name=user_data["full_name"],
                hashed_password=get_password_hash(user_data["password"]),
                role=user_data["role"],
                is_verified=user_data["is_verified"],
                is_active=user_data["is_active"],
            )

            db.add(user)
            print(f"  ✅ Created user: {user_data['email']} ({user_data['role'].value})")
            created += 1

        db.commit()
        print(f"\n📊 Summary: {created} created, {skipped} skipped")

    except Exception as e:
        db.rollback()
        print(f"❌ Error: {e}")
        raise
    finally:
        db.close()


def delete_all_users():
    """Delete all users from the database."""
    db = SessionLocal()
    try:
        count = db.query(User).delete()
        db.commit()
        print(f"🗑️  Deleted {count} users")
    except Exception as e:
        db.rollback()
        print(f"❌ Error deleting users: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    print("\n🌱 FitPilot User Seeder")
    print("=" * 40)

    # Check if users exist
    db = SessionLocal()
    existing_count = db.query(User).count()
    db.close()

    if existing_count > 0:
        print(f"\n⚠️  Database has {existing_count} existing users.")
        response = input("Do you want to delete them and create fresh mock users? (yes/no): ")

        if response.lower() == "yes":
            print("\n🗑️  Deleting existing users...")
            delete_all_users()
            print("\n👥 Creating mock users...")
            seed_users()
        else:
            print("❌ Operation cancelled.")
    else:
        print("\n👥 Creating mock users...")
        seed_users()

    print("\n✨ Done!")
    print("\n📝 Login credentials:")
    print("   Password for all users: password123")
    print("   Admin: admin@fitpilot.com")
    print("   Trainers: trainer1@fitpilot.com, trainer2@fitpilot.com")
    print("   Clients: client1@fitpilot.com, client2@fitpilot.com, client3@fitpilot.com")
