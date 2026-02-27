-- Seed de relaciones ejercicio-músculo para FitPilot
-- Asigna músculos primarios y secundarios a cada ejercicio

-- Variables para IDs de músculos (para facilitar lectura)
DO $$
DECLARE
    m_abs VARCHAR := 'a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd';
    m_adductors VARCHAR := '647be680-283b-4014-a57c-03eb2feb33f4';
    m_anterior_deltoid VARCHAR := '936a7751-7076-4802-821c-33fc87546897';
    m_biceps VARCHAR := 'a70b9f88-0317-4c0f-9de1-01679cfaedcb';
    m_calves VARCHAR := '2a06511f-22fd-49cc-85da-99a0d7bd0df1';
    m_chest VARCHAR := '91652340-844c-43d3-80da-de1ce7304a48';
    m_forearms VARCHAR := 'f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45';
    m_glutes VARCHAR := 'c1b71264-dafc-4e42-99f9-92df8b91fe5d';
    m_hamstrings VARCHAR := '99e28019-b7bc-4278-b4eb-0b9bb53878f6';
    m_lats VARCHAR := 'd768ffc4-b0a1-4c75-8c11-c886daf0e2cc';
    m_lower_back VARCHAR := 'abadd271-e2cb-4f4f-9aa4-9aabae72db67';
    m_obliques VARCHAR := '018c8d48-0ec8-4e81-ad52-43b091840c45';
    m_posterior_deltoid VARCHAR := '7ae11464-3f30-47ce-ab9e-5fae4a225805';
    m_quadriceps VARCHAR := 'b8a7caad-178d-4ae4-b345-fb1d73b9ad2b';
    m_tibialis VARCHAR := '3a83a736-9869-432f-985f-5430456ba7c1';
    m_triceps VARCHAR := '42193381-087e-4fb5-bfb1-ae4edba6aa4a';
    m_upper_back VARCHAR := 'b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352';

    ex_id VARCHAR;
BEGIN
    -- =============================================
    -- PECHO (Chest Exercises)
    -- =============================================

    -- Dumbbell Bench Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Bench Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Decline Bench Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Decline Bench Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Decline Dumbbell Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Decline Dumbbell Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dumbbell Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Incline Dumbbell Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Incline Dumbbell Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Pec Deck Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pec Deck Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Low Cable Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Low Cable Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- High Cable Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'High Cable Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Chest Press Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Chest Press Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- ESPALDA (Back Exercises)
    -- =============================================

    -- Dumbbell Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- T-Bar Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'T-Bar Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Seated Cable Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Seated Cable Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Pendlay Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pendlay Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Chest Supported Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Chest Supported Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Meadows Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Meadows Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Wide Grip Lat Pulldown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Wide Grip Lat Pulldown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Close Grip Lat Pulldown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Close Grip Lat Pulldown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Neutral Grip Pull-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Neutral Grip Pull-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Chin-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Chin-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Straight Arm Pulldown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Straight Arm Pulldown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Rack Pulls
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Rack Pulls';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Sumo Deadlift
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Sumo Deadlift';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_adductors, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Trap Bar Deadlift
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Trap Bar Deadlift';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- HOMBROS (Shoulder Exercises)
    -- =============================================

    -- Dumbbell Shoulder Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Shoulder Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Arnold Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Arnold Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Push Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Push Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Machine Shoulder Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Machine Shoulder Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Lateral Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Lateral Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Front Dumbbell Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Front Dumbbell Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Rear Delt Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Rear Delt Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Reverse Pec Deck
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Pec Deck';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Upright Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Upright Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dumbbell Shrugs
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Shrugs';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Barbell Shrugs
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Barbell Shrugs';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- PIERNAS (Leg Exercises)
    -- =============================================

    -- Front Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Front Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Goblet Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Goblet Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hack Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hack Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Bulgarian Split Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Bulgarian Split Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Sissy Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Sissy Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Box Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Box Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Pistol Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pistol Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Reverse Lunge
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Lunge';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lateral Lunge
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lateral Lunge';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_adductors, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Step-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Step-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lying Leg Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lying Leg Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Seated Leg Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Seated Leg Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Nordic Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Nordic Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Leg Leg Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Leg Leg Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Pendulum Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pendulum Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- GLUTEOS (Glute Exercises)
    -- =============================================

    -- Hip Thrust
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip Thrust';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Glute Bridge
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Glute Bridge';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Leg Hip Thrust
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Leg Hip Thrust';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Pull Through
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Pull Through';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Frog Pumps
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Frog Pumps';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Glute Kickback Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Glute Kickback Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Glute Kickback
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Glute Kickback';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hip Abduction Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip Abduction Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Hip Abduction
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Hip Abduction';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hip Adduction Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip Adduction Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_adductors, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- PANTORRILLAS (Calf Exercises)
    -- =============================================

    -- Seated Calf Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Seated Calf Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Standing Calf Raise Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Standing Calf Raise Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Donkey Calf Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Donkey Calf Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Leg Calf Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Leg Calf Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Press Calf Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Press Calf Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- BICEPS
    -- =============================================

    -- EZ Bar Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'EZ Bar Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Preacher Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Preacher Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Concentration Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Concentration Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Incline Dumbbell Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Incline Dumbbell Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Spider Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Spider Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Reverse Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Zottman Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Zottman Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Hammer Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Hammer Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- 21s Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = '21s Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- TRICEPS
    -- =============================================

    -- Close Grip Bench Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Close Grip Bench Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Overhead Tricep Extension
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Overhead Tricep Extension';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Rope Pushdown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Rope Pushdown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Arm Pushdown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Arm Pushdown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Tricep Kickback
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Tricep Kickback';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Overhead Cable Extension
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Overhead Cable Extension';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Diamond Push-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Diamond Push-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Bench Dips
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Bench Dips';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- JM Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'JM Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- ANTEBRAZOS Y AGARRE
    -- =============================================

    -- Wrist Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Wrist Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_forearms, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Farmers Walk
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Farmers Walk';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_forearms, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dead Hang
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dead Hang';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_forearms, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- CORE / ABDOMINALES
    -- =============================================

    -- Crunches
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Crunches';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Reverse Crunches
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Crunches';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Bicycle Crunches
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Bicycle Crunches';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- V-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'V-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Toe Touches
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Toe Touches';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dead Bug
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dead Bug';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Bird Dog
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Bird Dog';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Side Plank
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Side Plank';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Ab Wheel Rollout
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Ab Wheel Rollout';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dragon Flag
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dragon Flag';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Raises
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Raises';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Mountain Climbers
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Mountain Climbers';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Pallof Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pallof Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Woodchop
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Woodchop';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Woodchop High to Low
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Woodchop High to Low';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hollow Body Hold
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hollow Body Hold';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- L-Sit
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'L-Sit';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Copenhagen Plank
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Copenhagen Plank';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_adductors, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- CARDIO Y PLIOMETRICOS
    -- =============================================

    -- Stationary Bike
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Stationary Bike';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Elliptical
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Elliptical';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Stair Climber
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Stair Climber';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Battle Ropes
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Battle Ropes';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Sled Push
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Sled Push';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Sled Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Sled Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Box Jumps
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Box Jumps';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Jumping Jacks
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Jumping Jacks';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- High Knees
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'High Knees';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Kettlebell Swing
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Kettlebell Swing';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Clean and Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Clean and Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Snatch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Snatch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Power Clean
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Power Clean';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Thrusters
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Thrusters';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- EJERCICIOS ADICIONALES (agregados posteriormente)
    -- =============================================

    -- PECHO ADICIONAL

    -- Flat Barbell Bench Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Flat Barbell Bench Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Incline Barbell Bench Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Incline Barbell Bench Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Incline Dumbbell Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Incline Dumbbell Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Push-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Push-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Crossover
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Crossover';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dumbbell Pullover
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Pullover';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Low to High Cable Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Low to High Cable Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- High to Low Cable Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'High to Low Cable Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Close Grip Push-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Close Grip Push-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Smith Machine Bench Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Smith Machine Bench Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- ESPALDA ADICIONAL

    -- Pull-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pull-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lat Pulldown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lat Pulldown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Barbell Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Barbell Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Deadlift
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Deadlift';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Romanian Deadlift
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Romanian Deadlift';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Face Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Face Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Arm Lat Pulldown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Arm Lat Pulldown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Rack Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Rack Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Inverted Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Inverted Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Good Morning
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Good Morning';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Seal Row
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Seal Row';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- HOMBROS ADICIONAL

    -- Overhead Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Overhead Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lateral Raise (Dumbbell)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lateral Raise (Dumbbell)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lateral Raise (Cable)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lateral Raise (Cable)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Front Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Front Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Shrugs (Dumbbell)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Shrugs (Dumbbell)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Shrugs (Barbell)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Shrugs (Barbell)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- High Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'High Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- PIERNAS ADICIONAL

    -- Back Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Back Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Extension
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Extension';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Walking Lunge
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Walking Lunge';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Smith Machine Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Smith Machine Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Belt Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Belt Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Leg Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Leg Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Leg Romanian Deadlift
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Leg Romanian Deadlift';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Standing Leg Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Standing Leg Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- GLUTEOS ADICIONAL

    -- Hip Thrust (Barbell)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip Thrust (Barbell)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hip Thrust (Dumbbell)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip Thrust (Dumbbell)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Kickback
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Kickback';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Donkey Kick
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Donkey Kick';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Fire Hydrant
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Fire Hydrant';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Reverse Hyperextension
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Hyperextension';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- PANTORRILLAS ADICIONAL

    -- Standing Calf Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Standing Calf Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- BICEPS ADICIONAL

    -- Barbell Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Barbell Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dumbbell Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dumbbell Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hammer Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hammer Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cross Body Hammer Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cross Body Hammer Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Drag Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Drag Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- High Cable Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'High Cable Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- TRICEPS ADICIONAL

    -- Tricep Pushdown (Rope)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Tricep Pushdown (Rope)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Tricep Pushdown (V-Bar)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Tricep Pushdown (V-Bar)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Skull Crusher
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Skull Crusher';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Dips
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Dips';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Overhead Extension
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Overhead Extension';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Arm Tricep Pushdown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Arm Tricep Pushdown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- French Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'French Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- CORE ADICIONAL

    -- Plank
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Plank';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hanging Leg Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hanging Leg Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Crunch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Crunch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Russian Twist
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Russian Twist';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Bicycle Crunch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Bicycle Crunch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- V-Up
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'V-Up';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Woodchop (Cable)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Woodchop (Cable)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_obliques, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Reverse Crunch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Crunch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Toe Touch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Toe Touch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Flutter Kicks
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Flutter Kicks';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Decline Sit-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Decline Sit-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Weighted Plank
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Weighted Plank';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Superman
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Superman';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- CARDIO ADICIONAL

    -- Treadmill Running
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Treadmill Running';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Rowing Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Rowing Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Jump Rope
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Jump Rope';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_calves, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Assault Bike
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Assault Bike';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Burpees
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Burpees';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- OLIMPICOS ADICIONAL

    -- Hang Clean
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hang Clean';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hang Snatch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hang Snatch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Clean and Jerk
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Clean and Jerk';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Push Jerk
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Push Jerk';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Broad Jump
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Broad Jump';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Tuck Jump
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Tuck Jump';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Medicine Ball Slam
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Medicine Ball Slam';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Wall Ball
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Wall Ball';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Turkish Get Up
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Turkish Get Up';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_abs, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Overhead Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Overhead Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- =============================================
    -- EJERCICIOS FALTANTES
    -- =============================================

    -- MOVILIDAD Y CALENTAMIENTO

    -- Arm Circles
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Arm Circles';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- A-Skips
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'A-Skips';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- B-Skips
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'B-Skips';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Butt Kicks
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Butt Kicks';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hip Circles
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip Circles';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_adductors, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Swings
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Swings';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Inchworm
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Inchworm';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cat-Cow Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cat-Cow Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Thoracic Spine Rotation
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Thoracic Spine Rotation';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Shoulder Dislocates
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Shoulder Dislocates';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Wall Angels
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Wall Angels';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- World Greatest Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'World Greatest Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Hip 90/90 Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Hip 90/90 Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_adductors, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Pigeon Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Pigeon Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Couch Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Couch Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Frog Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Frog Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_adductors, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Scorpion Stretch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Scorpion Stretch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lower_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_obliques, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Foam Rolling Back
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Foam Rolling Back';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Foam Rolling Quads
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Foam Rolling Quads';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Foam Rolling IT Band
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Foam Rolling IT Band';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- HOMBROS ADICIONALES

    -- Band Pull Apart
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Band Pull Apart';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cable Face Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Face Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Behind Neck Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Behind Neck Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Cuban Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cuban Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lu Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lu Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leaning Lateral Raise
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leaning Lateral Raise';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lateral Raise (Machine)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lateral Raise (Machine)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Shoulder Press Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Shoulder Press Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Seated Bent Over Rear Delt Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Seated Bent Over Rear Delt Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_posterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- ESPALDA ADICIONAL

    -- Cable Row (Close Grip)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Cable Row (Close Grip)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Neutral Grip Lat Pulldown
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Neutral Grip Lat Pulldown';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- PECHO ADICIONAL

    -- Machine Fly
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Machine Fly';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Svend Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Svend Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Wide Grip Push-ups
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Wide Grip Push-ups';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- PIERNAS ADICIONAL

    -- Sumo Squat
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Sumo Squat';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_adductors, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Barbell Lunges
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Barbell Lunges';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Press (High Foot)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Press (High Foot)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Leg Press (Low Foot)
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Leg Press (Low Foot)';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Front Rack Lunge
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Front Rack Lunge';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- GLÚTEOS ADICIONAL

    -- Banded Hip Thrust
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Banded Hip Thrust';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- BÍCEPS ADICIONAL

    -- Machine Bicep Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Machine Bicep Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_biceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- TRÍCEPS ADICIONAL

    -- Tricep Machine
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Tricep Machine';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Tate Press
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Tate Press';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_triceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_chest, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- ANTEBRAZOS ADICIONAL

    -- Reverse Wrist Curl
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Reverse Wrist Curl';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_forearms, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Finger Curls
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Finger Curls';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_forearms, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Plate Pinch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Plate Pinch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_forearms, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Gripper
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Gripper';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_forearms, 'primary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- OLÍMPICOS Y PLIOMÉTRICOS ADICIONALES

    -- Clean Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Clean Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Snatch Pull
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Snatch Pull';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Muscle Snatch
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Muscle Snatch';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_upper_back, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Split Jerk
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Split Jerk';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Depth Jump
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Depth Jump';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Lateral Box Jump
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Lateral Box Jump';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_adductors, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Single Leg Box Jump
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Single Leg Box Jump';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Medicine Ball Throw
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Medicine Ball Throw';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_chest, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- CARDIO ADICIONAL

    -- Incline Treadmill Walk
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Incline Treadmill Walk';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Walk
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Walk';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Sprint Intervals
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Sprint Intervals';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_hamstrings, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_glutes, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_calves, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Ski Erg
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Ski Erg';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW()),
        (gen_random_uuid(), ex_id, m_triceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Versa Climber
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Versa Climber';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_quadriceps, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_biceps, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    -- Swimming
    SELECT id INTO ex_id FROM exercises WHERE name_en = 'Swimming';
    IF ex_id IS NOT NULL THEN
        INSERT INTO exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) VALUES
        (gen_random_uuid(), ex_id, m_lats, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_anterior_deltoid, 'primary', NOW()),
        (gen_random_uuid(), ex_id, m_abs, 'secondary', NOW())
        ON CONFLICT DO NOTHING;
    END IF;

    RAISE NOTICE 'Seed de exercise_muscles completado exitosamente';
END $$;
