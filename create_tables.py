"""
Script to create all database tables
Run this after the database is running
"""
from models.base import Base, engine
from models import *  # noqa: F403, F401

def create_tables():
    print("Creating all tables...")
    Base.metadata.create_all(bind=engine)
    print("✓ Tables created successfully!")

if __name__ == "__main__":
    create_tables()
