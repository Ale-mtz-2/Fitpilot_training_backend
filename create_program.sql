-- Programa de entrenamiento para Itzel Britney Rodríguez Brahams
-- 8 semanas, 5 días/semana, enfocado en glúteos y corrección postural

-- Variables
\set client_id 'ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c'
\set trainer_id 'e4244715-20b9-4103-beca-6da91ce89338'
\set macrocycle_id '550e8400-e29b-41d4-a716-446655440001'

-- Crear Macrocycle
INSERT INTO macrocycles (id, name, description, objective, start_date, end_date, client_id, trainer_id, status, created_at, updated_at)
VALUES (
    :'macrocycle_id',
    'Programa Recomposición Corporal - Itzel',
    'Programa de 8 semanas enfocado en desarrollo de glúteos, pérdida de grasa y corrección de postura cifótica. División Lower/Upper con énfasis en frecuencia de glúteos.',
    'fat_loss',
    '2025-12-02',
    '2026-01-26',
    :'client_id',
    :'trainer_id',
    'draft',
    NOW(),
    NOW()
);

-- Crear Mesocycle 1: Fase de Acumulación
\set meso1_id '550e8400-e29b-41d4-a716-446655440010'
INSERT INTO mesocycles (id, macrocycle_id, block_number, name, description, start_date, end_date, focus, created_at, updated_at)
VALUES (
    :'meso1_id',
    :'macrocycle_id',
    1,
    'Fase de Acumulación',
    'Bloque 1: Desarrollo de volumen de trabajo y técnica. Énfasis en patrón de movimiento de cadera.',
    '2025-12-02',
    '2025-12-29',
    'Volumen y técnica',
    NOW(),
    NOW()
);

-- Crear Mesocycle 2: Fase de Intensificación
\set meso2_id '550e8400-e29b-41d4-a716-446655440020'
INSERT INTO mesocycles (id, macrocycle_id, block_number, name, description, start_date, end_date, focus, created_at, updated_at)
VALUES (
    :'meso2_id',
    :'macrocycle_id',
    2,
    'Fase de Intensificación',
    'Bloque 2: Aumento de intensidad y consolidación de fuerza. Énfasis en cargas progresivas.',
    '2025-12-30',
    '2026-01-26',
    'Fuerza y definición',
    NOW(),
    NOW()
);

-- Función helper para crear semanas
-- Semana 1 (Mesocycle 1)
\set micro1_id '550e8400-e29b-41d4-a716-446655440101'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro1_id', :'meso1_id', 1, 'Semana 1 - Adaptación', '2025-12-02', '2025-12-08', 'low', NOW(), NOW());

-- Semana 2
\set micro2_id '550e8400-e29b-41d4-a716-446655440102'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro2_id', :'meso1_id', 2, 'Semana 2 - Progresión', '2025-12-09', '2025-12-15', 'medium', NOW(), NOW());

-- Semana 3
\set micro3_id '550e8400-e29b-41d4-a716-446655440103'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro3_id', :'meso1_id', 3, 'Semana 3 - Intensificación', '2025-12-16', '2025-12-22', 'high', NOW(), NOW());

-- Semana 4 (Deload)
\set micro4_id '550e8400-e29b-41d4-a716-446655440104'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro4_id', :'meso1_id', 4, 'Semana 4 - Descarga', '2025-12-23', '2025-12-29', 'deload', NOW(), NOW());

-- Semana 5 (Mesocycle 2)
\set micro5_id '550e8400-e29b-41d4-a716-446655440201'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro5_id', :'meso2_id', 5, 'Semana 5 - Adaptación', '2025-12-30', '2026-01-05', 'low', NOW(), NOW());

-- Semana 6
\set micro6_id '550e8400-e29b-41d4-a716-446655440202'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro6_id', :'meso2_id', 6, 'Semana 6 - Progresión', '2026-01-06', '2026-01-12', 'medium', NOW(), NOW());

-- Semana 7
\set micro7_id '550e8400-e29b-41d4-a716-446655440203'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro7_id', :'meso2_id', 7, 'Semana 7 - Intensificación', '2026-01-13', '2026-01-19', 'high', NOW(), NOW());

-- Semana 8 (Deload final)
\set micro8_id '550e8400-e29b-41d4-a716-446655440204'
INSERT INTO microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, created_at, updated_at)
VALUES (:'micro8_id', :'meso2_id', 8, 'Semana 8 - Descarga Final', '2026-01-20', '2026-01-26', 'deload', NOW(), NOW());

-- ==========================================
-- DÍAS DE ENTRENAMIENTO - SEMANA 1
-- ==========================================

-- Día 1: Lower Body - Énfasis Glúteos
\set day1_w1 '550e8400-e29b-41d4-a716-446655441011'
INSERT INTO training_days (id, microcycle_id, day_number, name, focus, date, rest_day, created_at, updated_at)
VALUES (:'day1_w1', :'micro1_id', 1, 'Lower Body - Énfasis Glúteos', 'Glúteos, Isquiotibiales', '2025-12-02', false, NOW(), NOW());

INSERT INTO day_exercises (id, training_day_id, exercise_id, order_index, sets, reps_min, reps_max, rest_seconds, effort_type, effort_value, created_at, updated_at) VALUES
(gen_random_uuid(), :'day1_w1', '43a9b1fe-8f85-4126-8690-e55410aa022c', 0, 3, 8, 12, 120, 'RIR', 3, NOW(), NOW()),  -- Hip Thrust Barbell
(gen_random_uuid(), :'day1_w1', 'a65dc37c-13ad-448d-8ef7-a31d938c7ead', 1, 3, 8, 10, 120, 'RIR', 3, NOW(), NOW()),  -- Romanian Deadlift
(gen_random_uuid(), :'day1_w1', 'bcc75aab-390b-4e8d-be43-b76bf5ff3466', 2, 3, 10, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Bulgarian Split Squat
(gen_random_uuid(), :'day1_w1', '1da215b2-666a-4246-b7eb-f72c98de082d', 3, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW()),  -- Hip Abduction
(gen_random_uuid(), :'day1_w1', 'bccfa9f4-6148-495e-acb3-721da14e9721', 4, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW()),  -- Cable Kickback
(gen_random_uuid(), :'day1_w1', '9538101e-512b-41a2-aec6-831b9f35780e', 5, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW());  -- Cable Pull Through

-- Día 2: Upper Body - Push + Corrección Postural
\set day2_w1 '550e8400-e29b-41d4-a716-446655441012'
INSERT INTO training_days (id, microcycle_id, day_number, name, focus, date, rest_day, created_at, updated_at)
VALUES (:'day2_w1', :'micro1_id', 2, 'Upper Body - Push + Corrección Postural', 'Pecho, Hombros, Postura', '2025-12-03', false, NOW(), NOW());

INSERT INTO day_exercises (id, training_day_id, exercise_id, order_index, sets, reps_min, reps_max, rest_seconds, effort_type, effort_value, created_at, updated_at) VALUES
(gen_random_uuid(), :'day2_w1', '18d50e17-4bce-4d39-8071-c93d969b7696', 0, 3, 8, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Incline DB Press
(gen_random_uuid(), :'day2_w1', '13135caf-d1bf-4be5-bc08-c3287dc4b7b6', 1, 3, 10, 12, 90, 'RIR', 3, NOW(), NOW()),  -- DB Shoulder Press
(gen_random_uuid(), :'day2_w1', '45ffd819-86b1-4f9f-998c-d0707edb1b8c', 2, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW()),  -- Low to High Cable Fly
(gen_random_uuid(), :'day2_w1', '9da2b8ad-0895-4665-987f-7b3b4cbd8cb1', 3, 4, 15, 20, 60, 'RIR', 3, NOW(), NOW()),  -- Face Pull
(gen_random_uuid(), :'day2_w1', '945a062b-0bfd-49b4-9bfc-3617fe1fad76', 4, 3, 15, 20, 60, 'RIR', 3, NOW(), NOW()),  -- Rear Delt Fly
(gen_random_uuid(), :'day2_w1', 'e08d2b37-cdf9-4285-8307-6d4a2a60492b', 5, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW());  -- Lateral Raise

-- Día 3: Lower Body - Cuádriceps/Glúteos
\set day3_w1 '550e8400-e29b-41d4-a716-446655441013'
INSERT INTO training_days (id, microcycle_id, day_number, name, focus, date, rest_day, created_at, updated_at)
VALUES (:'day3_w1', :'micro1_id', 3, 'Lower Body - Cuádriceps/Glúteos', 'Cuádriceps, Glúteos', '2025-12-04', false, NOW(), NOW());

INSERT INTO day_exercises (id, training_day_id, exercise_id, order_index, sets, reps_min, reps_max, rest_seconds, effort_type, effort_value, created_at, updated_at) VALUES
(gen_random_uuid(), :'day3_w1', '1dd47ff8-ab0e-4468-89b5-ef58218fb071', 0, 3, 6, 8, 150, 'RIR', 3, NOW(), NOW()),  -- Back Squat
(gen_random_uuid(), :'day3_w1', '06ca48f5-bfcc-4ffa-964b-48eddafab389', 1, 3, 10, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Leg Press
(gen_random_uuid(), :'day3_w1', '4eafd2c5-8de8-422c-9f27-90289f970e16', 2, 3, 10, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Walking Lunge
(gen_random_uuid(), :'day3_w1', 'dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34', 3, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW()),  -- Leg Extension
(gen_random_uuid(), :'day3_w1', '35be3e87-2c9d-454c-9c7b-5ec6ca0c9625', 4, 3, 12, 15, 60, 'RIR', 3, NOW(), NOW()),  -- Glute Bridge
(gen_random_uuid(), :'day3_w1', '1da215b2-666a-4246-b7eb-f72c98de082d', 5, 3, 15, 20, 45, 'RIR', 3, NOW(), NOW());  -- Hip Abduction

-- Día 4: Upper Body - Pull + Corrección Postural
\set day4_w1 '550e8400-e29b-41d4-a716-446655441014'
INSERT INTO training_days (id, microcycle_id, day_number, name, focus, date, rest_day, created_at, updated_at)
VALUES (:'day4_w1', :'micro1_id', 4, 'Upper Body - Pull + Corrección Postural', 'Espalda, Bíceps, Postura', '2025-12-05', false, NOW(), NOW());

INSERT INTO day_exercises (id, training_day_id, exercise_id, order_index, sets, reps_min, reps_max, rest_seconds, effort_type, effort_value, created_at, updated_at) VALUES
(gen_random_uuid(), :'day4_w1', '490a8870-e9f7-4a54-8444-6679403cd12c', 0, 3, 8, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Lat Pulldown
(gen_random_uuid(), :'day4_w1', '2b384748-2af0-4941-88fe-2a589bd3aeb4', 1, 3, 10, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Seated Cable Row
(gen_random_uuid(), :'day4_w1', 'a7e34918-49a4-47ef-aeba-69c4fb324fe8', 2, 3, 10, 12, 90, 'RIR', 3, NOW(), NOW()),  -- Chest Supported Row
(gen_random_uuid(), :'day4_w1', '9da2b8ad-0895-4665-987f-7b3b4cbd8cb1', 3, 4, 15, 20, 60, 'RIR', 3, NOW(), NOW()),  -- Face Pull
(gen_random_uuid(), :'day4_w1', '945a062b-0bfd-49b4-9bfc-3617fe1fad76', 4, 3, 15, 20, 60, 'RIR', 3, NOW(), NOW()),  -- Rear Delt Fly
(gen_random_uuid(), :'day4_w1', 'e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463', 5, 3, 10, 12, 60, 'RIR', 3, NOW(), NOW());  -- Dumbbell Row

-- Día 5: Full Body - Glúteos + Core
\set day5_w1 '550e8400-e29b-41d4-a716-446655441015'
INSERT INTO training_days (id, microcycle_id, day_number, name, focus, date, rest_day, created_at, updated_at)
VALUES (:'day5_w1', :'micro1_id', 5, 'Full Body - Glúteos + Core', 'Glúteos, Core, Cardio metabólico', '2025-12-06', false, NOW(), NOW());

INSERT INTO day_exercises (id, training_day_id, exercise_id, order_index, sets, reps_min, reps_max, rest_seconds, effort_type, effort_value, created_at, updated_at) VALUES
(gen_random_uuid(), :'day5_w1', 'ac7717a4-4e37-4cc2-9050-b4185af9c34c', 0, 3, 12, 15, 90, 'RIR', 3, NOW(), NOW()),  -- Hip Thrust Dumbbell
(gen_random_uuid(), :'day5_w1', '6cd9c5f9-38db-401d-8099-b64a7e580c5f', 1, 3, 12, 15, 75, 'RIR', 3, NOW(), NOW()),  -- Goblet Squat
(gen_random_uuid(), :'day5_w1', '155ee3c5-a401-4644-a6c5-06bed7a187a8', 2, 3, 10, 12, 75, 'RIR', 3, NOW(), NOW()),  -- Reverse Lunge
(gen_random_uuid(), :'day5_w1', '85a6425e-8ff0-40c2-b171-d6c404c9ee40', 3, 3, 8, 10, 90, 'RIR', 3, NOW(), NOW()),  -- Sumo Deadlift
(gen_random_uuid(), :'day5_w1', 'd483a4b4-9b78-4135-ae09-348de96db487', 4, 3, 30, 60, 45, 'RIR', 3, NOW(), NOW()),  -- Plank (segundos)
(gen_random_uuid(), :'day5_w1', 'cdaa6012-b647-4168-aadc-58c1d033b3bb', 5, 3, 15, 20, 45, 'RIR', 3, NOW(), NOW());  -- Cable Face Pull

-- Verificación
SELECT 'Programa creado exitosamente!' as status;
SELECT COUNT(*) as total_training_days FROM training_days WHERE microcycle_id = :'micro1_id';
