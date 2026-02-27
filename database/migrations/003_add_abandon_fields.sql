-- Migración: Agregar campos de abandono y reagendamiento a workout_logs
-- Fecha: 2024-12-04
-- Descripción: Permite trackear razones de abandono y reagendar entrenamientos

-- Crear tipo ENUM para abandon_reason si no existe
DO $$ BEGIN
    CREATE TYPE abandon_reason AS ENUM ('time', 'injury', 'fatigue', 'motivation', 'schedule', 'other');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Agregar columnas a workout_logs
ALTER TABLE workout_logs
ADD COLUMN IF NOT EXISTS abandon_reason VARCHAR(50),
ADD COLUMN IF NOT EXISTS abandon_notes TEXT,
ADD COLUMN IF NOT EXISTS rescheduled_to_date DATE;

-- Crear índice para consultas de entrenamientos perdidos
CREATE INDEX IF NOT EXISTS idx_workout_logs_client_status
ON workout_logs(client_id, status);

-- Crear índice para consultas por fecha
CREATE INDEX IF NOT EXISTS idx_workout_logs_client_created
ON workout_logs(client_id, created_at);

-- Comentarios
COMMENT ON COLUMN workout_logs.abandon_reason IS 'Razón por la que se abandonó el entrenamiento';
COMMENT ON COLUMN workout_logs.abandon_notes IS 'Notas adicionales sobre el abandono';
COMMENT ON COLUMN workout_logs.rescheduled_to_date IS 'Fecha a la que se reagendó el entrenamiento';
