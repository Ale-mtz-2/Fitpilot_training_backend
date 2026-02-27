-- Seed de músculos base para FitPilot
-- Este archivo debe ejecutarse ANTES de seed_exercise_muscles.sql

INSERT INTO muscles (id, name, display_name_es, display_name_en, body_region, muscle_category, sort_order, created_at, updated_at) VALUES
('91652340-844c-43d3-80da-de1ce7304a48', 'chest', 'Pecho', 'Chest', 'upper_body', 'chest', 1, NOW(), NOW()),
('d768ffc4-b0a1-4c75-8c11-c886daf0e2cc', 'lats', 'Dorsales', 'Lats', 'upper_body', 'back', 2, NOW(), NOW()),
('b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352', 'upper_back', 'Espalda Superior', 'Upper Back', 'upper_body', 'back', 3, NOW(), NOW()),
('abadd271-e2cb-4f4f-9aa4-9aabae72db67', 'lower_back', 'Espalda Baja', 'Lower Back', 'core', 'back', 4, NOW(), NOW()),
('936a7751-7076-4802-821c-33fc87546897', 'anterior_deltoid', 'Deltoides Anterior', 'Anterior Deltoid', 'upper_body', 'shoulders', 5, NOW(), NOW()),
('5a3f9770-4d52-4c5a-99df-1e6fd5e46c6a', 'lateral_deltoid', 'Deltoides Lateral', 'Lateral Deltoid', 'upper_body', 'shoulders', 6, NOW(), NOW()),
('7ae11464-3f30-47ce-ab9e-5fae4a225805', 'posterior_deltoid', 'Deltoides Posterior', 'Posterior Deltoid', 'upper_body', 'shoulders', 7, NOW(), NOW()),
('a70b9f88-0317-4c0f-9de1-01679cfaedcb', 'biceps', 'Bíceps', 'Biceps', 'upper_body', 'arms', 7, NOW(), NOW()),
('42193381-087e-4fb5-bfb1-ae4edba6aa4a', 'triceps', 'Tríceps', 'Triceps', 'upper_body', 'arms', 8, NOW(), NOW()),
('b8a7caad-178d-4ae4-b345-fb1d73b9ad2b', 'quadriceps', 'Cuádriceps', 'Quadriceps', 'lower_body', 'legs', 9, NOW(), NOW()),
('99e28019-b7bc-4278-b4eb-0b9bb53878f6', 'hamstrings', 'Isquiotibiales', 'Hamstrings', 'lower_body', 'legs', 10, NOW(), NOW()),
('c1b71264-dafc-4e42-99f9-92df8b91fe5d', 'glutes', 'Glúteos', 'Glutes', 'lower_body', 'legs', 11, NOW(), NOW()),
('2a06511f-22fd-49cc-85da-99a0d7bd0df1', 'calves', 'Pantorrillas', 'Calves', 'lower_body', 'legs', 12, NOW(), NOW()),
('647be680-283b-4014-a57c-03eb2feb33f4', 'adductors', 'Aductores', 'Adductors', 'lower_body', 'legs', 13, NOW(), NOW()),
('3a83a736-9869-432f-985f-5430456ba7c1', 'tibialis', 'Tibial Anterior', 'Tibialis', 'lower_body', 'legs', 14, NOW(), NOW()),
('a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd', 'abs', 'Abdominales', 'Abs', 'core', 'core', 15, NOW(), NOW()),
('018c8d48-0ec8-4e81-ad52-43b091840c45', 'obliques', 'Oblicuos', 'Obliques', 'core', 'core', 16, NOW(), NOW()),
('f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45', 'forearms', 'Antebrazos', 'Forearms', 'upper_body', 'arms', 17, NOW(), NOW())
ON CONFLICT (id) DO NOTHING;
