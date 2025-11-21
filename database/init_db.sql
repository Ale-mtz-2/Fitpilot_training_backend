-- Fit Pilot Database Initialization Script
-- This script will be run when the PostgreSQL container is created

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Database is already created by POSTGRES_DB environment variable
-- This file is for initial schema and seed data
