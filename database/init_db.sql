-- FitPilot Database Initialization Script
-- This script will be run when the PostgreSQL container is created

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Database is already created by POSTGRES_DB environment variable
-- This file is for initial schema and seed data

-- =====================================================
-- Migration: Add structured fields to client_interviews
-- =====================================================

-- Personal Information
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS weight_kg FLOAT;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS height_cm FLOAT;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS training_experience_months INTEGER;

-- Goals (structured)
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS primary_goal VARCHAR(50);
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS target_muscle_groups TEXT[];
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS specific_goals_text TEXT;

-- Availability (structured)
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS days_per_week INTEGER;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS session_duration_minutes INTEGER;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS preferred_days INTEGER[];

-- Equipment (structured)
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS has_gym_access BOOLEAN;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS available_equipment TEXT[];
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS equipment_notes TEXT;

-- Restrictions (structured)
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS injury_areas TEXT[];
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS injury_details TEXT;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS excluded_exercises TEXT[];
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS medical_conditions TEXT[];
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS mobility_limitations TEXT;

-- Drop legacy columns (if they exist and are not needed)
-- Note: Keep these commented until you're sure the migration is complete
-- ALTER TABLE client_interviews DROP COLUMN IF EXISTS goals;
-- ALTER TABLE client_interviews DROP COLUMN IF EXISTS injuries;
-- ALTER TABLE client_interviews DROP COLUMN IF EXISTS weekly_availability;
-- ALTER TABLE client_interviews DROP COLUMN IF EXISTS equipment_available;

-- =====================================================
-- Migration: Add set_type to day_exercises
-- =====================================================

-- Add set_type column for exercise configuration
-- Values: 'straight', 'rest_pause', 'drop_set', 'top_set', 'backoff', 'myo_reps', 'cluster'
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS set_type VARCHAR(20);

-- =====================================================
-- Migration: Add duration_seconds for cardio/isometric exercises
-- =====================================================

-- Add duration_seconds for time-based exercises (cardio, planks, etc.)
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS duration_seconds INTEGER;

-- Make reps_min and reps_max nullable for time-based exercises
-- Only run if the columns exist and are currently NOT NULL
DO $$
BEGIN
    -- Check if reps_min is NOT NULL and make it nullable
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'day_exercises'
        AND column_name = 'reps_min'
        AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE day_exercises ALTER COLUMN reps_min DROP NOT NULL;
    END IF;

    -- Check if reps_max is NOT NULL and make it nullable
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'day_exercises'
        AND column_name = 'reps_max'
        AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE day_exercises ALTER COLUMN reps_max DROP NOT NULL;
    END IF;
END $$;

-- =====================================================
-- Migration: Add exercise_class and cardio fields to exercises
-- =====================================================

-- exercise_class: Clasificación principal del ejercicio
-- Valores: strength, cardio, plyometric, flexibility, mobility, warmup, conditioning, balance
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS exercise_class VARCHAR(50) DEFAULT 'strength';

-- cardio_subclass: Sub-clasificación para cardio
-- Valores: liss, hiit, miss (solo cuando exercise_class = 'cardio')
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS cardio_subclass VARCHAR(20);

-- Campos específicos para cardio
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS intensity_zone INTEGER;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS target_heart_rate_min INTEGER;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS target_heart_rate_max INTEGER;
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS calories_per_minute FLOAT;

-- Migrar ejercicios existentes basados en category
UPDATE exercises SET exercise_class = 'cardio' WHERE LOWER(category) = 'cardio' AND exercise_class = 'strength';
UPDATE exercises SET exercise_class = 'plyometric' WHERE LOWER(category) = 'plyometric' AND exercise_class = 'strength';

-- Crear índice para búsquedas por exercise_class
CREATE INDEX IF NOT EXISTS idx_exercises_class ON exercises(exercise_class);

-- =====================================================
-- Migration: Add cardio-specific fields to day_exercises
-- =====================================================

-- Campos para ejercicios de CARDIO (LISS/MISS/HIIT)
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS intensity_zone INTEGER;
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS distance_meters INTEGER;
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS target_calories INTEGER;

-- Campos específicos para HIIT
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS intervals INTEGER;
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS work_seconds INTEGER;
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS interval_rest_seconds INTEGER;

-- =====================================================
-- Migration: Add phase field to day_exercises (warmup/main/cooldown)
-- =====================================================

-- Create exercise_phase enum type if not exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'exercise_phase') THEN
        CREATE TYPE exercise_phase AS ENUM ('warmup', 'main', 'cooldown');
    END IF;
END $$;

-- Add phase column to day_exercises
ALTER TABLE day_exercises ADD COLUMN IF NOT EXISTS phase exercise_phase NOT NULL DEFAULT 'main';

-- =====================================================
-- Migration: Restructure exercises table for bilingual names
-- Eliminates 'name' and 'description' columns, uses 'name_en' as primary
-- =====================================================

-- Step 1: Ensure name_en and description_en columns exist
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS name_en VARCHAR(200);
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS description_en TEXT;

-- Step 2: Copy data from old columns to new ones (only if new columns are empty)
UPDATE exercises SET name_en = name WHERE name_en IS NULL AND name IS NOT NULL;
UPDATE exercises SET description_en = description WHERE description_en IS NULL AND description IS NOT NULL;

-- Step 3: Make name_en NOT NULL (only after data is migrated)
DO $$
BEGIN
    -- Check if name_en column exists and has no NULL values
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'exercises'
        AND column_name = 'name_en'
    ) AND NOT EXISTS (
        SELECT 1 FROM exercises WHERE name_en IS NULL
    ) THEN
        -- Make name_en NOT NULL
        ALTER TABLE exercises ALTER COLUMN name_en SET NOT NULL;
    END IF;
END $$;

-- Step 4: Drop old columns (name and description) if name_en is now primary
DO $$
BEGIN
    -- Only drop if name_en is NOT NULL and name column exists
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'exercises' AND column_name = 'name_en'
    ) AND EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'exercises' AND column_name = 'name'
    ) AND NOT EXISTS (
        SELECT 1 FROM exercises WHERE name_en IS NULL
    ) THEN
        ALTER TABLE exercises DROP COLUMN IF EXISTS name;
        ALTER TABLE exercises DROP COLUMN IF EXISTS description;
    END IF;
END $$;

-- Step 5: Create index on name_en if not exists
CREATE INDEX IF NOT EXISTS idx_exercises_name_en ON exercises(name_en);

-- =====================================================
-- Migration: Add workout_logs and exercise_set_logs tables
-- For tracking client workout progress (Mobile App)
-- =====================================================

-- Create workout_status enum type if not exists
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'workout_status') THEN
        CREATE TYPE workout_status AS ENUM ('in_progress', 'completed', 'abandoned');
    END IF;
END $$;

-- Create workout_logs table
CREATE TABLE IF NOT EXISTS workout_logs (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    client_id VARCHAR(36) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    training_day_id VARCHAR(36) NOT NULL REFERENCES training_days(id) ON DELETE CASCADE,
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP,
    status workout_status NOT NULL DEFAULT 'in_progress',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for workout_logs
CREATE INDEX IF NOT EXISTS idx_workout_logs_client_id ON workout_logs(client_id);
CREATE INDEX IF NOT EXISTS idx_workout_logs_training_day_id ON workout_logs(training_day_id);
CREATE INDEX IF NOT EXISTS idx_workout_logs_status ON workout_logs(status);
CREATE INDEX IF NOT EXISTS idx_workout_logs_started_at ON workout_logs(started_at);

-- Create exercise_set_logs table
CREATE TABLE IF NOT EXISTS exercise_set_logs (
    id VARCHAR(36) PRIMARY KEY DEFAULT uuid_generate_v4()::text,
    workout_log_id VARCHAR(36) NOT NULL REFERENCES workout_logs(id) ON DELETE CASCADE,
    day_exercise_id VARCHAR(36) NOT NULL REFERENCES day_exercises(id) ON DELETE CASCADE,
    set_number INTEGER NOT NULL,
    reps_completed INTEGER NOT NULL,
    weight_kg FLOAT,
    effort_value FLOAT,
    completed_at TIMESTAMP NOT NULL DEFAULT NOW(),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Create indexes for exercise_set_logs
CREATE INDEX IF NOT EXISTS idx_exercise_set_logs_workout_log_id ON exercise_set_logs(workout_log_id);
CREATE INDEX IF NOT EXISTS idx_exercise_set_logs_day_exercise_id ON exercise_set_logs(day_exercise_id);

-- Add constraint for unique set per exercise in a workout
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_set_per_exercise
ON exercise_set_logs(workout_log_id, day_exercise_id, set_number);
