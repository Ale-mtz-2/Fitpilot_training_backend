# Reporte de Base de Datos - FitPilot

## Resumen Ejecutivo

FitPilot utiliza PostgreSQL con SQLAlchemy ORM. La base de datos está diseñada para gestionar una jerarquía completa de programas de entrenamiento con 5 niveles de profundidad, además de la gestión de usuarios, biblioteca de ejercicios, músculos, y datos de clientes.

**Total de tablas:** 14
**Extensiones PostgreSQL:** uuid-ossp, pg_trgm
**Tipo de IDs:** UUID (strings)
**Timestamps:** Todas las tablas tienen `created_at` y `updated_at`

---

## 1. USERS (Usuarios)

**Tabla:** `users`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| email | String | UNIQUE, NOT NULL, INDEX | Email del usuario |
| hashed_password | String | NOT NULL | Contraseña hasheada con Argon2 |
| full_name | String | NOT NULL | Nombre completo |
| role | Enum | NOT NULL, DEFAULT: 'client' | Rol del usuario |
| preferred_language | String(5) | NOT NULL, DEFAULT: 'es' | Idioma (es/en) |
| is_active | Boolean | NOT NULL, DEFAULT: True | Usuario activo |
| is_verified | Boolean | NOT NULL, DEFAULT: False | Email verificado |
| created_at | DateTime | NOT NULL, DEFAULT: now() | Fecha de creación |
| updated_at | DateTime | NOT NULL, AUTO-UPDATE | Última actualización |

### Enum: UserRole
- `admin` - Acceso completo al sistema
- `trainer` - Crear/gestionar programas y plantillas
- `client` - Ver programas asignados

### Relaciones
- **1:N** con `macrocycles` (como trainer) → `trainer_id`
- **1:N** con `macrocycles` (como client) → `client_id`
- **1:1** con `client_interviews` → `client_id`
- **1:N** con `client_metrics` → `client_id`

### Índices
- `email` (único)

---

## 2. MUSCLES (Músculos)

**Tabla:** `muscles`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| name | String(50) | UNIQUE, NOT NULL, INDEX | Nombre técnico (ej: 'pectoralis_major') |
| display_name_es | String(100) | NOT NULL | Nombre en español |
| display_name_en | String(100) | NOT NULL | Nombre en inglés |
| body_region | String(50) | NOT NULL | Región corporal |
| muscle_category | String(50) | NOT NULL | Categoría del músculo |
| svg_ids | ARRAY[String] | NULL | IDs de elementos SVG para visualización |
| sort_order | Integer | DEFAULT: 0 | Orden de presentación en UI |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enum: BodyRegion
- `upper_body` - Parte superior del cuerpo
- `lower_body` - Parte inferior del cuerpo
- `core` - Núcleo/abdomen

### Enum: MuscleCategory
- `chest`, `back`, `shoulders`, `arms`, `legs`, `core`

### Relaciones
- **N:M** con `exercises` a través de `exercise_muscles`

### Índices
- `name` (único)

---

## 3. EXERCISES (Ejercicios)

**Tabla:** `exercises`

### Columnas Base

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| type | Enum | NOT NULL | Tipo biomecánico (multiarticular/monoarticular) |
| resistance_profile | Enum | NOT NULL | Perfil de resistencia |
| category | String | NOT NULL | Categoría (ej: 'compound_push') |
| video_url | String | NULL | URL de video demostrativo |
| thumbnail_url | String | NULL | URL de imagen GIF/PNG del movimiento |
| image_url | String | NULL | URL de imagen personalizada |
| anatomy_image_url | String | NULL | URL con músculos destacados |
| equipment_needed | String | NULL | Equipo necesario |
| difficulty_level | String | NULL | Nivel (beginner/intermediate/advanced) |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Campos Bilingües ⭐ ACTUALIZADO

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| name_en | String | NOT NULL, INDEX | Nombre en inglés (principal) |
| name_es | String | NULL, INDEX | Nombre en español |
| description_en | Text | NULL | Descripción en inglés |
| description_es | Text | NULL | Descripción en español |

> **Nota:** Los campos `name` y `description` fueron renombrados a `name_en`/`name_es` y `description_en`/`description_es` para soportar contenido bilingüe.

### Clasificación de Ejercicios ⭐ NUEVO

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| exercise_class | Enum | NOT NULL, DEFAULT: 'strength', INDEX | Clasificación principal del ejercicio |
| cardio_subclass | Enum | NULL | Sub-clasificación para ejercicios cardio |

### Campos Específicos para Cardio ⭐ NUEVO

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| intensity_zone | Integer | NULL | Zona de frecuencia cardíaca (1-5) |
| target_heart_rate_min | Integer | NULL | BPM mínimo objetivo |
| target_heart_rate_max | Integer | NULL | BPM máximo objetivo |
| calories_per_minute | Float | NULL | Calorías quemadas por minuto |

### Enum: ExerciseType
- `multiarticular` - Múltiples articulaciones (compound)
- `monoarticular` - Una articulación (isolation)

### Enum: ResistanceProfile
- `ascending` - Resistencia aumenta durante el movimiento
- `descending` - Resistencia disminuye
- `flat` - Resistencia constante
- `bell_shaped` - Resistencia máxima a medio recorrido

### Enum: ExerciseClass ⭐ NUEVO
- `strength` - Ejercicios de fuerza (requieren músculos primarios)
- `cardio` - Ejercicios cardiovasculares
- `plyometric` - Ejercicios pliométricos/explosivos
- `flexibility` - Estiramientos
- `mobility` - Movilidad articular
- `warmup` - Calentamiento
- `conditioning` - Acondicionamiento metabólico
- `balance` - Equilibrio y estabilidad

### Enum: CardioSubclass ⭐ NUEVO
- `liss` - Low Intensity Steady State (20-60min, zona HR 1-2)
- `hiit` - High Intensity Interval Training (10-30min, zona HR 4-5)
- `miss` - Moderate Intensity Steady State (20-30min, zona HR 2-3)

### Relaciones
- **1:N** con `day_exercises` → `exercise_id` (CASCADE DELETE)
- **N:M** con `muscles` a través de `exercise_muscles` (CASCADE DELETE)

### Propiedades Computadas
- `primary_muscles` - Lista de músculos primarios
- `secondary_muscles` - Lista de músculos secundarios
- `primary_muscle_names` - Nombres de músculos primarios
- `secondary_muscle_names` - Nombres de músculos secundarios

### Métodos de Instancia
- `get_name(language='es')` - Obtiene nombre en idioma especificado con fallback a inglés
- `get_description(language='es')` - Obtiene descripción con fallback

### Índices
- `name_en` (simple)
- `name_es` (simple)
- `exercise_class` (simple)

---

## 4. EXERCISE_MUSCLES (Tabla de Unión)

**Tabla:** `exercise_muscles`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| exercise_id | String (UUID) | FK, NOT NULL, INDEX | Referencia a exercises.id |
| muscle_id | String (UUID) | FK, NOT NULL, INDEX | Referencia a muscles.id |
| muscle_role | String(20) | NOT NULL, CHECK | Rol ('primary' o 'secondary') |
| created_at | DateTime | NOT NULL | Fecha de creación |

### Enum: MuscleRole
- `primary` - Músculo primario trabajado
- `secondary` - Músculo secundario/sinergista

### Claves Foráneas
- `exercise_id` → `exercises.id` (CASCADE DELETE)
- `muscle_id` → `muscles.id` (RESTRICT DELETE)

### Constraints
- **UNIQUE:** `(exercise_id, muscle_id)` - Un músculo no puede tener múltiples roles en el mismo ejercicio
- **CHECK:** `muscle_role IN ('primary', 'secondary')`

### Índices
- `exercise_id`
- `muscle_id`

---

## 5. MACROCYCLES (Programas Completos)

**Tabla:** `macrocycles`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| name | String | NOT NULL | Nombre del programa |
| description | Text | NULL | Descripción detallada |
| objective | String | NOT NULL | Objetivo (hypertrophy, strength, etc.) |
| start_date | Date | NOT NULL | Fecha de inicio |
| end_date | Date | NOT NULL | Fecha de finalización |
| status | Enum | NOT NULL, DEFAULT: 'draft' | Estado del programa |
| trainer_id | String (UUID) | FK, NOT NULL | Entrenador creador |
| client_id | String (UUID) | FK, NULL | Cliente asignado (NULL = plantilla) |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enum: MesocycleStatus
- `draft` - Borrador
- `active` - Activo
- `completed` - Completado
- `archived` - Archivado

### Claves Foráneas
- `trainer_id` → `users.id`
- `client_id` → `users.id` (nullable)

### Relaciones
- **N:1** con `users` (trainer)
- **N:1** con `users` (client, opcional)
- **1:N** con `mesocycles` (CASCADE DELETE)

### Distinción Plantilla vs Programa de Cliente
- **Plantilla:** `client_id = NULL` - Programa reutilizable no asignado
- **Programa de Cliente:** `client_id = UUID` - Asignado a un cliente específico

---

## 6. MESOCYCLES (Bloques de Entrenamiento)

**Tabla:** `mesocycles`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| macrocycle_id | String (UUID) | FK, NOT NULL | Referencia al macrociclo padre |
| block_number | Integer | NOT NULL | Orden dentro del macrociclo |
| name | String | NOT NULL | Nombre del bloque |
| description | Text | NULL | Descripción |
| start_date | Date | NOT NULL | Fecha de inicio |
| end_date | Date | NOT NULL | Fecha de finalización |
| focus | String | NULL | Enfoque (Hypertrophy, Strength, Peaking, Deload) |
| notes | Text | NULL | Notas adicionales |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Claves Foráneas
- `macrocycle_id` → `macrocycles.id` (CASCADE DELETE)

### Relaciones
- **N:1** con `macrocycles`
- **1:N** con `microcycles` (CASCADE DELETE)

---

## 7. MICROCYCLES (Semanas de Entrenamiento)

**Tabla:** `microcycles`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| mesocycle_id | String (UUID) | FK, NOT NULL | Referencia al mesociclo padre |
| week_number | Integer | NOT NULL | Número de semana |
| name | String | NOT NULL | Nombre de la semana |
| start_date | Date | NOT NULL | Fecha de inicio |
| end_date | Date | NOT NULL | Fecha de finalización |
| intensity_level | Enum | NOT NULL, DEFAULT: 'medium' | Nivel de intensidad |
| notes | Text | NULL | Notas adicionales |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enum: IntensityLevel
- `low` - Intensidad baja
- `medium` - Intensidad media
- `high` - Intensidad alta
- `deload` - Semana de descarga

### Claves Foráneas
- `mesocycle_id` → `mesocycles.id` (CASCADE DELETE)

### Relaciones
- **N:1** con `mesocycles`
- **1:N** con `training_days` (CASCADE DELETE)

---

## 8. TRAINING_DAYS (Días de Entrenamiento)

**Tabla:** `training_days`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| microcycle_id | String (UUID) | FK, NOT NULL | Referencia al microciclo padre |
| day_number | Integer | NOT NULL | Número de día (1-7, Lun-Dom) |
| date | Date | NOT NULL | Fecha específica del día |
| name | String | NOT NULL | Nombre del día (ej: "Upper Body Push") |
| focus | String | NULL | Enfoque (ej: "Chest & Triceps") |
| rest_day | Boolean | NOT NULL, DEFAULT: False | Si es día de descanso |
| notes | Text | NULL | Notas adicionales |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Claves Foráneas
- `microcycle_id` → `microcycles.id` (CASCADE DELETE)

### Relaciones
- **N:1** con `microcycles`
- **1:N** con `day_exercises` (CASCADE DELETE)

---

## 9. DAY_EXERCISES (Ejercicios en un Día)

**Tabla:** `day_exercises`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| training_day_id | String (UUID) | FK, NOT NULL | Referencia al día padre |
| exercise_id | String (UUID) | FK, NOT NULL | Referencia al ejercicio |
| order_index | Integer | NOT NULL | Orden dentro del día |
| **phase** | **Enum** | **NOT NULL, DEFAULT: 'MAIN'** | **Fase del ejercicio** |
| sets | Integer | NOT NULL | Número de series |
| reps_min | Integer | NULL | Repeticiones mínimas (nullable para cardio) |
| reps_max | Integer | NULL | Repeticiones máximas (nullable para cardio) |
| rest_seconds | Integer | NOT NULL | Descanso entre series (segundos) |
| effort_type | Enum | NOT NULL | Tipo de esfuerzo (RIR/RPE/percentage) |
| effort_value | Float | NOT NULL | Valor del esfuerzo |
| tempo | String | NULL | Tempo (ej: "3-1-1-0") o tipo de tempo |
| set_type | String | NULL | Tipo de serie (straight, drop_set, etc.) |

#### Campos de CARDIO (LISS/MISS/HIIT)
| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| duration_seconds | Integer | NULL | Duración total (30-3600 segundos) |
| intensity_zone | Integer | NULL | Zona de frecuencia cardíaca (1-5) |
| distance_meters | Integer | NULL | Distancia objetivo en metros |
| target_calories | Integer | NULL | Calorías objetivo |

#### Campos específicos para HIIT
| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| intervals | Integer | NULL | Número de intervalos |
| work_seconds | Integer | NULL | Duración del intervalo de trabajo |
| interval_rest_seconds | Integer | NULL | Descanso entre intervalos |

#### Metadatos
| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| notes | Text | NULL | Notas adicionales |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enum: ExercisePhase ⭐ NUEVO
- `WARMUP` - Calentamiento (ejercicios preparatorios)
- `MAIN` - Entrenamiento principal (trabajo de fuerza/hipertrofia)
- `COOLDOWN` - Vuelta a la calma (estiramiento, movilidad)

### Enum: EffortType
- `RIR` - Reps in Reserve (repeticiones en reserva)
- `RPE` - Rate of Perceived Exertion (escala de esfuerzo percibido)
- `percentage` - Porcentaje del 1RM

### Claves Foráneas
- `training_day_id` → `training_days.id` (CASCADE DELETE)
- `exercise_id` → `exercises.id`

### Relaciones
- **N:1** con `training_days`
- **N:1** con `exercises`

---

## 10. CLIENT_INTERVIEWS (Cuestionarios de Clientes)

**Tabla:** `client_interviews`

### Columnas

#### Información Personal

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| client_id | String (UUID) | FK, UNIQUE, NOT NULL | Referencia al usuario cliente (1:1) |
| age | Integer | NULL | Edad del cliente |
| gender | Enum | NULL | Género |
| occupation | String(200) | NULL | Ocupación |
| weight_kg | Float | NULL | Peso en kilogramos |
| height_cm | Float | NULL | Altura en centímetros |
| training_experience_months | Integer | NULL | Meses de experiencia entrenando |

#### Perfil de Entrenamiento

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| experience_level | Enum | NOT NULL, DEFAULT: 'beginner' | Nivel de experiencia |

#### Objetivos

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| primary_goal | Enum | NULL | Objetivo principal |
| target_muscle_groups | ARRAY[String] | NULL | Grupos musculares a desarrollar |
| specific_goals_text | Text | NULL | Objetivos específicos en texto libre |

#### Disponibilidad

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| days_per_week | Integer | NULL | Días de entrenamiento por semana (1-7) |
| session_duration_minutes | Integer | NULL | Duración de sesión (20-180 min) |
| preferred_days | ARRAY[Integer] | NULL | Días preferidos (1-7 para Lun-Dom) |

#### Equipamiento

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| has_gym_access | Boolean | NULL | Tiene acceso a gimnasio |
| available_equipment | ARRAY[String] | NULL | Equipo disponible |
| equipment_notes | Text | NULL | Notas sobre equipamiento |

#### Restricciones

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| injury_areas | ARRAY[String] | NULL | Áreas con lesiones |
| injury_details | Text | NULL | Detalles de lesiones |
| excluded_exercises | ARRAY[String] | NULL | Ejercicios a evitar |
| medical_conditions | ARRAY[String] | NULL | Condiciones médicas relevantes |
| mobility_limitations | Text | NULL | Limitaciones de movilidad |

#### Adicional

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| notes | Text | NULL | Notas adicionales del entrenador |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enums

**Gender:**
- `MALE`, `FEMALE`, `OTHER`, `PREFER_NOT_TO_SAY`

**ExperienceLevel:**
- `BEGINNER`, `INTERMEDIATE`, `ADVANCED`

**PrimaryGoal:**
- `HYPERTROPHY` (hipertrofia)
- `STRENGTH` (fuerza)
- `POWER` (potencia)
- `ENDURANCE` (resistencia)
- `FAT_LOSS` (pérdida de grasa)
- `GENERAL_FITNESS` (fitness general)

**EquipmentType:**
- `BARBELL`, `DUMBBELLS`, `CABLES`, `MACHINES`, `KETTLEBELLS`, `RESISTANCE_BANDS`, `PULL_UP_BAR`, `BENCH`, `SQUAT_RACK`, `BODYWEIGHT`

**InjuryArea:**
- `SHOULDER`, `KNEE`, `LOWER_BACK`, `UPPER_BACK`, `HIP`, `ANKLE`, `WRIST`, `ELBOW`, `NECK`, `OTHER`

**MuscleGroup:**
- `CHEST`, `BACK`, `SHOULDERS`, `BICEPS`, `TRICEPS`, `LEGS`, `CORE`, `GLUTES`

### Claves Foráneas
- `client_id` → `users.id` (CASCADE DELETE, UNIQUE)

### Relaciones
- **1:1** con `users` (client)

### Métodos de Validación
- `is_complete_for_ai()` - Valida si la entrevista tiene todos los campos requeridos para generación con IA

---

## 11. CLIENT_METRICS (Métricas de Progreso)

**Tabla:** `client_metrics`

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| client_id | String (UUID) | FK, NOT NULL, INDEX | Referencia al cliente |
| metric_type | Enum | NOT NULL | Tipo de métrica |
| value | Float | NOT NULL | Valor de la medición |
| unit | String(20) | NOT NULL | Unidad (kg, cm, %, etc.) |
| date | Date | NOT NULL | Fecha de la medición |
| created_at | DateTime | NOT NULL | Fecha de creación del registro |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enum: MetricType
- `weight` - Peso corporal
- `body_fat` - Porcentaje de grasa corporal
- `chest` - Circunferencia de pecho
- `waist` - Circunferencia de cintura
- `hips` - Circunferencia de cadera
- `arms` - Circunferencia de brazos
- `thighs` - Circunferencia de muslos

### Claves Foráneas
- `client_id` → `users.id` (CASCADE DELETE)

### Relaciones
- **N:1** con `users` (client)

### Índices
- `client_id`

---

## 12. WORKOUT_LOGS (Sesiones de Entrenamiento) ⭐ NUEVO

**Tabla:** `workout_logs`

Registra cada sesión de entrenamiento realizada por un cliente.

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| client_id | String (UUID) | FK, NOT NULL, INDEX | Referencia al cliente |
| training_day_id | String (UUID) | FK, NOT NULL, INDEX | Referencia al día de entrenamiento |
| started_at | DateTime | NOT NULL, DEFAULT: now() | Inicio de la sesión |
| completed_at | DateTime | NULL | Fin de la sesión (NULL si no completada) |
| status | Enum | NOT NULL, DEFAULT: 'in_progress' | Estado del entrenamiento |
| notes | Text | NULL | Notas del usuario sobre la sesión |
| abandon_reason | Enum | NULL | Razón de abandono (si aplica) |
| abandon_notes | Text | NULL | Notas adicionales sobre el abandono |
| rescheduled_to_date | Date | NULL | Nueva fecha si se reagendó |
| created_at | DateTime | NOT NULL | Fecha de creación |
| updated_at | DateTime | NOT NULL | Última actualización |

### Enum: WorkoutStatus
- `in_progress` - Entrenamiento en curso
- `completed` - Entrenamiento completado exitosamente
- `abandoned` - Entrenamiento abandonado antes de terminar

### Enum: AbandonReason
- `time` - No tuvo tiempo suficiente
- `injury` - Lesión o dolor
- `fatigue` - Fatiga acumulada
- `motivation` - Falta de motivación
- `schedule` - Conflicto de horario
- `other` - Otra razón

### Claves Foráneas
- `client_id` → `users.id`
- `training_day_id` → `training_days.id`

### Relaciones
- **N:1** con `users` (client)
- **N:1** con `training_days`
- **1:N** con `exercise_set_logs` (CASCADE DELETE)

### Índices
- `client_id`
- `training_day_id`

### Métricas Derivables
- **Duración:** `completed_at - started_at`
- **Tasa de completitud:** `COUNT(completed) / COUNT(total) * 100`
- **Racha:** Días consecutivos con entrenamientos completados
- **Patrones de abandono:** Análisis por razón

---

## 13. EXERCISE_SET_LOGS (Series Realizadas) ⭐ NUEVO

**Tabla:** `exercise_set_logs`

Registra cada serie realizada durante una sesión de entrenamiento.

### Columnas

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | String (UUID) | PK | Identificador único |
| workout_log_id | String (UUID) | FK, NOT NULL, INDEX | Referencia a la sesión |
| day_exercise_id | String (UUID) | FK, NOT NULL, INDEX | Referencia al ejercicio programado |
| set_number | Integer | NOT NULL | Número de serie (1, 2, 3...) |
| reps_completed | Integer | NOT NULL | Repeticiones completadas |
| weight_kg | Float | NULL | Peso usado en kg (NULL para peso corporal) |
| effort_value | Float | NULL | RIR/RPE registrado por el usuario |
| completed_at | DateTime | NOT NULL, DEFAULT: now() | Timestamp de completado |
| notes | Text | NULL | Notas sobre la serie |
| created_at | DateTime | NOT NULL | Fecha de creación |

### Claves Foráneas
- `workout_log_id` → `workout_logs.id` (CASCADE DELETE)
- `day_exercise_id` → `day_exercises.id`

### Relaciones
- **N:1** con `workout_logs`
- **N:1** con `day_exercises`

### Índices
- `workout_log_id`
- `day_exercise_id`

### Métricas Derivables
- **Volumen total:** `SUM(reps_completed * weight_kg)`
- **Series completadas:** `COUNT(*)` por workout
- **PRs (Personal Records):** `MAX(weight_kg)` por ejercicio
- **Progresión:** Comparación de peso/reps entre sesiones
- **Tonnage semanal:** Agregación de volumen por semana

---

## Jerarquía de Datos - Programas de Entrenamiento

```
User (Trainer)
  |
  └─> Macrocycle (Programa completo, 8-52 semanas)
        ├─ trainer_id → User
        ├─ client_id → User (NULL = plantilla)
        |
        └─> Mesocycle [1..N] (Bloques de 3-6 semanas)
              ├─ block_number (orden)
              |
              └─> Microcycle [1..N] (Semanas)
                    ├─ week_number (orden)
3. Microcycle (semana)
4. TrainingDay (día)
5. DayExercise (ejercicio)

---

## Relaciones Exercise-Muscle (N:M)

```
Exercise
  |
  └─> ExerciseMuscle (junction table)
        ├─ muscle_id → Muscle
        ├─ muscle_role (primary/secondary)
        └─ UNIQUE(exercise_id, muscle_id)
```

**Ejemplo:**
- Bench Press tiene:
  - Primary: Pectoralis Major, Triceps
  - Secondary: Anterior Deltoid

---

## Extensiones PostgreSQL

### uuid-ossp
Genera UUIDs para IDs:
```sql
id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
```

### pg_trgm
Habilita búsquedas fuzzy/similitud de texto:
- Búsqueda de ejercicios por nombre aproximado
- Búsqueda de músculos por nombre
- Mejora performance de LIKE '%pattern%'

---

## Características Técnicas Importantes

### 1. IDs Universales
- **Tipo:** UUID v4 convertidos a String
- **Generación:** Automática con `uuid.uuid4()`
- **Ventajas:** Globalmente únicos, seguros, no secuenciales

### 2. Timestamps Automáticos
Todas las tablas tienen:
```python
created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
updated_at = Column(DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)
```

### 3. Cascade Deletes
Configurado para mantener integridad referencial:
- Eliminar Macrocycle → elimina todos sus Mesocycles
- Eliminar Mesocycle → elimina todos sus Microcycles
- Eliminar Microcycle → elimina todos sus TrainingDays
- Eliminar TrainingDay → elimina todos sus DayExercises
- Eliminar Exercise → elimina todas sus relaciones ExerciseMuscle
- Eliminar User (client) → elimina su ClientInterview y ClientMetrics

### 4. Índices Estratégicos
- **Email** (users) - Búsquedas rápidas de login
- **Name** (exercises, muscles) - Búsquedas de biblioteca
- **client_id** (client_metrics) - Filtrado por cliente
- **exercise_id, muscle_id** (exercise_muscles) - Joins rápidos

### 5. Validaciones a Nivel DB
- **CHECK Constraints:** muscle_role en exercise_muscles
- **UNIQUE Constraints:** Email, nombre de músculo, (exercise_id, muscle_id)
- **NOT NULL:** Campos críticos siempre requeridos

### 6. Arrays de PostgreSQL
Uso de tipos `ARRAY[String]` y `ARRAY[Integer]` para listas:
- `target_muscle_groups` - Lista de grupos musculares
- `injury_areas` - Lista de áreas lesionadas
- `available_equipment` - Lista de equipamiento
- `preferred_days` - Lista de días preferidos (1-7)

### 7. Enums a Nivel Python
SQLAlchemy Enum se traduce a VARCHAR con validación en app:
- No usa ENUM nativo de PostgreSQL
- Más flexibilidad para migraciones
- Validación en capa de aplicación

---

## Scripts de Inicialización

### database/init_db.sql
**Propósito:** Migración para modernizar `client_interviews`

**Acciones:**
1. Agrega columnas estructuradas a `client_interviews`
2. Usa `IF NOT EXISTS` para idempotencia
3. Habilita extensiones PostgreSQL
4. Prepara eliminación de columnas legacy (comentadas)

**Nota:** Las tablas principales son creadas por SQLAlchemy, no por este script.

### backend/scripts/seed_users.py
Crea usuarios de prueba:
- 1 Admin: `admin@fitpilot.com`
- 2 Trainers: `trainer1@fitpilot.com`, `trainer2@fitpilot.com`
- 2 Clients: `client1@fitpilot.com`, `client2@fitpilot.com`
- Password: `password123` (todos)

### backend/scripts/seed_exercises.py
Puebla la biblioteca de ejercicios con datos iniciales.

---

## Configuración de Conexión

**Puerto PostgreSQL:** 5433 (no el estándar 5432)
**Database URL:** `postgresql://fitpilot:fitpilot123@postgres:5433/fitpilot_db`
**Motor:** psycopg3 (PostgreSQL adapter)
**Pool:** SQLAlchemy maneja pool de conexiones
**PgAdmin:** Disponible en puerto 5050 para administración visual

---

## Diagrama ER Simplificado

```
┌─────────────┐
│   USERS     │
│  (Trainer/  │
│   Client/   │
│   Admin)    │
└──────┬──────┘
       │
       ├──1:N──────────────────────┐
       │                           │
       │ (trainer_id)              │ (client_id)
       │                           │
┌──────▼─────────┐          ┌──────▼────────────┐
│  MACROCYCLES   │          │ CLIENT_INTERVIEWS │
│   (Programs/   │          │     (1:1)         │
│   Templates)   │          └───────────────────┘
└────────┬───────┘
         │                  ┌──────────────────┐
         │                  │ CLIENT_METRICS   │
         │                  │     (N:1)        │
         │                  └──────────────────┘
         │1:N
         │
┌────────▼───────┐
│  MESOCYCLES    │
│   (Blocks)     │
└────────┬───────┘
         │1:N
         │
┌────────▼───────┐
│  MICROCYCLES   │
│    (Weeks)     │
└────────┬───────┘
         │1:N
         │
┌────────▼───────┐
│ TRAINING_DAYS  │
│     (Days)     │
└────────┬───────┘
         │1:N
         │
┌────────▼───────┐          ┌──────────┐
│ DAY_EXERCISES  │────N:1──▶│EXERCISES │
│  (Instances)   │          │(Library) │
└────────────────┘          └────┬─────┘
                                 │N:M
                                 │
                          ┌──────▼────────┐
                          │EXERCISE_      │
                          │  MUSCLES      │
                          │  (Junction)   │
                          └──────┬────────┘
                                 │N:M
                                 │
                          ┌──────▼────────┐
                          │   MUSCLES     │
                          │  (Anatomy)    │
                          └───────────────┘
```

---

## Resumen de Contadores

| Concepto | Cantidad |
|----------|----------|
| **Tablas totales** | 14 |
| **Tablas principales** | 12 |
| **Tablas junction** | 1 (exercise_muscles) |
| **Tablas auxiliares** | 1 (client_interviews) |
| **Enums definidos** | 19 |
| **Relaciones 1:N** | 10 |
| **Relaciones N:M** | 1 |
| **Relaciones 1:1** | 1 |
| **Índices únicos** | 3 |
| **Índices simples** | 8 |
| **Campos con arrays** | 10 |
| **Niveles jerarquía** | 5 |

---

## Conclusiones

### Fortalezas del Diseño

1. **Jerarquía clara y lógica** - Refleja la estructura real de periodización deportiva
2. **Separación plantillas/programas** - `client_id` nullable permite reutilización
3. **Normalización adecuada** - Exercise library separada de instancias
4. **Relaciones muscle-exercise flexibles** - Permite primary/secondary roles
5. **Timestamps completos** - Auditoría en todas las tablas
6. **Cascade deletes configurados** - Mantiene integridad automáticamente
7. **UUIDs** - Seguros y distribuibles
8. **Cuestionarios estructurados** - client_interviews con validaciones fuertes
9. **Tracking de progreso** - client_metrics permite seguimiento temporal

### Áreas de Atención

1. **Profundidad de jerarquía** - 5 niveles puede complicar queries
2. **Arrays PostgreSQL** - Dificulta búsquedas en listas de equipment, injuries, etc.
3. **Sin soft deletes** - Eliminaciones son permanentes (considerar `deleted_at`)
4. **Enums en Python** - Cambios requieren migración de código + DB
5. **Sin versionado** - Programas modificados pierden historial
6. **client_interviews 1:1** - Solo una entrevista por cliente (¿considerar histórico?)

### Recomendaciones Futuras

1. Considerar tabla `program_versions` para historial de cambios
2. Evaluar tabla separada `client_equipment` para normalizar equipamiento
3. Implementar soft deletes con `deleted_at` para datos sensibles
4. ~~Agregar tabla `workout_logs` para registrar entrenamientos completados~~ ✅ IMPLEMENTADO
5. Índices compuestos para queries frecuentes (ej: client_id + date en metrics)
6. Considerar tabla `exercise_progress` para trackear PRs históricos
7. Agregar endpoint `/api/workout-logs/weekly-stats` para dashboard de actividad

---

**Actualizado:** 2025-12-04
**Base de datos:** PostgreSQL 14+
**ORM:** SQLAlchemy 2.0+
**Proyecto:** FitPilot v1.0
