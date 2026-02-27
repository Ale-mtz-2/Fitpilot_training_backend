-- Compatibility storage for legacy fields not represented in training schema.
-- Safe to run multiple times.

CREATE TABLE IF NOT EXISTS training.compat_overrides (
    entity_type TEXT NOT NULL,
    entity_id TEXT NOT NULL,
    data JSONB NOT NULL DEFAULT '{}'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (entity_type, entity_id)
);

CREATE INDEX IF NOT EXISTS idx_training_compat_overrides_updated_at
    ON training.compat_overrides (updated_at DESC);

