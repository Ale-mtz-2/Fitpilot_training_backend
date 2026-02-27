# Training Migration Report

- Generated at: `2026-02-18T20:22:07.772469+00:00`
- Mode: `dry-run`
- Status: `dry_run_ok`
- Started at: `2026-02-18T20:22:04.713764+00:00`
- Finished at: `2026-02-18T20:22:07.769907+00:00`
- Backup dir: `C:/Users/ale_o/Fit-pilot1.0/database/backups/training_migration_20260218_142204`

## Notes
- Freeze training writes during migration window is required.
- Using transaction + table locks for target training tables.
- Dry-run only: schema/data were not modified.

## Counts

| Table | Source | Target |
|---|---:|---:|
| `muscles` | 18 | 18 |
| `exercises` | 232 | 232 |
| `exercise_muscles` | 527 | 527 |
| `macrocycles` | 5 | 5 |
| `mesocycles` | 6 | 6 |
| `microcycles` | 13 | 13 |
| `training_days` | 68 | 68 |
| `day_exercises` | 519 | 519 |
| `workout_logs` | 33 | 33 |
| `exercise_set_logs` | 137 | 137 |
| `client_interviews` | 4 | 4 |
| `client_metrics` | 4 | 4 |
| `patient_context_snapshots` | 0 | 0 |

## Users
- Reused users: `0`
- Created users: `0`

## Validation
- `source_connection`: `ok`
- `target_connection`: `ok`
- `schema_sql_exists`: `True`
- `missing_source_tables`: `[]`
- `missing_target_tables_before_schema_migration`: `[]`

## Artifacts
- Unsupported fields folder: `C:/Users/ale_o/Fit-pilot1.0/database/backups/training_migration_20260218_142204/unsupported_fields`
- Summary JSON: `C:/Users/ale_o/Fit-pilot1.0/database/backups/training_migration_20260218_142204/migration_summary.json`
