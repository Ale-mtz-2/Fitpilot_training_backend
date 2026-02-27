-- Migration: Patient Context snapshots y campos extendidos

-- Tabla de snapshots versionados del contexto del paciente
CREATE TABLE IF NOT EXISTS patient_context_snapshots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id VARCHAR NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    version VARCHAR NOT NULL,
    effective_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    source VARCHAR(50),
    data JSONB NOT NULL,
    created_by VARCHAR REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_patient_context_snapshots_client ON patient_context_snapshots (client_id, effective_at DESC);

-- Extender campos de client_interviews (identidad/contacto/seguro)
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS document_id VARCHAR(100);
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS phone VARCHAR(50);
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS address TEXT;
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS emergency_contact_name VARCHAR(200);
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS emergency_contact_phone VARCHAR(50);
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS insurance_provider VARCHAR(200);
ALTER TABLE client_interviews ADD COLUMN IF NOT EXISTS policy_number VARCHAR(100);

-- Extender enum metric_type con nuevas métricas clínicas/antropométricas
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'metrictype') THEN
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'resting_hr' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'resting_hr';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'blood_pressure_sys' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'blood_pressure_sys';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'blood_pressure_dia' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'blood_pressure_dia';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'neck' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'neck';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'calf' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'calf';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'shoulders' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'shoulders';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'forearm' AND enumtypid = 'metrictype'::regtype) THEN
            ALTER TYPE metrictype ADD VALUE 'forearm';
        END IF;
    END IF;
END $$;
