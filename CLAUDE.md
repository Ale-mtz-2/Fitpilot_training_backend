# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language

Always respond in Spanish (Español).

## Project Overview

FitPilot is an AI-powered workout routine management system with a FastAPI backend, React/TypeScript frontend, and PostgreSQL database. The application manages hierarchical training programs: Macrocycle → Mesocycle → Microcycle → TrainingDay → DayExercise.

## Common Commands

### Docker (Primary Development)
```bash
docker-compose up -d              # Start all services
docker-compose up -d --build      # Rebuild and start
docker-compose logs -f            # View logs
docker-compose down -v            # Stop and remove volumes
```

### Seed Data
```bash
docker exec -i fitpilot_backend python scripts/seed_users.py <<< "yes"
docker exec fitpilot_backend python scripts/seed_exercises.py
```

### Ollama (Translation Service)
```bash
docker exec fitpilot_ollama ollama pull llama3.2:3b  # Download model (first time only)
```

### Local Development
```bash
# Backend (runs on port 8000)
cd backend && pip install -r requirements.txt && uvicorn api.main:app --reload

# Frontend (runs on port 3000)
cd frontend && npm install && npm run dev
```

### Testing
```bash
# Backend
cd backend && pytest tests/ -v --cov

# Frontend
cd frontend && npm test
```

### Build & Lint
```bash
cd frontend && npm run build && npm run lint
```

## Architecture

### Backend Structure (FastAPI)
- `api/main.py` - FastAPI app initialization with CORS, health check
- `api/routers/` - REST endpoints (auth, exercises, muscles, mesocycles, microcycles, training_days, day_exercises, ai_generator, clients, client_interviews, client_metrics, translation)
- `core/security.py` - Argon2 password hashing, JWT token creation/verification
- `core/dependencies.py` - Auth guards: `get_current_user()`, `require_trainer()`, `require_admin()`
- `models/` - SQLAlchemy models with UUID primary keys
- `schemas/` - Pydantic validation schemas matching frontend types
- `services/ai_generator.py` - AI-powered routine generation service
- `services/translation.py` - Translation service using Ollama/Llama 3.2
- `services/muscle_image.py` and `wger_image.py` - Exercise image services
- `prompts/` - AI prompt templates for routine generation
- `core/config.py` - Environment settings (uses pydantic-settings, loads from .env)

### Frontend Structure (React + TypeScript)
- `services/api.ts` - Axios instance with JWT interceptor (auto-adds token, handles 401)
- `store/` - Zustand stores: authStore, mesocycleStore, uiStore, aiStore, clientStore, languageStore
- `types/` - TypeScript types matching backend schemas exactly
- `components/common/` - Reusable UI (Button, Card, Input, Modal, ProtectedRoute)
- `pages/` - Page components (TrainingTemplatesPage, AIGeneratorPage, ClientsPage, etc.)
- `i18n/` - Internationalization with i18next (es/en), locales in `i18n/locales/`
- `utils/exerciseHelpers.ts` - Helpers including `getExerciseName()`, `getExerciseDescription()` for bilingual content
- Path alias: `@/` maps to `src/` (configured in vite.config.ts)

### Data Hierarchy
```
Macrocycle (entire program - can be a template or assigned to a client)
  └─ Mesocycle[1..N] (training blocks, 3-6 weeks)
      └─ Microcycle[1..N] (weeks)
          └─ TrainingDay[1..7] (daily workouts)
              └─ DayExercise[1..N] (exercise instances with volume/intensity)
                  └─ Exercise (reference to library)
```

### Templates vs Client Programs
- **Templates** (`client_id = null`): Reusable training programs not assigned to any client. Managed at `/templates`.
- **Client Programs** (`client_id = uuid`): Programs assigned to a specific client. Managed at `/clients/:id/programs`.

Trainers can create templates and then load them when creating programs for specific clients.

### Frontend Routes
- `/templates` - List/manage training templates
- `/templates/new` - Create new template
- `/templates/:id` - Edit template
- `/clients` - List clients
- `/clients/:id/programs` - Client's training programs (can load from templates)
- `/ai-generator` - AI-powered routine generation wizard
- `/exercises` - Exercise library management

### Role-Based Access
- **ADMIN**: Full system access
- **TRAINER**: Create/manage programs for clients, create templates
- **CLIENT**: View assigned programs

## Service Ports
- Frontend: 3000 (Vite dev server, proxies /api and /static to backend)
- Backend: 8000 (FastAPI + Uvicorn)
- PostgreSQL: 5433 (not default 5432)
- Redis: 6379
- PgAdmin: 5050 (credentials: admin@fitpilot.com / admin123)
- Muscle Image API: 8080 (internal service for muscle group images)
- Ollama: 11434 (local LLM for translation, uses Llama 3.2 3B)

## Test Credentials
All use password: `password123`
- Admin: `admin@fitpilot.com`
- Trainers: `trainer1@fitpilot.com`, `trainer2@fitpilot.com`
- Clients: `client1@fitpilot.com`, `client2@fitpilot.com`

## API Documentation
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Key Technical Details
- Backend uses Pydantic v2 for validation; errors return as arrays
- Frontend Vite config proxies `/api` and `/static` requests to backend
- Database uses UUID strings for all primary keys
- Nested entity creation uses `db.flush()` for ID generation before final `commit()`
- JWT tokens expire in 30 minutes (configurable via ACCESS_TOKEN_EXPIRE_MINUTES)
- `client_id` in Macrocycle is nullable: `null` = template, `uuid` = client program

## Key Enums
- **EffortType**: `RIR` (Reps in Reserve), `RPE` (Rate of Perceived Exertion), `percentage` (of 1RM)
- **IntensityLevel**: `low`, `medium`, `high`, `deload`
- **MesocycleStatus**: `draft`, `active`, `completed`, `archived`

## Environment Variables
Required in `.env` for full functionality:
- `DATABASE_URL`, `REDIS_URL` - Database connections
- `SECRET_KEY` - JWT signing key (change in production)
- `ANTHROPIC_API_KEY` - For AI routine generation (uses Claude claude-sonnet-4-5-20250929)
- `OLLAMA_HOST`, `OLLAMA_MODEL` - For translation service (defaults: http://ollama:11434, llama3.2:3b)

## AI Workout Generation

### Flujo de Generación (Frontend)
El flujo de generación de rutinas con IA sigue estos pasos:

```
Cuestionario → Generar con IA → Guardar automáticamente (status: draft) → Redirigir a /mesocycles/:id → Editar con MesocycleEditorPage
```

**Archivos clave:**
- `pages/AIGeneratorPage.tsx` - Wizard de generación con pasos: mode-selection, client-selection, template-config, quick-config, questionnaire, generating
- `store/aiStore.ts` - Estado de generación: `isGenerating`, `isSaving`, `generatedWorkout`
- `components/ai/GenerationProgress.tsx` - Indicador de progreso con fases dinámicas (analizando, seleccionando, estructurando, calculando, guardando)

**Notas:**
- No hay paso de "preview" - el programa se guarda automáticamente como borrador
- El usuario edita el programa generado usando el editor manual existente (MesocycleEditorPage)
- `GenerationProgress` lee el estado del store y muestra la fase actual (generando vs guardando)

### Optimization Settings (`core/config.py`)
```python
AI_USE_PROMPT_CACHING: bool = True      # Anthropic Prompt Caching (~90% input cost reduction)
AI_USE_COMPRESSED_OUTPUT: bool = True   # Compact JSON keys (m, ms, mc, td, ex)
AI_FILTER_CATALOG: bool = True          # Filter exercises by goal/equipment (~30-50% reduction)
AI_USE_PHASED_GENERATION: bool = True   # Two-phase generation for 4+ week programs
```

### Generation Methods (`services/ai_generator.py`)
- **`_generate_with_caching()`**: Standard generation with Prompt Caching
- **`_generate_phased()`**: Two-phase generation for long programs (4+ weeks)
- **`_generate_legacy()`**: Fallback without optimizations

### Phased Generation (`AI_USE_PHASED_GENERATION`)
For programs ≥4 weeks, uses a two-phase approach that reduces tokens by **~70-87%**:

**Phase 1 - Base Week Template:**
```
API Call → Generate single base week with all exercises
Result: 1 microcycle with training days and exercises
```

**Phase 2 - Progression Matrix:**
```
API Call → Generate only deltas/changes for remaining weeks
Result: { weeks: [{ week: 2, intensity: "medium", changes: [...] }, ...] }
```

**Phase 3 - Local Expansion (No API):**
```
Apply progression matrix to base week → Generate all weeks locally
Uses: _apply_progression(), _expand_training_day(), _apply_deload()
```

**Progression Matrix Format:**
```json
{
  "weeks": [
    { "week": 2, "intensity": "medium", "changes": [
      { "exercise_id": "uuid", "sets": 4, "reps_min": 10, "reps_max": 12 }
    ]},
    { "week": 4, "intensity": "deload", "deload": true }
  ]
}
```

**Helper Methods:**
- `_should_use_phased(request)` - Decides when to use phased (≥4 weeks + enabled)
- `_apply_progression(base_week, progression, request)` - Applies deltas to base
- `_expand_training_day(td)` - Converts compressed format to full format
- `_apply_exercise_change(exercise, change)` - Updates exercise parameters
- `_apply_deload(exercises)` - Reduces sets by 40%, increases RIR
- `_default_progression(total_weeks, include_deload)` - Fallback ondulating periodization
- `_get_meso_focus(goal, meso_index)` - Returns focus name based on goal type

**Fallback Behavior:**
If progression parsing fails, uses default ondulating periodization:
- Week 1: LOW intensity (base)
- Week 2: MEDIUM intensity (+1 set)
- Week 3: HIGH intensity (+2 sets)
- Week 4: DELOAD intensity (-40% sets)

### Compressed Response Format
The AI returns compact JSON that gets expanded by `_expand_compressed_response()`:
```
m=macrocycle, ms=mesocycles, mc=microcycles, td=training_days, ex=exercises
n=name, d=description, s=sets, rm=reps_min, rx=reps_max, rs=rest_seconds
et=effort_type, ev=effort_value, ds=duration_seconds
```

### Token Usage Metrics (8-week program example)
```
Standard generation:  ~30,000 tokens (input + output)
Phased generation:    ~8,500 tokens (Phase 1: ~4,000 + Phase 2: ~4,500)
Savings:              ~70-87% reduction
Prompt Caching:       cache_read tokens reused between calls
```

### Prompt Templates (`prompts/workout_generator.py`)
- `build_system_prompt()` - Training principles and guidelines
- `build_filtered_catalog()` - Exercises filtered by goal, equipment, restrictions
- `build_compressed_output_schema()` - Compact JSON format instructions
- `assemble_optimized_prompt()` - Returns `(cacheable_content, specific_content)` tuple
- `assemble_base_week_prompt()` - For phased generation base week (Phase 1)
- `build_progression_prompt()` - For progression matrix generation (Phase 2)

## Internationalization (i18n)
- Frontend uses i18next with Spanish (es) as default language
- Language stored in localStorage as `fitpilot_language`
- Exercise model has bilingual fields: `name_es`, `name_en`, `description_es`, `description_en`
- Use `getExerciseName(exercise)` and `getExerciseDescription(exercise)` helpers to get content in current language
- Translation API endpoints at `/api/translation/` for on-demand translation via Ollama
