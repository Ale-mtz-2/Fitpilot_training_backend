--
-- PostgreSQL database dump
--

\restrict ClIIKY6BiqirmmDLvpOuMSaUNmEQcH9CccV5pdNImSRRoQhhfdhjOAA7h1ePiWv

-- Dumped from database version 15.15 (Debian 15.15-1.pgdg13+1)
-- Dumped by pg_dump version 15.15 (Debian 15.15-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: abandon_reason; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.abandon_reason AS ENUM (
    'time',
    'injury',
    'fatigue',
    'motivation',
    'schedule',
    'other'
);


ALTER TYPE public.abandon_reason OWNER TO admin;

--
-- Name: cardiosubclass; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.cardiosubclass AS ENUM (
    'liss',
    'hiit',
    'miss'
);


ALTER TYPE public.cardiosubclass OWNER TO admin;

--
-- Name: efforttype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.efforttype AS ENUM (
    'RIR',
    'RPE',
    'PERCENTAGE'
);


ALTER TYPE public.efforttype OWNER TO admin;

--
-- Name: exercise_phase; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.exercise_phase AS ENUM (
    'warmup',
    'main',
    'cooldown'
);


ALTER TYPE public.exercise_phase OWNER TO admin;

--
-- Name: exerciseclass; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.exerciseclass AS ENUM (
    'strength',
    'cardio',
    'plyometric',
    'flexibility',
    'mobility',
    'warmup',
    'conditioning',
    'balance'
);


ALTER TYPE public.exerciseclass OWNER TO admin;

--
-- Name: exercisephase; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.exercisephase AS ENUM (
    'WARMUP',
    'MAIN',
    'COOLDOWN'
);


ALTER TYPE public.exercisephase OWNER TO admin;

--
-- Name: exercisetype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.exercisetype AS ENUM (
    'MULTIARTICULAR',
    'MONOARTICULAR'
);


ALTER TYPE public.exercisetype OWNER TO admin;

--
-- Name: experiencelevel; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.experiencelevel AS ENUM (
    'BEGINNER',
    'INTERMEDIATE',
    'ADVANCED'
);


ALTER TYPE public.experiencelevel OWNER TO admin;

--
-- Name: gender; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.gender AS ENUM (
    'MALE',
    'FEMALE',
    'OTHER',
    'PREFER_NOT_TO_SAY'
);


ALTER TYPE public.gender OWNER TO admin;

--
-- Name: intensitylevel; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.intensitylevel AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'DELOAD'
);


ALTER TYPE public.intensitylevel OWNER TO admin;

--
-- Name: mesocyclestatus; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.mesocyclestatus AS ENUM (
    'DRAFT',
    'ACTIVE',
    'COMPLETED',
    'ARCHIVED'
);


ALTER TYPE public.mesocyclestatus OWNER TO admin;

--
-- Name: metrictype; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.metrictype AS ENUM (
    'WEIGHT',
    'BODY_FAT',
    'CHEST',
    'WAIST',
    'HIPS',
    'ARMS',
    'THIGHS'
);


ALTER TYPE public.metrictype OWNER TO admin;

--
-- Name: primarygoal; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.primarygoal AS ENUM (
    'HYPERTROPHY',
    'STRENGTH',
    'POWER',
    'ENDURANCE',
    'FAT_LOSS',
    'GENERAL_FITNESS'
);


ALTER TYPE public.primarygoal OWNER TO admin;

--
-- Name: resistanceprofile; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.resistanceprofile AS ENUM (
    'ASCENDING',
    'DESCENDING',
    'FLAT',
    'BELL_SHAPED'
);


ALTER TYPE public.resistanceprofile OWNER TO admin;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.userrole AS ENUM (
    'ADMIN',
    'TRAINER',
    'CLIENT'
);


ALTER TYPE public.userrole OWNER TO admin;

--
-- Name: workout_status; Type: TYPE; Schema: public; Owner: admin
--

CREATE TYPE public.workout_status AS ENUM (
    'in_progress',
    'completed',
    'abandoned'
);


ALTER TYPE public.workout_status OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: client_interviews; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_interviews (
    id character varying NOT NULL,
    client_id character varying NOT NULL,
    age integer,
    gender public.gender,
    occupation character varying(200),
    weight_kg double precision,
    height_cm double precision,
    training_experience_months integer,
    experience_level public.experiencelevel,
    primary_goal public.primarygoal,
    target_muscle_groups character varying[],
    specific_goals_text text,
    days_per_week integer,
    session_duration_minutes integer,
    preferred_days integer[],
    has_gym_access boolean,
    available_equipment character varying[],
    equipment_notes text,
    injury_areas character varying[],
    injury_details text,
    excluded_exercises character varying[],
    medical_conditions character varying[],
    mobility_limitations text,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.client_interviews OWNER TO admin;

--
-- Name: client_metrics; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.client_metrics (
    id character varying NOT NULL,
    client_id character varying NOT NULL,
    metric_type public.metrictype NOT NULL,
    value double precision NOT NULL,
    unit character varying(20) NOT NULL,
    date date NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.client_metrics OWNER TO admin;

--
-- Name: day_exercises; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.day_exercises (
    id character varying NOT NULL,
    training_day_id character varying NOT NULL,
    exercise_id character varying NOT NULL,
    order_index integer NOT NULL,
    phase public.exercisephase NOT NULL,
    sets integer NOT NULL,
    reps_min integer,
    reps_max integer,
    rest_seconds integer NOT NULL,
    effort_type public.efforttype NOT NULL,
    effort_value double precision NOT NULL,
    tempo character varying,
    set_type character varying,
    duration_seconds integer,
    intensity_zone integer,
    distance_meters integer,
    target_calories integer,
    intervals integer,
    work_seconds integer,
    interval_rest_seconds integer,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.day_exercises OWNER TO admin;

--
-- Name: exercise_muscles; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.exercise_muscles (
    id character varying NOT NULL,
    exercise_id character varying NOT NULL,
    muscle_id character varying NOT NULL,
    muscle_role character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    CONSTRAINT ck_muscle_role CHECK (((muscle_role)::text = ANY ((ARRAY['primary'::character varying, 'secondary'::character varying])::text[])))
);


ALTER TABLE public.exercise_muscles OWNER TO admin;

--
-- Name: exercise_set_logs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.exercise_set_logs (
    id character varying(36) DEFAULT (public.uuid_generate_v4())::text NOT NULL,
    workout_log_id character varying(36) NOT NULL,
    day_exercise_id character varying(36) NOT NULL,
    set_number integer NOT NULL,
    reps_completed integer NOT NULL,
    weight_kg double precision,
    effort_value double precision,
    completed_at timestamp without time zone DEFAULT now() NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.exercise_set_logs OWNER TO admin;

--
-- Name: exercises; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.exercises (
    id character varying NOT NULL,
    type public.exercisetype NOT NULL,
    resistance_profile public.resistanceprofile NOT NULL,
    category character varying NOT NULL,
    video_url character varying,
    thumbnail_url character varying,
    image_url character varying,
    anatomy_image_url character varying,
    equipment_needed character varying,
    difficulty_level character varying,
    exercise_class public.exerciseclass NOT NULL,
    cardio_subclass public.cardiosubclass,
    intensity_zone integer,
    target_heart_rate_min integer,
    target_heart_rate_max integer,
    calories_per_minute double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name_en character varying NOT NULL,
    name_es character varying,
    description_en text,
    description_es text
);


ALTER TABLE public.exercises OWNER TO admin;

--
-- Name: macrocycles; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.macrocycles (
    id character varying NOT NULL,
    name character varying NOT NULL,
    description text,
    objective character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    status public.mesocyclestatus NOT NULL,
    trainer_id character varying NOT NULL,
    client_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.macrocycles OWNER TO admin;

--
-- Name: mesocycles; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.mesocycles (
    id character varying NOT NULL,
    macrocycle_id character varying NOT NULL,
    block_number integer NOT NULL,
    name character varying NOT NULL,
    description text,
    start_date date NOT NULL,
    end_date date NOT NULL,
    focus character varying,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.mesocycles OWNER TO admin;

--
-- Name: microcycles; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.microcycles (
    id character varying NOT NULL,
    mesocycle_id character varying NOT NULL,
    week_number integer NOT NULL,
    name character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    intensity_level public.intensitylevel NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.microcycles OWNER TO admin;

--
-- Name: muscles; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.muscles (
    id character varying NOT NULL,
    name character varying(50) NOT NULL,
    display_name_es character varying(100) NOT NULL,
    display_name_en character varying(100) NOT NULL,
    body_region character varying(50) NOT NULL,
    muscle_category character varying(50) NOT NULL,
    svg_ids character varying[],
    sort_order integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.muscles OWNER TO admin;

--
-- Name: training_days; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.training_days (
    id character varying NOT NULL,
    microcycle_id character varying NOT NULL,
    day_number integer NOT NULL,
    date date NOT NULL,
    name character varying NOT NULL,
    focus character varying,
    rest_day boolean NOT NULL,
    notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.training_days OWNER TO admin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.users (
    id character varying NOT NULL,
    email character varying NOT NULL,
    hashed_password character varying NOT NULL,
    full_name character varying NOT NULL,
    role public.userrole NOT NULL,
    preferred_language character varying(5) NOT NULL,
    is_active boolean NOT NULL,
    is_verified boolean NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_image_url character varying
);


ALTER TABLE public.users OWNER TO admin;

--
-- Name: COLUMN users.profile_image_url; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.users.profile_image_url IS 'URL of the user profile image stored in /static/profiles/';


--
-- Name: workout_logs; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.workout_logs (
    id character varying(36) DEFAULT (public.uuid_generate_v4())::text NOT NULL,
    client_id character varying(36) NOT NULL,
    training_day_id character varying(36) NOT NULL,
    started_at timestamp without time zone DEFAULT now() NOT NULL,
    completed_at timestamp without time zone,
    status public.workout_status DEFAULT 'in_progress'::public.workout_status NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    abandon_reason character varying(50),
    abandon_notes text,
    rescheduled_to_date date
);


ALTER TABLE public.workout_logs OWNER TO admin;

--
-- Name: COLUMN workout_logs.abandon_reason; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.workout_logs.abandon_reason IS 'Razón por la que se abandonó el entrenamiento';


--
-- Name: COLUMN workout_logs.abandon_notes; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.workout_logs.abandon_notes IS 'Notas adicionales sobre el abandono';


--
-- Name: COLUMN workout_logs.rescheduled_to_date; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.workout_logs.rescheduled_to_date IS 'Fecha a la que se reagendó el entrenamiento';


--
-- Data for Name: client_interviews; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_interviews (id, client_id, age, gender, occupation, weight_kg, height_cm, training_experience_months, experience_level, primary_goal, target_muscle_groups, specific_goals_text, days_per_week, session_duration_minutes, preferred_days, has_gym_access, available_equipment, equipment_notes, injury_areas, injury_details, excluded_exercises, medical_conditions, mobility_limitations, notes, created_at, updated_at) FROM stdin;
b25fd229-07d0-4646-b6b5-247b9705045c	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	24	FEMALE	\N	57	149	12	INTERMEDIATE	FAT_LOSS	{legs}	El objetivo del cliente es desarrollar al máximo sus glúteos sin descuidar otros grupos musculares mientras pierde grasa (recomposición corporal).	5	90	{1,2,3,4,5}	t	{bodyweight,barbell,dumbbells,machines,cables,bench,pull_up_bar,squat_rack}	Busca corregir postura cifótica.	{Ninguna}	\N	\N	{Ninguna}	\N	\N	2025-11-29 22:04:52.450615	2025-11-29 22:04:52.450617
4e0391c9-3b16-42ea-adb1-df719220dcc5	d9db0550-0b04-45cd-b3ed-92ecea0fe11c	42	MALE	\N	57	150	1	BEGINNER	FAT_LOSS	{legs}	aumentar gluteos.	5	90	{1,2,3,4,5,6}	t	{bodyweight,barbell,dumbbells,machines,cables,resistance_bands,pull_up_bar,bench,squat_rack}	\N	{Ninguna}	\N	\N	{Ninguna}	No	\N	2025-12-02 02:33:51.039412	2025-12-02 02:33:51.039414
a55d7d61-ca0a-4564-bd48-a371fd1a6874	231ed91b-0207-41e4-a741-3b396a84ef3e	27	MALE	\N	78.3	168	24	INTERMEDIATE	HYPERTROPHY	{}	Recomposición coorporal	4	120	{1,2,4,5}	t	{bodyweight,barbell,dumbbells,machines,cables,pull_up_bar,bench,squat_rack}	\N	{Ninguna}	\N	{No}	{no}	no	\N	2025-12-08 22:55:41.178771	2025-12-08 22:55:41.178772
\.


--
-- Data for Name: client_metrics; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.client_metrics (id, client_id, metric_type, value, unit, date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: day_exercises; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.day_exercises (id, training_day_id, exercise_id, order_index, phase, sets, reps_min, reps_max, rest_seconds, effort_type, effort_value, tempo, set_type, duration_seconds, intensity_zone, distance_meters, target_calories, intervals, work_seconds, interval_rest_seconds, notes, created_at, updated_at) FROM stdin;
827be324-d9b6-467a-99a0-27c60f927cde	550e8400-e29b-41d4-a716-446655441012	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	3	8	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-29 22:25:05.4634
504272f8-80be-4ae0-89a1-0de8b0ef61b2	550e8400-e29b-41d4-a716-446655441014	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	3	8	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-29 22:25:05.4634
2758c3d1-45e0-4ceb-ad42-b3f8383317b3	550e8400-e29b-41d4-a716-446655441021	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	3	8	12	120	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
b59c8024-d375-4f46-adaf-165bb215dd5b	550e8400-e29b-41d4-a716-446655441022	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	3	8	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
69640a60-7554-42f4-827a-4ae2aeaf76e0	550e8400-e29b-41d4-a716-446655441011	a65dc37c-13ad-448d-8ef7-a31d938c7ead	3	MAIN	3	8	10	120	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:24:26.821411	2025-11-30 00:52:37.379824
93e4bf46-cca7-4bf1-9d88-b14417efe406	550e8400-e29b-41d4-a716-446655441015	85a6425e-8ff0-40c2-b171-d6c404c9ee40	1	MAIN	3	8	10	90	RIR	3		\N	\N	\N	\N	\N	\N	\N	\N		2025-11-29 22:25:05.4634	2025-11-30 00:23:50.308086
15c4bafe-c96a-4f97-91cb-e96b7075d8e4	550e8400-e29b-41d4-a716-446655441015	6cd9c5f9-38db-401d-8099-b64a7e580c5f	3	MAIN	3	12	15	75	RIR	3		\N	\N	\N	\N	\N	\N	\N	\N		2025-11-29 22:25:05.4634	2025-11-30 00:27:10.895662
22bf015b-b238-4d76-bbf1-913d9d5aca68	550e8400-e29b-41d4-a716-446655441015	d483a4b4-9b78-4135-ae09-348de96db487	7	MAIN	3	30	60	45	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 00:22:19.68742
486ec97e-46d3-4c22-b4f0-b964707b4514	550e8400-e29b-41d4-a716-446655441014	2b384748-2af0-4941-88fe-2a589bd3aeb4	3	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 01:27:11.433559
399b5de8-65ae-4351-bc86-8c80d7df887c	550e8400-e29b-41d4-a716-446655441013	1dd47ff8-ab0e-4468-89b5-ef58218fb071	1	MAIN	3	6	8	150	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 00:53:05.365915
8186bc21-de91-46ac-b179-1eefa79aff61	550e8400-e29b-41d4-a716-446655441011	9538101e-512b-41a2-aec6-831b9f35780e	8	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:24:26.821411	2025-11-30 00:52:37.379825
6c619b2e-df0b-4a42-a5ab-2412bd9a6018	550e8400-e29b-41d4-a716-446655441013	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	8	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 00:44:48.999587
d053d9a9-b67e-420b-bbab-ddfcee7f35f2	550e8400-e29b-41d4-a716-446655441021	bcc75aab-390b-4e8d-be43-b76bf5ff3466	4	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:41.860047
d9f79424-4755-4c14-a9bf-d29853c00ae9	550e8400-e29b-41d4-a716-446655441021	a65dc37c-13ad-448d-8ef7-a31d938c7ead	2	MAIN	3	8	10	120	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:41.860049
199804a6-9c0f-440c-a9c1-f32bef635be8	550e8400-e29b-41d4-a716-446655441014	945a062b-0bfd-49b4-9bfc-3617fe1fad76	6	MAIN	3	15	20	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 01:27:11.433558
ede9afd9-6910-4445-914a-408d24ae5648	550e8400-e29b-41d4-a716-446655441012	945a062b-0bfd-49b4-9bfc-3617fe1fad76	6	MAIN	3	15	20	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-12-02 00:18:32.637524
6508cb6d-54f7-43b9-ac76-c81a95e7321f	550e8400-e29b-41d4-a716-446655441011	bcc75aab-390b-4e8d-be43-b76bf5ff3466	5	MAIN	3	10	12	90	RIR	3	standard	straight	\N	\N	\N	\N	\N	\N	\N	Adelantar el pie y  poner foco en la extensión de cadera.	2025-11-29 22:24:26.821411	2025-11-30 00:52:37.379824
fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	550e8400-e29b-41d4-a716-446655441012	45ffd819-86b1-4f9f-998c-d0707edb1b8c	4	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-12-02 00:18:32.637524
f03f34f8-4884-43e6-89d9-dbc9f8299836	550e8400-e29b-41d4-a716-446655441011	1da215b2-666a-4246-b7eb-f72c98de082d	7	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:24:26.821411	2025-11-30 00:52:37.379826
c2f74608-f52c-437c-bb5f-cd528ebee8cd	550e8400-e29b-41d4-a716-446655441013	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	7	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 00:53:05.365919
f73bb029-b02a-4b76-b3a8-2ec6d9ea0c71	550e8400-e29b-41d4-a716-446655441013	06ca48f5-bfcc-4ffa-964b-48eddafab389	3	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-11-30 00:53:05.365919
b04eb2a7-b4d7-4858-a9f2-4eed37c1091c	550e8400-e29b-41d4-a716-446655441013	4eafd2c5-8de8-422c-9f27-90289f970e16	5	MAIN	2	10	12	90	RIR	3	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-29 22:25:05.4634	2025-12-01 17:04:42.028331
e4a5abbe-3f57-4dc8-a2e8-c49ea7e52f3a	550e8400-e29b-41d4-a716-446655441021	1da215b2-666a-4246-b7eb-f72c98de082d	6	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:41.86005
fb06cc62-7dc1-4a3b-ac04-fbe5ce90106a	550e8400-e29b-41d4-a716-446655441021	9538101e-512b-41a2-aec6-831b9f35780e	7	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:41.860051
46235883-25df-4bf5-8ad3-0917db296d6f	550e8400-e29b-41d4-a716-446655441022	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	2	MAIN	4	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:37.193941
9e3cc58c-3205-4507-964b-8d88c0133514	550e8400-e29b-41d4-a716-446655441022	45ffd819-86b1-4f9f-998c-d0707edb1b8c	1	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:37.196334
a97e41fe-ffd7-4f13-b90b-5bf49b94a590	550e8400-e29b-41d4-a716-446655441022	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	0	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:37.196334
8df310c5-b4c0-473e-a95b-1a0fef40f303	550e8400-e29b-41d4-a716-446655441011	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	3	8	12	120	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-29 22:24:26.821411	2025-12-02 00:18:26.000396
2d8c6528-9b95-46c9-8380-b4026ef9227a	550e8400-e29b-41d4-a716-446655441012	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	7	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:05.4634	2025-12-02 00:18:32.637514
a824a1c4-581d-4439-b375-81bd4db8b12f	550e8400-e29b-41d4-a716-446655441023	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	3	6	8	150	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
16da441e-1b72-4940-9441-203178a42891	550e8400-e29b-41d4-a716-446655441024	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	3	8	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
7b360246-e137-4f87-9613-be330b99c60a	550e8400-e29b-41d4-a716-446655441025	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	3	12	15	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
e11ccf09-8527-4013-a27c-d170f3067a6a	550e8400-e29b-41d4-a716-446655441025	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	3	12	15	75	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
85a5b54d-ccef-4fe3-bc37-5cc249299720	550e8400-e29b-41d4-a716-446655441025	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	3	10	12	75	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
7d4feedf-033d-472f-b2c9-3c00f12449dc	550e8400-e29b-41d4-a716-446655441025	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	3	8	10	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
682d9904-9835-49da-b95a-f16e3e326d4e	550e8400-e29b-41d4-a716-446655441025	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	3	30	60	45	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
5dbb1f39-6390-4187-99dd-90e1d96f47f4	550e8400-e29b-41d4-a716-446655441025	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	3	15	20	45	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-11-29 22:25:52.255524
adda031d-e946-472d-9115-f53a937732bc	550e8400-e29b-41d4-a716-446655441031	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	4	8	12	120	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
49389fe4-6485-439f-a396-f8556ddfacba	550e8400-e29b-41d4-a716-446655441031	a65dc37c-13ad-448d-8ef7-a31d938c7ead	1	MAIN	4	8	10	120	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
4c56773c-237e-43f4-93c8-df244cff8053	550e8400-e29b-41d4-a716-446655441031	bcc75aab-390b-4e8d-be43-b76bf5ff3466	2	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
e23eaf92-dea8-4fb9-b10d-1532b6caff98	550e8400-e29b-41d4-a716-446655441031	1da215b2-666a-4246-b7eb-f72c98de082d	3	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
3e110723-9d12-4b63-a841-ca98b6653fa7	550e8400-e29b-41d4-a716-446655441031	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
8d2fb2cb-8254-4972-8274-a3c5b6a7a671	550e8400-e29b-41d4-a716-446655441031	9538101e-512b-41a2-aec6-831b9f35780e	5	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
4bb732e2-f07f-4be6-ae24-42943fd433e3	550e8400-e29b-41d4-a716-446655441032	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	4	8	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
00df0b92-7e12-406d-90d9-bf9a8306c240	550e8400-e29b-41d4-a716-446655441032	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
f1dfdd45-bd60-453e-b898-1456f365060b	550e8400-e29b-41d4-a716-446655441032	45ffd819-86b1-4f9f-998c-d0707edb1b8c	2	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
27c50814-3b10-469b-b60b-2b52521b4eda	550e8400-e29b-41d4-a716-446655441032	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	5	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
19fea6d5-1bc9-4bf5-8a42-8b04b2c80965	550e8400-e29b-41d4-a716-446655441032	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	4	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
47453fe0-815b-4590-a5a9-51d676136189	550e8400-e29b-41d4-a716-446655441032	e08d2b37-cdf9-4285-8307-6d4a2a60492b	5	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
ec1f2e9a-3ae4-40cb-b0a1-bf8b3fb697e5	550e8400-e29b-41d4-a716-446655441033	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	4	6	8	150	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
df5b9fc1-b6b3-4ad7-a2d7-1281509e9f7d	550e8400-e29b-41d4-a716-446655441033	06ca48f5-bfcc-4ffa-964b-48eddafab389	1	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
f79613b9-c4a0-443b-89eb-c2e194ce31d4	550e8400-e29b-41d4-a716-446655441033	4eafd2c5-8de8-422c-9f27-90289f970e16	2	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
a484fa54-8be9-4885-822c-2b86c8350114	550e8400-e29b-41d4-a716-446655441033	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	3	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
42020e3b-984b-4b23-9330-a078fc008cf1	550e8400-e29b-41d4-a716-446655441033	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	4	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
66da3619-0a24-4b58-9133-dc782e7ee976	550e8400-e29b-41d4-a716-446655441033	1da215b2-666a-4246-b7eb-f72c98de082d	5	MAIN	4	15	20	45	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
2010e4e8-99ec-4c59-8fba-038a7edcc138	550e8400-e29b-41d4-a716-446655441034	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	4	8	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
c752f882-a301-44d4-b3a6-e52e9663ffef	550e8400-e29b-41d4-a716-446655441034	2b384748-2af0-4941-88fe-2a589bd3aeb4	1	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
0652b3b3-f6e6-4eb3-beab-8151098a390b	550e8400-e29b-41d4-a716-446655441023	4eafd2c5-8de8-422c-9f27-90289f970e16	4	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:23:45.01466
2fa82bde-08b1-4c76-b00c-5f61457d3477	550e8400-e29b-41d4-a716-446655441023	06ca48f5-bfcc-4ffa-964b-48eddafab389	2	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:23:45.01466
6ce511d0-9c77-47f9-be31-1f6d56fb992f	550e8400-e29b-41d4-a716-446655441022	e08d2b37-cdf9-4285-8307-6d4a2a60492b	4	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:37.196332
e3fdb318-76b8-41ab-b6c5-03cc9a7521c8	550e8400-e29b-41d4-a716-446655441023	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	6	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:23:45.014662
5ae2755d-4b44-4455-b544-6c69cf2cd044	550e8400-e29b-41d4-a716-446655441023	1da215b2-666a-4246-b7eb-f72c98de082d	7	MAIN	3	15	20	45	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:24:16.383252
6d630a81-4df4-4b16-b251-0283d425356d	550e8400-e29b-41d4-a716-446655441022	945a062b-0bfd-49b4-9bfc-3617fe1fad76	3	MAIN	3	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:25:37.196334
6a08dcd1-10e4-4e11-9037-8fecc264ae4d	550e8400-e29b-41d4-a716-446655441034	a7e34918-49a4-47ef-aeba-69c4fb324fe8	2	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
5113ecfc-9bf0-44ea-9420-ce2dc235e122	550e8400-e29b-41d4-a716-446655441034	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	5	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
f9370af4-49a4-4beb-9c7d-2e1f350f3541	550e8400-e29b-41d4-a716-446655441034	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	4	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
6a7e3702-6bd7-4d0d-b39f-dd3baf0c5496	550e8400-e29b-41d4-a716-446655441034	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	5	MAIN	4	10	12	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
fcba6ae7-72b0-46a7-8613-7a8a14a1887a	550e8400-e29b-41d4-a716-446655441035	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	4	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
63434447-9239-47ca-a9bb-d9614dbb7fe1	550e8400-e29b-41d4-a716-446655441035	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	4	12	15	75	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
6950bdcb-a57f-4a65-bf12-9f4f484745fa	550e8400-e29b-41d4-a716-446655441035	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	4	10	12	75	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
039b28fd-b343-4fc3-93fa-67e64fb9cf83	550e8400-e29b-41d4-a716-446655441035	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	4	8	10	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
869895e3-5a2c-4178-acc6-ada48c7ea215	550e8400-e29b-41d4-a716-446655441035	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	4	30	60	45	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
e7e62537-09c4-43f9-894b-076bb9730aeb	550e8400-e29b-41d4-a716-446655441035	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	4	15	20	45	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
53e328a3-8d07-4aa2-8dd2-e869828ed23d	550e8400-e29b-41d4-a716-446655441041	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	2	8	12	120	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
9782179a-139e-4890-b4fa-be7e6cfdf327	550e8400-e29b-41d4-a716-446655441041	a65dc37c-13ad-448d-8ef7-a31d938c7ead	1	MAIN	2	8	10	120	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
e4223737-5d2e-497c-a9a4-46f4b7989fe5	550e8400-e29b-41d4-a716-446655441041	bcc75aab-390b-4e8d-be43-b76bf5ff3466	2	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
5e30d921-31d7-46ce-a84d-8f8b386b215c	550e8400-e29b-41d4-a716-446655441041	1da215b2-666a-4246-b7eb-f72c98de082d	3	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
1bdc0cec-c0ea-482e-a10c-5d3f22b42012	550e8400-e29b-41d4-a716-446655441041	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
560a94b9-09ab-4f72-839c-08ca3d0b86da	550e8400-e29b-41d4-a716-446655441041	9538101e-512b-41a2-aec6-831b9f35780e	5	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
3ac1935b-b634-4ce8-86a3-945da44775f6	550e8400-e29b-41d4-a716-446655441042	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	2	8	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
b19c4753-808d-4e58-b80d-d63685a9578e	550e8400-e29b-41d4-a716-446655441042	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
6b518d40-08c0-4716-8eb8-2090ba6cebc8	550e8400-e29b-41d4-a716-446655441042	45ffd819-86b1-4f9f-998c-d0707edb1b8c	2	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
b6a6a0f1-819a-4c3a-9ae7-add90eddf91d	550e8400-e29b-41d4-a716-446655441042	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	3	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
57fb7a4f-065f-4db5-80d8-bcda4495003a	550e8400-e29b-41d4-a716-446655441042	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	2	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
a5fc02a7-fe9e-4034-b405-02a1c4f47a57	550e8400-e29b-41d4-a716-446655441042	e08d2b37-cdf9-4285-8307-6d4a2a60492b	5	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
2fdd5c15-9046-4ccc-b7f5-969e625c9152	550e8400-e29b-41d4-a716-446655441043	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	2	6	8	150	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
673935e7-05a2-4b2c-8dda-68c543df11a2	550e8400-e29b-41d4-a716-446655441043	06ca48f5-bfcc-4ffa-964b-48eddafab389	1	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
e4b4953c-e683-4a6c-9742-aaa8b7f20306	550e8400-e29b-41d4-a716-446655441043	4eafd2c5-8de8-422c-9f27-90289f970e16	2	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
6529dd55-4b89-4fa4-bbe3-21bcc8425b8a	550e8400-e29b-41d4-a716-446655441043	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	3	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
09334424-4413-47f5-b5c4-c1ea9b16a838	550e8400-e29b-41d4-a716-446655441043	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	4	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
2d97a100-7dd4-4f6a-a75e-8fb1e5c57560	550e8400-e29b-41d4-a716-446655441043	1da215b2-666a-4246-b7eb-f72c98de082d	5	MAIN	2	15	20	45	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
390c7372-b290-41ad-89c6-1c87789e0416	550e8400-e29b-41d4-a716-446655441044	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	2	8	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
6c59be76-55b4-4894-a890-c65b3bf7275a	550e8400-e29b-41d4-a716-446655441044	2b384748-2af0-4941-88fe-2a589bd3aeb4	1	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
f137e812-c449-4a69-b01d-7949772b056b	550e8400-e29b-41d4-a716-446655441044	a7e34918-49a4-47ef-aeba-69c4fb324fe8	2	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
72478ab1-41ac-449e-8a87-8857d1626039	550e8400-e29b-41d4-a716-446655441044	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	3	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
cb1d3690-7e38-48fa-a95b-39b35f357d01	550e8400-e29b-41d4-a716-446655441044	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	2	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
491a8e21-5ada-4602-8426-8f49775a43af	550e8400-e29b-41d4-a716-446655441044	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	5	MAIN	2	10	12	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
2397181f-ab6c-4f59-8f16-5318fe445130	550e8400-e29b-41d4-a716-446655441045	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	2	12	15	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
c3bf4bcb-3ffb-4a70-ac40-b040fa036bf8	550e8400-e29b-41d4-a716-446655441045	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	2	12	15	75	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
bce0d3e5-f960-4ff6-9db4-6c0d29c6ac06	550e8400-e29b-41d4-a716-446655441045	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	2	10	12	75	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
89191356-e921-481a-85f2-42b46f3a1013	550e8400-e29b-41d4-a716-446655441045	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	2	8	10	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
cc1438c5-fbe1-4ad2-9273-6fa8a69dcd19	550e8400-e29b-41d4-a716-446655441045	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	2	30	60	45	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
33b20ae0-a0e6-4fe0-bf4a-be89773edc25	550e8400-e29b-41d4-a716-446655441045	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	2	15	20	45	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:05.510649	2025-11-29 22:26:05.510649
09cf2928-c005-4296-a343-d3ec63e651c5	550e8400-e29b-41d4-a716-446655441051	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	3	8	12	120	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
69f3bb57-960f-418d-86d4-89ddcce6c333	550e8400-e29b-41d4-a716-446655441051	a65dc37c-13ad-448d-8ef7-a31d938c7ead	1	MAIN	3	8	10	120	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
9ce5f839-53b6-4df8-a789-a3cb75401253	550e8400-e29b-41d4-a716-446655441051	bcc75aab-390b-4e8d-be43-b76bf5ff3466	2	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
250a1490-f91c-4e08-85a0-0622f9e0f722	550e8400-e29b-41d4-a716-446655441051	1da215b2-666a-4246-b7eb-f72c98de082d	3	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
7d3212cf-a993-461a-ac8c-186785621093	550e8400-e29b-41d4-a716-446655441051	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
7cd0c0fb-3a21-4adf-8c36-ec2a1b3cc73b	550e8400-e29b-41d4-a716-446655441051	9538101e-512b-41a2-aec6-831b9f35780e	5	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
f53d397d-1418-4492-acde-2a56bd157a68	550e8400-e29b-41d4-a716-446655441052	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	3	8	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
5caac705-1b21-4e7d-b5cb-74972e175b4f	550e8400-e29b-41d4-a716-446655441052	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
1c80e583-37e7-477a-b673-b6d90c780ca4	550e8400-e29b-41d4-a716-446655441052	45ffd819-86b1-4f9f-998c-d0707edb1b8c	2	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
556a6a22-9153-45d1-9dc8-2f6e8a5421f7	550e8400-e29b-41d4-a716-446655441052	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	4	15	20	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
6722854c-62b0-4db3-b032-015d209c0f17	550e8400-e29b-41d4-a716-446655441052	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	3	15	20	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
9326cecc-cf64-4f9e-9657-32a70dd4cb51	550e8400-e29b-41d4-a716-446655441052	e08d2b37-cdf9-4285-8307-6d4a2a60492b	5	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
8ea1940a-bfb5-4cbb-9c6e-d276a7283e27	550e8400-e29b-41d4-a716-446655441053	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	3	6	8	150	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
c719df6e-dbe3-4188-b0c2-8ce5b1546296	550e8400-e29b-41d4-a716-446655441053	06ca48f5-bfcc-4ffa-964b-48eddafab389	1	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
eb5cbcfd-4a6a-44d4-bb32-d41411726b63	550e8400-e29b-41d4-a716-446655441053	4eafd2c5-8de8-422c-9f27-90289f970e16	2	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
39e21987-91f9-4e9f-9698-1f31d8df1b59	550e8400-e29b-41d4-a716-446655441053	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	3	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
a1315ff3-5b9a-4bda-b034-37fe4caa3693	550e8400-e29b-41d4-a716-446655441053	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	4	MAIN	3	12	15	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
2e769621-ecda-4248-ad13-5eaff3788679	550e8400-e29b-41d4-a716-446655441053	1da215b2-666a-4246-b7eb-f72c98de082d	5	MAIN	3	15	20	45	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
967a5ca1-d6e4-4fb2-9e36-c997296225d6	550e8400-e29b-41d4-a716-446655441054	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	3	8	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
1207fdf7-1799-4315-8d8b-0d1ea533d1dd	550e8400-e29b-41d4-a716-446655441054	2b384748-2af0-4941-88fe-2a589bd3aeb4	1	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
7edd0d4b-f760-45f3-924d-afa6b7be3a5b	550e8400-e29b-41d4-a716-446655441054	a7e34918-49a4-47ef-aeba-69c4fb324fe8	2	MAIN	3	10	12	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
d84b556e-d05d-4734-8ccc-9f9b529faee0	550e8400-e29b-41d4-a716-446655441054	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	4	15	20	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
cf388006-3b76-4acb-838e-3fe20767dcf8	550e8400-e29b-41d4-a716-446655441054	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	3	15	20	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
22830cb0-5d30-4da5-a451-f6ad3266e783	550e8400-e29b-41d4-a716-446655441054	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	5	MAIN	3	10	12	60	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
62dbd4fe-998b-4796-8c65-7d269f4814c4	550e8400-e29b-41d4-a716-446655441055	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	3	12	15	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
216f0c84-8090-4319-b5b5-f96e86e2cbaf	550e8400-e29b-41d4-a716-446655441055	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	3	12	15	75	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
5d79c4aa-d782-49fa-91b0-c0d01d3d453f	550e8400-e29b-41d4-a716-446655441055	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	3	10	12	75	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
d8d91a7f-56af-4c4e-99d4-593a0d917069	550e8400-e29b-41d4-a716-446655441055	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	3	8	10	90	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
7cf4c2be-fd21-487e-88c8-891d35943352	550e8400-e29b-41d4-a716-446655441055	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	3	30	60	45	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
36348a2c-7f9c-4b71-8efe-549b307b71df	550e8400-e29b-41d4-a716-446655441055	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	3	15	20	45	RIR	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
7fe0a99d-e06e-4e0a-a38e-489974a1e5c8	550e8400-e29b-41d4-a716-446655441061	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	3	8	12	120	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
25409a3f-7764-4062-99b5-3f198c67fd8e	550e8400-e29b-41d4-a716-446655441061	a65dc37c-13ad-448d-8ef7-a31d938c7ead	1	MAIN	3	8	10	120	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
42854e98-c823-44bb-b0da-55ed8af3cf6e	550e8400-e29b-41d4-a716-446655441061	bcc75aab-390b-4e8d-be43-b76bf5ff3466	2	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
d49e8745-c133-4487-80ff-47f368d06076	550e8400-e29b-41d4-a716-446655441061	1da215b2-666a-4246-b7eb-f72c98de082d	3	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
09a48b03-f498-4294-a640-7779460f3bb1	550e8400-e29b-41d4-a716-446655441061	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
9e7f13c9-3d8f-43cd-b857-eb0e55390367	550e8400-e29b-41d4-a716-446655441061	9538101e-512b-41a2-aec6-831b9f35780e	5	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
1d506329-5d07-4334-aa57-228829eb1dd4	550e8400-e29b-41d4-a716-446655441062	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	3	8	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
4636acd2-9a58-462e-a6f7-b0bad5bec900	550e8400-e29b-41d4-a716-446655441062	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
8ce80ae5-f50e-4bba-b1c7-e260ba96345c	550e8400-e29b-41d4-a716-446655441062	45ffd819-86b1-4f9f-998c-d0707edb1b8c	2	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
8bb7f946-0396-4095-a7a8-c0de1ebb3080	550e8400-e29b-41d4-a716-446655441062	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	4	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
76710c90-bedc-4782-b5ed-41f85346ef89	550e8400-e29b-41d4-a716-446655441062	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	3	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e16ab7ad-e117-43bc-afc6-836311aadbe1	550e8400-e29b-41d4-a716-446655441062	e08d2b37-cdf9-4285-8307-6d4a2a60492b	5	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
34ae674c-fbba-42e4-9e5f-f806b3e350b6	550e8400-e29b-41d4-a716-446655441063	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	3	6	8	150	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
f2f6b455-b2b2-4e59-94cb-234558d4fa1a	550e8400-e29b-41d4-a716-446655441063	06ca48f5-bfcc-4ffa-964b-48eddafab389	1	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
b0f015d7-1bf3-42cc-9018-f6ce5e65089b	550e8400-e29b-41d4-a716-446655441063	4eafd2c5-8de8-422c-9f27-90289f970e16	2	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
365492e0-0545-4886-b6d9-bcc9d831774d	550e8400-e29b-41d4-a716-446655441063	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	3	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
8d112015-3e1d-4f31-b396-c776ceace514	550e8400-e29b-41d4-a716-446655441063	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	4	MAIN	3	12	15	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
852035a4-a30b-4963-a63c-22ad0dadc21d	550e8400-e29b-41d4-a716-446655441063	1da215b2-666a-4246-b7eb-f72c98de082d	5	MAIN	3	15	20	45	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
c311fc05-f76e-4c90-862f-491ebafc7857	550e8400-e29b-41d4-a716-446655441064	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	3	8	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
a12bc364-3a46-4c8e-b6a7-99d5f8ddead3	550e8400-e29b-41d4-a716-446655441064	2b384748-2af0-4941-88fe-2a589bd3aeb4	1	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
909ccd09-46d8-4f23-a46c-05cb5c4fc977	550e8400-e29b-41d4-a716-446655441064	a7e34918-49a4-47ef-aeba-69c4fb324fe8	2	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
69873d5e-b49c-4cef-90a7-b330ebbbeb32	550e8400-e29b-41d4-a716-446655441064	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	4	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
ac3cf22b-972f-4720-981d-703949125081	550e8400-e29b-41d4-a716-446655441064	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	3	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
b3e3a8bd-b9bd-4ce4-a983-40f802a35859	550e8400-e29b-41d4-a716-446655441064	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	5	MAIN	3	10	12	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
c6c6d9aa-441d-49e2-9e50-b6b5456e54d1	550e8400-e29b-41d4-a716-446655441065	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	3	12	15	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
a7e2ae88-9ae9-4d28-8f9b-fe0d865a22e0	550e8400-e29b-41d4-a716-446655441065	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	3	12	15	75	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e4dc65b4-b135-4b22-9b0e-e81765bbb7c8	550e8400-e29b-41d4-a716-446655441065	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	3	10	12	75	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
6d923796-a4d1-4bfe-958e-1c5421168b33	550e8400-e29b-41d4-a716-446655441065	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	3	8	10	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
f2f74270-3ab8-44aa-869a-8d2734357ffb	550e8400-e29b-41d4-a716-446655441065	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	3	30	60	45	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
516030e5-c7ec-44a2-aafe-40aac6e8c7b4	550e8400-e29b-41d4-a716-446655441065	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	3	15	20	45	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
1a233e62-4339-4b70-8949-cdc4c29b0733	550e8400-e29b-41d4-a716-446655441071	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	4	8	12	120	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e3300666-6ff8-4548-9cfb-5e8d828085d1	550e8400-e29b-41d4-a716-446655441071	a65dc37c-13ad-448d-8ef7-a31d938c7ead	1	MAIN	4	8	10	120	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
80ecd7f5-43cf-4a56-ab88-2b175c6fa9fe	550e8400-e29b-41d4-a716-446655441071	bcc75aab-390b-4e8d-be43-b76bf5ff3466	2	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
cb4cb830-aede-4781-9eb8-45760bdf89b1	550e8400-e29b-41d4-a716-446655441071	1da215b2-666a-4246-b7eb-f72c98de082d	3	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e6c78438-2b3a-4879-885f-4ebc557005c3	550e8400-e29b-41d4-a716-446655441071	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
133e868d-bf54-44ef-b527-6839df6ca432	550e8400-e29b-41d4-a716-446655441071	9538101e-512b-41a2-aec6-831b9f35780e	5	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
0b4b6a2d-3347-4bb0-bc8c-46d8a32c86e2	550e8400-e29b-41d4-a716-446655441072	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	4	8	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
a1819a50-43ee-4af2-92b3-66cf265b2eea	550e8400-e29b-41d4-a716-446655441072	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
fbfa38dc-0c53-46fb-89c7-dbacaa31bdd1	550e8400-e29b-41d4-a716-446655441072	45ffd819-86b1-4f9f-998c-d0707edb1b8c	2	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
6a1608fd-f1ef-46b9-824f-403109bea5cf	550e8400-e29b-41d4-a716-446655441072	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	5	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
7e372b6e-5a22-4998-9cfd-28707310e40b	550e8400-e29b-41d4-a716-446655441072	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	4	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
b8a201b5-fe97-4e5b-9f01-5f4269cc5d0d	550e8400-e29b-41d4-a716-446655441072	e08d2b37-cdf9-4285-8307-6d4a2a60492b	5	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e3076c98-9c32-4fd7-8ace-e39f4618cb7e	550e8400-e29b-41d4-a716-446655441073	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	4	6	8	150	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
9c7fe09c-ff7c-4bc2-b9ab-477f4e8c1daf	550e8400-e29b-41d4-a716-446655441073	06ca48f5-bfcc-4ffa-964b-48eddafab389	1	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
275920ff-51a2-48e5-a0cd-d14b229c0e0f	550e8400-e29b-41d4-a716-446655441073	4eafd2c5-8de8-422c-9f27-90289f970e16	2	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
f13b3c49-9729-4553-8603-00f31ce1e67b	550e8400-e29b-41d4-a716-446655441073	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	3	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
d1b3068e-4ce4-4b50-b0ce-d731b5cb07a0	550e8400-e29b-41d4-a716-446655441073	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	4	MAIN	4	12	15	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
65778636-a9ad-4779-9b23-f50b9e7e38cf	550e8400-e29b-41d4-a716-446655441073	1da215b2-666a-4246-b7eb-f72c98de082d	5	MAIN	4	15	20	45	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
cb3a1743-5b9e-4501-98b5-fada866074c1	550e8400-e29b-41d4-a716-446655441074	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	4	8	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
a5bfaddb-0b9a-49e1-a033-09994307ca88	550e8400-e29b-41d4-a716-446655441074	2b384748-2af0-4941-88fe-2a589bd3aeb4	1	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
538449bc-43a9-44e7-beb4-b7e55601140b	550e8400-e29b-41d4-a716-446655441074	a7e34918-49a4-47ef-aeba-69c4fb324fe8	2	MAIN	4	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
63fbc194-fa73-4629-8da9-5308ba0b8463	550e8400-e29b-41d4-a716-446655441074	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	5	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
929fac5c-198d-4358-bb15-6006b8bffea6	550e8400-e29b-41d4-a716-446655441074	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	4	15	20	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
82bda61d-894a-492b-a63d-2dea58d2024c	550e8400-e29b-41d4-a716-446655441074	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	5	MAIN	4	10	12	60	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
50cd79d4-b57c-4b1c-9aa0-af0ff23af762	550e8400-e29b-41d4-a716-446655441075	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	4	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
8918a859-c5d7-442c-9aa2-ccbc677c1c0a	550e8400-e29b-41d4-a716-446655441075	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	4	12	15	75	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
414795ea-e2ef-4c0f-b52b-7ddd399c44de	550e8400-e29b-41d4-a716-446655441075	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	4	10	12	75	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
473b81e1-1377-4159-9a01-ebe89044e6b4	550e8400-e29b-41d4-a716-446655441075	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	4	8	10	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
2182394b-8bdf-4492-93b3-9f232beddc1b	550e8400-e29b-41d4-a716-446655441075	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	4	30	60	45	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
89f59571-67ec-46c0-82b1-9b63f75b376a	550e8400-e29b-41d4-a716-446655441075	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	4	15	20	45	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
efcd8cbf-4be3-4f21-b27c-3768dff91592	550e8400-e29b-41d4-a716-446655441081	43a9b1fe-8f85-4126-8690-e55410aa022c	0	MAIN	2	8	12	120	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
a00eed33-eae3-4c95-96a1-8a396270c0fe	550e8400-e29b-41d4-a716-446655441081	a65dc37c-13ad-448d-8ef7-a31d938c7ead	1	MAIN	2	8	10	120	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
ad33d5b8-37ed-48a6-8d76-64a97eff5c0a	550e8400-e29b-41d4-a716-446655441081	bcc75aab-390b-4e8d-be43-b76bf5ff3466	2	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
448a9651-3558-4a04-9d2a-b56d8c7a26b8	550e8400-e29b-41d4-a716-446655441081	1da215b2-666a-4246-b7eb-f72c98de082d	3	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
ebb8e9ff-413e-4c30-98c7-111028a56fcb	550e8400-e29b-41d4-a716-446655441081	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
8c745a0d-c750-4ed4-89dc-2ef5c05ed252	550e8400-e29b-41d4-a716-446655441081	9538101e-512b-41a2-aec6-831b9f35780e	5	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
fd16ff37-d02e-46b0-a1d2-5b6ac842c0ac	550e8400-e29b-41d4-a716-446655441082	18d50e17-4bce-4d39-8071-c93d969b7696	0	MAIN	2	8	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e8925a71-1b21-4c14-9ab4-b8cec351f4d0	550e8400-e29b-41d4-a716-446655441082	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
e3ad510e-ab5b-438e-b8bf-45713c676cd1	550e8400-e29b-41d4-a716-446655441082	45ffd819-86b1-4f9f-998c-d0707edb1b8c	2	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
840940cf-e753-475d-8275-865cb676fddc	550e8400-e29b-41d4-a716-446655441082	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	3	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
59978177-fae4-4bae-8873-d482c055c010	550e8400-e29b-41d4-a716-446655441082	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	2	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
f564733e-3b4b-45af-af4d-f05e49e22f22	550e8400-e29b-41d4-a716-446655441082	e08d2b37-cdf9-4285-8307-6d4a2a60492b	5	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
5484a82e-4d9d-46aa-9f5f-7f1a70e82251	550e8400-e29b-41d4-a716-446655441083	1dd47ff8-ab0e-4468-89b5-ef58218fb071	0	MAIN	2	6	8	150	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
24e0ca41-4fb8-4441-8d9f-7ed10960aefc	550e8400-e29b-41d4-a716-446655441083	06ca48f5-bfcc-4ffa-964b-48eddafab389	1	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
210fb9ca-377a-48cb-b673-9a4a2ff0417e	550e8400-e29b-41d4-a716-446655441083	4eafd2c5-8de8-422c-9f27-90289f970e16	2	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
30cd7901-c541-4f85-804d-038acba06fc4	550e8400-e29b-41d4-a716-446655441083	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	3	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
eb359de4-4f48-4c8e-8bd7-28699d1fa120	550e8400-e29b-41d4-a716-446655441083	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	4	MAIN	2	12	15	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
4beee1e7-f1f6-417c-aa43-79dcde8024cb	550e8400-e29b-41d4-a716-446655441083	1da215b2-666a-4246-b7eb-f72c98de082d	5	MAIN	2	15	20	45	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
64754311-2bad-41e1-ae49-7cd98657867f	550e8400-e29b-41d4-a716-446655441084	490a8870-e9f7-4a54-8444-6679403cd12c	0	MAIN	2	8	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
564fa29b-38f2-4740-9433-6323d62a27d7	550e8400-e29b-41d4-a716-446655441084	2b384748-2af0-4941-88fe-2a589bd3aeb4	1	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
641060d3-d6fd-4c12-bebc-efc6d0313c11	550e8400-e29b-41d4-a716-446655441084	a7e34918-49a4-47ef-aeba-69c4fb324fe8	2	MAIN	2	10	12	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
b4bdff6d-b2fe-4ed0-8af7-d69c115c6dba	550e8400-e29b-41d4-a716-446655441084	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	3	MAIN	3	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
44edde9a-8b7f-4fca-965f-e081795a5b9f	550e8400-e29b-41d4-a716-446655441084	945a062b-0bfd-49b4-9bfc-3617fe1fad76	4	MAIN	2	15	20	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
657bd02c-1c9f-42c0-bce3-212fbf4d47d1	550e8400-e29b-41d4-a716-446655441084	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	5	MAIN	2	10	12	60	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
9e0f33b3-85e9-4aac-b8a4-1db69ec34523	550e8400-e29b-41d4-a716-446655441085	ac7717a4-4e37-4cc2-9050-b4185af9c34c	0	MAIN	2	12	15	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
f44c6558-0519-4cbf-9845-fdab01ff293a	550e8400-e29b-41d4-a716-446655441085	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	2	12	15	75	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
34bb479b-735b-455f-b09f-1c7ae4543d26	550e8400-e29b-41d4-a716-446655441085	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	2	10	12	75	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
4b216495-0eea-42a3-8f43-56a0057a5545	550e8400-e29b-41d4-a716-446655441085	85a6425e-8ff0-40c2-b171-d6c404c9ee40	3	MAIN	2	8	10	90	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
138f6073-beb8-43db-aba0-98abeac60ebf	550e8400-e29b-41d4-a716-446655441085	d483a4b4-9b78-4135-ae09-348de96db487	4	MAIN	2	30	60	45	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
06509f75-b0c8-4227-b580-d9b530dabf6b	550e8400-e29b-41d4-a716-446655441085	cdaa6012-b647-4168-aadc-58c1d033b3bb	5	MAIN	2	15	20	45	RIR	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:26:26.167964	2025-11-29 22:26:26.167964
2b46f034-dae4-4443-88aa-fc6a6e5d5b7e	550e8400-e29b-41d4-a716-446655441033	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
934295cc-3b19-4a73-96c4-8f9c015aee92	550e8400-e29b-41d4-a716-446655441031	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
a02a2978-d4b9-4d2f-9950-f8221263242d	550e8400-e29b-41d4-a716-446655441043	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
ab76308e-cf5c-46b0-b3de-2f1d866e5aed	550e8400-e29b-41d4-a716-446655441041	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
48e7cb05-8cc2-4e29-8809-0c082d02a445	550e8400-e29b-41d4-a716-446655441053	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
48baf5a1-59ac-4e4d-8a93-67e197926d62	550e8400-e29b-41d4-a716-446655441051	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
12896f9e-daf2-4385-8b32-4cb9f44ab593	550e8400-e29b-41d4-a716-446655441063	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
b4a3389a-1f7a-481e-83e8-3c1907ecbc96	550e8400-e29b-41d4-a716-446655441061	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
302e9642-8076-47a8-aed9-07f1b597c712	550e8400-e29b-41d4-a716-446655441073	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
9be51595-8ca1-4904-b444-f98cb53a0dfc	550e8400-e29b-41d4-a716-446655441071	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
d4b701a9-7a4c-4bd2-b39b-7298b3566a0c	550e8400-e29b-41d4-a716-446655441083	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
c21faf79-faa4-4368-87aa-2b91d5d24a87	550e8400-e29b-41d4-a716-446655441081	f89614fb-f6ed-4733-877f-e357906c4925	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
667124e2-e796-4206-88b5-7ae23c2e8824	550e8400-e29b-41d4-a716-446655441033	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
dd824777-3b15-4a69-864b-5342772481e3	550e8400-e29b-41d4-a716-446655441031	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
f7a2c22a-da24-4125-91ce-c9e2a93eee21	550e8400-e29b-41d4-a716-446655441043	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
e545c959-529c-4b78-a54a-0eee02b50f65	550e8400-e29b-41d4-a716-446655441041	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
4cfae30c-94db-4ee0-87d9-c517eab1ed73	550e8400-e29b-41d4-a716-446655441053	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
a3f7bc58-afc0-4160-a81c-854f61af9a0a	550e8400-e29b-41d4-a716-446655441051	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
8133b270-0787-417e-80d5-75939c4eb7b4	550e8400-e29b-41d4-a716-446655441063	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
1a34d685-4e6a-4131-bd85-36f571cc2a1d	550e8400-e29b-41d4-a716-446655441061	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
5f97b915-550a-462c-a617-fa52322e32bf	550e8400-e29b-41d4-a716-446655441073	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
be0d7306-a272-40ba-b3cb-94cf7da60254	550e8400-e29b-41d4-a716-446655441071	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
02418fb5-8ef9-4d13-b3ba-3db19c374b4b	550e8400-e29b-41d4-a716-446655441083	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
4bc11b16-0ad7-40d1-aec3-3874597c0a90	550e8400-e29b-41d4-a716-446655441081	7027654b-575d-49b8-8e26-e70bc76966b1	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
64aedbc1-5f68-4efc-b783-ac223fdea3d5	550e8400-e29b-41d4-a716-446655441033	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
6ec3ab2d-7fdb-4142-a9d3-2ccaeae85415	550e8400-e29b-41d4-a716-446655441031	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
59964e57-a928-4b8f-9e41-2e8818d3ed62	550e8400-e29b-41d4-a716-446655441043	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
92a562b9-4a72-4767-bea0-167890728fd4	550e8400-e29b-41d4-a716-446655441041	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
5b39a8d5-a8c9-4609-9ef0-86de12646d5e	550e8400-e29b-41d4-a716-446655441011	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-30 00:52:37.379821
e64b6f41-e01b-49c8-8867-ba6360734986	550e8400-e29b-41d4-a716-446655441011	7027654b-575d-49b8-8e26-e70bc76966b1	4	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-30 00:52:37.379825
05548fe6-679d-4a6c-a577-eb51a1f5cd4c	550e8400-e29b-41d4-a716-446655441023	bad51b6d-2654-4c25-b69e-ba9c5f094449	5	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-12-01 20:23:45.014657
9f7bf65c-f347-4913-9ab1-d775aef526c5	550e8400-e29b-41d4-a716-446655441023	f89614fb-f6ed-4733-877f-e357906c4925	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-12-01 20:23:45.014661
fa11e201-662e-47f7-9494-bd600fcabccd	550e8400-e29b-41d4-a716-446655441023	7027654b-575d-49b8-8e26-e70bc76966b1	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-12-01 20:23:45.014662
3d21b614-20ee-4047-9bdc-e9d068b3cacb	550e8400-e29b-41d4-a716-446655441021	bad51b6d-2654-4c25-b69e-ba9c5f094449	5	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-12-01 20:25:41.858773
d6ee9838-89a5-4616-9574-6522c48e40ae	550e8400-e29b-41d4-a716-446655441021	f89614fb-f6ed-4733-877f-e357906c4925	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-12-01 20:25:41.860049
f299fcfc-7bb5-48cb-b088-8662549176f5	550e8400-e29b-41d4-a716-446655441021	7027654b-575d-49b8-8e26-e70bc76966b1	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-12-01 20:25:41.86005
16bb83ec-64c1-4b5b-aa27-28cd9a25fe85	550e8400-e29b-41d4-a716-446655441053	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
532c1f93-c77c-4b3d-810d-9933a6a92445	550e8400-e29b-41d4-a716-446655441051	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
1632d3a5-8bff-4e40-9df4-57f742eeae66	550e8400-e29b-41d4-a716-446655441063	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
c5cfc818-8d71-46c2-be17-e96f17771ce9	550e8400-e29b-41d4-a716-446655441061	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
e903aff8-f804-4113-ac11-8c72049281df	550e8400-e29b-41d4-a716-446655441073	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
2cf148eb-3d9b-42ba-8945-4beb73a4e8fb	550e8400-e29b-41d4-a716-446655441071	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
7f44e455-469c-4e36-a423-111679f5b297	550e8400-e29b-41d4-a716-446655441083	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
6fbe9256-bab4-48c4-9ed5-74005fab8cfc	550e8400-e29b-41d4-a716-446655441081	bad51b6d-2654-4c25-b69e-ba9c5f094449	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-29 22:35:03.876154
86d91930-8ef9-405f-817c-7c54621e570e	550e8400-e29b-41d4-a716-446655441034	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
fea0da10-400a-4f38-9b8b-9e0c4f9f940a	550e8400-e29b-41d4-a716-446655441032	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
77656c2c-0d61-4316-9182-1bd7ea63d666	550e8400-e29b-41d4-a716-446655441044	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
87c8253c-417f-4ec1-b8d3-f73baf616470	550e8400-e29b-41d4-a716-446655441042	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
88bc4457-7d14-4e36-b248-c87155c19f78	550e8400-e29b-41d4-a716-446655441054	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
8856f782-a7cd-4267-9b61-95ae55e17933	550e8400-e29b-41d4-a716-446655441052	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
bdeda6bc-e334-4536-9c13-1500f46a42f0	550e8400-e29b-41d4-a716-446655441064	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
59f377ab-0e4e-4448-a015-04adac156409	550e8400-e29b-41d4-a716-446655441062	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
a98d5ab4-72aa-42d7-9b5a-b5d05ebf2ddc	550e8400-e29b-41d4-a716-446655441074	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
1574e7be-442e-4b54-9732-d4d32d1f6536	550e8400-e29b-41d4-a716-446655441072	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
7c643a70-95b7-4ca7-ae2d-92005f4510ad	550e8400-e29b-41d4-a716-446655441084	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
200c2a87-401e-43d6-ab5a-b4315a65a9c3	550e8400-e29b-41d4-a716-446655441082	0e27b27f-1558-48e0-9e09-6a950d63d6f7	0	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
d100b607-e8e7-41c8-afad-692fb9e43d66	550e8400-e29b-41d4-a716-446655441034	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
1515fee3-4f17-4ba4-991f-f41c89e8e509	550e8400-e29b-41d4-a716-446655441032	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
ae1948fb-41b5-4d4c-9560-d1613e470eba	550e8400-e29b-41d4-a716-446655441044	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
1c5cf15a-ce15-4cc2-b5a1-72651bbff789	550e8400-e29b-41d4-a716-446655441042	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
6caeabf7-bc2d-44a8-b927-4e65e7d87597	550e8400-e29b-41d4-a716-446655441054	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
862fc1aa-039f-4cfb-8132-560bd762eccf	550e8400-e29b-41d4-a716-446655441052	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
737dd118-5c1b-4590-98fb-2dd12c44c0e1	550e8400-e29b-41d4-a716-446655441064	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
70887f63-18fa-4d77-be21-9ac8b36695c1	550e8400-e29b-41d4-a716-446655441062	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
cfe7bb0b-f8ac-47e8-9bc5-a98d05df56f5	550e8400-e29b-41d4-a716-446655441074	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
bb16eec9-9500-4c47-bf5e-6ec9daa7e75a	550e8400-e29b-41d4-a716-446655441072	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
4cad918c-4c3f-44e9-b1a1-3964964f1e63	550e8400-e29b-41d4-a716-446655441084	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
2d3bd59e-867b-449a-ba59-46f15a12df28	550e8400-e29b-41d4-a716-446655441082	3fb2ab04-137c-44ce-a16b-d4b12c818172	1	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
f98c2d9c-ee5e-498d-87df-ee37906b6612	550e8400-e29b-41d4-a716-446655441014	0e27b27f-1558-48e0-9e09-6a950d63d6f7	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-30 01:27:11.433561
69bf3a17-61f2-4409-9c3d-382e7046a7a6	550e8400-e29b-41d4-a716-446655441024	3fb2ab04-137c-44ce-a16b-d4b12c818172	3	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:22:55.120468
af457977-e7c7-4dfc-a412-d027ab30a3c0	550e8400-e29b-41d4-a716-446655441012	3fb2ab04-137c-44ce-a16b-d4b12c818172	3	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-02 00:18:32.637522
5ce79cbc-964c-43cc-862b-2be6f4ce464b	550e8400-e29b-41d4-a716-446655441022	0e27b27f-1558-48e0-9e09-6a950d63d6f7	6	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:25:41.859217
d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	550e8400-e29b-41d4-a716-446655441012	0e27b27f-1558-48e0-9e09-6a950d63d6f7	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-02 00:18:32.637523
fd52c20f-72c2-4bb1-a47e-6e9d88a961c5	550e8400-e29b-41d4-a716-446655441034	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
7a60db56-1102-4f3d-b667-5d20cb10f0dc	550e8400-e29b-41d4-a716-446655441032	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
42b1b247-e52e-4844-80d5-0a603bb81d30	550e8400-e29b-41d4-a716-446655441044	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
217a1a07-47d8-4758-95be-6b2d0dc2e2e5	550e8400-e29b-41d4-a716-446655441042	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
b36f337e-c918-4ddf-952e-fba0e985c151	550e8400-e29b-41d4-a716-446655441054	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
07e5c985-4c28-4b40-86a3-bd35280c3985	550e8400-e29b-41d4-a716-446655441052	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
76fbc66b-8aea-4e9d-8d96-a152a04eca31	550e8400-e29b-41d4-a716-446655441064	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
e719d9c3-0ed0-4ed5-b142-7b8641f58343	550e8400-e29b-41d4-a716-446655441062	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
ac5c8677-5646-4615-9c17-6601797d1a67	550e8400-e29b-41d4-a716-446655441074	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
fde075ac-bb6e-4b0a-9805-fba28821102c	550e8400-e29b-41d4-a716-446655441072	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
8caa23db-b33a-4e31-8c1d-baeff038c9e8	550e8400-e29b-41d4-a716-446655441084	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
c0d7ef9b-fe91-49ad-9796-b795b3e5e82e	550e8400-e29b-41d4-a716-446655441082	e25515d5-4d65-446d-869e-cfb2cab39ff1	2	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
339adc91-9b1c-49b2-b657-d0d4ef3555f6	550e8400-e29b-41d4-a716-446655441034	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
c9313d12-c05c-43fc-aa5c-45e5c4fd4937	550e8400-e29b-41d4-a716-446655441032	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
a6c4e561-c6eb-474e-b9ef-8ee059748a2c	550e8400-e29b-41d4-a716-446655441044	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
b573b170-87fe-4c24-8ff9-c27ad1062cea	550e8400-e29b-41d4-a716-446655441042	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
fff3dc92-10ec-48b4-b90b-5b434b3f3aba	550e8400-e29b-41d4-a716-446655441054	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
d75ced27-385d-4aff-a0d8-b4fb1f6d6d8f	550e8400-e29b-41d4-a716-446655441052	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
b2a08b85-eb4e-4c38-a4a4-fc489080d6b9	550e8400-e29b-41d4-a716-446655441064	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
f68a8498-520a-4b8f-b39c-53201e685bac	550e8400-e29b-41d4-a716-446655441062	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
ff904598-1e5e-4049-be51-857e2b970587	550e8400-e29b-41d4-a716-446655441074	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
1b66e9f7-cdd3-4009-8d8e-02cd56ca6749	550e8400-e29b-41d4-a716-446655441072	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
826f8634-7e2d-49de-a0bb-0433ca4692e3	550e8400-e29b-41d4-a716-446655441084	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
954eeb80-03fe-48fa-819e-476bed7ac6f6	550e8400-e29b-41d4-a716-446655441082	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	3	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-29 22:35:16.694359
6fe5858f-5820-42d0-acf1-91e35dd44b3e	550e8400-e29b-41d4-a716-446655441025	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
24ae9bbd-5319-41c2-bc14-283ca03f01b5	550e8400-e29b-41d4-a716-446655441035	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
544af333-08ed-4264-b0c8-f86ad3809d75	550e8400-e29b-41d4-a716-446655441045	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
77b73746-0184-4575-9103-8a6270589c58	550e8400-e29b-41d4-a716-446655441055	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
51443bb9-655f-4f0e-9f7a-6403b48e76cd	550e8400-e29b-41d4-a716-446655441065	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
3f6b092f-5128-4c99-9308-732d91edf030	550e8400-e29b-41d4-a716-446655441075	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
794c2dbd-8b8f-42c1-a12e-f8e0b79822ac	550e8400-e29b-41d4-a716-446655441085	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
993fac10-e0ca-4cba-8718-28d4bc9f5397	550e8400-e29b-41d4-a716-446655441014	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	5	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-30 01:27:11.43356
df6b044d-24bf-429d-8e2a-d8f9119b5c40	550e8400-e29b-41d4-a716-446655441014	e25515d5-4d65-446d-869e-cfb2cab39ff1	4	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-11-30 01:27:11.433561
71047dd4-1c7c-4d4b-8df9-6317a4477888	550e8400-e29b-41d4-a716-446655441024	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	7	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:22:55.12047
2d75339d-d51f-4b5c-9fca-bcd17b5c6299	550e8400-e29b-41d4-a716-446655441022	e25515d5-4d65-446d-869e-cfb2cab39ff1	1	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:25:37.193938
364290fc-154f-4cb5-b305-373784916cc0	550e8400-e29b-41d4-a716-446655441022	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:25:37.193941
6ebe547c-32e4-4224-a744-b355b95a92af	550e8400-e29b-41d4-a716-446655441012	e25515d5-4d65-446d-869e-cfb2cab39ff1	5	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-02 00:18:32.637522
6df8540d-18b3-4a87-8f75-aa0836189e0b	550e8400-e29b-41d4-a716-446655441025	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
71fc1b8e-388d-44ec-829c-f6effcb8f674	550e8400-e29b-41d4-a716-446655441035	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
b67ccc67-d870-4917-9957-60ff2c85284f	550e8400-e29b-41d4-a716-446655441045	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
e91b9fc2-6574-4a55-9347-9f9e5420f4b0	550e8400-e29b-41d4-a716-446655441055	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
9203b00e-d79c-4208-bb96-d01abb8e852a	550e8400-e29b-41d4-a716-446655441065	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
96c84841-50f1-4f5d-a524-b3f59fc847cc	550e8400-e29b-41d4-a716-446655441075	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
70fe2dee-c47a-4b66-ad05-cb356cb6d3fe	550e8400-e29b-41d4-a716-446655441085	ade38363-28c5-43c3-8f9e-711a997b0683	1	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
c04cb326-9852-46ff-b65d-72f4350d89ce	550e8400-e29b-41d4-a716-446655441025	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
d35df644-11f6-47ae-b2d4-ddac68d992b4	550e8400-e29b-41d4-a716-446655441035	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
b749ad4b-5ba2-4892-a3d9-9fc24cb8d237	550e8400-e29b-41d4-a716-446655441045	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
a503eb77-311d-471d-aada-4bfcf1fd7b92	550e8400-e29b-41d4-a716-446655441055	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
6edb5b16-000b-4ab7-9d31-508fde515ae6	550e8400-e29b-41d4-a716-446655441065	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
b40c8574-14fe-41d0-aded-3850042889a6	550e8400-e29b-41d4-a716-446655441075	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
c2c8deca-0f23-4bb5-91ff-7ae22779397d	550e8400-e29b-41d4-a716-446655441085	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-29 22:35:26.102102
3cf43c32-2ceb-47e9-86cd-065fa73e167a	550e8400-e29b-41d4-a716-446655441015	43a9b1fe-8f85-4126-8690-e55410aa022c	2	MAIN	3	6	8	90	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-29 23:23:15.998273	2025-11-30 00:47:47.251568
9cb9c7cb-475e-4e2d-85dd-2893a8022f59	550e8400-e29b-41d4-a716-446655441015	bccfa9f4-6148-495e-acb3-721da14e9721	4	MAIN	3	12	15	60	RIR	0	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-30 00:20:22.880729	2025-11-30 00:49:05.45508
f30acb50-26db-48c0-9a63-e65354dda1bc	550e8400-e29b-41d4-a716-446655441011	bad51b6d-2654-4c25-b69e-ba9c5f094449	6	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-30 00:52:37.379826
54491c32-9aff-4ac9-9b6d-c6ee525ac880	550e8400-e29b-41d4-a716-446655441013	7027654b-575d-49b8-8e26-e70bc76966b1	4	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-30 00:53:05.365917
bed46793-eb3b-4344-a506-fa2fd9f9c00c	550e8400-e29b-41d4-a716-446655441013	f89614fb-f6ed-4733-877f-e357906c4925	2	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-30 00:53:05.365918
bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	550e8400-e29b-41d4-a716-446655441013	bad51b6d-2654-4c25-b69e-ba9c5f094449	6	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:03.876154	2025-11-30 00:53:05.365919
b2c29b3e-3cf6-47fb-914e-083d24bc5419	550e8400-e29b-41d4-a716-446655441015	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	0	WARMUP	2	6	6	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-30 00:23:02.814764
d36998b2-2d15-4801-94fc-b2ffec8c4cd0	550e8400-e29b-41d4-a716-446655441015	bc9b3a59-10da-4b32-b126-bebea984581e	0	MAIN	3	15	20	60	RIR	0	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-30 00:53:23.731394	2025-11-30 00:54:14.784954
079b776c-b40c-466e-8f42-c09c6b60174a	550e8400-e29b-41d4-a716-446655441014	cdaa6012-b647-4168-aadc-58c1d033b3bb	2	MAIN	3	15	20	60	RIR	3	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-29 23:55:22.820164	2025-11-30 01:27:11.433554
92759e3d-5ea0-48f2-ac68-8febb26001a5	550e8400-e29b-41d4-a716-446655441014	26b71d2c-1250-4b4f-8804-934360d384ca	7	MAIN	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-30 01:27:06.334627	2025-11-30 01:27:11.433559
eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	550e8400-e29b-41d4-a716-446655441012	cdaa6012-b647-4168-aadc-58c1d033b3bb	2	MAIN	3	15	20	60	RIR	3	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-29 23:56:51.347755	2025-12-02 00:18:32.637523
54b1d045-e412-46d6-8462-7c0c61b8031f	550e8400-e29b-41d4-a716-446655441015	f89614fb-f6ed-4733-877f-e357906c4925	6	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-30 00:27:10.895665
627df66c-8824-4479-acc0-d382ab4f5fdc	550e8400-e29b-41d4-a716-446655441013	09607947-3376-4fd7-bc0d-5386825c73bf	0	MAIN	3	12	15	60	RIR	1	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-30 00:53:02.33262	2025-11-30 00:55:23.766228
b66bac52-68c8-422f-95f3-4b6be56ae50f	550e8400-e29b-41d4-a716-446655441015	ade38363-28c5-43c3-8f9e-711a997b0683	5	WARMUP	2	5	5	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:26.102102	2025-11-30 00:27:10.895666
5036d3da-b96f-4875-8a4e-0f6c56348ae7	550e8400-e29b-41d4-a716-446655441024	945a062b-0bfd-49b4-9bfc-3617fe1fad76	9	MAIN	3	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:22:55.120465
68e04e7a-30a1-4a19-8045-59e735013ccf	550e8400-e29b-41d4-a716-446655441024	a7e34918-49a4-47ef-aeba-69c4fb324fe8	5	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:22:59.319749
60f45ed7-e7bc-49b7-b752-9e2f922094ed	550e8400-e29b-41d4-a716-446655441024	2b384748-2af0-4941-88fe-2a589bd3aeb4	2	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:22:55.120467
8c730718-3dba-4053-a5b6-7d028ff0f6d3	550e8400-e29b-41d4-a716-446655441024	0e27b27f-1558-48e0-9e09-6a950d63d6f7	1	WARMUP	2	10	10	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:22:55.12047
bc28eed7-848f-490b-899a-fbed4435885e	550e8400-e29b-41d4-a716-446655441024	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	8	MAIN	3	10	12	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:22:55.120471
c6ed9524-4f00-4c7f-b3c8-3c981381c8bc	550e8400-e29b-41d4-a716-446655441024	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	4	MAIN	4	15	20	60	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:25:52.255524	2025-12-01 20:22:59.319751
bafec842-a261-4bb5-8b75-d7a1e98bf6f4	550e8400-e29b-41d4-a716-446655441011	06e8e4ce-4a0e-46a0-9c74-d3e702a7428f	1	MAIN	3	6	8	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-11-30 00:52:33.317303	2025-12-02 00:18:26.000401
eefafcec-3285-4d03-90f7-99490e49d0ee	550e8400-e29b-41d4-a716-446655441024	e25515d5-4d65-446d-869e-cfb2cab39ff1	6	WARMUP	2	8	8	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:22:59.319752
347d1871-da2a-4855-a613-0df4f23ac401	550e8400-e29b-41d4-a716-446655441023	e8f83a19-7d60-4b15-94f5-debe51c4e341	8	MAIN	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-01 20:23:32.653202	2025-12-01 20:24:16.383247
f66b7cae-bfa5-4c73-aa86-e309a0f4f864	550e8400-e29b-41d4-a716-446655441022	3fb2ab04-137c-44ce-a16b-d4b12c818172	0	WARMUP	2	15	15	30	RIR	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-11-29 22:35:16.694359	2025-12-01 20:25:37.196336
5a8b0205-6071-461e-96cd-a3ed73bde66d	550e8400-e29b-41d4-a716-446655441013	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	0	MAIN	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-04 19:06:27.623432	2025-12-04 19:06:27.623436
50b2f460-5d6f-4a0f-b974-53e61f4c2df5	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	e79f0884-280f-4e5e-9659-4df058afb828	0	MAIN	3	10	12	90	RIR	3	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Sentadilla en Máquina Smith - Segura para principiantes	2025-12-05 13:17:09.596265	2025-12-05 13:17:09.596266
15361b14-b0be-416e-a173-da7d3d47df4c	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	da02760a-78ad-410c-aedc-d8bba31198dc	1	MAIN	3	12	15	60	RIR	3	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Curl de Pierna Acostado - Para isquiotibiales	2025-12-05 13:17:09.596271	2025-12-05 13:17:09.596272
0a8db66a-e918-4c5e-8d35-3a2762bc677f	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	b3b03d37-e041-4fdc-8bc1-87487b47d769	2	MAIN	3	10	10	90	RIR	3	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Step-ups / Subidas a Banco - 10 por pierna	2025-12-05 13:17:09.596275	2025-12-05 13:17:09.596276
8079d6d9-eab9-435c-bfa4-10495082e7a1	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	ac7717a4-4e37-4cc2-9050-b4185af9c34c	3	MAIN	3	12	15	90	RIR	2	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Empuje de Cadera con Mancuerna - Contraer glúteos arriba	2025-12-05 13:17:09.596279	2025-12-05 13:17:09.596279
7fe5909b-bc1e-45ad-8513-1a5fbf745bcf	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	e70ccada-9057-4466-a8ba-f706f2b4438c	4	MAIN	3	15	20	45	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N	Patada de Burro - Alto volumen para glúteos	2025-12-05 13:17:09.596282	2025-12-05 13:17:09.596282
5b3a915c-a661-4a0b-8b56-b8f79cfdbce1	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	5	COOLDOWN	1	\N	\N	0	RIR	5	\N	\N	1200	\N	\N	\N	\N	\N	\N	Cardio final en escaladora - 20 minutos para cerrar la semana	2025-12-05 13:17:09.596285	2025-12-05 13:17:09.596285
3d40e3c2-bc07-4acf-bc7c-4310a0a9e968	1413e724-153d-4618-9d90-125710fd321e	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	0	MAIN	1	8	12	60	RIR	5	standard	straight	2100	\N	\N	\N	\N	\N	\N	Escaladora LISS - 35 minutos intensidad moderada. Excelente para glúteos.	2025-12-05 13:17:09.593042	2025-12-08 22:08:11.586289
5e107bab-2ca3-41ed-970d-67ec24956285	7ae61469-78c1-4af6-9b84-5b89dee5103c	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	0	COOLDOWN	1	\N	\N	0	RIR	5	\N	\N	900	\N	\N	\N	\N	\N	\N	Cardio final en escaladora - 15 minutos para fat loss	2025-12-05 13:17:09.590815	2025-12-08 20:43:18.36842
f8f6eee6-bcdc-4e9f-b043-76c54f3dab0d	d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	e796d58b-b6a3-4ed3-9522-af85490f93e9	6	WARMUP	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:48:51.808746	2025-12-08 20:48:53.694232
b288b68c-e888-46e0-93ab-621c01ae2511	ea9581e2-d848-495d-bf0b-b7e7708f634f	06e8e4ce-4a0e-46a0-9c74-d3e702a7428f	0	MAIN	4	6	8	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:53:58.233122	2025-12-08 20:54:28.996648
0aa4c023-c982-46fc-82bf-2664d369dfd5	7ae61469-78c1-4af6-9b84-5b89dee5103c	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	1	MAIN	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:46:53.594601	2025-12-08 21:01:31.627853
37f3afff-1acc-4285-aaea-f38c962c11ec	7ae61469-78c1-4af6-9b84-5b89dee5103c	a9ab1def-2dc4-4fe8-a517-f38d33cb1dda	3	MAIN	3	8	12	120	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:51:49.477168	2025-12-08 21:01:31.627856
d05473a3-f20f-44d0-b2f8-e8d3578e6275	7ae61469-78c1-4af6-9b84-5b89dee5103c	26b71d2c-1250-4b4f-8804-934360d384ca	4	MAIN	3	12	15	60	RIR	0	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:52:29.306732	2025-12-08 21:01:31.627857
e0d29d2a-eb7f-4327-be61-2fd56567d915	7ae61469-78c1-4af6-9b84-5b89dee5103c	15badbbe-7f3a-401d-ab0f-c7049381e935	2	MAIN	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:49:24.946695	2025-12-08 21:01:31.627858
3809d8f1-96bf-4038-a950-b9f505ad7ea3	ea9581e2-d848-495d-bf0b-b7e7708f634f	1da215b2-666a-4246-b7eb-f72c98de082d	4	MAIN	3	12	15	60	RIR	2	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Abducción de Cadera en Máquina	2025-12-05 13:17:09.583966	2025-12-08 22:05:57.285333
c365f4dc-5ec8-4c19-aef1-0882b88f9e07	ea9581e2-d848-495d-bf0b-b7e7708f634f	6cd9c5f9-38db-401d-8099-b64a7e580c5f	1	MAIN	3	10	12	90	RIR	3	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Sentadilla Goblet - Profundidad completa	2025-12-05 13:17:09.583956	2025-12-08 20:55:02.241919
f518f138-5d91-4e30-8fba-2197e3f98afd	ea9581e2-d848-495d-bf0b-b7e7708f634f	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	5	COOLDOWN	1	\N	\N	0	RIR	5	\N	\N	900	\N	\N	\N	\N	\N	\N	Cardio final en escaladora - 15 minutos para fat loss	2025-12-05 13:17:09.583969	2025-12-08 20:55:02.24192
f30ce59e-4ebb-46a0-823d-805ae995edf5	51940114-1276-49d0-8f3d-221ec70d8254	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	0	WARMUP	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 20:58:20.144897	2025-12-08 20:58:21.625435
048be1db-8dac-411d-af83-16a4d78411f6	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	180cac0a-9343-4208-9762-bacad127a9e8	3	MAIN	3	5	6	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.511318	2025-12-08 23:33:43.917031
eeb3662a-1526-4625-88e7-23bea1176c22	1413e724-153d-4618-9d90-125710fd321e	d483a4b4-9b78-4135-ae09-348de96db487	0	MAIN	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N	Realizar contracción isométrica al fallo en cada serie.	2025-12-08 22:03:47.536786	2025-12-08 22:03:47.536788
ef2f148d-51e7-482a-bbbf-d7dde4a4ca2a	ea9581e2-d848-495d-bf0b-b7e7708f634f	e796d58b-b6a3-4ed3-9522-af85490f93e9	6	WARMUP	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 21:00:12.70819	2025-12-08 21:00:16.552826
529bf890-7578-4267-a1a9-b30077a2d492	1413e724-153d-4618-9d90-125710fd321e	1b1adef1-d675-4a94-b499-42dc244011c6	0	MAIN	3	12	15	60	RIR	0	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 22:04:24.167659	2025-12-08 22:04:24.167661
25f2ec04-d87b-46b0-849d-6758374d9209	7ae61469-78c1-4af6-9b84-5b89dee5103c	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	7	WARMUP	3	8	12	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 21:00:45.931798	2025-12-08 21:01:31.627856
71c995d2-06a6-4852-930d-38a3ec3ba480	ea9581e2-d848-495d-bf0b-b7e7708f634f	eb812164-a155-43c5-9ae9-45956eb584cb	3	MAIN	3	12	15	60	RIR	2	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Patada de Glúteo en Máquina - Contraer al final del movimiento	2025-12-05 13:17:09.583962	2025-12-08 22:06:30.373486
e56b5fc5-5da8-4556-8d97-74411b23c1a5	ea9581e2-d848-495d-bf0b-b7e7708f634f	155ee3c5-a401-4644-a6c5-06bed7a187a8	2	MAIN	3	10	12	90	RIR	3	controlled	straight	\N	\N	\N	\N	\N	\N	\N	Zancada Reversa - 10 repeticiones por pierna	2025-12-05 13:17:09.583959	2025-12-08 22:07:19.706349
92d014bc-f787-4274-8151-7fefc86049d5	51940114-1276-49d0-8f3d-221ec70d8254	c58171e7-74bb-485e-827e-51df76a444e1	1	MAIN	3	8	12	120	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 21:03:14.835351	2025-12-08 21:06:27.954272
b30cb92c-f4a0-4b0e-880c-daf04bd4d7fb	51940114-1276-49d0-8f3d-221ec70d8254	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	2	MAIN	3	6	8	120	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 21:04:32.78208	2025-12-08 21:06:27.954273
1300a4cc-7098-459c-80ed-4663a10b74d4	51940114-1276-49d0-8f3d-221ec70d8254	e08d2b37-cdf9-4285-8307-6d4a2a60492b	3	MAIN	3	8	12	120	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 21:05:17.112127	2025-12-08 21:06:35.080533
cf7b2024-8dd1-4058-b652-97382f1524a1	51940114-1276-49d0-8f3d-221ec70d8254	4c59e8a9-c49f-4f65-a319-776a670482bf	4	MAIN	3	12	15	60	RIR	2	standard	straight	\N	\N	\N	\N	\N	\N	\N		2025-12-08 21:06:26.084854	2025-12-08 21:06:57.975011
0de8bafb-9dad-432a-8fa4-f7f9eed055d1	3a755073-7581-45e8-8846-e43b1b6abd7f	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	7	MAIN	3	15	20	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.49697	2025-12-08 23:33:43.917034
21e768a2-1f59-4024-8efc-6bfbff3464b9	32150047-3d57-456f-bc05-9193188ab3fa	9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb	4	MAIN	3	8	10	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.460594	2025-12-08 23:33:43.917035
21f83dcd-3fad-4c73-97f8-55515bd6d452	32150047-3d57-456f-bc05-9193188ab3fa	93523bc4-42be-47da-8286-fb628887bf5f	3	MAIN	3	6	8	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.460591	2025-12-08 23:33:43.917036
2cb6543c-4f8c-43e8-b940-acdbde01ef17	3a755073-7581-45e8-8846-e43b1b6abd7f	2b384748-2af0-4941-88fe-2a589bd3aeb4	4	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.496968	2025-12-08 23:33:43.917037
106ffcf6-7636-4eb1-a5fd-5a08099a61b4	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	06e8e4ce-4a0e-46a0-9c74-d3e702a7428f	7	MAIN	4	15	20	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.511322	2025-12-08 23:33:43.917034
2e8a4ead-ce53-4d31-93e3-bf2826df1ee3	3a755073-7581-45e8-8846-e43b1b6abd7f	18d50e17-4bce-4d39-8071-c93d969b7696	3	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.496966	2025-12-08 23:33:43.917037
30baafc9-5f36-4a0c-821e-477431df59fb	dc2d38c0-0d15-45b8-ad3b-78b882247948	afbb218b-fa3d-49cf-b7cf-8e0642bab3ed	3	MAIN	3	6	8	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.477629	2025-12-08 23:33:43.917038
41618ba2-1d65-4a9e-883c-7ccf2fbd0156	dc2d38c0-0d15-45b8-ad3b-78b882247948	5941db40-0f07-47b8-a9e2-f31bc44d9710	6	MAIN	3	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.477632	2025-12-08 23:33:43.917038
5ff2bae7-59c4-4b00-8230-c07428ced452	32150047-3d57-456f-bc05-9193188ab3fa	797aa448-10ec-49cf-b0b4-7cb589844710	7	MAIN	3	10	12	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.460596	2025-12-08 23:33:43.917038
6e0fab99-44c1-4d0a-a06b-407e883c3d2e	dc2d38c0-0d15-45b8-ad3b-78b882247948	61117023-fca8-49a7-a914-e8fddd9350af	5	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.477631	2025-12-08 23:33:43.917039
7164e73e-9208-49b2-8bdc-aaeb7865550e	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	5	MAIN	3	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.511321	2025-12-08 23:33:43.917039
8de0cf6b-822d-47da-9fba-7ead06f44d21	3a755073-7581-45e8-8846-e43b1b6abd7f	71650a04-03a5-4fc9-980e-123ee302f86a	5	MAIN	4	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.496969	2025-12-08 23:33:43.917039
a0441fde-b349-4c11-a3a8-bb81fefa625f	dc2d38c0-0d15-45b8-ad3b-78b882247948	8733deeb-0ceb-4541-a027-94e00a95586b	4	MAIN	3	8	10	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.477631	2025-12-08 23:33:43.91704
c247ac61-5644-4f8e-8320-fbe22133f1f5	32150047-3d57-456f-bc05-9193188ab3fa	e575c180-fd48-4cde-8c67-86b784dc5220	5	MAIN	3	8	10	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.460595	2025-12-08 23:33:43.91704
c313468f-bf9a-48b3-883a-8ff7d8d710b9	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	3aeb6a7d-b69f-4fc5-bcb8-14e04221ae11	6	MAIN	3	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.511321	2025-12-08 23:33:43.91704
d97d0fc9-ad0e-481c-825f-814107761fa8	dc2d38c0-0d15-45b8-ad3b-78b882247948	06e8e4ce-4a0e-46a0-9c74-d3e702a7428f	7	MAIN	4	15	20	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.477632	2025-12-08 23:33:43.91704
e90741ce-5e78-4f82-9661-3db7642056e6	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	bbbee470-42c9-45fc-aee1-3455ed5599c6	4	MAIN	3	10	12	90	RIR	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.51132	2025-12-08 23:33:43.917041
f733eea9-12af-4fbc-be6f-32354392a568	3a755073-7581-45e8-8846-e43b1b6abd7f	acc5f43d-ecdc-46c9-bde8-3f2979199e80	6	MAIN	3	12	15	90	RIR	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-08 23:04:25.496969	2025-12-08 23:33:43.917041
085da05a-465f-4cee-b855-dd7c2d5530d0	32150047-3d57-456f-bc05-9193188ab3fa	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	0	WARMUP	1	\N	\N	0	RPE	5	\N	\N	300	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924582	2025-12-08 23:33:43.924585
a7995daf-0384-4276-b60c-a706ff6b0ab6	32150047-3d57-456f-bc05-9193188ab3fa	bad51b6d-2654-4c25-b69e-ba9c5f094449	1	WARMUP	1	\N	\N	0	RPE	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924585	2025-12-08 23:33:43.924586
260b9a20-0c39-477a-bcd1-f3d9980fab2d	32150047-3d57-456f-bc05-9193188ab3fa	13e1a0d1-c18d-47ad-a80e-d2313395e432	8	COOLDOWN	2	\N	\N	30	RPE	3	\N	\N	60	\N	\N	\N	\N	\N	\N	Static stretch	2025-12-08 23:33:43.924586	2025-12-08 23:33:43.924586
d23e415a-d5c7-4921-afe6-7e4779d537e4	dc2d38c0-0d15-45b8-ad3b-78b882247948	be1663cf-6c5a-47cd-b427-0865baaf77e8	0	WARMUP	1	\N	\N	0	RPE	5	\N	\N	300	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924586	2025-12-08 23:33:43.924587
380c28d8-614f-4a4c-a36f-bab8edc5cb6a	dc2d38c0-0d15-45b8-ad3b-78b882247948	58c9abd8-de2f-456d-8321-32b773457487	1	WARMUP	1	\N	\N	0	RPE	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924587	2025-12-08 23:33:43.924587
9a6d0022-d6e8-4206-98b9-d2348407bde7	dc2d38c0-0d15-45b8-ad3b-78b882247948	defba1ad-1834-410c-9a1e-6833a42ce87d	9	COOLDOWN	2	\N	\N	30	RPE	3	\N	\N	60	\N	\N	\N	\N	\N	\N	Static stretch	2025-12-08 23:33:43.924588	2025-12-08 23:33:43.924588
f4a8308c-0b3b-4386-97ac-bc3a67d0f613	3a755073-7581-45e8-8846-e43b1b6abd7f	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	0	WARMUP	1	\N	\N	0	RPE	5	\N	\N	300	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924588	2025-12-08 23:33:43.924588
ea2831b6-c780-409d-b88f-400f0a004c09	3a755073-7581-45e8-8846-e43b1b6abd7f	bad51b6d-2654-4c25-b69e-ba9c5f094449	1	WARMUP	1	\N	\N	0	RPE	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924589	2025-12-08 23:33:43.924589
c08738af-7765-499a-adb0-a6bede1fd1ff	3a755073-7581-45e8-8846-e43b1b6abd7f	13e1a0d1-c18d-47ad-a80e-d2313395e432	8	COOLDOWN	2	\N	\N	30	RPE	3	\N	\N	60	\N	\N	\N	\N	\N	\N	Static stretch	2025-12-08 23:33:43.924589	2025-12-08 23:33:43.924589
a8bc4979-a143-4415-83ea-51593ab21314	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	be1663cf-6c5a-47cd-b427-0865baaf77e8	0	WARMUP	1	\N	\N	0	RPE	5	\N	\N	300	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.924589	2025-12-08 23:33:43.92459
ab415cc9-0880-4036-aab5-503d2a292188	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	58c9abd8-de2f-456d-8321-32b773457487	1	WARMUP	1	\N	\N	0	RPE	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	Light intensity	2025-12-08 23:33:43.92459	2025-12-08 23:33:43.92459
67e2800f-f07f-4a46-9193-e356e48e2154	5a5e7ca7-e0aa-4dea-b66c-b742c227684a	defba1ad-1834-410c-9a1e-6833a42ce87d	9	COOLDOWN	2	\N	\N	30	RPE	3	\N	\N	60	\N	\N	\N	\N	\N	\N	Static stretch	2025-12-08 23:33:43.92459	2025-12-08 23:33:43.92459
99f56789-60de-40dc-b21f-8ab051989f99	32150047-3d57-456f-bc05-9193188ab3fa	f884891b-550e-46db-bb76-d5e2709e075c	6	MAIN	3	8	12	90	RIR	1	standard	straight	\N	\N	\N	\N	\N	\N	\N	Al fallo o RIR 1	2025-12-08 23:04:25.460595	2025-12-08 23:58:44.490817
\.


--
-- Data for Name: exercise_muscles; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.exercise_muscles (id, exercise_id, muscle_id, muscle_role, created_at) FROM stdin;
847f3258-4779-4289-8f58-d03c8c332673	8d2e790f-19fb-4951-b365-d8a5015c8295	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
f11bce5c-6013-46e0-a643-bba0a3e459ac	8d2e790f-19fb-4951-b365-d8a5015c8295	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
1e9b3f3c-ac56-48d1-bd90-819112b4c646	8d2e790f-19fb-4951-b365-d8a5015c8295	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
ea183ecd-e2c5-4e6f-a44a-0952bd95c8ba	ac69990d-a46b-4eba-81a3-86a0992622dd	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
25347177-3862-477f-9420-0d50300b1e93	4a28e859-2658-4ae3-979c-28b220344e3b	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
e224742e-7037-413f-b546-5b2fef243839	4a28e859-2658-4ae3-979c-28b220344e3b	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
c6b2a332-9c26-4ea6-a86b-3a95fe61a5ec	4a28e859-2658-4ae3-979c-28b220344e3b	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
23e2991e-92b5-4cea-852c-b7787801b88e	4a28e859-2658-4ae3-979c-28b220344e3b	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-11-29 21:38:19.204624
aaa52dc2-d887-4d7e-af6c-db26ecef8d33	499b3e67-b5e2-41e5-9cc2-ef521ea0f492	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
1b8d394a-3a51-4102-9d53-f4bb03392b4d	499b3e67-b5e2-41e5-9cc2-ef521ea0f492	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
de5671d3-dfc3-4dd8-94e2-ced2b5722ea0	499b3e67-b5e2-41e5-9cc2-ef521ea0f492	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
13d2c93e-8882-4ddb-bfb3-eee3d615188b	a9b7100d-33af-47f3-bb90-1921af186225	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
28d88c8e-ab2d-4edc-a285-7bc08ee10d7b	a9b7100d-33af-47f3-bb90-1921af186225	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
4fe15e00-cb8d-45fc-b871-ac025e1a576b	a9b7100d-33af-47f3-bb90-1921af186225	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
c4fe8c95-e43d-440f-9710-4eee4aea85a3	1c1ab84b-4a92-4b49-bba2-01f4bc1ab9fd	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
1d9a03d8-8fd7-4af1-866c-b1edd81f550d	1c1ab84b-4a92-4b49-bba2-01f4bc1ab9fd	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
0f282b48-7afe-48e9-a760-d8054fedac9e	f11e51d7-3336-453b-bb00-d4da5293f40a	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-11-29 21:38:19.204624
aa8d40a8-38b4-49ea-a02e-9fbd6af5ae96	f11e51d7-3336-453b-bb00-d4da5293f40a	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
a680a43f-b076-49d2-97af-fa2b293c2945	998fbd55-139a-409c-85f7-4e84251df22c	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
0ffae7e8-1154-4f4d-ab38-67b657cf3dfd	998fbd55-139a-409c-85f7-4e84251df22c	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
ade74355-9795-469b-97f7-4b0944a3e610	998fbd55-139a-409c-85f7-4e84251df22c	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
64a94f51-d5fc-4a2f-b18c-1dfdfd9bfac0	c1328ee6-43d4-4f47-827e-38f21e7120dd	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
047436a6-1a3b-451c-b12d-d5dee77ac56a	26918508-effb-428b-b6c0-0a7470c9968a	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
4e622b80-f40e-471f-bbc9-97a5cd3514e6	26918508-effb-428b-b6c0-0a7470c9968a	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
4c7ee7e6-ec69-4cb7-b723-31a34da3547f	ecc38482-1057-44b0-bb0d-76d3a645c49f	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
65ce70ba-6084-4d08-8dd2-12930fa80e48	ecc38482-1057-44b0-bb0d-76d3a645c49f	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 21:38:19.204624
34398d43-8838-407c-8f4f-195611f0508a	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 21:40:22.186064
34908a76-782b-4f86-8526-a7eb1ab5fdbd	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 21:40:22.186072
292b7348-a11f-4014-be78-b72b0d5f3dfb	2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-12-08 21:40:22.186078
7e23f5fc-6640-4119-ac37-2b50fb24235d	e796d58b-b6a3-4ed3-9522-af85490f93e9	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 21:41:37.754724
c774d2d2-bfba-402b-807e-697742d29253	e796d58b-b6a3-4ed3-9522-af85490f93e9	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-08 21:41:37.75473
b9059734-3076-45cb-b79e-3a54470cb176	4a718bbd-9a37-4b7c-b804-62e213f0e5a8	647be680-283b-4014-a57c-03eb2feb33f4	primary	2025-11-29 21:38:19.204624
c116d50d-af5c-4ba5-91e0-751396f5281c	e796d58b-b6a3-4ed3-9522-af85490f93e9	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-12-08 21:41:37.754734
077ed197-0f39-4185-9488-c5bad701437f	e796d58b-b6a3-4ed3-9522-af85490f93e9	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 21:41:37.754739
3a264e5f-61a5-431e-921f-ff34bd64891b	0d1669ad-d3b1-4fc2-af13-6df361ffba64	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
278dc2cc-70b9-40ec-a7fa-ad077f7dca6d	d62eae0b-9ab5-4a2f-b9c9-9ca9697af74d	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
769eee66-ab6b-4498-b79a-f9563f3cbd16	40cbc496-5c69-4ca6-b6f1-4635692702ed	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
40cfc263-fe5b-40dc-9a40-ec9e571622b0	78d9226e-8c17-4d5c-ae02-09ff7ed6ae51	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
01f77b66-541c-43b3-85ff-d9df15cb508b	062cfaf1-2abd-49cf-8ad9-2c3784ec4419	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
594bda91-a759-4733-aa32-9fd76e7f37e8	06e8e4ce-4a0e-46a0-9c74-d3e702a7428f	2a06511f-22fd-49cc-85da-99a0d7bd0df1	primary	2025-12-08 21:46:31.887547
e675db59-c586-4d16-9a9c-dd54c3d67ba3	f856b6a1-300b-4fbf-b967-9071a0d11141	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
5cc31a41-84d1-448d-b986-3d1e2386e086	f3df9354-773b-4635-a2f1-b6f210bb0095	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
933ec87d-7548-4be7-a5ee-740707f3bb0d	cb7daf45-405b-48c2-9a6e-37cfdddeeb5d	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
5bfb4481-a7da-46e7-86e4-0633c55f01cc	cb7daf45-405b-48c2-9a6e-37cfdddeeb5d	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
06943d23-fa33-47fc-9d4e-02f53d4512d6	cb7daf45-405b-48c2-9a6e-37cfdddeeb5d	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
f9b75abe-3e06-45ff-bfed-b708d65e6f9c	fb1802ef-1799-48ca-af9f-9de08e10ab26	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
ac5591c2-4d43-4f78-8f42-b85b4954d5f9	a3a6ae8b-5238-483e-bc62-d328aaeb6fb0	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
447571d1-5efe-4de1-8269-e6e8706ea59e	98d2acbd-4b74-4b92-a76f-34a74f1f21a2	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
bbb1015c-c183-4727-abc5-a3cc87295d90	98d2acbd-4b74-4b92-a76f-34a74f1f21a2	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
effe240e-ae52-4fbe-af58-acf18f1f6c67	d3978a05-e7d7-41a1-bb30-7e7c8f450d63	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
af5a10da-8348-4c0c-807d-6678b6ed0958	d3978a05-e7d7-41a1-bb30-7e7c8f450d63	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
d72e5dbf-f3c4-45a1-947d-9e896a255ee1	d3978a05-e7d7-41a1-bb30-7e7c8f450d63	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
636af00e-cf5e-413d-ad05-c853c69052a4	6981e3ef-21eb-4773-bfe0-dd823252ed08	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
53bbfcfb-6597-49cb-8549-e22f0b955d7f	6981e3ef-21eb-4773-bfe0-dd823252ed08	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
02e94cf4-5aef-419d-813e-52ef59c3a4e9	0a9724cd-177f-47bb-821d-f0ea3105f9ca	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	primary	2025-11-29 21:38:19.204624
411c5020-c59f-4b71-97b1-8584ad5f7292	85cbe2d0-c7f9-407a-8b4f-1e7bad47594f	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
8646f79c-2803-4ba2-9339-b9fc85282636	85cbe2d0-c7f9-407a-8b4f-1e7bad47594f	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	secondary	2025-11-29 21:38:19.204624
991d753c-f793-4c98-a568-a135c14731f0	85cbe2d0-c7f9-407a-8b4f-1e7bad47594f	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
e4891989-312c-4545-bd74-6ec7335171cc	f4b345f7-e37c-4a27-9f9a-279c748dfcb6	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	primary	2025-11-29 21:38:19.204624
83dabe6d-f341-4394-8347-956a5fcebae4	f4b345f7-e37c-4a27-9f9a-279c748dfcb6	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	secondary	2025-11-29 21:38:19.204624
6a9d457c-fe1a-4205-aaef-97cc6ae7ad32	bc6452cb-8d45-471d-8948-a16a5cbf76cd	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
746b2df2-7f2f-4781-a65f-8a19cbc77a28	dfb6bdf3-9a78-496c-9eb3-0cb2f91a2182	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
31125ae8-0ac7-48fb-b37b-dacdadd0ccfd	dfb6bdf3-9a78-496c-9eb3-0cb2f91a2182	018c8d48-0ec8-4e81-ad52-43b091840c45	secondary	2025-11-29 21:38:19.204624
2b052163-c898-4a03-8d73-8f0cd2635078	cded2f69-f3aa-4414-9898-966bc650e5d6	018c8d48-0ec8-4e81-ad52-43b091840c45	primary	2025-11-29 21:38:19.204624
63345d4e-afaa-4bf1-91c9-7f75b49b66bf	cded2f69-f3aa-4414-9898-966bc650e5d6	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
3098df1c-16a3-4651-9720-04d3006546b0	0d81f1d5-a132-4b29-9715-763349e49dda	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
0e828d11-d46a-4e3b-b2ae-ea7490662530	0d81f1d5-a132-4b29-9715-763349e49dda	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	secondary	2025-11-29 21:38:19.204624
3969a6cf-0c2e-4570-b9d4-4fbd00bbe8c3	12af8c22-bfb5-42f3-babc-fbfde97e03f6	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
39209c88-e9f7-4e75-b669-a36f02f99bd2	c052c480-7488-41e7-83c1-13b3772f2250	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
a35b1b63-221d-4f98-920e-0feb5e8389b9	c052c480-7488-41e7-83c1-13b3772f2250	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
0b51c27a-4622-44d3-a111-a560a76bce29	c052c480-7488-41e7-83c1-13b3772f2250	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
c6721161-368c-4cbb-a53f-3dce4bdb7f84	3795dc73-8f9a-4b77-8def-f9d3be8a517d	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
484f5797-900c-4c3a-b443-55c443e010f2	3795dc73-8f9a-4b77-8def-f9d3be8a517d	018c8d48-0ec8-4e81-ad52-43b091840c45	primary	2025-11-29 21:38:19.204624
be5e5f6b-e6bd-4a05-a7e1-ea482cc9747b	f080434f-5670-4fe4-93f1-f75cc6860427	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
d4b70405-f109-47b9-9212-1d8ed19181c6	9052a646-277d-492f-8ef2-2ae99f91cc48	647be680-283b-4014-a57c-03eb2feb33f4	primary	2025-11-29 21:38:19.204624
5ca6c027-f663-44ab-bc50-2fc852fab154	9052a646-277d-492f-8ef2-2ae99f91cc48	018c8d48-0ec8-4e81-ad52-43b091840c45	secondary	2025-11-29 21:38:19.204624
47fb10f6-884e-4c14-a38a-12673c62a7b7	9052a646-277d-492f-8ef2-2ae99f91cc48	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
4f0b9adb-4287-4267-823e-674fc22c9547	8bc71e2d-19b9-48b0-ba33-9494749eef8a	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
9fc6afd9-e965-47c6-9243-78ced3d746b6	8bc71e2d-19b9-48b0-ba33-9494749eef8a	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 21:38:19.204624
e8fefb55-1ef8-44a2-9123-84d1248d8d31	8bc71e2d-19b9-48b0-ba33-9494749eef8a	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
046e097a-5fe9-4ed4-b1af-bc611ea5ee94	18f621cb-7f79-4a95-9fa4-4067bfa5a1f9	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
ca2cedc0-f7b5-484b-9bfe-7997ccea9cd3	18f621cb-7f79-4a95-9fa4-4067bfa5a1f9	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
95e1e0af-0c4d-447d-a8f2-fc159ddecf45	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	936a7751-7076-4802-821c-33fc87546897	primary	2025-12-08 21:49:48.417027
2820d082-72c6-44a5-867d-22df1dd59f3f	13135caf-d1bf-4be5-bc08-c3287dc4b7b6	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-12-08 21:49:48.417032
6287c96c-c807-42c9-b473-1c2c1620ac68	15badbbe-7f3a-401d-ab0f-c7049381e935	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-12-08 21:51:17.746127
7c8b2614-10bc-4061-a12a-8ae03c1772eb	0f09b024-96e5-4838-87cb-32cb794a385b	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
7dce341a-5aa8-40d2-b301-da077a436e11	0f09b024-96e5-4838-87cb-32cb794a385b	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
daf65c23-ba51-42f5-9ac3-c01d2c8c6efa	0f09b024-96e5-4838-87cb-32cb794a385b	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	secondary	2025-11-29 21:38:19.204624
ec5b8e8b-7549-4e42-a128-14790734d3ed	be1dd3e7-d9c3-4852-a7d6-6384c84260b6	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
239ceb32-bd21-40ea-aca2-43d22b32d37e	be1dd3e7-d9c3-4852-a7d6-6384c84260b6	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
20f9cb09-75db-4a88-91ef-5b8de584248b	be1dd3e7-d9c3-4852-a7d6-6384c84260b6	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
60359086-4b08-457c-9e13-534a6e89cd47	4a209f26-f4e5-4e55-85bc-54b259f3a289	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
c0aa18be-57e0-4b5d-8af5-04b8ff9f24d6	4a209f26-f4e5-4e55-85bc-54b259f3a289	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
1725c4ac-c5b9-4f39-ac53-4b5bd28174e1	4a209f26-f4e5-4e55-85bc-54b259f3a289	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	secondary	2025-11-29 21:38:19.204624
22083338-9c9f-4c57-9275-cf45136e620a	ba2057dc-35f3-416c-b717-0214554ad8d8	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
ddc2904a-1eef-4b93-aaea-2c8b95c37979	ba2057dc-35f3-416c-b717-0214554ad8d8	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
0d48a833-b6bd-4a30-bc82-5d1191679737	ba2057dc-35f3-416c-b717-0214554ad8d8	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
e04b18fe-8c8e-4cf4-8a77-03fc9229b6f4	9df5a698-50c3-4db0-a63b-b3a848d73734	2a06511f-22fd-49cc-85da-99a0d7bd0df1	primary	2025-11-29 21:38:19.204624
cc26b10b-3d95-4992-ae61-a7aaa87ed9fd	9df5a698-50c3-4db0-a63b-b3a848d73734	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
c035f8e5-6588-41cf-aa90-46571c7f9125	9566c4f0-016c-4655-a040-08ff2e368111	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
616454bb-9a5e-42ec-b589-87bea7574055	9566c4f0-016c-4655-a040-08ff2e368111	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
527cc7be-0bc2-434e-9bb8-8f59871d0bcd	9566c4f0-016c-4655-a040-08ff2e368111	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
24c1f38f-5541-45bb-bc32-e7f81c6ad898	e867589b-ceca-4d3d-b2e5-f23f44d2d22d	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
ff30ebfc-aaa5-42db-9cad-7ca0d4cbf2e7	e867589b-ceca-4d3d-b2e5-f23f44d2d22d	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
8480a399-7f75-4ea4-9976-57b8b095ef88	e867589b-ceca-4d3d-b2e5-f23f44d2d22d	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-11-29 21:38:19.204624
f325d933-7170-4ac4-96d2-ac7840f99acd	e867589b-ceca-4d3d-b2e5-f23f44d2d22d	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
f0859867-64b4-4b88-bc65-9cbc511be28c	fae71fe3-2bd1-4525-ab8d-f7cf0cab52fa	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
da15dfed-cbc1-4df0-b806-cc61f91d6ece	fae71fe3-2bd1-4525-ab8d-f7cf0cab52fa	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
bb847b3e-14f4-4e9c-89c7-e3458ba9160d	fae71fe3-2bd1-4525-ab8d-f7cf0cab52fa	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
ae3ce0b7-2702-4d6d-b3ae-605065e1d388	fae71fe3-2bd1-4525-ab8d-f7cf0cab52fa	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
c8519ad5-0322-4568-9498-2938fc420cf5	fae71fe3-2bd1-4525-ab8d-f7cf0cab52fa	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
1d7c77a4-7b5a-4952-b1c1-7a20842750ec	b3c60b00-8728-4a7d-8f9f-2e5d1f8e3368	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
2b2ccb6c-9d5d-4488-947c-9e66b3f1c3d8	b3c60b00-8728-4a7d-8f9f-2e5d1f8e3368	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
fc479c46-85c4-46ba-8bb3-df826e4297de	b3c60b00-8728-4a7d-8f9f-2e5d1f8e3368	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
2d7483c5-c65a-424e-a16b-7d479d470737	b3c60b00-8728-4a7d-8f9f-2e5d1f8e3368	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
e07042a3-4436-441a-88a1-511978c1409d	8059bab2-c321-4408-a8c9-dc4048c7ee37	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
dbb2bbbc-0195-4210-a520-8d186251dae0	8059bab2-c321-4408-a8c9-dc4048c7ee37	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
57a4b6b6-ea8b-4a95-9f83-1a7692f127bf	8059bab2-c321-4408-a8c9-dc4048c7ee37	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
b0e96e59-0947-4f0d-8f80-84e3a4aacc1c	8059bab2-c321-4408-a8c9-dc4048c7ee37	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
f46ed370-ae48-4531-8813-5834e56ad92c	05c07fc6-9f1b-4177-8586-5131cbbf7dcc	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
bff705dc-18f2-4c36-96f7-b70e6d99f1cb	05c07fc6-9f1b-4177-8586-5131cbbf7dcc	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
716ea2ec-0fa9-42d7-9d6c-e13f7e4cf6fd	05c07fc6-9f1b-4177-8586-5131cbbf7dcc	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
7a1e3a40-e303-4375-94f9-c2e72d0b1889	15badbbe-7f3a-401d-ab0f-c7049381e935	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-12-08 21:51:17.746132
8d1d7c24-3833-4ca3-8d80-165c0435d356	26b71d2c-1250-4b4f-8804-934360d384ca	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-12-08 21:51:55.168217
bcadd64e-c492-43b3-a261-10b67ded9a63	a9ab1def-2dc4-4fe8-a517-f38d33cb1dda	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-12-08 21:53:11.487938
ade50704-fe3d-4234-9132-49d1f390af80	1c4009ee-4fda-4994-84ad-4701242821f4	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
e5c2cb79-c56a-4553-b967-0321a003db97	1c4009ee-4fda-4994-84ad-4701242821f4	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
11224002-ff06-4f5c-aec5-de030bde3e2e	1c4009ee-4fda-4994-84ad-4701242821f4	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
bdb50e93-8f5c-40fc-a149-9cd078e247f6	1c4009ee-4fda-4994-84ad-4701242821f4	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
9d1cdbf9-d79e-4afa-8f5c-231fffbecba6	48fcbc48-db8b-428c-9f1b-086b659c1d87	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
41fae135-9eca-47d7-af93-5d333ced49a8	48fcbc48-db8b-428c-9f1b-086b659c1d87	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
d6e9b89f-0a0f-4f87-a9ea-84d644574843	e296fac2-b7c9-40ea-b657-f9861b6ec70f	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
c0f5cf9b-e6c3-4447-83f0-8acdf76395ba	e296fac2-b7c9-40ea-b657-f9861b6ec70f	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
da37ff62-6331-448c-8f41-ce2b0ee4d1f2	e296fac2-b7c9-40ea-b657-f9861b6ec70f	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
934b9394-3ad8-4369-99f4-d28289d08bae	a9ab1def-2dc4-4fe8-a517-f38d33cb1dda	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-12-08 21:53:11.487942
8df80eb5-1b4b-4a41-bde9-761e82a8c03b	a9ab1def-2dc4-4fe8-a517-f38d33cb1dda	936a7751-7076-4802-821c-33fc87546897	secondary	2025-12-08 21:53:11.487945
a660ca6d-7be0-4f4d-842d-e06d94f09aa0	0c1ca425-2019-483f-963b-143fd74d49ae	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
9226e180-97fd-451b-ad29-3db4f36cdb20	0c1ca425-2019-483f-963b-143fd74d49ae	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
acfa25b8-32ea-4e4e-b49e-8475ba4124a1	04c1ff1d-7b26-4943-9911-4bf31fe2c8b6	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
cd0104a2-de9c-4e4c-bf49-8f4d24b0920f	04c1ff1d-7b26-4943-9911-4bf31fe2c8b6	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
3835bc8c-f995-4902-94d4-7b094d65275a	04c1ff1d-7b26-4943-9911-4bf31fe2c8b6	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
afff7363-13b4-44b4-a17c-3e78b1879488	f7579300-0e09-446e-b2fe-c26a5bc8d5c7	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
07a2e918-40cb-459f-9705-acfc99ebe729	f7579300-0e09-446e-b2fe-c26a5bc8d5c7	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
75ef0687-e366-49fa-8515-090f406e0006	f7579300-0e09-446e-b2fe-c26a5bc8d5c7	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
67a0b7a5-bba6-4d47-ae75-37c7a03ae49f	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-12-08 21:58:43.697908
c3b7d040-b257-4503-9c6d-28a43f5f83fe	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-12-08 21:58:43.697914
cc811467-f1bf-46e8-8526-ecac7511b66a	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-12-08 21:58:43.697918
5aa37f64-77c1-45a0-b0a5-e5ad82702829	e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	7ae11464-3f30-47ce-ab9e-5fae4a225805	secondary	2025-12-08 21:58:43.697922
d3de7c6a-1410-4a8a-b964-eb847a180f16	e08d2b37-cdf9-4285-8307-6d4a2a60492b	936a7751-7076-4802-821c-33fc87546897	primary	2025-12-08 22:00:42.453777
af0ee9ff-92eb-4771-8586-0c28a4942a95	4c59e8a9-c49f-4f65-a319-776a670482bf	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-12-08 22:01:32.59027
844353fd-ada8-4a4b-ba04-7492a74365ef	cd014645-50c5-4168-b247-9c1cfdfebb96	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
47c86da2-344f-46fb-89b3-9e9ee9095f5a	cd014645-50c5-4168-b247-9c1cfdfebb96	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
aa43df1c-a1b7-43fb-8f73-8ad981e39875	949f1f23-2e1a-4b14-89c3-47638a5525a4	abadd271-e2cb-4f4f-9aa4-9aabae72db67	primary	2025-11-29 21:38:19.204624
cf765378-3a19-440a-b782-c928d27fc821	949f1f23-2e1a-4b14-89c3-47638a5525a4	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
a98d4091-011f-42e0-8e16-fa3e62e60d3f	949f1f23-2e1a-4b14-89c3-47638a5525a4	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
0ed5c1ca-f6d5-4629-aca3-a5fc1574dc85	949f1f23-2e1a-4b14-89c3-47638a5525a4	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 21:38:19.204624
5fdf27d5-5abd-40d7-a53e-5f6a1cedeb88	54ab1340-051d-4f8a-8ec2-f2748cc504b3	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
538d8ff4-181e-4153-b8b4-b39fa7268bda	54ab1340-051d-4f8a-8ec2-f2748cc504b3	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
fac5cee5-bc0a-4a11-9b48-fc3dfd65fe10	54ab1340-051d-4f8a-8ec2-f2748cc504b3	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
75500b52-1bb3-47ba-89e8-d445481ee157	df8e5f58-f528-448e-a41e-3938c669bfe1	abadd271-e2cb-4f4f-9aa4-9aabae72db67	primary	2025-11-29 21:38:19.204624
ec1724e5-34c5-4c5f-bdbb-4ce6f2849105	df8e5f58-f528-448e-a41e-3938c669bfe1	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
43c93102-23e9-41bb-a286-17330eda677c	df8e5f58-f528-448e-a41e-3938c669bfe1	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
6e93abf9-a5bb-4c09-a62e-690b9e96d17a	3f2f4b50-e5d4-47fc-acb4-72c02260bad3	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
236be403-93d3-4266-b97a-75636f673b48	3f2f4b50-e5d4-47fc-acb4-72c02260bad3	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
046b961f-4cac-4f18-8373-f6a10ac0a7d8	3f2f4b50-e5d4-47fc-acb4-72c02260bad3	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
0f7cec36-00bb-44f4-b968-b7fddeaad203	c58171e7-74bb-485e-827e-51df76a444e1	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-12-08 21:55:17.635525
d7ececb4-df7f-4ee9-bbe4-60cd7711d6d5	1dd3d269-0767-417e-a415-320897158e74	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
3356369b-d610-4ffe-8dec-39727541ecc9	1dd3d269-0767-417e-a415-320897158e74	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
e28e25e7-bca9-4cd3-8dc6-e30dabffb466	5ffd4f75-1b02-44a8-8245-036b03e8ca8b	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
65512848-04b4-4a3f-a2be-bb415bf9d85d	eb822a60-9981-4041-9a9e-5b3b8c82b07b	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
a29c613a-46df-4155-a55c-c1960f5adbd1	cb74c9b1-8845-4899-a203-67028cfae5c2	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
fdb73583-f00d-448a-9e0b-deece6afb9fb	cb74c9b1-8845-4899-a203-67028cfae5c2	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
d51b767b-56f5-4321-a0e0-48191e9d570f	cb74c9b1-8845-4899-a203-67028cfae5c2	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
c7920479-73e1-4504-909a-ec6f61a94cb9	c58171e7-74bb-485e-827e-51df76a444e1	936a7751-7076-4802-821c-33fc87546897	secondary	2025-12-08 21:55:17.63553
6a6ff5e4-eabc-446c-b43f-1273c57d81b1	c58171e7-74bb-485e-827e-51df76a444e1	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-12-08 21:55:17.635534
d3f89f68-631d-4661-b0e6-8a32658efee7	e91aae68-2323-473a-9798-01026fe559c9	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
a8cfe69a-f79e-46f4-b057-3c59dcb0e5e5	e91aae68-2323-473a-9798-01026fe559c9	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
8d6d9d09-2a01-4b3f-b5b6-3ac17feb310c	cad31ba5-690d-4e66-826c-822365f616cd	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
9f89d9aa-5944-48ea-a8d5-ea56557e9386	3e0ea4a8-b258-44bf-85c8-529900fc0a94	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
971a6629-8be8-40f8-a47a-380d13254d06	3e0ea4a8-b258-44bf-85c8-529900fc0a94	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-11-29 21:38:19.204624
d2f05596-a80a-497c-9d13-0526ad21d8e8	3e0ea4a8-b258-44bf-85c8-529900fc0a94	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 21:38:19.204624
8ada8d36-dd31-4edc-bbb6-22508ffce037	a2f075c0-d141-49a1-a6d1-c1cb2d188b3b	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
c8ab358b-3134-49fa-82ef-af216597713f	70cd9e39-297d-420f-8ebb-5af2423d504c	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
efc6ff4a-9dde-4437-ac3c-180c1ce6df30	ebbb5bed-2741-4c41-8705-2ad8f97d765d	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
9e6855ad-d69b-43db-9f28-59b29d52e653	69273c3a-e289-4ce6-9ef0-ff5b0d734c73	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
5ac551f3-980d-4408-81e6-8ba3720b7ce5	d6fb6584-6d85-4e22-9c82-f88c5a407e52	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
4d9dad5c-cc20-4246-8d5f-770eb66a3853	94e22043-d2e5-40d9-9355-b5db003f9964	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
ba210d18-4a74-43a7-8efb-41429f5ac139	a780f0ae-8236-4bb3-baef-6b830dc3f287	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
655233a0-dc69-4f52-8d94-9914913c84f3	6efb5bc1-5475-48d0-a476-4ee49aa3c162	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
e79e762b-3ef7-43c3-908e-50d035c1324e	d704f33f-d57d-41ed-9611-dc367d90bdef	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
47b16352-866f-4f9c-8917-49c46342e21f	d704f33f-d57d-41ed-9611-dc367d90bdef	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
a3ee4c48-509c-4404-a314-de4769bcb2ea	d704f33f-d57d-41ed-9611-dc367d90bdef	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
fe9715d3-afcb-41f6-a514-b631b45cc8ce	05b47a90-d82a-4200-b0d0-890e09cef009	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
57ff6cad-2129-4ffb-a98c-5aee7180294f	a493d846-8694-4095-9b19-66db1a585761	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
6afd48cc-d46e-4156-96b0-092c2241cf1c	1b1adef1-d675-4a94-b499-42dc244011c6	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-12-08 22:35:49.017937
1aa83a06-0b37-4729-a6ee-8f12ba9b09bd	a053c71f-8d4f-4904-a8b7-c1462864639f	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
719acee7-355f-4f68-9743-04158cd7a3f4	15ec8aab-14c7-4841-9a6b-1ebfb94cbf19	018c8d48-0ec8-4e81-ad52-43b091840c45	primary	2025-11-29 21:38:19.204624
9ebdb398-9838-47f4-9c72-09b13f013b4c	15ec8aab-14c7-4841-9a6b-1ebfb94cbf19	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
0b4403b3-fb14-4483-b263-f957a2d3015a	6a044c4f-42af-4d15-88a5-fa6e9493f011	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
ce8683a3-efd9-4441-acaa-198392ce1218	3493b170-38aa-406e-9d0f-57cc4cde4ffa	018c8d48-0ec8-4e81-ad52-43b091840c45	primary	2025-11-29 21:38:19.204624
d2ea58db-7902-498b-b13c-685407f7393c	3493b170-38aa-406e-9d0f-57cc4cde4ffa	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
6cfbfbf1-0648-4c29-9849-bac164d3a471	c03d86b7-2c86-45fe-bbee-5bdc2f7b1fb4	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
e739f53f-e21c-48d6-afb0-c1be8d564ea7	e5950111-2ce1-46db-88fe-43c7441d065b	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
b1f6da3a-da1a-449b-aee0-3b55f897ff56	5cabccc1-9c4e-4093-a995-412697afd3fd	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
9fd26ac0-d6da-4365-a9fe-3687ae6f5318	a109862e-2fd8-4453-8282-ed5f7394c522	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
331a4d6e-277a-41ce-bc19-fa4af59f6654	4b9859d5-7fae-46a8-80ec-9dc2cc883701	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
955c04c6-cbf7-41ca-819d-6c65c11b56d9	fabf8448-ed3b-4b8d-ab28-6f16ff68c416	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
9c930bf5-41d9-41e2-9b12-b3927dae7391	fabf8448-ed3b-4b8d-ab28-6f16ff68c416	018c8d48-0ec8-4e81-ad52-43b091840c45	secondary	2025-11-29 21:38:19.204624
46761b7f-080c-4168-b73f-248db73b4159	3813c6cb-0747-469f-9f4e-0c63846b2fa6	abadd271-e2cb-4f4f-9aa4-9aabae72db67	primary	2025-11-29 21:38:19.204624
edb68e30-e44b-4138-b744-9a8df55a8db3	3813c6cb-0747-469f-9f4e-0c63846b2fa6	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
6b4e3039-006b-45e4-8ec5-db4052c2979c	01a58ace-ecbd-4e07-85e9-dd9d92025374	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
07e0d6bc-c549-44c5-adc5-7d51847df36d	01a58ace-ecbd-4e07-85e9-dd9d92025374	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
df9c6f24-0634-4b1c-8cba-7036ded15df5	01a58ace-ecbd-4e07-85e9-dd9d92025374	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
0630927d-9f4d-4c4c-a071-a145a52f62fe	ec99a632-2f73-47f0-8a1e-2ec9c1885549	2a06511f-22fd-49cc-85da-99a0d7bd0df1	primary	2025-11-29 21:38:19.204624
3a3aeff3-f5a5-45da-8828-f1f005e4e25e	ec99a632-2f73-47f0-8a1e-2ec9c1885549	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
75c888d8-1b97-4d91-99b7-d0599713b636	acd5f253-ce68-4269-b9c0-6f95656b13c9	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
7d90a6dc-14fd-411c-be48-898c8c3c2e30	acd5f253-ce68-4269-b9c0-6f95656b13c9	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
22661ee8-9170-48f6-ad3a-750e585deb98	acd5f253-ce68-4269-b9c0-6f95656b13c9	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
a395d450-ad23-4473-80a2-efed0d83b696	86ad9163-4c2f-4b35-aa08-805e0bb86a72	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
f08c7807-df23-475d-86e0-b4161a1400b7	86ad9163-4c2f-4b35-aa08-805e0bb86a72	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
fed185c3-d7e5-4607-b77f-22a7cc159353	86ad9163-4c2f-4b35-aa08-805e0bb86a72	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
3bb913e6-78c6-465a-a740-21f13b2e055b	86ad9163-4c2f-4b35-aa08-805e0bb86a72	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
8efb9175-40ca-4c48-be32-636a1970ad51	873a693f-baf9-41a9-84d2-71f7510c1894	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
550c8745-f5ee-440b-b4ae-dc7d7008e0a6	873a693f-baf9-41a9-84d2-71f7510c1894	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
16c80132-71e6-4824-b398-f9c1746859b1	873a693f-baf9-41a9-84d2-71f7510c1894	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
2580aa3b-2b8f-4b24-b57e-8adcc54db18c	873a693f-baf9-41a9-84d2-71f7510c1894	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
57859a54-2166-4fd4-84d4-625c47383cf1	a1b20788-20e9-4b96-a36f-06700a0d6854	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
6de274fe-843a-45e1-9d80-5d84cd5b80ca	a1b20788-20e9-4b96-a36f-06700a0d6854	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
4a02a8cc-61f9-427e-9645-40f8f4b10201	a1b20788-20e9-4b96-a36f-06700a0d6854	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
8b4b1443-f5d3-4656-9820-9434c64ffb7d	a1b20788-20e9-4b96-a36f-06700a0d6854	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
8c05841d-0b61-4c01-a0e9-68233cf3dd13	a1b20788-20e9-4b96-a36f-06700a0d6854	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
f9020d10-1356-4fa5-b9ab-af9381457e2f	77933ce8-df0e-4b08-be8a-b8769459c420	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
20d97716-7cb5-474d-a0bf-abead8f2f088	77933ce8-df0e-4b08-be8a-b8769459c420	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
17c755c9-7012-4fd2-895b-07485e8650f1	77933ce8-df0e-4b08-be8a-b8769459c420	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
8f98cb38-f0bc-4507-baa5-f1b342c5ca9e	77933ce8-df0e-4b08-be8a-b8769459c420	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
e246cf86-566a-402e-9add-6480a3571cd7	77933ce8-df0e-4b08-be8a-b8769459c420	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
64bb6c13-1a99-4be3-9955-d7eaa26bcac1	5278631f-9d65-4029-9c8a-d46a65edb89b	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
44e83033-2431-4395-be4a-b66d4f9fbb96	5278631f-9d65-4029-9c8a-d46a65edb89b	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
45dde9f3-898c-4d4d-95ce-91c6d7c84a0c	5278631f-9d65-4029-9c8a-d46a65edb89b	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
e64cfd55-f69c-472a-9776-0d125f89e118	098443c2-6240-444b-9d6e-9d3af6a954a0	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
3e11da96-5163-474e-84d7-86583d23f3bd	098443c2-6240-444b-9d6e-9d3af6a954a0	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
9a861550-8def-4b09-83c3-09ce1c618335	098443c2-6240-444b-9d6e-9d3af6a954a0	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
cd167fcc-c15f-4873-8af8-a4d9fc667254	44c6b7e4-d1ce-4744-a475-9553513f1b52	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
d9a71182-be39-47fd-bc21-46c399cd1b53	44c6b7e4-d1ce-4744-a475-9553513f1b52	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
fb9f84fc-6b73-4555-adfe-a41c1bb05736	44c6b7e4-d1ce-4744-a475-9553513f1b52	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
95a74694-e8ff-4e0a-9cf6-38220143c553	92646e7f-1247-465a-944d-2f37f81564a0	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
e4923277-57db-4506-a12d-ca8b17122c7c	92646e7f-1247-465a-944d-2f37f81564a0	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
69ceae1b-7dfb-4380-a822-d62a19d4819a	92646e7f-1247-465a-944d-2f37f81564a0	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
a66c836a-c33a-4939-b555-6c7fe1029900	09e504a3-2524-48df-899a-0d0ed4a5a358	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
7a5d4696-bd35-4725-92ce-12972e664e73	09e504a3-2524-48df-899a-0d0ed4a5a358	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
6e347df9-135b-44d3-a066-0a3745a8400f	09e504a3-2524-48df-899a-0d0ed4a5a358	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
53b2e466-cfb9-4009-b549-4f856354a2a9	44454387-8369-448f-a7e2-54d503773ce0	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-11-29 21:38:19.204624
2d231cfd-28d5-4895-bca3-3923f37ee13b	44454387-8369-448f-a7e2-54d503773ce0	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
0f7c31ae-74e9-4ac8-bc6a-a8ce8e785ef0	44454387-8369-448f-a7e2-54d503773ce0	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
140eecbd-8d49-4b09-a1a8-f0fcbaed7bd5	44454387-8369-448f-a7e2-54d503773ce0	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
e5f56b57-b902-49f0-876c-7df19bfaa7c9	2981641d-f2ec-4267-9d33-c0032d73fba4	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
92b615c5-d50f-45ce-bade-b3d0bc0a5f35	2981641d-f2ec-4267-9d33-c0032d73fba4	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
aa86725e-cd3f-4beb-9e97-4e78875b2139	2981641d-f2ec-4267-9d33-c0032d73fba4	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
bae4b470-b5f4-4fd2-a7d3-06a93b08e5ea	2981641d-f2ec-4267-9d33-c0032d73fba4	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
c5db7909-0227-48d4-aa15-129474e76eff	d483a4b4-9b78-4135-ae09-348de96db487	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-12-08 22:36:51.400736
78eca679-a63a-418f-880a-df2e53796948	4eda37b2-1e29-42cc-bd84-fe78bfd4f045	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
49ef3cb4-07b6-4764-9726-f73449ba2023	4eda37b2-1e29-42cc-bd84-fe78bfd4f045	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
25273e68-925f-4182-916c-01b2dbc27c72	8fb09fe8-6871-4e1d-b3a7-3dca5e5a6e6e	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
900d3a76-2edb-4636-a8cc-0cd230570b75	8fb09fe8-6871-4e1d-b3a7-3dca5e5a6e6e	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
84d71785-c5ae-445a-bc24-a6458db1eb80	349689c5-87dd-4efe-84ee-cc1f6dd2ce7e	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
d8a6f781-1a73-4741-95f4-042e2bbfd8be	349689c5-87dd-4efe-84ee-cc1f6dd2ce7e	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
0a7401d7-2469-496a-8965-71a33ff0f42a	d483a4b4-9b78-4135-ae09-348de96db487	018c8d48-0ec8-4e81-ad52-43b091840c45	secondary	2025-12-08 22:36:51.400749
88868ef7-ac49-443d-a6e0-771ae57dfd58	afbb218b-fa3d-49cf-b7cf-8e0642bab3ed	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 23:21:35.089489
99a2fb9d-169f-44b4-8f24-59e4a711603b	cbb47703-379e-4d82-8d82-fd27537cdf76	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
ecd730c8-7a88-45be-a427-988f914f9e19	cbb47703-379e-4d82-8d82-fd27537cdf76	7ae11464-3f30-47ce-ab9e-5fae4a225805	secondary	2025-11-29 21:38:19.204624
d5ab656d-abb8-4f48-8f57-ab3057802670	afbb218b-fa3d-49cf-b7cf-8e0642bab3ed	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 23:21:35.089503
d0cd183c-7b1c-4035-8b26-72b47d6123d2	93523bc4-42be-47da-8286-fb628887bf5f	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-12-08 23:24:48.621061
f093fd09-37ef-41a5-b7ae-b51450ea5b06	93523bc4-42be-47da-8286-fb628887bf5f	936a7751-7076-4802-821c-33fc87546897	secondary	2025-12-08 23:24:48.621068
e125ca6c-56a2-4b1c-8a3d-942bf1933ec2	93523bc4-42be-47da-8286-fb628887bf5f	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-12-08 23:24:48.621073
52c3480a-bbc0-4eba-91ad-3029e0084126	8f77ef33-bbb3-40ff-963d-b0d34a12652c	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
e76086e4-1e2a-493e-a5ac-9c5468954519	8f77ef33-bbb3-40ff-963d-b0d34a12652c	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 21:38:19.204624
5d0ba1eb-68ac-44a0-ac9d-89f0ccde99a8	659dd679-0b5e-493e-87d3-02b2c6ab4836	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
5ddc0a1a-8481-47e9-8a9d-b7ce050daaa1	613bfb65-bfde-474e-8404-ced4adeb323b	647be680-283b-4014-a57c-03eb2feb33f4	secondary	2025-11-29 21:38:19.204624
a511c446-4223-4935-a177-efa46f99984d	613bfb65-bfde-474e-8404-ced4adeb323b	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
f53ad5c1-7770-4a79-ba0d-19b145002be9	8b90fc50-b3e2-4de3-ba55-2c1e7ba5153b	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-11-29 21:38:19.204624
9a1e75b5-3a00-46f3-87e5-c4f83da19f52	8b90fc50-b3e2-4de3-ba55-2c1e7ba5153b	018c8d48-0ec8-4e81-ad52-43b091840c45	secondary	2025-11-29 21:38:19.204624
7e72cf38-b111-471e-9fce-2423715f6a95	e578906d-fcfc-400c-80fb-d953c8ad1c05	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
138618fe-2cc1-4fcd-9d44-87349c14cb65	e578906d-fcfc-400c-80fb-d953c8ad1c05	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	secondary	2025-11-29 21:38:19.204624
38d94c60-c864-413b-aa76-937c06c687b9	2320d84b-4474-4e73-ab89-97eea65e6c5e	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
242a5f83-7c50-4e62-86cf-e2f63a4bed47	2320d84b-4474-4e73-ab89-97eea65e6c5e	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
a109df88-e847-4be5-9bb8-3e7ace1afa4c	9457341a-48cc-452a-9a06-e21f12591341	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
15f4ff0d-1ec8-404d-b5ec-89f52388d9d3	9457341a-48cc-452a-9a06-e21f12591341	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
9aa55ab4-a363-4b63-bc14-f16dfb84161f	ac0fa73b-c23e-4531-9a06-1daae941d022	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-11-29 21:38:19.204624
c1f7210d-910d-40fb-92cb-ea7a843bea91	ac0fa73b-c23e-4531-9a06-1daae941d022	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
a092dc7f-e4c3-4ec3-8eec-d7fb523b9e68	3f9b3503-9ddd-4a54-bd4a-62a07b4ca2af	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
a36721ef-1e61-4df4-a4b5-4a187ee4c825	3f9b3503-9ddd-4a54-bd4a-62a07b4ca2af	7ae11464-3f30-47ce-ab9e-5fae4a225805	secondary	2025-11-29 21:38:19.204624
cca31001-4cdd-4f44-8b0a-703b4c684261	b7fba09d-c119-4eff-8d06-88880c9e0ee3	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
220c29d5-5039-4eac-b666-9e6e9dfe8067	e8f83a19-7d60-4b15-94f5-debe51c4e341	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
d5b07645-c236-4068-a75d-0911885145c1	b103746c-91e4-41ed-a6b1-0e379dd78d0c	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
d830540b-d0d8-4124-947e-79a3247fe0f3	b103746c-91e4-41ed-a6b1-0e379dd78d0c	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
b6c078df-699c-4aa3-8e74-f10396c78dce	254dac1d-ca3e-4e21-867d-a535e900da56	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-11-29 21:38:19.204624
65ebd24d-a3ce-4221-83c7-5c75249eeb41	254dac1d-ca3e-4e21-867d-a535e900da56	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
62145bf9-18e1-434c-b60a-6875c85856df	bc53946d-16e3-4534-831c-713ec3429461	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
1f97b4a6-6653-4332-8e38-8c3510569ceb	bc53946d-16e3-4534-831c-713ec3429461	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
07a60de1-4157-438c-b9fb-8bb72ad2eaa1	bc53946d-16e3-4534-831c-713ec3429461	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
95d27cb8-f02f-46db-be69-d578d490bfc0	61144002-0b86-4cec-bcce-84f185fac9a3	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
7dbd187a-43cb-4bd8-ac6a-9e290b15af2a	81addbb4-c1b9-4a36-9cfd-dfd607f96036	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
816dd87b-d057-499c-a106-66659a590229	81addbb4-c1b9-4a36-9cfd-dfd607f96036	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
c0563631-7c30-4378-891a-a2a15c5db393	6639b4e0-8f09-44d5-8077-73e29b4cfa6d	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
c60b1b12-a66c-42c5-a10a-64818bafbbee	6639b4e0-8f09-44d5-8077-73e29b4cfa6d	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 21:38:19.204624
26a8bf96-9627-4cf3-9940-ac35159c8a87	6639b4e0-8f09-44d5-8077-73e29b4cfa6d	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
a25baeac-8e4c-4fbe-a257-5600fc50e4ad	9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-12-08 23:27:35.691239
10cf86df-a3bf-4e40-a631-b8f9ec1fe043	9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-12-08 23:27:35.691244
d0dc47d5-f029-401a-be35-da267d8e66f2	9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-12-08 23:27:35.691249
09bc9567-39a7-4019-aaf1-13c2a74b3645	9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-12-08 23:27:35.691253
82554b59-977e-44f8-b440-287004a198bf	2e5fdb7e-8a24-474b-bb4a-4ac86fd96d57	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
2a417281-511e-4ec8-bd95-26a6854b6b58	2e5fdb7e-8a24-474b-bb4a-4ac86fd96d57	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 21:38:19.204624
56e81d13-fed9-4f5b-863b-21fef64846a7	dab3a0cd-09db-4cad-8815-5ab04dd548ac	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
85eca5fc-ad49-4d97-9af5-240285661a7e	dab3a0cd-09db-4cad-8815-5ab04dd548ac	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
cfa69794-5a3e-40f1-8ea3-dd0309a6b35a	dab3a0cd-09db-4cad-8815-5ab04dd548ac	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
4f3e3911-2aef-4e04-8e32-3aded64adf0a	46db6fb8-ade5-4b1c-b1de-aefe7f46b00b	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 21:38:19.204624
1bfc2d77-139c-4fc2-83d1-cfbdbaab14a2	ae2fd8ee-e4e3-4cb9-b8e0-79eae1f76522	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
58e639eb-c92b-4dfe-9ab0-ed6f95af0e8a	f78d4747-f546-4c2d-9c89-402c6396717a	42193381-087e-4fb5-bfb1-ae4edba6aa4a	primary	2025-11-29 21:38:19.204624
7ca3b9db-1601-4d27-a752-4d48a6f3b678	f78d4747-f546-4c2d-9c89-402c6396717a	91652340-844c-43d3-80da-de1ce7304a48	secondary	2025-11-29 21:38:19.204624
94a9091a-3c2d-41c2-adc9-5808f5e7a59b	bf6579b5-5704-45ef-94b0-6eac92d3a45e	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	primary	2025-11-29 21:38:19.204624
3d2c839c-0daf-4caf-b66e-105f35d6cfe4	ce1040e4-784d-415f-a36f-e3d81402960e	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	primary	2025-11-29 21:38:19.204624
5a3dedfc-8857-463d-9750-4d994d2d3432	881afbd4-8895-4591-82ec-96b64f80a352	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	primary	2025-11-29 21:38:19.204624
efc5384c-a57b-49fe-8cd5-c501132cb79e	fc140b0a-4244-45fa-8a77-2e28df28a3ac	f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	primary	2025-11-29 21:38:19.204624
fa8b5aaf-3ee8-4ae0-a4c3-70a558619ff2	fff16b04-1581-4369-ba5b-e68296e777a5	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
afd9adc8-3393-4e33-a4f2-6bed8303768e	fff16b04-1581-4369-ba5b-e68296e777a5	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
e7556bc3-4b35-46cd-9fcf-e54dff1795f8	fff16b04-1581-4369-ba5b-e68296e777a5	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
ef24b9ce-092c-4e04-b27d-38670c1af7a6	8992461a-fec3-4eb2-8bff-6d5ed82380ff	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
917dda0f-1433-4a68-b986-4bb4fd96a830	8992461a-fec3-4eb2-8bff-6d5ed82380ff	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
a2224711-5a37-4bed-ac60-c7d8300a0ce7	8992461a-fec3-4eb2-8bff-6d5ed82380ff	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 21:38:19.204624
12f92543-9bf7-4e64-a642-0273cebe0559	cb0f187d-d525-4594-a69f-b45a2588dd20	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
67683fc1-c153-4dbb-9ba5-ea5282704968	cb0f187d-d525-4594-a69f-b45a2588dd20	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 21:38:19.204624
e7bf925a-7bb4-40dc-b23c-c95e8e33a1e5	cb0f187d-d525-4594-a69f-b45a2588dd20	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
fe17ec6a-a97a-4d14-8b63-1ec6b708ba5e	78a34a1c-0b0d-4e05-a8e4-bc56283d1a2e	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
2010f6fe-bac7-441d-89db-df260c07d9a6	78a34a1c-0b0d-4e05-a8e4-bc56283d1a2e	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
7270727c-8307-4c2c-b490-668a06b78de9	78a34a1c-0b0d-4e05-a8e4-bc56283d1a2e	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
63962bc7-db97-4eff-a801-7f359947cddc	2f4af852-c63b-4289-93ae-71ff952f4a02	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
8292d589-a845-4103-b55d-2ff8c29c6e28	2f4af852-c63b-4289-93ae-71ff952f4a02	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
2f1f17b2-a859-48a8-8c9f-34b807b7082b	2f4af852-c63b-4289-93ae-71ff952f4a02	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
d7f6366e-a1c1-4edb-952c-c88b25b5ef01	25f6cf0f-d16e-4f00-88df-70e803aeb41f	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
0031aff6-4fd1-47dd-a7fd-5fcb61b4142c	25f6cf0f-d16e-4f00-88df-70e803aeb41f	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
b01358d4-e609-487f-9f1c-a8683447ca03	25f6cf0f-d16e-4f00-88df-70e803aeb41f	647be680-283b-4014-a57c-03eb2feb33f4	secondary	2025-11-29 21:38:19.204624
6b7f0319-79c6-466a-a476-65cf65c630ca	a245ce1d-1f11-4174-b7ff-5a4bdedf51b9	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
8efa8140-5c9c-4a20-acc9-e0bb3bedf5d6	a245ce1d-1f11-4174-b7ff-5a4bdedf51b9	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
2ee7b1b8-9a89-4038-b20a-df25ebe1c471	a245ce1d-1f11-4174-b7ff-5a4bdedf51b9	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
48b5de3f-85f5-4356-8761-81f640ef5c59	1d371fc9-8617-4557-b323-d7b9b700c472	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 21:38:19.204624
cb7b9608-adec-4aae-bba5-53dd820f66b8	1d371fc9-8617-4557-b323-d7b9b700c472	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
94577ae1-5d55-4317-86ab-10c419c3b291	1d371fc9-8617-4557-b323-d7b9b700c472	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
59ba3016-8c07-4246-b01d-134ec26b12b5	7506b5f6-3890-4a58-92b5-a4782676492a	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 21:38:19.204624
6d0ea80f-dd33-46b6-b6e7-50bc9614a9a0	7506b5f6-3890-4a58-92b5-a4782676492a	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
03c08295-ce0c-4899-8b00-4130a01520de	0956d3e5-dda2-4dc5-bf55-ba99da6758da	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
de463c92-60b1-494a-aeaf-256c4079eb24	0956d3e5-dda2-4dc5-bf55-ba99da6758da	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-29 21:38:19.204624
66eb82d4-4aab-49f9-9215-bb167da4495e	0956d3e5-dda2-4dc5-bf55-ba99da6758da	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 21:38:19.204624
5734d6f1-dad4-4f4a-b9c1-d0fc02e659f4	0956d3e5-dda2-4dc5-bf55-ba99da6758da	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-11-29 21:38:19.204624
0d537a45-d2c0-40e2-bd54-aa2d67cba689	45d2cb8f-e2cd-4242-8c03-d7570c8189f4	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
82f0aac5-ef30-4d23-b87f-8666513ac1c7	45d2cb8f-e2cd-4242-8c03-d7570c8189f4	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
7ae74f4c-2778-4bc7-bce9-72a622527e27	45d2cb8f-e2cd-4242-8c03-d7570c8189f4	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 21:38:19.204624
a95fdde0-f957-47bd-9b54-2e7243a385cd	9b9ac85f-2bf1-4382-8bca-6301e4304b02	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 21:38:19.204624
19a61715-c807-4478-b990-149869ba9e4b	9b9ac85f-2bf1-4382-8bca-6301e4304b02	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
cb7881c3-4c28-4e20-9253-1b44587eeebd	9b9ac85f-2bf1-4382-8bca-6301e4304b02	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 21:38:19.204624
ded896bd-8073-4cbc-8c20-a41cd4b747fe	ad7e8942-08b8-49d8-8352-532edfefcbdd	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 21:38:19.204624
aeddc744-7212-458b-82fe-f5aee272a246	ad7e8942-08b8-49d8-8352-532edfefcbdd	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 21:38:19.204624
ca2f59a9-0bf0-49e9-a967-bbe0cd138f55	ad7e8942-08b8-49d8-8352-532edfefcbdd	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 21:38:19.204624
44efd207-a852-4d73-ba4f-33cb967bd039	442ff8a8-20d8-4259-b398-5b1d1ee2d038	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 22:20:27.458588
f3ad08e7-4933-480e-926f-3fc134832280	442ff8a8-20d8-4259-b398-5b1d1ee2d038	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 22:20:27.458595
e2457979-46d5-4e68-9e46-dd70867b35cb	442ff8a8-20d8-4259-b398-5b1d1ee2d038	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 22:20:27.4586
dcd5a793-94ac-435c-9d9c-66f29b550447	1aa24acf-9fa5-498c-910b-78358dfaf362	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 22:20:42.00431
aa4252d4-5c6d-416a-b137-d51b978e8dfe	1aa24acf-9fa5-498c-910b-78358dfaf362	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 22:20:42.004318
b45822e4-8462-4105-9989-cbf35da48d22	ffe46193-27da-4485-9d62-ee07a4c168a6	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-12-08 23:27:49.682379
8b698cfd-da0c-4b2f-a94b-eb1b4f03f3bf	ffe46193-27da-4485-9d62-ee07a4c168a6	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-12-08 23:27:49.682387
790cf448-6a58-41b0-a454-eacf50dab439	ffe46193-27da-4485-9d62-ee07a4c168a6	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-12-08 23:27:49.682392
78f98a84-77ad-4e2e-8287-0ceba3d3fba2	ffe46193-27da-4485-9d62-ee07a4c168a6	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-12-08 23:27:49.682396
45299275-ebed-4b08-86f5-c120f678b2ae	b886bfd5-6bd2-41be-98c8-9ac9f8d23fc5	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 22:49:43.098286
4cf01938-405c-433c-a18f-568b5b7c9445	b886bfd5-6bd2-41be-98c8-9ac9f8d23fc5	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 22:49:43.098291
8768673e-212e-4b08-8852-8bea7eb3a38e	b886bfd5-6bd2-41be-98c8-9ac9f8d23fc5	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 22:49:43.098294
a93e1a6b-742a-4b87-9dda-2c71dedb6fbb	4e13fe45-9aac-4a33-8abe-f5efed940440	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 22:50:50.549056
2bba2466-9ff4-4b6f-b5d1-097767b8a541	4e13fe45-9aac-4a33-8abe-f5efed940440	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-11-29 22:50:50.549063
2b5c159e-7de7-40ec-aa5f-40e11f538efb	4e13fe45-9aac-4a33-8abe-f5efed940440	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 22:50:50.549067
7bc0d140-d9a3-47f2-a34a-012d64935373	c4e8fbc7-b3e1-4f40-9f01-d6e5dbe275c8	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 22:51:36.561246
083904b3-f32f-486b-a76a-d9281393d821	c4e8fbc7-b3e1-4f40-9f01-d6e5dbe275c8	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 22:51:36.561252
453a96f1-1de8-4450-922a-5e609ccb0050	85a6425e-8ff0-40c2-b171-d6c404c9ee40	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 22:52:18.856919
68ca3cc6-6252-40de-bf9c-43ca9f3fa21c	85a6425e-8ff0-40c2-b171-d6c404c9ee40	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 22:52:18.856925
8493fb20-0c7f-4300-8ae2-693155217e1c	85a6425e-8ff0-40c2-b171-d6c404c9ee40	647be680-283b-4014-a57c-03eb2feb33f4	primary	2025-11-29 22:52:18.856928
e67d738d-2a54-45fc-ae2f-841fb8b179ef	85a6425e-8ff0-40c2-b171-d6c404c9ee40	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 22:52:18.856931
b5ac0da9-7a0f-4334-8352-df2bd77fac72	85a6425e-8ff0-40c2-b171-d6c404c9ee40	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-11-29 22:52:18.856934
3bd5445d-a53f-4633-acde-ef05916d8dee	8e5a5996-e52a-4fac-bb94-c475d85cfb36	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 22:54:07.1587
565b9e57-1acb-45cd-ab18-b8be84f539fb	8e5a5996-e52a-4fac-bb94-c475d85cfb36	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-11-29 22:54:07.158707
417e84bc-f012-4e1b-bb3a-d6b3a9720360	8e5a5996-e52a-4fac-bb94-c475d85cfb36	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 22:54:07.158711
bdad9344-9cfc-440f-aa33-10fd1bec3f62	8e5a5996-e52a-4fac-bb94-c475d85cfb36	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 22:54:07.158714
5d3e73ee-db3e-4f9c-82e9-519a9eb09e3f	b71bc548-189e-40a3-84dc-a826b521b5d4	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 22:54:44.608939
37ddb818-cd36-474b-a643-852923bdf146	b71bc548-189e-40a3-84dc-a826b521b5d4	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 22:54:44.608944
41a1ce4c-92a9-4204-a33d-66889ab7efc1	b71bc548-189e-40a3-84dc-a826b521b5d4	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 22:54:44.608948
56352bef-449b-48e8-81ef-f59427b81766	d03a2816-e622-4c66-b843-2a82f55f6d24	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 22:56:33.494355
5fa079b1-7b7e-4453-b99c-4312d9d1aa46	d03a2816-e622-4c66-b843-2a82f55f6d24	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 22:56:33.494361
4763c160-ebf8-4fa5-9716-19ff8dbabf33	d03a2816-e622-4c66-b843-2a82f55f6d24	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 22:56:33.494364
b8acfbf9-7ce3-478a-9f9b-a9c526a1f2ac	180cac0a-9343-4208-9762-bacad127a9e8	abadd271-e2cb-4f4f-9aa4-9aabae72db67	primary	2025-12-08 23:30:24.384239
e0243df7-4e4e-4601-bae8-4a030318370a	180cac0a-9343-4208-9762-bacad127a9e8	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-08 23:30:24.384246
3afa9048-04ce-45e3-ad4f-fac03e126fd7	180cac0a-9343-4208-9762-bacad127a9e8	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 23:30:24.384249
512bb376-83d4-4e4e-98ec-b83107ab054a	18d50e17-4bce-4d39-8071-c93d969b7696	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-12-08 23:32:14.197813
5363916d-11bf-464a-804f-c1559438beb3	18d50e17-4bce-4d39-8071-c93d969b7696	936a7751-7076-4802-821c-33fc87546897	secondary	2025-12-08 23:32:14.197821
bf18eb1a-b353-4e4a-8eb6-5c3f73688c96	f89614fb-f6ed-4733-877f-e357906c4925	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 23:06:10.057354
fe155966-4ee9-4787-b0d5-8d59147cecf1	f89614fb-f6ed-4733-877f-e357906c4925	647be680-283b-4014-a57c-03eb2feb33f4	secondary	2025-11-29 23:06:10.05736
36f5226c-8f1c-4167-ac1b-76f0b82a47bb	7027654b-575d-49b8-8e26-e70bc76966b1	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 23:10:29.588239
7b275901-ab0b-4f85-9305-43a922ad2583	7027654b-575d-49b8-8e26-e70bc76966b1	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 23:10:29.588244
ab772254-fd3e-4211-9e68-666a4ca7773c	9538101e-512b-41a2-aec6-831b9f35780e	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 23:12:58.395791
580b0030-eb9f-42f8-b5ad-57cb25874734	9538101e-512b-41a2-aec6-831b9f35780e	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 23:12:58.395797
d6f5dbdb-889f-4d5b-8afa-c477d129fa2f	0e27b27f-1558-48e0-9e09-6a950d63d6f7	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 23:14:30.173714
2a1d0159-a035-404c-bd35-31dbe8e94e92	3fb2ab04-137c-44ce-a16b-d4b12c818172	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-11-29 23:16:48.937456
0429bc84-eb45-4f6c-b180-cd9a97348c8d	3fb2ab04-137c-44ce-a16b-d4b12c818172	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 23:16:48.937461
1a19c71f-b840-4268-8953-696ce627782d	e25515d5-4d65-446d-869e-cfb2cab39ff1	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 23:19:19.645053
a6322743-87f0-4dc5-bf1f-d053588a9eb6	e25515d5-4d65-446d-869e-cfb2cab39ff1	018c8d48-0ec8-4e81-ad52-43b091840c45	secondary	2025-11-29 23:19:19.645059
e42e5ba9-c7eb-4f41-a16d-bf338f8eb37d	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 23:20:32.179101
36dad711-51ae-4ed1-843d-d6cadf50bc89	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-11-29 23:20:32.179106
07fcc9f4-8a1b-4949-8775-16429a51cc38	f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 23:20:32.17911
bd0cc66c-2692-4a30-b159-bae720e364f1	ade38363-28c5-43c3-8f9e-711a997b0683	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 23:21:52.214516
0f692069-3c84-4602-96fd-9195b5c13b45	ade38363-28c5-43c3-8f9e-711a997b0683	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-11-29 23:21:52.214526
b9e1941a-be8a-426a-9a97-79e7dbc62adb	ade38363-28c5-43c3-8f9e-711a997b0683	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 23:21:52.214532
07ef98fc-6aba-4e21-85d1-122d7793a230	cdaa6012-b647-4168-aadc-58c1d033b3bb	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-11-29 23:24:40.255159
df948712-4349-43b5-b697-0a9207c1d006	cdaa6012-b647-4168-aadc-58c1d033b3bb	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	primary	2025-11-29 23:24:40.255165
01668bf9-8520-42ff-9f74-88bae1979427	945a062b-0bfd-49b4-9bfc-3617fe1fad76	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-11-29 23:28:06.648671
380f45e0-9e66-4a62-adaa-a2cebe01b59b	945a062b-0bfd-49b4-9bfc-3617fe1fad76	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 23:28:06.648682
0d7e0579-eaaf-4a5d-b584-722bd7d763ad	18d50e17-4bce-4d39-8071-c93d969b7696	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-12-08 23:32:14.197825
7b8b51ae-fab4-4a4b-80f5-67d4062f0d61	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 23:29:40.956956
25d59473-bebe-45b8-b3b8-bfa6d36466a1	b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	7ae11464-3f30-47ce-ab9e-5fae4a225805	secondary	2025-11-29 23:29:40.956961
1e69ae83-6967-4b46-9066-68046c1ed03a	e575c180-fd48-4cde-8c67-86b784dc5220	936a7751-7076-4802-821c-33fc87546897	primary	2025-12-08 23:36:12.849457
a7d958d9-d753-48a6-8afa-421b87553859	b04c66f3-b76c-443a-a7b4-2d89da9dd266	936a7751-7076-4802-821c-33fc87546897	primary	2025-11-29 23:35:33.592727
8e90b27a-6fc0-4826-8d2f-bc2f95d52c98	e575c180-fd48-4cde-8c67-86b784dc5220	42193381-087e-4fb5-bfb1-ae4edba6aa4a	secondary	2025-12-08 23:36:12.849465
16a69e32-79ec-40fc-97bf-4c2b16d4f38f	e575c180-fd48-4cde-8c67-86b784dc5220	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-12-08 23:36:12.84947
2792df18-02c3-4607-a85b-2538593ecddf	58c9abd8-de2f-456d-8321-32b773457487	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 23:37:10.183051
611065f2-06b9-4e44-86ab-246af37bc56a	13e1a0d1-c18d-47ad-a80e-d2313395e432	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 23:46:57.350908
cf23434d-cee7-4c2e-9d86-a793fc39fe09	13e1a0d1-c18d-47ad-a80e-d2313395e432	647be680-283b-4014-a57c-03eb2feb33f4	secondary	2025-12-08 23:46:57.350913
653540e8-da52-4208-8f87-d78c8efe2992	61117023-fca8-49a7-a914-e8fddd9350af	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 23:51:23.672292
b0301a45-7712-4f3b-b6c7-3bff5215e571	61117023-fca8-49a7-a914-e8fddd9350af	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 23:51:23.672298
20c75a61-1d19-4a18-b2ab-996cc09f8885	71650a04-03a5-4fc9-980e-123ee302f86a	936a7751-7076-4802-821c-33fc87546897	primary	2025-12-08 23:55:35.251388
d57a4e20-436e-4f6d-9b5e-24ec6c811c68	f884891b-550e-46db-bb76-d5e2709e075c	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-12-08 23:59:10.652648
ec0c8e56-4093-466d-a30e-1262e9f80556	f884891b-550e-46db-bb76-d5e2709e075c	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-12-08 23:59:10.652655
1b61c8cd-4c5d-4fbe-a851-5b41878e2946	f884891b-550e-46db-bb76-d5e2709e075c	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-12-08 23:59:10.65266
fbdd1e1f-d922-428e-8c0b-0a913ba8446d	45ffd819-86b1-4f9f-998c-d0707edb1b8c	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-11-29 23:38:57.693897
5d25bf23-0dc9-49d9-9af2-c8675fdf5f17	45ffd819-86b1-4f9f-998c-d0707edb1b8c	936a7751-7076-4802-821c-33fc87546897	secondary	2025-11-29 23:38:57.693903
64cb6aad-0aa4-447f-9893-2bb28c1bd786	be1663cf-6c5a-47cd-b427-0865baaf77e8	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	primary	2025-12-08 23:39:01.533147
39dc6afb-eb29-40f4-b465-95f9c7113697	be1663cf-6c5a-47cd-b427-0865baaf77e8	018c8d48-0ec8-4e81-ad52-43b091840c45	primary	2025-12-08 23:39:01.533153
1e94f305-6327-4f88-9577-5452f63614d2	06ca48f5-bfcc-4ffa-964b-48eddafab389	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-29 23:43:40.238787
e6377324-cec7-4fdf-959f-c107c0166509	06ca48f5-bfcc-4ffa-964b-48eddafab389	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-29 23:43:40.238793
f47a5a2c-f071-466f-8580-4cedd2f61844	490a8870-e9f7-4a54-8444-6679403cd12c	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-29 23:48:20.006908
fac898dd-c82e-4c3c-8731-ed24c43304cf	490a8870-e9f7-4a54-8444-6679403cd12c	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-29 23:48:20.006914
45ee392c-1151-4897-85d1-d1e39c6230e3	490a8870-e9f7-4a54-8444-6679403cd12c	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-29 23:48:20.006918
5e86bd64-18d6-43b4-98c8-77f7843f129f	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-29 23:57:29.760486
397711fa-c140-4c0a-af87-38b7e0086e3b	35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-29 23:57:29.760492
81f9aafe-7f14-4f82-90e1-fe84dd365b95	797aa448-10ec-49cf-b0b4-7cb589844710	a70b9f88-0317-4c0f-9de1-01679cfaedcb	primary	2025-12-08 23:41:38.665021
98ee4c21-94e3-4f8c-9314-8127a97514c2	bad51b6d-2654-4c25-b69e-ba9c5f094449	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-12-08 23:43:06.227579
db259e8b-e34b-45c3-bfc1-bd2dfe8af9d3	bad51b6d-2654-4c25-b69e-ba9c5f094449	a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	secondary	2025-12-08 23:43:06.227584
87c6572b-ab4a-4ade-a7fa-2f166cffe4c4	bbbee470-42c9-45fc-aee1-3455ed5599c6	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 23:45:17.193637
63600550-f99e-4938-b751-581635a737e8	bbbee470-42c9-45fc-aee1-3455ed5599c6	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 23:45:17.193642
9d73ed35-fd12-4e1a-b289-6807e6eede98	bc9b3a59-10da-4b32-b126-bebea984581e	2a06511f-22fd-49cc-85da-99a0d7bd0df1	primary	2025-11-30 00:56:58.082133
aa61472f-a85d-455e-a3fb-618e91cb2dc9	09607947-3376-4fd7-bc0d-5386825c73bf	2a06511f-22fd-49cc-85da-99a0d7bd0df1	primary	2025-11-30 00:58:45.476699
113c25f4-bdbb-464d-ad85-7ffce8c5ab59	bcc75aab-390b-4e8d-be43-b76bf5ff3466	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-11-30 01:11:10.966444
3ad2b296-2efa-4b83-aa22-ae2b3ea04108	bcc75aab-390b-4e8d-be43-b76bf5ff3466	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-11-30 01:11:10.966452
971d09f2-65f2-4383-9525-db2d233231ea	bcc75aab-390b-4e8d-be43-b76bf5ff3466	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-11-30 01:11:10.966458
e12d8826-25d7-4c81-a2b9-a306cf04cc76	bbbee470-42c9-45fc-aee1-3455ed5599c6	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-08 23:45:17.193645
1bd9e412-e50a-4884-9f0f-84fdb4cb5af0	defba1ad-1834-410c-9a1e-6833a42ce87d	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-12-08 23:47:52.950693
2bbcd78a-249f-4b5b-b5f9-73a144b54db7	2b384748-2af0-4941-88fe-2a589bd3aeb4	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-12-08 23:48:34.383385
054f4acf-d6e6-4315-b67e-9d89a121931f	2b384748-2af0-4941-88fe-2a589bd3aeb4	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-12-08 23:48:34.38339
6ace31ce-3294-4da5-8b32-acdb7787fdbc	a65dc37c-13ad-448d-8ef7-a31d938c7ead	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-11-30 01:13:39.881753
abb282e9-98ac-4ee0-ae9c-5b65495c7d2c	a65dc37c-13ad-448d-8ef7-a31d938c7ead	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-11-30 01:13:39.88176
de044bbe-baff-4bf6-b83d-674e73865f39	a65dc37c-13ad-448d-8ef7-a31d938c7ead	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-11-30 01:13:39.881764
6a6bfb33-7f08-442a-a550-6f681e3cdd50	a65dc37c-13ad-448d-8ef7-a31d938c7ead	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-30 01:13:39.881767
2f975235-43a0-4347-a945-6e15cf21c88f	2b384748-2af0-4941-88fe-2a589bd3aeb4	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-12-08 23:48:34.383393
e4ef68a6-3e9f-4212-acc5-e73ba363634b	8733deeb-0ceb-4541-a027-94e00a95586b	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-12-08 23:50:06.087715
d63094e9-f7e8-4eba-92bc-430ea7b9e17a	8733deeb-0ceb-4541-a027-94e00a95586b	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 23:50:06.08772
8bfb5b24-76a1-4c4d-96f7-6027d6edbc74	a7e34918-49a4-47ef-aeba-69c4fb324fe8	d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	primary	2025-11-30 01:22:04.067379
ef6ce12d-5b02-496c-8c1c-16409e9a1a99	a7e34918-49a4-47ef-aeba-69c4fb324fe8	a70b9f88-0317-4c0f-9de1-01679cfaedcb	secondary	2025-11-30 01:22:04.067387
689ac3c0-e453-4675-b868-37aabe0c184a	a7e34918-49a4-47ef-aeba-69c4fb324fe8	7ae11464-3f30-47ce-ab9e-5fae4a225805	secondary	2025-11-30 01:22:04.067391
5640ad7a-fb8b-4363-82c4-d71e16486cd5	a7e34918-49a4-47ef-aeba-69c4fb324fe8	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-11-30 01:22:04.067395
1e951ad8-14ca-44f8-9fff-c36b3242ccfa	1dd47ff8-ab0e-4468-89b5-ef58218fb071	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-01 16:59:21.526822
84160478-f193-467d-872e-2786dd070b8f	1dd47ff8-ab0e-4468-89b5-ef58218fb071	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-01 16:59:21.526831
8389141a-7c3e-41e8-990d-b3265366e37d	1dd47ff8-ab0e-4468-89b5-ef58218fb071	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-01 16:59:21.526838
248b72ce-f346-4998-a594-4d32c0f0b766	8733deeb-0ceb-4541-a027-94e00a95586b	abadd271-e2cb-4f4f-9aa4-9aabae72db67	secondary	2025-12-08 23:50:06.087724
0ee5c8da-4f4c-4ed9-97cb-e0018d089345	5941db40-0f07-47b8-a9e2-f31bc44d9710	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-12-08 23:54:11.947585
f0fd937c-7986-4781-a1e8-2084750f431d	ac7717a4-4e37-4cc2-9050-b4185af9c34c	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-07 00:45:28.198758
2b4f0745-d8b9-4832-92f9-a2f922c6d054	ac7717a4-4e37-4cc2-9050-b4185af9c34c	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-07 00:45:28.198769
61cf53de-eefa-407f-918b-0f2380aff931	b95b0ba1-fa46-49cb-94d5-bd07fd62f844	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 15:09:14.20003
b27e1bec-344d-4089-bf6c-4d9ab74df87c	6cd9c5f9-38db-401d-8099-b64a7e580c5f	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 15:28:39.814743
aa2d1495-1411-4f87-ae04-1a57b6b1faeb	b3b03d37-e041-4fdc-8bc1-87487b47d769	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 16:05:23.474034
31cc136b-b6b1-4701-9d50-d9d5e0e3590f	b3b03d37-e041-4fdc-8bc1-87487b47d769	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 16:05:23.47404
a49c8ea8-53d6-46ea-9205-b71a9dd846e0	b95b0ba1-fa46-49cb-94d5-bd07fd62f844	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-12-08 15:09:14.200035
3dd46e79-7a08-48b8-b68b-d609b83e9874	dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 15:26:05.924789
0ac076fd-ae9f-4a3b-a711-d5ddcb135444	3aeb6a7d-b69f-4fc5-bcb8-14e04221ae11	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-12-08 15:50:11.195949
979d60d6-5b1a-400b-9995-a49efc0c0438	92ec1a6d-9108-4fa0-93f9-7e1b11b753e8	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 15:51:58.008316
3593e05c-fa78-441f-a1ee-8ca62aed2f6f	da02760a-78ad-410c-aedc-d8bba31198dc	99e28019-b7bc-4278-b4eb-0b9bb53878f6	primary	2025-12-08 15:53:11.033485
aa8b4afd-330a-4f75-883f-263cbf6c742e	da02760a-78ad-410c-aedc-d8bba31198dc	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-12-08 15:53:11.033491
21920fc3-8a67-45ca-97be-370dd3cdf7cd	e79f0884-280f-4e5e-9659-4df058afb828	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 15:54:20.55414
7d8c50d1-95e3-450b-a396-37f9b5129201	e79f0884-280f-4e5e-9659-4df058afb828	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 15:54:20.554145
de4b8c9c-8f6c-475f-9b62-82e3be661990	e70ccada-9057-4466-a8ba-f706f2b4438c	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 15:57:42.990999
09200d73-5447-4bea-ba81-c46127973b29	4eafd2c5-8de8-422c-9f27-90289f970e16	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 18:49:40.713704
29193462-2d96-432d-a607-b5d28b4d62d2	4eafd2c5-8de8-422c-9f27-90289f970e16	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 18:49:40.71371
b2fcd71b-0d97-44ce-a7ab-0fe16efebd74	4eafd2c5-8de8-422c-9f27-90289f970e16	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-08 18:49:40.713714
1df92db5-19fb-49a2-99db-9ec19677f428	acc5f43d-ecdc-46c9-bde8-3f2979199e80	91652340-844c-43d3-80da-de1ce7304a48	primary	2025-12-08 23:57:11.362415
77417b04-94d3-49bb-b763-55bb80b7b1a3	acc5f43d-ecdc-46c9-bde8-3f2979199e80	936a7751-7076-4802-821c-33fc87546897	secondary	2025-12-08 23:57:11.36242
8453fd83-1186-4166-ace7-ccd7d7cb79dc	6cd9c5f9-38db-401d-8099-b64a7e580c5f	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 15:28:39.81475
a7eafed7-735c-4391-a402-4c69378af3e8	155ee3c5-a401-4644-a6c5-06bed7a187a8	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 15:31:32.080318
3f700c83-dbd1-4ca5-b7d7-75061a175220	155ee3c5-a401-4644-a6c5-06bed7a187a8	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	secondary	2025-12-08 15:31:32.080325
41c094e0-031b-4136-b51c-eb2b82c81901	e74733e1-43cd-43f9-9945-c1b0a50fadc9	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 15:46:19.097535
7cc25bbd-ca57-4546-a37f-816cc90deb5b	e74733e1-43cd-43f9-9945-c1b0a50fadc9	c1b71264-dafc-4e42-99f9-92df8b91fe5d	secondary	2025-12-08 15:46:19.097541
a0dfaee4-1969-4f68-9156-d3f1ccded6ff	1da215b2-666a-4246-b7eb-f72c98de082d	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 15:48:01.015432
a3eb6295-dd20-4fc7-ab0b-67c07cbf0a87	43a9b1fe-8f85-4126-8690-e55410aa022c	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 19:04:53.147503
f3700abc-3dea-47fb-ae44-681984eee2bb	43a9b1fe-8f85-4126-8690-e55410aa022c	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-08 19:04:53.147509
930c29db-81bc-46c8-bfa9-af012d02af76	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	7ae11464-3f30-47ce-ab9e-5fae4a225805	primary	2025-12-09 04:02:27.286688
94199eb7-a2c3-407f-a5d6-32284cb6c0bf	9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	secondary	2025-12-09 04:02:27.286697
a746b14d-727a-43e7-a2a3-bb61ca3f01f0	bf177fc2-1241-40f0-b1ef-b1001685d77f	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 19:56:04.748267
25099ebd-23bc-41cc-9ad1-2ac13e07c456	bf177fc2-1241-40f0-b1ef-b1001685d77f	99e28019-b7bc-4278-b4eb-0b9bb53878f6	secondary	2025-12-08 19:56:04.748278
38712373-7a7c-4559-a618-f085334bfc5c	eb812164-a155-43c5-9ae9-45956eb584cb	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 20:05:41.546615
4319ac24-f706-48bc-898f-95a9f34bc1d9	bccfa9f4-6148-495e-acb3-721da14e9721	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 20:11:37.583471
0cf9000a-25bd-4336-ae58-f23918832715	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	primary	2025-12-08 20:18:04.105549
8d5edff1-3029-428a-aa37-3a24cf4e0529	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	c1b71264-dafc-4e42-99f9-92df8b91fe5d	primary	2025-12-08 20:18:04.105557
de96f5d0-9b2a-4e6c-9cc1-bd52bce80b9b	ab1f5ba2-01ae-4770-8fad-9dd007edf61d	2a06511f-22fd-49cc-85da-99a0d7bd0df1	secondary	2025-12-08 20:18:04.105561
\.


--
-- Data for Name: exercise_set_logs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.exercise_set_logs (id, workout_log_id, day_exercise_id, set_number, reps_completed, weight_kg, effort_value, completed_at, notes, created_at) FROM stdin;
1b2638f4-b109-4b2c-bb39-c83d17446272	71392227-b8a3-402a-adff-0edc4a129b6e	8df310c5-b4c0-473e-a95b-1a0fef40f303	1	8	20	\N	2025-12-02 04:10:17.878919	\N	2025-12-02 04:10:17.87892
9b6a2c96-0393-4ca5-9966-c055a2fcd4ab	71392227-b8a3-402a-adff-0edc4a129b6e	8df310c5-b4c0-473e-a95b-1a0fef40f303	2	8	20	\N	2025-12-02 04:10:31.43279	\N	2025-12-02 04:10:31.432791
1b3d87c9-8dc3-4229-956e-85bdb98898ab	71392227-b8a3-402a-adff-0edc4a129b6e	8df310c5-b4c0-473e-a95b-1a0fef40f303	3	8	20	\N	2025-12-02 04:11:03.451759	\N	2025-12-02 04:11:03.451761
99bd1568-5b68-4404-8b32-2117ca0adeda	71392227-b8a3-402a-adff-0edc4a129b6e	bafec842-a261-4bb5-8b75-d7a1e98bf6f4	1	6	20	\N	2025-12-02 04:11:59.663785	\N	2025-12-02 04:11:59.663787
9f9c7d80-9135-4be3-870e-cdd1f481cb7f	71392227-b8a3-402a-adff-0edc4a129b6e	bafec842-a261-4bb5-8b75-d7a1e98bf6f4	2	6	20	\N	2025-12-02 04:12:00.292523	\N	2025-12-02 04:12:00.292524
b46d5a9b-a32c-46a4-b2c1-42208fdd1e6a	71392227-b8a3-402a-adff-0edc4a129b6e	bafec842-a261-4bb5-8b75-d7a1e98bf6f4	3	6	20	\N	2025-12-02 04:12:06.709184	\N	2025-12-02 04:12:06.709186
f08f6c61-52b6-4b68-b926-fb4e5dfbcaf9	71392227-b8a3-402a-adff-0edc4a129b6e	5b39a8d5-a8c9-4609-9ef0-86de12646d5e	1	10	20	\N	2025-12-02 04:12:12.723376	\N	2025-12-02 04:12:12.723378
3dc60fef-ecdc-4d6a-b4a4-de69b5ea101e	71392227-b8a3-402a-adff-0edc4a129b6e	5b39a8d5-a8c9-4609-9ef0-86de12646d5e	2	10	20	\N	2025-12-02 04:12:17.065177	\N	2025-12-02 04:12:17.065179
cdfb3fbf-6ef3-47cf-b0cc-a716ebf5b85b	71392227-b8a3-402a-adff-0edc4a129b6e	69640a60-7554-42f4-827a-4ae2aeaf76e0	1	8	20	\N	2025-12-02 04:12:39.633645	\N	2025-12-02 04:12:39.633647
e547a65f-ebf5-4511-890c-dcb1ac423e07	71392227-b8a3-402a-adff-0edc4a129b6e	69640a60-7554-42f4-827a-4ae2aeaf76e0	2	8	20	\N	2025-12-02 04:12:53.328752	\N	2025-12-02 04:12:53.328754
f64749a6-1ece-4fdc-91a3-1ddeb4605738	71392227-b8a3-402a-adff-0edc4a129b6e	69640a60-7554-42f4-827a-4ae2aeaf76e0	3	8	20	\N	2025-12-02 04:13:03.017454	\N	2025-12-02 04:13:03.017456
207c78fd-9705-4fd5-9ceb-20580d9c9f6a	71392227-b8a3-402a-adff-0edc4a129b6e	e64b6f41-e01b-49c8-8867-ba6360734986	1	10	20	\N	2025-12-02 04:14:28.378587	\N	2025-12-02 04:14:28.378589
37435397-503c-4ad2-ae40-2aff73113bbe	71392227-b8a3-402a-adff-0edc4a129b6e	e64b6f41-e01b-49c8-8867-ba6360734986	2	10	20	\N	2025-12-02 04:14:32.97924	\N	2025-12-02 04:14:32.979242
287f3301-71bc-4829-ac21-576738a7303f	71392227-b8a3-402a-adff-0edc4a129b6e	6508cb6d-54f7-43b9-ac76-c81a95e7321f	1	12	35	\N	2025-12-02 04:14:57.231144	\N	2025-12-02 04:14:57.231145
f381fd6d-aacf-48af-8970-a494babd62ab	71392227-b8a3-402a-adff-0edc4a129b6e	6508cb6d-54f7-43b9-ac76-c81a95e7321f	2	10	35	\N	2025-12-02 04:15:35.611823	\N	2025-12-02 04:15:35.611825
5c4302e1-bb96-4be1-b2c8-e2f9698169df	71392227-b8a3-402a-adff-0edc4a129b6e	6508cb6d-54f7-43b9-ac76-c81a95e7321f	3	10	40	\N	2025-12-02 04:16:37.174705	\N	2025-12-02 04:16:37.174707
21f5014d-f503-4fa3-8ec7-63911025ad58	71392227-b8a3-402a-adff-0edc4a129b6e	f30acb50-26db-48c0-9a63-e65354dda1bc	1	8	40	\N	2025-12-02 04:16:50.885368	\N	2025-12-02 04:16:50.88537
5967871b-bc1b-4537-abc0-c20dfc09a9f0	71392227-b8a3-402a-adff-0edc4a129b6e	f30acb50-26db-48c0-9a63-e65354dda1bc	2	8	40	\N	2025-12-02 04:16:56.042154	\N	2025-12-02 04:16:56.042156
01923949-7598-4380-bedc-23559eb46e1f	71392227-b8a3-402a-adff-0edc4a129b6e	f03f34f8-4884-43e6-89d9-dbc9f8299836	1	12	40	\N	2025-12-02 04:17:00.316666	\N	2025-12-02 04:17:00.316668
a2b962c9-27ec-41a1-a03e-0b5030288084	71392227-b8a3-402a-adff-0edc4a129b6e	f03f34f8-4884-43e6-89d9-dbc9f8299836	2	12	40	\N	2025-12-02 04:17:02.702099	\N	2025-12-02 04:17:02.702101
c58cd386-68dc-4b12-b14b-1998e45df86a	71392227-b8a3-402a-adff-0edc4a129b6e	f03f34f8-4884-43e6-89d9-dbc9f8299836	3	12	40	\N	2025-12-02 04:17:05.429699	\N	2025-12-02 04:17:05.429701
c9da9998-5421-488f-92d5-4bc462412fc7	71392227-b8a3-402a-adff-0edc4a129b6e	8186bc21-de91-46ac-b179-1eefa79aff61	1	12	40	\N	2025-12-02 04:17:18.314394	\N	2025-12-02 04:17:18.314395
508d4348-7ee3-4243-b3c7-db362a62d71b	71392227-b8a3-402a-adff-0edc4a129b6e	8186bc21-de91-46ac-b179-1eefa79aff61	2	12	40	\N	2025-12-02 04:17:26.07971	\N	2025-12-02 04:17:26.079711
0ae5b898-e68e-4424-b1c0-be33980b874f	71392227-b8a3-402a-adff-0edc4a129b6e	8186bc21-de91-46ac-b179-1eefa79aff61	3	12	40	\N	2025-12-02 04:17:42.377036	\N	2025-12-02 04:17:42.377037
4c7921d2-5a2a-4a0d-8150-3e6508f8dcdf	93cd4e31-68a6-4715-93d5-aa71356b73d1	827be324-d9b6-467a-99a0-27c60f927cde	1	8	\N	\N	2025-12-02 19:49:42.650609	\N	2025-12-02 19:49:42.650613
7f1357e5-5541-4cfd-8b04-fc491f5e6a83	93cd4e31-68a6-4715-93d5-aa71356b73d1	827be324-d9b6-467a-99a0-27c60f927cde	2	8	\N	\N	2025-12-02 19:49:49.058476	\N	2025-12-02 19:49:49.058478
12bd64ad-6574-406d-a9eb-2d98da4c91f8	93cd4e31-68a6-4715-93d5-aa71356b73d1	827be324-d9b6-467a-99a0-27c60f927cde	3	8	\N	\N	2025-12-02 19:49:51.473124	\N	2025-12-02 19:49:51.473126
9addb0a1-c3d9-4ce3-8852-49d69728506e	93cd4e31-68a6-4715-93d5-aa71356b73d1	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	1	10	\N	\N	2025-12-02 20:06:05.498777	\N	2025-12-02 20:06:05.498779
fcbe8c26-590f-4746-9ec4-b50d5b44ccb3	93cd4e31-68a6-4715-93d5-aa71356b73d1	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	2	10	\N	\N	2025-12-02 20:06:17.306543	\N	2025-12-02 20:06:17.306547
2f6dbfa1-6f61-427e-b98d-37f07cc39a8d	93cd4e31-68a6-4715-93d5-aa71356b73d1	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	1	15	\N	\N	2025-12-02 20:06:23.773131	\N	2025-12-02 20:06:23.773133
90814e27-fb7b-488f-9efc-023b21ec5c63	93cd4e31-68a6-4715-93d5-aa71356b73d1	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	2	15	\N	\N	2025-12-02 20:06:31.218685	\N	2025-12-02 20:06:31.218687
da5fa4a3-20b6-4378-a074-ea60f2fbdb8e	93cd4e31-68a6-4715-93d5-aa71356b73d1	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	3	15	\N	\N	2025-12-03 03:08:08.900961	\N	2025-12-03 03:08:08.900963
d81db3a9-e131-4fae-aaf0-b48e92749f08	93cd4e31-68a6-4715-93d5-aa71356b73d1	af457977-e7c7-4dfc-a412-d027ab30a3c0	1	14	\N	\N	2025-12-03 03:08:16.143372	\N	2025-12-03 03:08:16.143375
73c85198-c142-435b-9617-9176f31552fb	93cd4e31-68a6-4715-93d5-aa71356b73d1	af457977-e7c7-4dfc-a412-d027ab30a3c0	2	15	\N	\N	2025-12-03 03:08:30.858069	\N	2025-12-03 03:08:30.85807
1c42dab7-287c-4bed-a314-65cdf02d7740	93cd4e31-68a6-4715-93d5-aa71356b73d1	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	1	12	\N	\N	2025-12-03 03:08:31.944017	\N	2025-12-03 03:08:31.944019
756ac4e4-bf10-4edc-bf3e-d2afd78059d4	93cd4e31-68a6-4715-93d5-aa71356b73d1	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	2	12	\N	\N	2025-12-03 03:08:37.463743	\N	2025-12-03 03:08:37.463744
c8219258-7901-4037-bee4-078484395589	93cd4e31-68a6-4715-93d5-aa71356b73d1	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	3	12	\N	\N	2025-12-03 03:08:44.04066	\N	2025-12-03 03:08:44.040662
a99bfa05-2241-428d-a636-4f4885e01a94	93cd4e31-68a6-4715-93d5-aa71356b73d1	6ebe547c-32e4-4224-a744-b355b95a92af	1	8	\N	\N	2025-12-03 03:10:22.894983	\N	2025-12-03 03:10:22.894985
a2be376a-aa43-4e0d-90d0-096a16dc59b5	93cd4e31-68a6-4715-93d5-aa71356b73d1	6ebe547c-32e4-4224-a744-b355b95a92af	2	8	\N	\N	2025-12-03 03:10:34.598653	\N	2025-12-03 03:10:34.598655
0fec5cf8-b938-4e52-8553-9cb3ebcf4208	089cb89b-9653-47b0-9243-21d1510c34e2	827be324-d9b6-467a-99a0-27c60f927cde	1	8	\N	\N	2025-12-03 03:11:03.72933	\N	2025-12-03 03:11:03.729332
b41e0862-b1db-42f2-9125-a0baf77c7230	089cb89b-9653-47b0-9243-21d1510c34e2	827be324-d9b6-467a-99a0-27c60f927cde	2	8	\N	\N	2025-12-03 03:11:14.362909	\N	2025-12-03 03:11:14.362911
b8ac9aa5-e30c-4aca-96ab-c996dcb0730e	089cb89b-9653-47b0-9243-21d1510c34e2	827be324-d9b6-467a-99a0-27c60f927cde	3	8	\N	\N	2025-12-03 03:11:23.384352	\N	2025-12-03 03:11:23.384354
88cb6aa2-91fd-41d0-b759-91d8234e9002	089cb89b-9653-47b0-9243-21d1510c34e2	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	1	10	\N	\N	2025-12-03 03:12:16.378469	\N	2025-12-03 03:12:16.378471
346e0236-0ad1-47c2-af03-becdd2039596	089cb89b-9653-47b0-9243-21d1510c34e2	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	2	10	\N	\N	2025-12-03 03:12:37.700953	\N	2025-12-03 03:12:37.700955
af5ccbed-e633-4a64-a2c3-8943c7a3051a	02a5a483-b447-417d-8e4c-02071b32fe69	827be324-d9b6-467a-99a0-27c60f927cde	1	8	\N	\N	2025-12-03 03:14:48.408942	\N	2025-12-03 03:14:48.408944
46e92c3f-877b-464b-85c1-1521567ceb64	02a5a483-b447-417d-8e4c-02071b32fe69	827be324-d9b6-467a-99a0-27c60f927cde	2	8	\N	\N	2025-12-03 03:14:51.662979	\N	2025-12-03 03:14:51.66298
c26871c5-0ccd-47d2-8bcd-a4750320d2f4	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	827be324-d9b6-467a-99a0-27c60f927cde	1	8	\N	\N	2025-12-03 03:30:07.694909	\N	2025-12-03 03:30:07.694912
b1e89c93-2277-46fa-916b-ce8a9c68b0db	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	827be324-d9b6-467a-99a0-27c60f927cde	2	8	\N	\N	2025-12-03 03:30:08.673851	\N	2025-12-03 03:30:08.673853
606f3cf2-3eed-4990-a959-5ec6eea41301	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	827be324-d9b6-467a-99a0-27c60f927cde	3	8	\N	\N	2025-12-03 03:30:21.359365	\N	2025-12-03 03:30:21.359368
5b738435-fc29-41b5-aa88-5bd27dbfc10c	ea19c26e-31de-45c6-b8b6-531c958cb1fc	827be324-d9b6-467a-99a0-27c60f927cde	1	8	\N	\N	2025-12-03 03:15:02.344406	\N	2025-12-03 03:15:02.344408
6790278a-69e4-4217-be27-aa894a4af7d2	ea19c26e-31de-45c6-b8b6-531c958cb1fc	827be324-d9b6-467a-99a0-27c60f927cde	2	8	\N	\N	2025-12-03 03:15:05.61942	\N	2025-12-03 03:15:05.619421
11576c90-e508-4c0b-9b96-9db050b496b1	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	1	10	\N	\N	2025-12-03 03:30:26.470258	\N	2025-12-03 03:30:26.47026
c516180e-8b73-4ac2-b557-4c76c290310a	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	2	10	\N	\N	2025-12-03 03:30:27.533929	\N	2025-12-03 03:30:27.533932
104deb92-1106-426c-b623-5651a2c03339	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	1	15	\N	\N	2025-12-03 03:30:33.011354	\N	2025-12-03 03:30:33.011358
3d15b927-49c4-4926-b41a-7333f4605e2d	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	2	15	\N	\N	2025-12-03 03:31:00.041994	\N	2025-12-03 03:31:00.041997
24288ec0-9bff-4572-a456-d342d1964ad1	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	3	15	\N	\N	2025-12-03 03:31:06.52994	\N	2025-12-03 03:31:06.529942
8e9d6351-5544-4ef6-91bd-99fec6e897e6	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	af457977-e7c7-4dfc-a412-d027ab30a3c0	1	15	\N	\N	2025-12-03 03:31:10.563026	\N	2025-12-03 03:31:10.563029
2c5b4c90-9226-45b8-a97c-7da388b03018	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	af457977-e7c7-4dfc-a412-d027ab30a3c0	2	15	\N	\N	2025-12-03 03:31:11.617025	\N	2025-12-03 03:31:11.617027
ed3c5e97-a54e-44b0-a4f7-a67506bdccfe	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	1	12	\N	\N	2025-12-03 04:04:18.527498	\N	2025-12-03 04:04:18.5275
94ec579e-0f68-4ea8-a08f-f1853295170c	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	2	12	\N	\N	2025-12-03 04:04:53.272014	\N	2025-12-03 04:04:53.272016
6bf5a81d-fe8f-44be-aa9e-3d7b42e7f035	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	3	12	\N	\N	2025-12-03 04:05:14.582373	\N	2025-12-03 04:05:14.582377
04b384f5-f26a-4163-ac5f-70295f420daa	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	6ebe547c-32e4-4224-a744-b355b95a92af	1	8	\N	\N	2025-12-03 04:05:19.656137	\N	2025-12-03 04:05:19.656138
6a6397b2-0478-4e4b-96d1-1761ff09b4e6	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	6ebe547c-32e4-4224-a744-b355b95a92af	2	8	\N	\N	2025-12-03 13:24:59.06939	\N	2025-12-03 13:24:59.069394
3997cb11-0558-41a9-8ef6-5d10d988e335	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	ede9afd9-6910-4445-914a-408d24ae5648	1	15	15	\N	2025-12-03 13:25:22.43132	\N	2025-12-03 13:25:22.431322
a2c4cef7-e02f-4a21-a408-22f6f83fda28	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	ede9afd9-6910-4445-914a-408d24ae5648	2	15	15	\N	2025-12-03 13:25:45.290358	\N	2025-12-03 13:25:45.290359
147275b8-16b1-427d-9be5-57f67b09f746	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	ede9afd9-6910-4445-914a-408d24ae5648	3	15	15	\N	2025-12-03 13:26:11.611556	\N	2025-12-03 13:26:11.611558
cf7718e9-6b97-4410-a111-ec3374d432f4	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	2d8c6528-9b95-46c9-8380-b4026ef9227a	1	10	25	\N	2025-12-03 13:26:30.615585	\N	2025-12-03 13:26:30.615586
859a341a-ea12-4049-bea7-88b941e1fd00	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	2d8c6528-9b95-46c9-8380-b4026ef9227a	2	10	30	\N	2025-12-03 13:27:07.681336	\N	2025-12-03 13:27:07.681338
7c8debcf-30f7-42b6-9b38-f8d7d2958e2f	c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	2d8c6528-9b95-46c9-8380-b4026ef9227a	3	10	30	\N	2025-12-03 13:27:39.936235	\N	2025-12-03 13:27:39.936237
86b4c048-6acb-47a9-bfe8-9177d7274e6b	bd36152e-ff0e-4406-8f13-c70460ce50f7	827be324-d9b6-467a-99a0-27c60f927cde	1	8	\N	\N	2025-12-03 17:01:23.838725	\N	2025-12-03 17:01:23.838726
04c45af7-61dd-4c0e-a49e-37362b52c8f9	bd36152e-ff0e-4406-8f13-c70460ce50f7	827be324-d9b6-467a-99a0-27c60f927cde	2	8	5	\N	2025-12-03 17:01:44.257279	\N	2025-12-03 17:01:44.257281
6108d505-9c0b-4fce-b110-b2e09347399a	bd36152e-ff0e-4406-8f13-c70460ce50f7	827be324-d9b6-467a-99a0-27c60f927cde	3	8	5	\N	2025-12-03 17:01:52.737459	\N	2025-12-03 17:01:52.737461
851f3c98-cfb8-4cb9-9b12-266e6bc4b2bd	bd36152e-ff0e-4406-8f13-c70460ce50f7	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	1	10	5	\N	2025-12-03 17:01:53.997355	\N	2025-12-03 17:01:53.997357
cd8b04db-fc9a-4c06-91af-19fcf6fc93c6	bd36152e-ff0e-4406-8f13-c70460ce50f7	d6bfbae2-8d5e-457d-ac0b-0e4d2ee1161e	2	10	5	\N	2025-12-03 17:01:54.589825	\N	2025-12-03 17:01:54.589826
709cf849-ecf3-4643-8c92-00b3f088476a	bd36152e-ff0e-4406-8f13-c70460ce50f7	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	1	15	7.5	\N	2025-12-03 17:33:18.262579	\N	2025-12-03 17:33:18.262581
67696a66-313d-4e42-a68d-c187cc58421f	bd36152e-ff0e-4406-8f13-c70460ce50f7	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	2	15	7.5	\N	2025-12-03 17:33:22.669934	\N	2025-12-03 17:33:22.669936
9daa7b2f-fc18-4f0f-b53d-941b52b9ce1f	bd36152e-ff0e-4406-8f13-c70460ce50f7	eabd0a06-1f02-4bd6-a0d6-bb5de0aae273	3	15	7.5	\N	2025-12-03 17:33:32.375124	\N	2025-12-03 17:33:32.375126
ac26c6ff-aa41-4b02-9e6f-20b13ba6e40e	bd36152e-ff0e-4406-8f13-c70460ce50f7	af457977-e7c7-4dfc-a412-d027ab30a3c0	1	15	7.5	\N	2025-12-03 17:33:36.891304	\N	2025-12-03 17:33:36.891306
b74aca13-9933-4845-b4da-44b30548ca5e	bd36152e-ff0e-4406-8f13-c70460ce50f7	af457977-e7c7-4dfc-a412-d027ab30a3c0	2	15	7.5	\N	2025-12-03 17:33:43.121116	\N	2025-12-03 17:33:43.121118
da6f2521-7e74-49b8-ab10-19cfa7fa9d94	bd36152e-ff0e-4406-8f13-c70460ce50f7	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	1	12	7.5	\N	2025-12-03 17:33:51.551852	\N	2025-12-03 17:33:51.551854
dc8c5bc2-60ba-436f-9a5c-bd366c3c2ebb	bd36152e-ff0e-4406-8f13-c70460ce50f7	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	2	12	7.5	\N	2025-12-03 17:33:55.611166	\N	2025-12-03 17:33:55.611168
885d7e31-7143-471d-8fb0-807a1af96502	bd36152e-ff0e-4406-8f13-c70460ce50f7	fdd9f7b3-f77d-4ef8-8518-f52326ca5aaa	3	12	7.5	\N	2025-12-03 17:34:03.217521	\N	2025-12-03 17:34:03.217524
656774a8-2f50-4964-8817-dff4a4b95f4a	bd36152e-ff0e-4406-8f13-c70460ce50f7	6ebe547c-32e4-4224-a744-b355b95a92af	1	8	7.5	\N	2025-12-03 17:34:06.865079	\N	2025-12-03 17:34:06.86508
482b5086-2b81-4716-9471-6c8274e75889	bd36152e-ff0e-4406-8f13-c70460ce50f7	6ebe547c-32e4-4224-a744-b355b95a92af	2	8	7.5	\N	2025-12-03 17:34:16.796619	\N	2025-12-03 17:34:16.796621
671e9cad-198a-4ce9-8e2b-c84653ff9e24	bd36152e-ff0e-4406-8f13-c70460ce50f7	ede9afd9-6910-4445-914a-408d24ae5648	1	15	20	\N	2025-12-03 17:34:41.909768	\N	2025-12-03 17:34:41.909771
a889afac-3a5f-4646-b6fb-320cefd31dab	bd36152e-ff0e-4406-8f13-c70460ce50f7	ede9afd9-6910-4445-914a-408d24ae5648	2	15	50	\N	2025-12-03 17:36:44.698106	\N	2025-12-03 17:36:44.698107
30d006bd-fde9-4b9e-b5bf-5bbf2d18b7d4	bd36152e-ff0e-4406-8f13-c70460ce50f7	ede9afd9-6910-4445-914a-408d24ae5648	3	15	50	\N	2025-12-03 17:37:00.97594	\N	2025-12-03 17:37:00.975943
eb2f5639-c92f-4618-b03e-79288471226f	bd36152e-ff0e-4406-8f13-c70460ce50f7	2d8c6528-9b95-46c9-8380-b4026ef9227a	1	10	50	\N	2025-12-03 17:37:24.559325	\N	2025-12-03 17:37:24.559327
a998b90f-d458-4073-b5e2-0296e226f323	bd36152e-ff0e-4406-8f13-c70460ce50f7	2d8c6528-9b95-46c9-8380-b4026ef9227a	2	10	50	\N	2025-12-03 17:38:09.771091	\N	2025-12-03 17:38:09.771092
58ac4185-1476-45ff-9712-e19216b7a9eb	bd36152e-ff0e-4406-8f13-c70460ce50f7	2d8c6528-9b95-46c9-8380-b4026ef9227a	3	10	50	\N	2025-12-03 17:38:36.359899	\N	2025-12-03 17:38:36.359901
755d4137-d09a-409d-a185-65c4ee0ba42f	852df412-afac-44c8-8536-8b44460e9f39	627df66c-8824-4479-acc0-d382ab4f5fdc	1	12	\N	\N	2025-12-03 17:41:56.95911	\N	2025-12-03 17:41:56.959112
a6e707e9-b005-44ac-b13a-4f3d165c147d	852df412-afac-44c8-8536-8b44460e9f39	627df66c-8824-4479-acc0-d382ab4f5fdc	2	12	\N	\N	2025-12-03 17:42:10.75538	\N	2025-12-03 17:42:10.755382
1a61927a-31b0-4e35-96c3-2b2e69ab2d47	852df412-afac-44c8-8536-8b44460e9f39	627df66c-8824-4479-acc0-d382ab4f5fdc	3	12	\N	\N	2025-12-03 17:42:22.444345	\N	2025-12-03 17:42:22.444347
7e1b96e8-1dfe-4a66-955b-d9ff2d503464	852df412-afac-44c8-8536-8b44460e9f39	399b5de8-65ae-4351-bc86-8c80d7df887c	1	6	\N	\N	2025-12-03 17:42:27.034443	\N	2025-12-03 17:42:27.034445
e8e508ff-ad96-4c8e-a079-4ab94cbb50bd	852df412-afac-44c8-8536-8b44460e9f39	399b5de8-65ae-4351-bc86-8c80d7df887c	2	6	\N	\N	2025-12-03 17:43:06.947188	\N	2025-12-03 17:43:06.94719
56724e7e-8ebf-4db1-9285-108412be3241	852df412-afac-44c8-8536-8b44460e9f39	399b5de8-65ae-4351-bc86-8c80d7df887c	3	6	\N	\N	2025-12-03 17:43:16.007242	\N	2025-12-03 17:43:16.007243
4a669736-02c1-41da-9bbb-7c8524436a5c	7b678572-0537-435d-affb-dfb70aebd59d	627df66c-8824-4479-acc0-d382ab4f5fdc	3	12	\N	\N	2025-12-04 01:17:31.677955	\N	2025-12-04 01:17:31.677957
85beae99-14a5-4d4d-8483-af48d535ac8d	0cf3b350-4be2-4d8b-9523-c2628bb0c65b	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	\N	\N	2025-12-04 02:43:34.679628	\N	2025-12-04 02:43:34.67963
dc073ec5-9652-4cac-b213-34d574939ead	7b678572-0537-435d-affb-dfb70aebd59d	627df66c-8824-4479-acc0-d382ab4f5fdc	1	12	\N	\N	2025-12-04 01:16:41.912061	\N	2025-12-04 01:16:41.912062
c5f6e1d2-7ef1-4648-a16a-aea725beec62	7f4cbcc8-0159-46d0-9281-155e69b3b641	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	\N	\N	2025-12-04 01:32:25.368802	\N	2025-12-04 01:32:25.368803
78abe4bf-6016-4ce0-9be6-fafd2bb7bf63	0cf3b350-4be2-4d8b-9523-c2628bb0c65b	627df66c-8824-4479-acc0-d382ab4f5fdc	1	10	\N	\N	2025-12-04 02:43:54.023238	\N	2025-12-04 02:43:54.023239
7ba2f653-09bd-4cfd-a9b2-406b4be79977	7b678572-0537-435d-affb-dfb70aebd59d	627df66c-8824-4479-acc0-d382ab4f5fdc	2	12	\N	\N	2025-12-04 01:17:08.528516	\N	2025-12-04 01:17:08.528517
6f06b2a3-81ba-40ae-8abb-74b652181dd7	7f4cbcc8-0159-46d0-9281-155e69b3b641	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 01:32:50.528342	\N	2025-12-04 01:32:50.528343
320ad304-7268-44b3-9ef0-a727152c3610	1174faa0-7373-48f4-81f3-69c898b983da	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	\N	\N	2025-12-04 01:39:37.982506	\N	2025-12-04 01:39:37.982508
70ee2d95-fb06-4129-9d03-af7f2fad59cf	0cf3b350-4be2-4d8b-9523-c2628bb0c65b	627df66c-8824-4479-acc0-d382ab4f5fdc	2	12	25	\N	2025-12-04 02:44:20.901103	\N	2025-12-04 02:44:20.901105
7ef5b60c-70ba-4459-8432-19c07ba12ab1	1174faa0-7373-48f4-81f3-69c898b983da	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 01:39:43.42791	\N	2025-12-04 01:39:43.427911
f230ef9b-37ea-44d0-89ec-ebbf3b0937fa	0cf3b350-4be2-4d8b-9523-c2628bb0c65b	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 02:43:45.987973	\N	2025-12-04 02:43:45.987975
6998b645-45f4-446f-821b-3dd62d428dc7	eb492bd3-557b-486a-88ed-a9e12866181a	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	\N	\N	2025-12-04 02:59:02.120822	\N	2025-12-04 02:59:02.120823
5a3328af-ff05-40cf-85ca-c405fe814071	eb492bd3-557b-486a-88ed-a9e12866181a	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 02:59:06.334467	\N	2025-12-04 02:59:06.334468
34ae53cb-63ed-4d5f-83b8-567cbe16fa60	40a31804-794f-414e-969a-b41d851da1be	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	\N	\N	2025-12-04 02:59:29.57519	\N	2025-12-04 02:59:29.575191
8f41186e-8dcc-4958-a664-7c085103ecc4	b9a15c6b-03b4-4176-8c12-d97fa3976914	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	20	\N	2025-12-04 03:58:33.998967	\N	2025-12-04 03:58:33.998968
bc557169-b701-4c55-8d9b-cd4c68e9168f	b9a15c6b-03b4-4176-8c12-d97fa3976914	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 03:58:58.941769	\N	2025-12-04 03:58:58.94177
181e731a-68e5-4522-814d-f6cb438f4634	b9a15c6b-03b4-4176-8c12-d97fa3976914	54491c32-9aff-4ac9-9b6d-c6ee525ac880	1	10	\N	\N	2025-12-04 03:59:08.250673	\N	2025-12-04 03:59:08.250674
cffc6ab2-5b3f-41c6-a27f-9699edd6b74d	b9a15c6b-03b4-4176-8c12-d97fa3976914	54491c32-9aff-4ac9-9b6d-c6ee525ac880	2	10	\N	\N	2025-12-04 03:59:24.573258	\N	2025-12-04 03:59:24.573259
164838c2-a674-4e75-b50e-5c4fa8b4409c	b9a15c6b-03b4-4176-8c12-d97fa3976914	bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	1	10	7.5	\N	2025-12-04 03:59:35.044796	\N	2025-12-04 03:59:35.044797
f896a15e-f92b-4345-8304-c13cc8b6af0d	b9a15c6b-03b4-4176-8c12-d97fa3976914	bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	2	8	7.5	\N	2025-12-04 03:59:37.89361	\N	2025-12-04 03:59:37.893611
f47e52d8-0e28-4867-b4c5-f0e10d969e88	c2178bee-6588-4049-927f-af30d9412d3c	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	12	\N	\N	2025-12-04 13:21:24.49098	\N	2025-12-04 13:21:24.490983
23282899-5cea-42f7-8700-e7c8f74a726a	c2178bee-6588-4049-927f-af30d9412d3c	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 13:22:17.162836	\N	2025-12-04 13:22:17.162837
f14a082c-63be-4049-a354-052e47c2dd93	c2178bee-6588-4049-927f-af30d9412d3c	54491c32-9aff-4ac9-9b6d-c6ee525ac880	1	10	\N	\N	2025-12-04 13:22:31.884451	\N	2025-12-04 13:22:31.884452
39e69838-b367-4006-81b3-d4327450aa53	c2178bee-6588-4049-927f-af30d9412d3c	54491c32-9aff-4ac9-9b6d-c6ee525ac880	2	10	\N	\N	2025-12-04 13:24:45.171933	\N	2025-12-04 13:24:45.171934
4e6223ba-3ce1-4553-aff8-5cb97d106757	c2178bee-6588-4049-927f-af30d9412d3c	bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	1	10	\N	\N	2025-12-04 13:24:49.640058	\N	2025-12-04 13:24:49.64006
d2aa97d5-5e77-4a6e-be7a-45e828066708	c2178bee-6588-4049-927f-af30d9412d3c	bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	2	8	10	\N	2025-12-04 13:25:21.555841	\N	2025-12-04 13:25:21.555842
b096d956-709c-44d7-aec0-957d5a6b6dfa	c2178bee-6588-4049-927f-af30d9412d3c	627df66c-8824-4479-acc0-d382ab4f5fdc	1	12	30	\N	2025-12-04 13:25:32.957633	\N	2025-12-04 13:25:32.957637
92829db0-56d1-436f-b9a7-6de33585d7a5	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	bed46793-eb3b-4344-a506-fa2fd9f9c00c	1	10	\N	\N	2025-12-04 17:14:50.797427	\N	2025-12-04 17:14:50.797428
8817710c-2e26-4677-883c-5e6e3d08798f	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	bed46793-eb3b-4344-a506-fa2fd9f9c00c	2	10	\N	\N	2025-12-04 17:15:12.17935	\N	2025-12-04 17:15:12.179351
40267fb2-53f5-47e5-8147-5748b8e8dc5a	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	54491c32-9aff-4ac9-9b6d-c6ee525ac880	1	10	\N	\N	2025-12-04 17:15:30.293888	\N	2025-12-04 17:15:30.293888
7e5b6c8a-551a-4024-b7f2-1d099d36e1f3	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	54491c32-9aff-4ac9-9b6d-c6ee525ac880	2	10	\N	\N	2025-12-04 17:16:12.626741	\N	2025-12-04 17:16:12.626742
c4c11d8d-4b8f-4f9b-826e-bce70756a394	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	1	8	\N	\N	2025-12-04 17:16:44.333387	\N	2025-12-04 17:16:44.333388
4bf2774e-a0c2-43d8-8db5-7f696182342b	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	bf57e2be-3823-4f81-86c7-aed8f4e1d5a3	2	8	\N	\N	2025-12-04 17:17:34.097912	\N	2025-12-04 17:17:34.097913
1d898984-9af8-4275-b737-6009ae45a3be	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	627df66c-8824-4479-acc0-d382ab4f5fdc	1	12	100	\N	2025-12-04 17:18:18.413785	\N	2025-12-04 17:18:18.413786
1193caf7-26bb-4a0b-80e5-b56166d06588	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	627df66c-8824-4479-acc0-d382ab4f5fdc	2	12	100	\N	2025-12-04 17:18:47.317531	\N	2025-12-04 17:18:47.317532
94b21dfc-d667-42ba-a839-e0c75965e6a0	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	627df66c-8824-4479-acc0-d382ab4f5fdc	3	12	100	\N	2025-12-04 17:18:59.750647	\N	2025-12-04 17:18:59.750648
d0cb39e2-7820-4c46-92aa-b1abfd526c76	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	399b5de8-65ae-4351-bc86-8c80d7df887c	1	6	100	\N	2025-12-04 17:19:39.251973	\N	2025-12-04 17:19:39.251975
47616ef8-97ff-4231-b436-663965e8742d	65a81dea-3ee8-42e1-a3dc-b5382239ce4a	399b5de8-65ae-4351-bc86-8c80d7df887c	2	6	100	\N	2025-12-04 17:20:17.576328	\N	2025-12-04 17:20:17.576329
6b3d6dab-0a9a-4709-8da9-500803ea59c7	d6c0367b-6c2c-49af-8215-1b24bc2e5469	5a8b0205-6071-461e-96cd-a3ed73bde66d	1	8	15	\N	2025-12-05 19:51:05.193755	\N	2025-12-05 19:51:05.193757
b68d2736-f4e7-4782-b096-a0fed8d35426	d6c0367b-6c2c-49af-8215-1b24bc2e5469	5a8b0205-6071-461e-96cd-a3ed73bde66d	2	8	20	\N	2025-12-05 19:51:36.767967	\N	2025-12-05 19:51:36.767968
6153b237-cc03-41a2-923c-1ff501a758e4	d6c0367b-6c2c-49af-8215-1b24bc2e5469	5a8b0205-6071-461e-96cd-a3ed73bde66d	3	8	30	\N	2025-12-05 19:51:52.562278	\N	2025-12-05 19:51:52.56228
\.


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.exercises (id, type, resistance_profile, category, video_url, thumbnail_url, image_url, anatomy_image_url, equipment_needed, difficulty_level, exercise_class, cardio_subclass, intensity_zone, target_heart_rate_min, target_heart_rate_max, calories_per_minute, created_at, updated_at, name_en, name_es, description_en, description_es) FROM stdin;
05c07fc6-9f1b-4177-8586-5131cbbf7dcc	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell, incline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Incline Barbell Bench Press	Press de Banca Inclinado con Barra	Same as flat bench press but on an incline bench targeting upper chest	Igual que press plano pero en banco inclinado para pecho superior
48fcbc48-db8b-428c-9f1b-086b659c1d87	MONOARTICULAR	FLAT	Fly	\N	\N	\N	\N	cables	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Cable Crossover	Cruce de Poleas	Standing cable fly movement for chest	Movimiento de apertura de pie con poleas para pecho
ac69990d-a46b-4eba-81a3-86a0992622dd	MONOARTICULAR	BELL_SHAPED	Fly	\N	\N	\N	\N	pec deck machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Pec Deck Machine	Máquina Pec Deck	Machine chest fly exercise	Ejercicio de apertura de pecho en máquina
1c4009ee-4fda-4994-84ad-4701242821f4	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Push-ups	Flexiones	Classic bodyweight chest exercise	Ejercicio clásico de pecho con peso corporal
e296fac2-b7c9-40ea-b657-f9861b6ec70f	MONOARTICULAR	BELL_SHAPED	Fly	\N	\N	\N	\N	dumbbell, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Dumbbell Pullover	Pullover con Mancuerna	Lying dumbbell pullover for chest and lats	Pullover acostado con mancuerna para pecho y dorsales
0c1ca425-2019-483f-963b-143fd74d49ae	MONOARTICULAR	FLAT	Fly	\N	\N	\N	\N	cables	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	High to Low Cable Fly	Cruce de Poleas Alto a Bajo	Cable fly from high to low targeting lower chest	Cruce de poleas desde arriba hacia abajo para pecho inferior
04c1ff1d-7b26-4943-9911-4bf31fe2c8b6	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Close Grip Push-ups	Flexiones Agarre Cerrado	Push-ups with hands close together for inner chest and triceps	Flexiones con manos juntas para pecho interno y tríceps
f7579300-0e09-446e-b2fe-c26a5bc8d5c7	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	smith machine, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Smith Machine Bench Press	Press de Banca en Máquina Smith	Bench press on Smith machine for controlled movement	Press de banca en máquina Smith para movimiento controlado
8d2e790f-19fb-4951-b365-d8a5015c8295	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	dumbbells, decline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Decline Dumbbell Press	Press Declinado con Mancuernas	Dumbbell press on decline bench for lower chest	Press con mancuernas en banco declinado para pecho inferior
6639b4e0-8f09-44d5-8077-73e29b4cfa6d	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Wide Grip Push-ups	Flexiones Agarre Ancho	Push-ups with wide hand placement for outer chest	Flexiones con manos separadas para pecho externo
61144002-0b86-4cec-bcce-84f185fac9a3	MONOARTICULAR	BELL_SHAPED	Fly	\N	\N	\N	\N	fly machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Machine Fly	Máquina de Aperturas	Machine fly exercise for chest isolation	Apertura en máquina para aislamiento de pecho
81addbb4-c1b9-4a36-9cfd-dfd607f96036	MONOARTICULAR	FLAT	Press	\N	\N	\N	\N	weight plate	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 21:38:11.425865	Svend Press	Press Svend	Plate squeeze press for inner chest	Press apretando discos para pecho interno
a9b7100d-33af-47f3-bb90-1921af186225	MULTIARTICULAR	DESCENDING	Pull	\N	\N	\N	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Wide Grip Lat Pulldown	Jalón al Pecho Agarre Ancho	Lat pulldown with wide grip for outer lats	Jalón con agarre ancho para dorsales externos
e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463	MULTIARTICULAR	ASCENDING	Row			/static/exercises/e6ed8a59-9ca0-46d8-9c4d-f5dc92b5b463_23d4f02f.gif	\N	dumbbell, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 21:58:43.771	Dumbbell Row	Remo con Mancuerna	Single arm dumbbell row for back	Remo con mancuerna a una mano para espalda
1aa24acf-9fa5-498c-910b-78358dfaf362	MONOARTICULAR	BELL_SHAPED	Fly		/static/exercises/movement/incline_dumbbell_fly_movement.webp		\N	dumbbells, incline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 22:20:42.002786	Incline Dumbbell Fly	Aperturas Inclinadas con Mancuernas	Chest fly on incline bench for upper chest	Apertura en banco inclinado para pecho superior
18d50e17-4bce-4d39-8071-c93d969b7696	MULTIARTICULAR	ASCENDING	Press			/static/exercises/18d50e17-4bce-4d39-8071-c93d969b7696_d48dcb33.jpg	\N	dumbbells, incline bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-12-08 23:32:14.267043	Incline Dumbbell Press	Press Inclinado con Mancuernas	Dumbbell press on incline bench for upper chest development	Press con mancuernas en banco inclinado para desarrollo del pecho superior
acc5f43d-ecdc-46c9-bde8-3f2979199e80	MONOARTICULAR	BELL_SHAPED	Fly			/static/exercises/acc5f43d-ecdc-46c9-bde8-3f2979199e80_713b14ad.gif	\N	dumbbells, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-12-08 23:57:11.46317	Dumbbell Fly	Aperturas con Mancuernas	Chest fly movement with dumbbells on flat bench	Movimiento de apertura con mancuernas en banco plano
4e13fe45-9aac-4a33-8abe-f5efed940440	MULTIARTICULAR	DESCENDING	Pull			/static/exercises/4e13fe45-9aac-4a33-8abe-f5efed940440_da7d81c8.gif	\N	pull-up bar	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 22:50:50.630506	Chin-ups	Dominadas Supinas	Pull-up variation with underhand grip targeting biceps more	Variante de dominada con agarre supino enfocando más los bíceps
2b384748-2af0-4941-88fe-2a589bd3aeb4	MULTIARTICULAR	FLAT	Row			/static/exercises/2b384748-2af0-4941-88fe-2a589bd3aeb4_dda75f12.jpg	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 23:48:34.449495	Seated Cable Row	Remo Sentado en Polea	Seated cable row for middle back	Remo sentado en polea para espalda media
490a8870-e9f7-4a54-8444-6679403cd12c	MULTIARTICULAR	DESCENDING	Pull			/static/exercises/490a8870-e9f7-4a54-8444-6679403cd12c_ec4f13d3.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 23:48:20.092777	Lat Pulldown	Jalón al Pecho	Cable pulldown exercise for lats	Ejercicio de jalón en polea para dorsales
a9ab1def-2dc4-4fe8-a517-f38d33cb1dda	MULTIARTICULAR	ASCENDING	Press			/static/exercises/a9ab1def-2dc4-4fe8-a517-f38d33cb1dda_c4d219e2.gif	\N	chest press machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-12-08 21:53:11.593146	Chest Press Machine	Máquina Press de Pecho	Machine assisted chest press	Press de pecho asistido por máquina
c58171e7-74bb-485e-827e-51df76a444e1	MULTIARTICULAR	ASCENDING	Press			/static/exercises/c58171e7-74bb-485e-827e-51df76a444e1_cddec601.gif	\N	dumbbells, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-12-08 21:55:17.726371	Dumbbell Bench Press	Press de Banca con Mancuernas	Bench press variation with dumbbells allowing greater range of motion	Variante de press con mancuernas permitiendo mayor rango de movimiento
9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb	MULTIARTICULAR	ASCENDING	Row			/static/exercises/9a4ff421-a8a4-4a47-8cd8-b3e47593c9eb_e852f093.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 23:27:35.789675	Barbell Row	Remo con Barra	Bent over barbell row for back thickness	Remo inclinado con barra para grosor de espalda
f884891b-550e-46db-bb76-d5e2709e075c	MULTIARTICULAR	DESCENDING	Pull			/static/exercises/f884891b-550e-46db-bb76-d5e2709e075c_87149ea0.gif	\N	pull-up bar	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 23:59:10.779952	Pull-ups	Dominadas	Classic bodyweight back exercise using overhand grip	Ejercicio clásico de espalda con peso corporal usando agarre prono
4a28e859-2658-4ae3-979c-28b220344e3b	MULTIARTICULAR	ASCENDING	Row	\N	\N	\N	\N	barbell, landmine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	T-Bar Row	Remo en T	T-bar row for back thickness	Remo en T para grosor de espalda
499b3e67-b5e2-41e5-9cc2-ef521ea0f492	MULTIARTICULAR	ASCENDING	Row	\N	\N	\N	\N	barbell, landmine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Meadows Row	Remo Meadows	Single arm landmine row for back thickness	Remo a una mano con landmine para grosor de espalda
cd014645-50c5-4168-b247-9c1cfdfebb96	MULTIARTICULAR	DESCENDING	Pull	\N	\N	\N	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Single Arm Lat Pulldown	Jalón Unilateral	Single arm cable pulldown for lat isolation	Jalón a un brazo en polea para aislamiento de dorsales
949f1f23-2e1a-4b14-89c3-47638a5525a4	MULTIARTICULAR	ASCENDING	Deadlift	\N	\N	\N	\N	barbell, rack	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Rack Pull	Peso Muerto desde Rack	Partial deadlift from knee height for upper back	Peso muerto parcial desde rodillas para espalda alta
54ab1340-051d-4f8a-8ec2-f2748cc504b3	MULTIARTICULAR	DESCENDING	Row	\N	\N	\N	\N	bar, rings	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Inverted Row	Remo Invertido	Bodyweight row using bar or rings	Remo con peso corporal usando barra o anillas
df8e5f58-f528-448e-a41e-3938c669bfe1	MULTIARTICULAR	ASCENDING	Deadlift	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Good Morning	Buenos Días	Hip hinge exercise for lower back and hamstrings	Ejercicio de bisagra de cadera para espalda baja e isquiotibiales
bc53946d-16e3-4534-831c-713ec3429461	MULTIARTICULAR	FLAT	Row	\N	\N	\N	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Cable Row (Close Grip)	Remo en Polea Agarre Cerrado	Seated cable row with close grip for middle back	Remo sentado con agarre cerrado para espalda media
3f2f4b50-e5d4-47fc-acb4-72c02260bad3	MULTIARTICULAR	ASCENDING	Row	\N	\N	\N	\N	barbell, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 21:38:11.431043	Seal Row	Remo Seal	Lying chest supported barbell row	Remo acostado con soporte de pecho
1c1ab84b-4a92-4b49-bba2-01f4bc1ab9fd	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	dumbbells	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Arnold Press	Press Arnold	Rotating dumbbell shoulder press variation	Variante de press con rotación de mancuernas
e8f83a19-7d60-4b15-94f5-debe51c4e341	MONOARTICULAR	FLAT	Raise	\N	\N	\N	\N	lateral raise machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Lateral Raise (Machine)	Elevación Lateral en Máquina	Machine lateral raise for side delts	Elevación lateral en máquina para deltoides lateral
1dd3d269-0767-417e-a415-320897158e74	MONOARTICULAR	DESCENDING	Raise	\N	\N	\N	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Front Raise	Elevación Frontal	Front dumbbell raise for anterior delts	Elevación frontal con mancuernas para deltoides anterior
f11e51d7-3336-453b-bb00-d4da5293f40a	MONOARTICULAR	BELL_SHAPED	Fly	\N	\N	\N	\N	pec deck machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Reverse Pec Deck	Pec Deck Inverso	Reverse pec deck for rear delts	Pec deck inverso para deltoides posterior
5ffd4f75-1b02-44a8-8245-036b03e8ca8b	MONOARTICULAR	FLAT	Raise	\N	\N	\N	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Shrugs (Dumbbell)	Encogimientos con Mancuernas	Dumbbell shrugs for trapezius	Encogimientos con mancuernas para trapecios
eb822a60-9981-4041-9a9e-5b3b8c82b07b	MONOARTICULAR	FLAT	Raise	\N	\N	\N	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Shrugs (Barbell)	Encogimientos con Barra	Barbell shrugs for trapezius	Encogimientos con barra para trapecios
998fbd55-139a-409c-85f7-4e84251df22c	MULTIARTICULAR	ASCENDING	Pull	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Upright Row	Remo al Mentón	Barbell or dumbbell upright row for shoulders	Remo al mentón con barra o mancuernas para hombros
cb74c9b1-8845-4899-a203-67028cfae5c2	MULTIARTICULAR	ASCENDING	Pull	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	High Pull	Tirón Alto	Explosive pull for shoulders and traps	Tirón explosivo para hombros y trapecios
ac0fa73b-c23e-4531-9a06-1daae941d022	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	dumbbells	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Cuban Press	Press Cubano	Rotational shoulder press for rotator cuff	Press de hombros con rotación para manguito rotador
3f9b3503-9ddd-4a54-bd4a-62a07b4ca2af	MONOARTICULAR	DESCENDING	Raise	\N	\N	\N	\N	dumbbells	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Lu Raise	Elevación Lu	Front to lateral raise combination	Combinación de elevación frontal a lateral
13135caf-d1bf-4be5-bc08-c3287dc4b7b6	MULTIARTICULAR	ASCENDING	Press			/static/exercises/13135caf-d1bf-4be5-bc08-c3287dc4b7b6_f9ad45b3.webp	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-12-08 21:49:48.511927	Dumbbell Shoulder Press	Press de Hombros con Mancuernas	Seated or standing dumbbell shoulder press	Press de hombros sentado o de pie con mancuernas
a7e34918-49a4-47ef-aeba-69c4fb324fe8	MULTIARTICULAR	ASCENDING	Row			/static/exercises/a7e34918-49a4-47ef-aeba-69c4fb324fe8_55338d05.gif	\N	dumbbells, incline bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 22:48:56.428677	Chest Supported Row	Remo con Apoyo de Pecho	Incline bench supported dumbbell row	Remo con mancuernas apoyado en banco inclinado
c4e8fbc7-b3e1-4f40-9f01-d6e5dbe275c8	MONOARTICULAR	DESCENDING	Pull			/static/exercises/c4e8fbc7-b3e1-4f40-9f01-d6e5dbe275c8_6f4712f4.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 22:51:36.643831	Straight Arm Pulldown	Jalón con Brazos Rectos	Standing straight arm pulldown for lats	Jalón de pie con brazos rectos para dorsales
5941db40-0f07-47b8-a9e2-f31bc44d9710	MONOARTICULAR	ASCENDING	Curl			/static/exercises/5941db40-0f07-47b8-a9e2-f31bc44d9710_97271699.gif	\N	leg curl machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 23:54:12.02729	Standing Leg Curl	Curl de Pierna de Pie	Single leg standing hamstring curl	Curl de isquiotibiales de pie a una pierna
945a062b-0bfd-49b4-9bfc-3617fe1fad76	MONOARTICULAR	BELL_SHAPED	Fly			/static/exercises/945a062b-0bfd-49b4-9bfc-3617fe1fad76_d6c7daf9.webp	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 23:28:06.686989	Rear Delt Fly	Aperturas para Deltoides Posterior	Bent over fly for rear delts	Apertura inclinado para deltoides posterior
15badbbe-7f3a-401d-ab0f-c7049381e935	MULTIARTICULAR	DESCENDING	Pull			/static/exercises/15badbbe-7f3a-401d-ab0f-c7049381e935_833406b9.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 21:51:17.82633	Neutral Grip Lat Pulldown	Jalón Agarre Neutro	Lat pulldown with neutral grip handle	Jalón con agarre neutro
180cac0a-9343-4208-9762-bacad127a9e8	MULTIARTICULAR	ASCENDING	Deadlift			/static/exercises/180cac0a-9343-4208-9762-bacad127a9e8_ac0f7d70.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 23:30:24.508076	Deadlift	Peso Muerto	Conventional deadlift for full posterior chain	Peso muerto convencional para toda la cadena posterior
e575c180-fd48-4cde-8c67-86b784dc5220	MULTIARTICULAR	ASCENDING	Press			/static/exercises/e575c180-fd48-4cde-8c67-86b784dc5220_9b2b0279.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-12-08 23:36:12.929792	Overhead Press	Press Militar	Standing barbell shoulder press	Press de hombros de pie con barra
71650a04-03a5-4fc9-980e-123ee302f86a	MONOARTICULAR	FLAT	Raise			/static/exercises/71650a04-03a5-4fc9-980e-123ee302f86a_9069bdb8.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-12-08 23:55:35.33653	Lateral Raise (Cable)	Elevación Lateral en Polea	Cable lateral raise for constant tension	Elevación lateral en polea para tensión constante
254dac1d-ca3e-4e21-867d-a535e900da56	MONOARTICULAR	BELL_SHAPED	Fly	\N	\N	\N	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Seated Bent Over Rear Delt Fly	Aperturas Posterior Sentado	Seated bent over fly for rear delts	Apertura inclinado sentado para deltoides posterior
b103746c-91e4-41ed-a6b1-0e379dd78d0c	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	shoulder press machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Shoulder Press Machine	Press de Hombros en Máquina	Machine assisted shoulder press	Press de hombros asistido por máquina
9457341a-48cc-452a-9a06-e21f12591341	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Behind Neck Press	Press Tras Nuca	Overhead press behind the neck (requires good mobility)	Press sobre la cabeza por detrás (requiere buena movilidad)
b7fba09d-c119-4eff-8d06-88880c9e0ee3	MONOARTICULAR	DESCENDING	Raise	\N	\N	\N	\N	dumbbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 21:38:11.434871	Leaning Lateral Raise	Elevación Lateral Inclinado	Single arm lateral raise while leaning for full ROM	Elevación lateral a un brazo inclinado para ROM completo
26918508-effb-428b-b6c0-0a7470c9968a	MULTIARTICULAR	ASCENDING	Squat	\N	\N	\N	\N	pendulum squat machine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 21:38:11.437979	Pendulum Squat	Sentadilla Péndulo	Machine squat with pendulum mechanism	Sentadilla en máquina con mecanismo de péndulo
e91aae68-2323-473a-9798-01026fe559c9	MULTIARTICULAR	ASCENDING	Squat	\N	\N	\N	\N	belt squat machine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 21:38:11.437979	Belt Squat	Sentadilla con Cinturón	Squat using belt machine for reduced spinal load	Sentadilla con máquina de cinturón para reducir carga espinal
c1328ee6-43d4-4f47-827e-38f21e7120dd	MONOARTICULAR	DESCENDING	Curl	\N	\N	\N	\N	bodyweight, anchor	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 21:38:11.437979	Nordic Curl	Curl Nórdico	Bodyweight hamstring curl exercise	Ejercicio de curl de isquiotibiales con peso corporal
2e5fdb7e-8a24-474b-bb4a-4ac86fd96d57	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	leg press machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 21:38:11.437979	Leg Press (Low Foot)	Prensa de Pierna Pies Bajos	Leg press with low foot placement for quads	Prensa con pies bajos para cuádriceps
dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34	MONOARTICULAR	ASCENDING	Extension			/static/exercises/dfe4b5e1-eaa6-4817-bdd0-e1d4562c6f34_ce3a2b9b.gif	\N	leg extension machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:26:06.085033	Leg Extension	Extensión de Pierna	Machine leg extension for quads isolation	Extensión de pierna en máquina para aislamiento de cuádriceps
b04c66f3-b76c-443a-a7b4-2d89da9dd266	MONOARTICULAR	FLAT	Raise			/static/exercises/b04c66f3-b76c-443a-a7b4-2d89da9dd266_60aec5be.jpg	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 23:35:33.65968	Cable Lateral Raise	Elevación Lateral con Cable	Single arm cable lateral raise	Elevación lateral a un brazo con cable
d03a2816-e622-4c66-b843-2a82f55f6d24	MULTIARTICULAR	ASCENDING	Squat			/static/exercises/d03a2816-e622-4c66-b843-2a82f55f6d24_67fcb3b5.gif	\N	bodyweight	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 22:56:33.570904	Pistol Squat	Sentadilla Pistola	Single leg bodyweight squat	Sentadilla a una pierna con peso corporal
4eafd2c5-8de8-422c-9f27-90289f970e16	MULTIARTICULAR	ASCENDING	Lunge			/static/exercises/4eafd2c5-8de8-422c-9f27-90289f970e16_c7c8fb9d.gif	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 18:49:35.715127	Walking Lunge	Zancada Caminando	Walking lunges for legs and glutes	Zancadas caminando para piernas y glúteos
e79f0884-280f-4e5e-9659-4df058afb828	MULTIARTICULAR	ASCENDING	Squat			/static/exercises/e79f0884-280f-4e5e-9659-4df058afb828_ab82ac2c.gif	\N	smith machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:54:20.646874	Smith Machine Squat	Sentadilla en Máquina Smith	Squat using Smith machine for stability	Sentadilla en máquina Smith para estabilidad
1dd47ff8-ab0e-4468-89b5-ef58218fb071	MULTIARTICULAR	ASCENDING	Squat			/static/exercises/1dd47ff8-ab0e-4468-89b5-ef58218fb071_5da5a872.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 23:41:09.460808	Back Squat	Sentadilla Trasera	Barbell back squat for overall leg development	Sentadilla trasera con barra para desarrollo general de piernas
06ca48f5-bfcc-4ffa-964b-48eddafab389	MULTIARTICULAR	ASCENDING	Press			/static/exercises/06ca48f5-bfcc-4ffa-964b-48eddafab389_672d56aa.jpg	\N	leg press machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 23:43:40.29995	Leg Press 45°	Prensa de Pierna	Machine leg press for quads and glutes	Prensa de pierna para cuádriceps y glúteos
155ee3c5-a401-4644-a6c5-06bed7a187a8	MULTIARTICULAR	ASCENDING	Lunge			/static/exercises/155ee3c5-a401-4644-a6c5-06bed7a187a8_c089387f.gif	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:31:32.232438	Reverse Lunge	Zancada Reversa	Stepping backward lunge variation	Variante de zancada hacia atrás
b95b0ba1-fa46-49cb-94d5-bd07fd62f844	MULTIARTICULAR	ASCENDING	Press			/static/exercises/b95b0ba1-fa46-49cb-94d5-bd07fd62f844_7c8a9289.jpg	\N	leg press machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:09:14.27604	Leg Press (High Foot)	Prensa de Pierna Pies Altos	Leg press with high foot placement for glutes/hams	Prensa con pies altos para glúteos e isquiotibiales
e74733e1-43cd-43f9-9945-c1b0a50fadc9	MULTIARTICULAR	ASCENDING	Squat			/static/exercises/e74733e1-43cd-43f9-9945-c1b0a50fadc9_1af8ec5d.gif	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:46:19.179719	Sumo Squat	Sentadilla Sumo	Wide stance squat targeting adductors	Sentadilla con postura amplia para aductores
3aeb6a7d-b69f-4fc5-bcb8-14e04221ae11	MONOARTICULAR	ASCENDING	Curl			/static/exercises/3aeb6a7d-b69f-4fc5-bcb8-14e04221ae11_230481a2.gif	\N	leg curl machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:50:11.282477	Seated Leg Curl	Curl de Pierna Sentado	Seated leg curl for hamstrings	Curl de pierna sentado para isquiotibiales
b3b03d37-e041-4fdc-8bc1-87487b47d769	MULTIARTICULAR	ASCENDING	Lunge			/static/exercises/b3b03d37-e041-4fdc-8bc1-87487b47d769_9b61cda4.gif	\N	dumbbells, box	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 16:05:23.557407	Step-ups	Subidas a Banco	Step-ups on box or bench	Subidas a caja o banco
afbb218b-fa3d-49cf-b7cf-8e0642bab3ed	MULTIARTICULAR	ASCENDING	Squat			/static/exercises/afbb218b-fa3d-49cf-b7cf-8e0642bab3ed_94f83ff6.gif	\N	hack squat machine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 23:21:35.19692	Hack Squat	Sentadilla Hack	Machine hack squat for quads	Sentadilla hack en máquina para cuádriceps
58c9abd8-de2f-456d-8321-32b773457487	MONOARTICULAR	ASCENDING	Squat			/static/exercises/58c9abd8-de2f-456d-8321-32b773457487_de2dd1b6.jpg	\N	bodyweight, support	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 23:37:10.318703	Sissy Squat	Sentadilla Sissy	Bodyweight quad isolation exercise	Ejercicio de aislamiento de cuádriceps con peso corporal
bbbee470-42c9-45fc-aee1-3455ed5599c6	MULTIARTICULAR	ASCENDING	Lunge			/static/exercises/bbbee470-42c9-45fc-aee1-3455ed5599c6_e567c1cd.webp	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 23:45:17.262978	Barbell Lunges	Zancadas con Barra	Forward lunges with barbell on back	Zancadas hacia adelante con barra en espalda
61117023-fca8-49a7-a914-e8fddd9350af	MULTIARTICULAR	ASCENDING	Press			/static/exercises/61117023-fca8-49a7-a914-e8fddd9350af_203f63bf.gif	\N	leg press machine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 23:51:23.750934	Single Leg Press	Prensa de Pierna Unilateral	Single leg press for unilateral leg development	Prensa a una pierna para desarrollo unilateral
4a718bbd-9a37-4b7c-b804-62e213f0e5a8	MONOARTICULAR	ASCENDING	Adduction	\N	\N	\N	\N	hip adduction machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 21:38:11.44143	Hip Adduction Machine	Máquina de Aducción de Cadera	Machine hip adduction for inner thighs	Aducción de cadera en máquina para muslos internos
ecc38482-1057-44b0-bb0d-76d3a645c49f	MULTIARTICULAR	ASCENDING	Thrust	\N	\N	\N	\N	bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 21:38:11.44143	Single Leg Hip Thrust	Empuje de Cadera Unilateral	Single leg hip thrust for unilateral glute work	Empuje de cadera a una pierna para trabajo unilateral
3e0ea4a8-b258-44bf-85c8-529900fc0a94	MULTIARTICULAR	ASCENDING	Extension	\N	\N	\N	\N	reverse hyper machine	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 21:38:11.44143	Reverse Hyperextension	Hiperextensión Inversa	Reverse hyper for glutes and lower back	Hiperextensión inversa para glúteos y espalda baja
cad31ba5-690d-4e66-826c-822365f616cd	MONOARTICULAR	ASCENDING	Abduction	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 21:38:11.44143	Fire Hydrant	Hidrante	Quadruped hip abduction for glute medius	Abducción de cadera en cuadrupedia para glúteo medio
a2f075c0-d141-49a1-a6d1-c1cb2d188b3b	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Barbell Curl	Curl con Barra	Standing barbell curl for biceps	Curl de pie con barra para bíceps
0d1669ad-d3b1-4fc2-af13-6df361ffba64	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	ez bar	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	EZ Bar Curl	Curl con Barra EZ	Curl with EZ bar for reduced wrist strain	Curl con barra EZ para reducir tensión en muñecas
70cd9e39-297d-420f-8ebb-5af2423d504c	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Hammer Curl	Curl Martillo	Neutral grip curl for brachialis	Curl con agarre neutro para braquial
d62eae0b-9ab5-4a2f-b9c9-9ca9697af74d	MONOARTICULAR	DESCENDING	Curl	\N	\N	\N	\N	ez bar, preacher bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Preacher Curl	Curl Predicador	Preacher bench curl for biceps peak	Curl en banco predicador para pico del bíceps
062cfaf1-2abd-49cf-8ad9-2c3784ec4419	MONOARTICULAR	ASCENDING	Curl	\N	\N	\N	\N	dumbbells, incline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Incline Dumbbell Curl	Curl Inclinado con Mancuernas	Incline bench curl for long head stretch	Curl en banco inclinado para estiramiento de cabeza larga
78d9226e-8c17-4d5c-ae02-09ff7ed6ae51	MONOARTICULAR	FLAT	Curl	\N	\N	\N	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Cable Curl	Curl en Polea	Cable curl for constant tension	Curl en polea para tensión constante
40cbc496-5c69-4ca6-b6f1-4635692702ed	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	dumbbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Concentration Curl	Curl Concentrado	Seated concentration curl for bicep peak	Curl concentrado sentado para pico del bíceps
f856b6a1-300b-4fbf-b967-9071a0d11141	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Reverse Curl	Curl Reverso	Overhand grip curl for brachioradialis	Curl con agarre prono para braquiorradial
d6fb6584-6d85-4e22-9c82-f88c5a407e52	MONOARTICULAR	FLAT	Curl	\N	\N	\N	\N	cables	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	High Cable Curl	Curl de Cable Alto	Overhead cable curl for bicep peak	Curl de cable sobre la cabeza para pico del bíceps
ebbb5bed-2741-4c41-8705-2ad8f97d765d	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Cross Body Hammer Curl	Curl Martillo Cruzado	Hammer curl across the body for brachialis	Curl martillo cruzando el cuerpo para braquial
e5950111-2ce1-46db-88fe-43c7441d065b	MONOARTICULAR	BELL_SHAPED	Crunch	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Toe Touch	Toque de Dedos	Lying toe touch crunch	Crunch tocando los dedos de los pies
e70ccada-9057-4466-a8ba-f706f2b4438c	MONOARTICULAR	ASCENDING	Extension			/static/exercises/e70ccada-9057-4466-a8ba-f706f2b4438c_6e084513.gif	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 15:57:43.111124	Donkey Kick	Patada de Burro	Quadruped kickback for glutes	Patada en cuadrupedia para glúteos
06e8e4ce-4a0e-46a0-9c74-d3e702a7428f	MONOARTICULAR	ASCENDING	Raise			/static/exercises/06e8e4ce-4a0e-46a0-9c74-d3e702a7428f_bde0dcad.jpg	\N	calf raise machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.444861	2025-12-08 21:46:31.964698	Standing Calf Raise	Elevación de Talones de Pie	Standing calf raise machine	Elevación de talones de pie en máquina
eb812164-a155-43c5-9ae9-45956eb584cb	MONOARTICULAR	ASCENDING	Extension			/static/exercises/eb812164-a155-43c5-9ae9-45956eb584cb_3114ff13.gif	\N	glute kickback machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 20:05:41.711776	Glute Kickback Machine	Patada de Glúteo en Máquina	Machine kickback for glute isolation	Patada en máquina para aislamiento de glúteos
85a6425e-8ff0-40c2-b171-d6c404c9ee40	MULTIARTICULAR	ASCENDING	Deadlift			/static/exercises/85a6425e-8ff0-40c2-b171-d6c404c9ee40_75d240d9.webp	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 22:52:18.936094	Sumo Deadlift	Peso Muerto Sumo	Wide stance deadlift for glutes and adductors	Peso muerto con postura amplia para glúteos y aductores
9538101e-512b-41a2-aec6-831b9f35780e	MULTIARTICULAR	FLAT	Thrust			/static/exercises/9538101e-512b-41a2-aec6-831b9f35780e_9081727c.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 23:12:58.477943	Cable Pull Through	Pull Through en Polea	Cable pull through for glutes and hamstrings	Pull through en polea para glúteos e isquiotibiales
bc9b3a59-10da-4b32-b126-bebea984581e	MONOARTICULAR	ASCENDING	Raise			/static/exercises/bc9b3a59-10da-4b32-b126-bebea984581e_eefa699b.jpg	\N	calf raise machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.444861	2025-11-30 00:56:58.147797	Seated Calf Raise	Elevación de Talones Sentado	Seated calf raise for soleus	Elevación de talones sentado para sóleo
09607947-3376-4fd7-bc0d-5386825c73bf	MONOARTICULAR	ASCENDING	Raise			/static/exercises/09607947-3376-4fd7-bc0d-5386825c73bf_bf99e660.gif	\N	leg press machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.444861	2025-11-30 00:58:45.555107	Leg Press Calf Raise	Elevación de Talones en Prensa	Calf raises on leg press machine	Elevación de talones en máquina de prensa
ac7717a4-4e37-4cc2-9050-b4185af9c34c	MULTIARTICULAR	ASCENDING	Thrust			/static/exercises/ac7717a4-4e37-4cc2-9050-b4185af9c34c_c2362f9a.gif	\N	dumbbell, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-07 00:45:28.302942	Hip Thrust (Dumbbell)	Empuje de Cadera con Mancuerna	Dumbbell hip thrust variation	Variante de empuje de cadera con mancuerna
bccfa9f4-6148-495e-acb3-721da14e9721	MONOARTICULAR	FLAT	Extension			/static/exercises/bccfa9f4-6148-495e-acb3-721da14e9721_7e304a77.gif	\N	cables, ankle strap	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 20:11:37.73496	Cable Kickback	Patada de Glúteo en Polea	Cable kickback for glute isolation	Patada en polea para aislamiento de glúteos
92ec1a6d-9108-4fa0-93f9-7e1b11b753e8	MONOARTICULAR	ASCENDING	Thrust			/static/exercises/92ec1a6d-9108-4fa0-93f9-7e1b11b753e8_4f12b2cc.gif	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 15:51:58.104695	Frog Pumps	Bombeo de Rana	Glute bridge variation with feet together	Variante de puente de glúteos con pies juntos
797aa448-10ec-49cf-b0b4-7cb589844710	MONOARTICULAR	BELL_SHAPED	Curl			/static/exercises/797aa448-10ec-49cf-b0b4-7cb589844710_69c70324.webp	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-12-08 23:41:38.738877	Dumbbell Curl	Curl con Mancuernas	Standing dumbbell curl	Curl de pie con mancuernas
69273c3a-e289-4ce6-9ef0-ff5b0d734c73	MONOARTICULAR	ASCENDING	Curl	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Drag Curl	Curl Arrastre	Barbell curl dragging the bar up the body	Curl con barra arrastrando la barra por el cuerpo
f3df9354-773b-4635-a2f1-b6f210bb0095	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	dumbbells	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Zottman Curl	Curl Zottman	Curl with rotation for biceps and forearms	Curl con rotación para bíceps y antebrazos
46db6fb8-ade5-4b1c-b1de-aefe7f46b00b	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	bicep curl machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-11-29 21:38:11.447839	Machine Bicep Curl	Curl de Bíceps en Máquina	Machine assisted bicep curl	Curl de bíceps asistido por máquina
cb7daf45-405b-48c2-9a6e-37cfdddeeb5d	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Close Grip Bench Press	Press de Banca Agarre Cerrado	Bench press with close grip for triceps	Press de banca con agarre cerrado para tríceps
94e22043-d2e5-40d9-9355-b5db003f9964	MONOARTICULAR	DESCENDING	Extension	\N	\N	\N	\N	cables, rope attachment	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Tricep Pushdown (Rope)	Extensión de Tríceps con Cuerda	Cable pushdown with rope attachment	Extensión en polea con cuerda
a780f0ae-8236-4bb3-baef-6b830dc3f287	MONOARTICULAR	DESCENDING	Extension	\N	\N	\N	\N	cables, v-bar	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Tricep Pushdown (V-Bar)	Extensión de Tríceps con V-Bar	Cable pushdown with V-bar	Extensión en polea con V-bar
6efb5bc1-5475-48d0-a476-4ee49aa3c162	MONOARTICULAR	DESCENDING	Extension	\N	\N	\N	\N	ez bar, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Skull Crusher	Rompecráneos	Lying tricep extension with EZ bar	Extensión de tríceps acostado con barra EZ
fb1802ef-1799-48ca-af9f-9de08e10ab26	MONOARTICULAR	ASCENDING	Extension	\N	\N	\N	\N	dumbbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Overhead Tricep Extension	Extensión de Tríceps sobre Cabeza	Overhead dumbbell tricep extension	Extensión de tríceps sobre la cabeza con mancuerna
d704f33f-d57d-41ed-9611-dc367d90bdef	MULTIARTICULAR	ASCENDING	Dip	\N	\N	\N	\N	parallel bars	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Dips	Fondos en Paralelas	Parallel bar dips for triceps and chest	Fondos en paralelas para tríceps y pecho
d3978a05-e7d7-41a1-bb30-7e7c8f450d63	MULTIARTICULAR	ASCENDING	Dip	\N	\N	\N	\N	bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Bench Dips	Fondos en Banco	Dips using a bench	Fondos usando un banco
a3a6ae8b-5238-483e-bc62-d328aaeb6fb0	MONOARTICULAR	ASCENDING	Extension	\N	\N	\N	\N	dumbbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Tricep Kickback	Patada de Tríceps	Bent over dumbbell kickback for triceps	Patada de tríceps inclinado con mancuerna
05b47a90-d82a-4200-b0d0-890e09cef009	MONOARTICULAR	ASCENDING	Extension	\N	\N	\N	\N	cables, rope attachment	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Cable Overhead Extension	Extensión Sobre Cabeza en Polea	Overhead cable tricep extension	Extensión de tríceps sobre la cabeza en polea
98d2acbd-4b74-4b92-a76f-34a74f1f21a2	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	bodyweight	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Diamond Push-ups	Flexiones Diamante	Push-ups with hands in diamond position	Flexiones con manos en posición de diamante
6981e3ef-21eb-4773-bfe0-dd823252ed08	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell, bench	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	JM Press	Press JM	Hybrid bench press and skull crusher for triceps	Híbrido de press de banca y rompecráneos para tríceps
f78d4747-f546-4c2d-9c89-402c6396717a	MONOARTICULAR	DESCENDING	Extension	\N	\N	\N	\N	dumbbells, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Tate Press	Press Tate	Dumbbell tricep extension with elbows out	Extensión de tríceps con mancuernas con codos hacia afuera
ae2fd8ee-e4e3-4cb9-b8e0-79eae1f76522	MONOARTICULAR	DESCENDING	Extension	\N	\N	\N	\N	tricep machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	Tricep Machine	Máquina de Tríceps	Machine assisted tricep extension	Extensión de tríceps asistida por máquina
a493d846-8694-4095-9b19-66db1a585761	MONOARTICULAR	DESCENDING	Extension	\N	\N	\N	\N	ez bar	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-11-29 21:38:11.450813	French Press	Press Francés	Standing or seated overhead barbell extension	Extensión sobre la cabeza de pie o sentado con barra
bc6452cb-8d45-471d-8948-a16a5cbf76cd	MONOARTICULAR	BELL_SHAPED	Crunch	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Crunches	Abdominales	Basic crunch exercise for abs	Ejercicio básico de abdominal
a053c71f-8d4f-4904-a8b7-c1462864639f	MONOARTICULAR	DESCENDING	Raise	\N	\N	\N	\N	pull-up bar	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Hanging Leg Raise	Elevación de Piernas Colgado	Hanging leg raise for lower abs	Elevación de piernas colgado para abdominales inferiores
15ec8aab-14c7-4841-9a6b-1ebfb94cbf19	MONOARTICULAR	FLAT	Rotation	\N	\N	\N	\N	weight plate	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Russian Twist	Giro Ruso	Rotational core exercise	Ejercicio de rotación para core
0d81f1d5-a132-4b29-9715-763349e49dda	MULTIARTICULAR	DESCENDING	Crunch	\N	\N	\N	\N	ab wheel	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Ab Wheel Rollout	Rueda Abdominal	Ab wheel exercise for full core	Ejercicio de rueda abdominal para todo el core
dfb6bdf3-9a78-496c-9eb3-0cb2f91a2182	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Dead Bug	Dead Bug	Core stability exercise	Ejercicio de estabilidad del core
3795dc73-8f9a-4b77-8def-f9d3be8a517d	MONOARTICULAR	FLAT	Press	\N	\N	\N	\N	cables	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Pallof Press	Press Pallof	Anti-rotation core exercise	Ejercicio anti-rotación para core
cded2f69-f3aa-4414-9898-966bc650e5d6	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Side Plank	Plancha Lateral	Lateral plank for obliques	Plancha lateral para oblicuos
6a044c4f-42af-4d15-88a5-fa6e9493f011	MONOARTICULAR	DESCENDING	Crunch	\N	\N	\N	\N	bodyweight	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	V-Up	V-Up	Full body crunch forming V shape	Crunch de cuerpo completo formando V
12af8c22-bfb5-42f3-babc-fbfde97e03f6	MONOARTICULAR	DESCENDING	Raise	\N	\N	\N	\N	bench	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Dragon Flag	Bandera del Dragón	Advanced core exercise keeping body straight	Ejercicio avanzado de core manteniendo el cuerpo recto
3493b170-38aa-406e-9d0f-57cc4cde4ffa	MULTIARTICULAR	FLAT	Rotation	\N	\N	\N	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Woodchop (Cable)	Leñador en Polea	Rotational cable movement for core	Movimiento rotacional en polea para core
c03d86b7-2c86-45fe-bbee-5bdc2f7b1fb4	MONOARTICULAR	DESCENDING	Crunch	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Reverse Crunch	Crunch Inverso	Crunch lifting hips for lower abs	Crunch levantando caderas para abdominales inferiores
4c59e8a9-c49f-4f65-a319-776a670482bf	MONOARTICULAR	DESCENDING	Extension			/static/exercises/4c59e8a9-c49f-4f65-a319-776a670482bf_1c968ed3.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.450813	2025-12-08 22:01:32.673281	Single Arm Tricep Pushdown	Extensión de Tríceps Unilateral	Single arm cable pushdown	Extensión en polea a un brazo
be1663cf-6c5a-47cd-b427-0865baaf77e8	MONOARTICULAR	BELL_SHAPED	Crunch			/static/exercises/be1663cf-6c5a-47cd-b427-0865baaf77e8_8b9e8733.gif	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-12-08 23:39:01.661979	Bicycle Crunch	Crunch Bicicleta	Rotational crunch targeting obliques	Crunch rotacional para oblicuos
5cabccc1-9c4e-4093-a995-412697afd3fd	MONOARTICULAR	FLAT	Raise	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Flutter Kicks	Patadas Aleteo	Alternating leg raises for lower abs	Elevaciones alternas de piernas para abdominales inferiores
a109862e-2fd8-4453-8282-ed5f7394c522	MONOARTICULAR	DESCENDING	Raise	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Leg Raise	Elevación de Piernas	Lying leg raise for lower abs	Elevación de piernas acostado para abdominales inferiores
9052a646-277d-492f-8ef2-2ae99f91cc48	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	bench	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Copenhagen Plank	Plancha Copenhague	Side plank variation with leg elevated	Variante de plancha lateral con pierna elevada
4b9859d5-7fae-46a8-80ec-9dc2cc883701	MONOARTICULAR	BELL_SHAPED	Crunch	\N	\N	\N	\N	decline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Decline Sit-ups	Abdominales Declinados	Sit-ups on decline bench	Abdominales en banco declinado
fabf8448-ed3b-4b8d-ab28-6f16ff68c416	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	weight plate	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Weighted Plank	Plancha con Peso	Plank with added weight on back	Plancha con peso adicional en la espalda
f080434f-5670-4fe4-93f1-f75cc6860427	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	bodyweight	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Hollow Body Hold	Posición Hueca	Gymnastic core hold position	Posición de core gimnástica
3813c6cb-0747-469f-9f4e-0c63846b2fa6	MONOARTICULAR	FLAT	Extension	\N	\N	\N	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-11-29 21:38:11.453974	Superman	Superman	Lying back extension for lower back	Extensión acostado para espalda baja
8bc71e2d-19b9-48b0-ba33-9494749eef8a	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	stationary bike	beginner	cardio	liss	2	100	130	6	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Stationary Bike	Bicicleta Estática	Cycling on stationary bike	Ciclismo en bicicleta estática
01a58ace-ecbd-4e07-85e9-dd9d92025374	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	rowing machine	beginner	cardio	miss	3	130	150	9	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Rowing Machine	Máquina de Remo	Rowing ergometer exercise	Ejercicio en ergómetro de remo
18f621cb-7f79-4a95-9fa4-4067bfa5a1f9	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	elliptical machine	beginner	cardio	liss	2	100	130	6	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Elliptical	Elíptica	Elliptical machine workout	Entrenamiento en máquina elíptica
0f09b024-96e5-4838-87cb-32cb794a385b	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	battle ropes	intermediate	cardio	hiit	4	150	180	12	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Battle Ropes	Cuerdas de Batalla	High intensity battle ropes	Cuerdas de batalla de alta intensidad
86ad9163-4c2f-4b35-aa08-805e0bb86a72	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	bodyweight	intermediate	cardio	hiit	4	150	180	12	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Burpees	Burpees	Full body cardio exercise	Ejercicio cardiovascular de cuerpo completo
9df5a698-50c3-4db0-a63b-b3a848d73734	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	bodyweight	beginner	cardio	hiit	4	150	180	10	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Jumping Jacks	Saltos de Tijera	Classic jumping jack exercise	Ejercicio clásico de saltos de tijera
c052c480-7488-41e7-83c1-13b3772f2250	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	bodyweight	beginner	cardio	hiit	4	150	180	11	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Mountain Climbers	Escaladores	Mountain climber cardio exercise	Ejercicio cardiovascular de escaladores
ec99a632-2f73-47f0-8a1e-2ec9c1885549	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	jump rope	beginner	cardio	miss	3	130	160	11	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Jump Rope	Saltar la Cuerda	Skipping rope cardio exercise	Ejercicio cardiovascular de saltar la cuerda
acd5f253-ce68-4269-b9c0-6f95656b13c9	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	assault bike	beginner	cardio	hiit	4	150	180	14	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Assault Bike	Bicicleta Assault	Air bike with arm movement	Bicicleta de aire con movimiento de brazos
be1dd3e7-d9c3-4852-a7d6-6384c84260b6	MULTIARTICULAR	ASCENDING	Cardio	\N	\N	\N	\N	sled	intermediate	cardio	hiit	4	150	180	12	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Sled Push	Empuje de Trineo	Pushing weighted sled for conditioning	Empujar trineo con peso para acondicionamiento
4a209f26-f4e5-4e55-85bc-54b259f3a289	MULTIARTICULAR	ASCENDING	Cardio	\N	\N	\N	\N	sled, rope	intermediate	cardio	hiit	4	150	180	11	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Sled Pull	Tirón de Trineo	Pulling weighted sled backwards	Tirar del trineo con peso hacia atrás
9566c4f0-016c-4655-a040-08ff2e368111	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	bodyweight	beginner	cardio	hiit	4	150	175	10	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	High Knees	Rodillas Altas	Running in place with high knees	Correr en el lugar con rodillas altas
349689c5-87dd-4efe-84ee-cc1f6dd2ce7e	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	bodyweight	beginner	cardio	hiit	3	130	160	9	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Butt Kicks	Talones a Glúteos	Running in place kicking heels to glutes	Correr en el lugar llevando talones a glúteos
0956d3e5-dda2-4dc5-bf55-ba99da6758da	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	treadmill, track	intermediate	cardio	hiit	5	170	190	15	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Sprint Intervals	Intervalos de Sprint	High intensity sprint intervals	Intervalos de sprint de alta intensidad
ad7e8942-08b8-49d8-8352-532edfefcbdd	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	pool	beginner	cardio	liss	2	110	140	8	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Swimming	Natación	Swimming laps for cardio	Nadar largos para cardio
9b9ac85f-2bf1-4382-8bca-6301e4304b02	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	versa climber	intermediate	cardio	hiit	4	150	180	13	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Versa Climber	Versa Climber	Vertical climbing machine	Máquina de escalada vertical
45d2cb8f-e2cd-4242-8c03-d7570c8189f4	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	ski erg	beginner	cardio	miss	3	130	160	9	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Ski Erg	Ski Erg	Ski ergometer for upper body cardio	Ergómetro de ski para cardio de tren superior
7506b5f6-3890-4a58-92b5-a4782676492a	MULTIARTICULAR	FLAT	Cardio	\N	\N	\N	\N	treadmill, outdoor	beginner	cardio	liss	1	90	110	4	2025-11-29 21:38:11.456916	2025-11-29 21:38:11.456916	Walk	Caminar	Low intensity walking	Caminata de baja intensidad
7027654b-575d-49b8-8e26-e70bc76966b1	MONOARTICULAR	FLAT	Warmup			/static/exercises/7027654b-575d-49b8-8e26-e70bc76966b1_f5ebf559.gif	\N	bodyweight	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:10:29.659757	Leg Swings	Balanceo de Piernas	Dynamic leg swings for hip mobility	Balanceo dinámico de piernas para movilidad de cadera
0e27b27f-1558-48e0-9e09-6a950d63d6f7	MONOARTICULAR	FLAT	Warmup			/static/exercises/0e27b27f-1558-48e0-9e09-6a950d63d6f7_6dc025ee.gif	\N	bodyweight	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:14:30.255055	Arm Circles	Círculos de Brazos	Arm circles for shoulder warm-up	Círculos de brazos para calentar hombros
2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d	MULTIARTICULAR	FLAT	Cardio			/static/exercises/2b9ddf4b-35af-4b61-9f87-cbd6a292ab5d_d8268bcf.gif	\N	treadmill	beginner	cardio	liss	2	100	130	6	2025-11-29 21:38:11.456916	2025-12-08 21:40:22.291708	Incline Treadmill Walk	Caminata en Cinta Inclinada	Walking on incline treadmill for low impact cardio	Caminata en cinta inclinada para cardio de bajo impacto
e796d58b-b6a3-4ed3-9522-af85490f93e9	MULTIARTICULAR	FLAT	Cardio			/static/exercises/e796d58b-b6a3-4ed3-9522-af85490f93e9_4d88b945.jpg	\N	treadmill	beginner	cardio	miss	3	130	150	10	2025-11-29 21:38:11.456916	2025-12-08 21:41:37.828185	Treadmill Running	Correr en Cinta	Running on treadmill	Correr en cinta de correr
cbb47703-379e-4d82-8d82-fd27537cdf76	MONOARTICULAR	FLAT	Warmup	\N	\N	\N	\N	resistance band	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Shoulder Dislocates	Dislocaciones de Hombro	Shoulder mobility with band or stick	Movilidad de hombro con banda o palo
659dd679-0b5e-493e-87d3-02b2c6ab4836	MONOARTICULAR	FLAT	Mobility	\N	\N	\N	\N	bench, wall	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Couch Stretch	Estiramiento de Sofá	Hip flexor and quad stretch	Estiramiento de flexor de cadera y cuádriceps
8f77ef33-bbb3-40ff-963d-b0d34a12652c	MONOARTICULAR	FLAT	Mobility	\N	\N	\N	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Pigeon Stretch	Estiramiento de Paloma	Hip opener stretch	Estiramiento de apertura de cadera
e578906d-fcfc-400c-80fb-d953c8ad1c05	MONOARTICULAR	FLAT	Recovery	\N	\N	\N	\N	foam roller	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Foam Rolling Back	Rodillo en Espalda	Foam rolling for back muscles	Rodillo de espuma para músculos de la espalda
2320d84b-4474-4e73-ab89-97eea65e6c5e	MONOARTICULAR	FLAT	Recovery	\N	\N	\N	\N	foam roller	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Foam Rolling IT Band	Rodillo en Banda IT	Foam rolling for IT band	Rodillo de espuma para banda iliotibial
8b90fc50-b3e2-4de3-ba55-2c1e7ba5153b	MONOARTICULAR	FLAT	Mobility	\N	\N	\N	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Scorpion Stretch	Estiramiento del Escorpión	Lying spinal rotation stretch	Estiramiento de rotación espinal acostado
613bfb65-bfde-474e-8404-ced4adeb323b	MONOARTICULAR	FLAT	Mobility	\N	\N	\N	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	Frog Stretch	Estiramiento de Rana	Groin and hip adductor stretch	Estiramiento de ingle y aductores
4eda37b2-1e29-42cc-bd84-fe78bfd4f045	MULTIARTICULAR	FLAT	Warmup	\N	\N	\N	\N	bodyweight	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	A-Skips	Skips-A	Dynamic warm-up skip drill	Ejercicio dinámico de calentamiento con saltos
8fb09fe8-6871-4e1d-b3a7-3dca5e5a6e6e	MULTIARTICULAR	FLAT	Warmup	\N	\N	\N	\N	bodyweight	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 21:38:11.459868	B-Skips	Skips-B	Dynamic warm-up skip drill with leg extension	Ejercicio dinámico de calentamiento con extensión de pierna
b3c60b00-8728-4a7d-8f9f-2e5d1f8e3368	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Power Clean	Cargada de Potencia	Olympic weightlifting power clean	Cargada de potencia del levantamiento olímpico
ba2057dc-35f3-416c-b717-0214554ad8d8	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	plyo box	intermediate	plyometric	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Box Jumps	Saltos a Caja	Explosive box jump exercise	Ejercicio explosivo de salto a caja
e867589b-ceca-4d3d-b2e5-f23f44d2d22d	MULTIARTICULAR	BELL_SHAPED	Swing	\N	\N	\N	\N	kettlebell	intermediate	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Kettlebell Swing	Swing con Kettlebell	Hip hinge kettlebell swing	Swing de kettlebell con bisagra de cadera
8059bab2-c321-4408-a8c9-dc4048c7ee37	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell	intermediate	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Thrusters	Thrusters	Squat to overhead press combination	Combinación de sentadilla con press sobre cabeza
873a693f-baf9-41a9-84d2-71f7510c1894	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Hang Clean	Cargada Colgante	Clean starting from hang position	Cargada comenzando desde posición colgante
fae71fe3-2bd1-4525-ab8d-f7cf0cab52fa	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Snatch	Arrancada	Olympic snatch from floor to overhead	Arrancada olímpica desde el suelo hasta sobre la cabeza
a1b20788-20e9-4b96-a36f-06700a0d6854	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Hang Snatch	Arrancada Colgante	Snatch starting from hang position	Arrancada comenzando desde posición colgante
77933ce8-df0e-4b08-be8a-b8769459c420	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Clean and Jerk	Cargada y Envión	Full olympic clean and jerk	Cargada y envión olímpico completo
5278631f-9d65-4029-9c8a-d46a65edb89b	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Push Jerk	Envión con Impulso	Overhead jerk with leg drive and dip	Envión sobre la cabeza con impulso y hundimiento
2f4af852-c63b-4289-93ae-71ff952f4a02	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	plyo box	advanced	plyometric	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Depth Jump	Salto de Profundidad	Drop from box and immediately jump	Caer de caja y saltar inmediatamente
098443c2-6240-444b-9d6e-9d3af6a954a0	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	bodyweight	intermediate	plyometric	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Broad Jump	Salto Largo	Standing horizontal jump for distance	Salto horizontal de pie para distancia
44c6b7e4-d1ce-4744-a475-9553513f1b52	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	bodyweight	intermediate	plyometric	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Tuck Jump	Salto con Rodillas	Vertical jump bringing knees to chest	Salto vertical llevando rodillas al pecho
92646e7f-1247-465a-944d-2f37f81564a0	MULTIARTICULAR	DESCENDING	Plyometric	\N	\N	\N	\N	medicine ball	beginner	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Medicine Ball Slam	Slam de Balón Medicinal	Explosive overhead slam with medicine ball	Slam explosivo sobre la cabeza con balón medicinal
1d371fc9-8617-4557-b323-d7b9b700c472	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	medicine ball	beginner	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Medicine Ball Throw	Lanzamiento de Balón Medicinal	Explosive chest pass with medicine ball	Pase de pecho explosivo con balón medicinal
13e1a0d1-c18d-47ad-a80e-d2313395e432	MONOARTICULAR	FLAT	Mobility			/static/exercises/13e1a0d1-c18d-47ad-a80e-d2313395e432_5c16e61b.gif	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-12-08 23:46:57.432501	Hip 90/90 Stretch	Estiramiento de Cadera 90/90	Hip mobility stretch in 90/90 position	Estiramiento de movilidad de cadera en posición 90/90
e25515d5-4d65-446d-869e-cfb2cab39ff1	MONOARTICULAR	FLAT	Mobility			/static/exercises/e25515d5-4d65-446d-869e-cfb2cab39ff1_0170a581.gif	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:19:19.682547	Thoracic Spine Rotation	Rotación de Columna Torácica	Thoracic mobility exercise	Ejercicio de movilidad torácica
f531b3c7-2bb0-4f26-81e0-276d2fc8adaf	MULTIARTICULAR	FLAT	Warmup			/static/exercises/f531b3c7-2bb0-4f26-81e0-276d2fc8adaf_5ec68b96.gif	\N	bodyweight	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:20:32.26497	Inchworm	Gusano	Dynamic warm-up exercise	Ejercicio dinámico de calentamiento
ade38363-28c5-43c3-8f9e-711a997b0683	MULTIARTICULAR	FLAT	Mobility			/static/exercises/ade38363-28c5-43c3-8f9e-711a997b0683_994d4344.gif	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:21:52.320537	World Greatest Stretch	El Mejor Estiramiento del Mundo	Comprehensive mobility stretch	Estiramiento integral de movilidad
b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82	MONOARTICULAR	FLAT	Warmup			/static/exercises/b4a3e27c-a5b3-45ea-9eaa-97bbab6b3e82_2451c96d.gif	\N	wall	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:29:41.032381	Wall Angels	Ángeles en Pared	Wall slide for shoulder mobility	Deslizamiento en pared para movilidad de hombros
defba1ad-1834-410c-9a1e-6833a42ce87d	MONOARTICULAR	FLAT	Recovery			/static/exercises/defba1ad-1834-410c-9a1e-6833a42ce87d_8b0f0ce0.gif	\N	foam roller	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-12-08 23:47:53.038694	Foam Rolling Quads	Rodillo en Cuádriceps	Foam rolling for quad recovery	Rodillo de espuma para recuperación de cuádriceps
09e504a3-2524-48df-899a-0d0ed4a5a358	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	medicine ball, wall	beginner	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Wall Ball	Wall Ball	Squat and throw medicine ball to wall	Sentadilla y lanzar balón medicinal a la pared
25f6cf0f-d16e-4f00-88df-70e803aeb41f	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	plyo box	intermediate	plyometric	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Lateral Box Jump	Salto Lateral a Caja	Side-to-side box jump	Salto a caja de lado a lado
a245ce1d-1f11-4174-b7ff-5a4bdedf51b9	MULTIARTICULAR	ASCENDING	Plyometric	\N	\N	\N	\N	plyo box	advanced	plyometric	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Single Leg Box Jump	Salto a Caja Unilateral	Single leg jump onto box	Salto a caja con una pierna
85cbe2d0-c7f9-407a-8b4f-1e7bad47594f	MULTIARTICULAR	FLAT	Carry	\N	\N	\N	\N	dumbbells, kettlebells	beginner	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Farmers Walk	Caminata del Granjero	Walking while holding heavy weights	Caminar mientras se sostienen pesos pesados
44454387-8369-448f-a7e2-54d503773ce0	MULTIARTICULAR	FLAT	Olympic	\N	\N	\N	\N	kettlebell	advanced	conditioning	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Turkish Get Up	Levantamiento Turco	Complex full body movement from lying to standing	Movimiento complejo de cuerpo completo de acostado a de pie
fff16b04-1581-4369-ba5b-e68296e777a5	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Clean Pull	Tirón de Cargada	Pulling portion of the clean without catch	Parte de tirón de la cargada sin recepción
8992461a-fec3-4eb2-8bff-6d5ed82380ff	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Snatch Pull	Tirón de Arrancada	Pulling portion of the snatch without catch	Parte de tirón de la arrancada sin recepción
dab3a0cd-09db-4cad-8815-5ab04dd548ac	MULTIARTICULAR	ASCENDING	Lunge	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Front Rack Lunge	Zancada con Rack Frontal	Lunge with barbell in front rack position	Zancada con barra en posición de rack frontal
2981641d-f2ec-4267-9d33-c0032d73fba4	MULTIARTICULAR	ASCENDING	Squat	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Overhead Squat	Sentadilla sobre Cabeza	Squat with barbell held overhead	Sentadilla con barra sostenida sobre la cabeza
78a34a1c-0b0d-4e05-a8e4-bc56283d1a2e	MULTIARTICULAR	ASCENDING	Press	\N	\N	\N	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Split Jerk	Envión con Split	Jerk with split stance landing	Envión con aterrizaje en posición de split
cb0f187d-d525-4594-a69f-b45a2588dd20	MULTIARTICULAR	ASCENDING	Olympic	\N	\N	\N	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 21:38:11.462845	Muscle Snatch	Arrancada Muscular	Snatch without receiving in overhead squat	Arrancada sin recepción en sentadilla sobre cabeza
0a9724cd-177f-47bb-821d-f0ea3105f9ca	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.465802	2025-11-29 21:38:11.465802	Wrist Curl	Curl de Muñeca	Seated wrist curl for forearm flexors	Curl de muñeca sentado para flexores del antebrazo
bf6579b5-5704-45ef-94b0-6eac92d3a45e	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.465802	2025-11-29 21:38:11.465802	Reverse Wrist Curl	Curl de Muñeca Inverso	Reverse wrist curl for forearm extensors	Curl de muñeca inverso para extensores del antebrazo
881afbd4-8895-4591-82ec-96b64f80a352	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	weight plates	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.465802	2025-11-29 21:38:11.465802	Plate Pinch	Pinzamiento de Disco	Pinching weight plates together for grip	Pellizcar discos de peso para agarre
f4b345f7-e37c-4a27-9f9a-279c748dfcb6	MONOARTICULAR	FLAT	Static	\N	\N	\N	\N	pull-up bar	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.465802	2025-11-29 21:38:11.465802	Dead Hang	Colgado Muerto	Hanging from bar for grip endurance	Colgarse de la barra para resistencia de agarre
ce1040e4-784d-415f-a36f-e3d81402960e	MONOARTICULAR	BELL_SHAPED	Curl	\N	\N	\N	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.465802	2025-11-29 21:38:11.465802	Finger Curls	Curls de Dedos	Finger curls for grip strength	Curls de dedos para fuerza de agarre
fc140b0a-4244-45fa-8a77-2e28df28a3ac	MONOARTICULAR	ASCENDING	Static	\N	\N	\N	\N	hand gripper	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.465802	2025-11-29 21:38:11.465802	Gripper	Ejercicio de Pinza	Hand gripper for crushing grip	Pinza de mano para agarre de aplastamiento
442ff8a8-20d8-4259-b398-5b1d1ee2d038	MULTIARTICULAR	ASCENDING	Press		/static/exercises/movement/decline_bench_press_movement.png		\N	barbell, decline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 22:20:27.457279	Decline Bench Press	Press de Banca Declinado	Bench press on decline bench targeting lower chest	Press en banco declinado para pecho inferior
ffe46193-27da-4485-9d62-ee07a4c168a6	MULTIARTICULAR	ASCENDING	Row			/static/exercises/ffe46193-27da-4485-9d62-ee07a4c168a6_c7496633.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-08 23:27:49.792192	Pendlay Row	Remo Pendlay	Explosive barbell row from floor with strict form	Remo explosivo con barra desde el suelo con forma estricta
a65dc37c-13ad-448d-8ef7-a31d938c7ead	MULTIARTICULAR	ASCENDING	Deadlift			/static/exercises/a65dc37c-13ad-448d-8ef7-a31d938c7ead_91c07c0f.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 22:34:32.932258	Romanian Deadlift	Peso Muerto Rumano	Stiff-legged deadlift variation for hamstrings	Variante de peso muerto para isquiotibiales
43a9b1fe-8f85-4126-8690-e55410aa022c	MULTIARTICULAR	ASCENDING	Thrust			/static/exercises/43a9b1fe-8f85-4126-8690-e55410aa022c_4d870c8d.gif	\N	barbell, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 18:50:25.241729	Hip Thrust (Barbell)	Empuje de Cadera con Barra	Barbell hip thrust for glutes	Empuje de cadera con barra para glúteos
b886bfd5-6bd2-41be-98c8-9ac9f8d23fc5	MULTIARTICULAR	DESCENDING	Pull			/static/exercises/b886bfd5-6bd2-41be-98c8-9ac9f8d23fc5_acc7fd73.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-11-29 22:49:43.185528	Close Grip Lat Pulldown	Jalón al Pecho Agarre Cerrado	Lat pulldown with close grip	Jalón con agarre cerrado
8e5a5996-e52a-4fac-bb94-c475d85cfb36	MULTIARTICULAR	ASCENDING	Press			/static/exercises/8e5a5996-e52a-4fac-bb94-c475d85cfb36_9970136c.gif	\N	barbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.462845	2025-11-29 22:54:07.194253	Push Press	Press con Impulso	Overhead press with leg drive	Press sobre la cabeza con impulso de piernas
b71bc548-189e-40a3-84dc-a826b521b5d4	MULTIARTICULAR	ASCENDING	Squat		/static/exercises/movement/front_squat_movement.png	/static/exercises/b71bc548-189e-40a3-84dc-a826b521b5d4_a0ff5516.webp	\N	barbell	advanced	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 22:54:44.685947	Front Squat	Sentadilla Frontal	Barbell front squat emphasizing quads	Sentadilla frontal con barra enfatizando cuádriceps
bcc75aab-390b-4e8d-be43-b76bf5ff3466	MULTIARTICULAR	ASCENDING	Squat		/static/exercises/movement/bulgarian_split_squat_movement.png	/static/exercises/bcc75aab-390b-4e8d-be43-b76bf5ff3466_4981bb4d.gif	\N	dumbbells, bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-11-29 22:55:33.026333	Bulgarian Split Squat	Sentadilla Búlgara	Single leg squat with rear foot elevated	Sentadilla a una pierna con pie trasero elevado
f89614fb-f6ed-4733-877f-e357906c4925	MONOARTICULAR	FLAT	Warmup			/static/exercises/f89614fb-f6ed-4733-877f-e357906c4925_8272c6b5.gif	\N	bodyweight	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:06:10.141701	Hip Circles	Círculos de Cadera	Hip circles for mobility	Círculos de cadera para movilidad
3fb2ab04-137c-44ce-a16b-d4b12c818172	MONOARTICULAR	FLAT	Warmup			/static/exercises/3fb2ab04-137c-44ce-a16b-d4b12c818172_2231d282.gif	\N	resistance band	beginner	warmup	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-11-29 23:16:49.019556	Band Pull Apart	Separación de Banda	Band pull apart for shoulder warm-up	Separación de banda para calentar hombros
cdaa6012-b647-4168-aadc-58c1d033b3bb	MONOARTICULAR	FLAT	Pull			/static/exercises/cdaa6012-b647-4168-aadc-58c1d033b3bb_6ff31e31.webp	\N	cables, rope attachment	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-11-29 23:24:40.325006	Cable Face Pull	Tirón Facial con Cable	Cable face pull variation with external rotation	Variación de tirón facial con rotación externa
bad51b6d-2654-4c25-b69e-ba9c5f094449	MONOARTICULAR	FLAT	Mobility			/static/exercises/bad51b6d-2654-4c25-b69e-ba9c5f094449_7afb369c.webp	\N	bodyweight	beginner	mobility	\N	\N	\N	\N	\N	2025-11-29 21:38:11.459868	2025-12-08 23:43:06.258881	Cat-Cow Stretch	Estiramiento Gato-Vaca	Spinal mobility exercise	Ejercicio de movilidad espinal
45ffd819-86b1-4f9f-998c-d0707edb1b8c	MONOARTICULAR	FLAT	Fly			/static/exercises/45ffd819-86b1-4f9f-998c-d0707edb1b8c_7933a48b.jpg	\N	cables	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-11-29 23:38:57.762974	Low to High Cable Fly	Cruce de Poleas Bajo a Alto	Cable fly from low to high targeting upper chest	Cruce de poleas desde abajo hacia arriba para pecho superior
35be3e87-2c9d-454c-9c7b-5ec6ca0c9625	MULTIARTICULAR	ASCENDING	Thrust			/static/exercises/35be3e87-2c9d-454c-9c7b-5ec6ca0c9625_f0451f08.jpg	\N	barbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-11-29 23:57:29.825886	Glute Bridge	Puente de Glúteos	Floor glute bridge exercise	Puente de glúteos en el suelo
8733deeb-0ceb-4541-a027-94e00a95586b	MULTIARTICULAR	ASCENDING	Deadlift			/static/exercises/8733deeb-0ceb-4541-a027-94e00a95586b_96aa8c6c.gif	\N	dumbbell	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 23:50:06.189297	Single Leg Romanian Deadlift	Peso Muerto Rumano Unilateral	Single leg RDL for hamstrings and balance	Peso muerto rumano a una pierna para isquiotibiales y equilibrio
ab1f5ba2-01ae-4770-8fad-9dd007edf61d	MULTIARTICULAR	FLAT	Cardio			/static/exercises/ab1f5ba2-01ae-4770-8fad-9dd007edf61d_e0222903.gif	\N	stair climber machine	beginner	cardio	liss	2	100	130	7	2025-11-29 21:38:11.456916	2025-12-07 00:42:20.640312	Stair Climber	Escaladora	Stair climbing machine	Máquina de subir escaleras
6cd9c5f9-38db-401d-8099-b64a7e580c5f	MULTIARTICULAR	ASCENDING	Squat		/static/exercises/movement/goblet_squat_movement.jpeg	/static/exercises/6cd9c5f9-38db-401d-8099-b64a7e580c5f_ff04b8b1.jpg	\N	dumbbell	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:28:39.891612	Goblet Squat	Sentadilla Goblet	Dumbbell or kettlebell squat held at chest	Sentadilla con mancuerna o kettlebell sostenida al pecho
1da215b2-666a-4246-b7eb-f72c98de082d	MONOARTICULAR	ASCENDING	Abduction			/static/exercises/1da215b2-666a-4246-b7eb-f72c98de082d_f5baf3d0.gif	\N	hip abduction machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 15:48:01.123276	Hip Abduction Machine	Máquina de Abducción de Cadera	Machine hip abduction for glute medius	Abducción de cadera en máquina para glúteo medio
da02760a-78ad-410c-aedc-d8bba31198dc	MONOARTICULAR	ASCENDING	Curl			/static/exercises/da02760a-78ad-410c-aedc-d8bba31198dc_6d299ce3.gif	\N	leg curl machine	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.437979	2025-12-08 15:53:11.119261	Lying Leg Curl	Curl de Pierna Acostado	Lying leg curl for hamstrings	Curl de pierna acostado para isquiotibiales
bf177fc2-1241-40f0-b1ef-b1001685d77f	MULTIARTICULAR	ASCENDING	Thrust			/static/exercises/bf177fc2-1241-40f0-b1ef-b1001685d77f_3a64b0c3.jpg	\N	resistance band, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.44143	2025-12-08 19:56:04.824036	Banded Hip Thrust	Empuje de Cadera con Banda	Hip thrust with resistance band around knees	Empuje de cadera con banda de resistencia en rodillas
26b71d2c-1250-4b4f-8804-934360d384ca	MONOARTICULAR	DESCENDING	Curl			/static/exercises/26b71d2c-1250-4b4f-8804-934360d384ca_352f4f8c.gif	\N	dumbbells, incline bench	intermediate	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.447839	2025-12-08 21:51:55.253555	Spider Curl	Curl Araña	Incline bench curl with arms hanging	Curl en banco inclinado con brazos colgando
e08d2b37-cdf9-4285-8307-6d4a2a60492b	MONOARTICULAR	DESCENDING	Raise			/static/exercises/e08d2b37-cdf9-4285-8307-6d4a2a60492b_5fd662ca.gif	\N	dumbbells	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.434871	2025-12-08 22:00:42.538137	Lateral Raise (Dumbbell)	Elevación Lateral con Mancuernas	Dumbbell lateral raise for side delts	Elevación lateral con mancuernas para deltoides lateral
1b1adef1-d675-4a94-b499-42dc244011c6	MONOARTICULAR	DESCENDING	Crunch			/static/exercises/1b1adef1-d675-4a94-b499-42dc244011c6_224cda9d.gif	\N	cables	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-12-08 22:35:49.090293	Cable Crunch	Crunch en Polea	Kneeling cable crunch for abs	Crunch de rodillas en polea para abdominales
d483a4b4-9b78-4135-ae09-348de96db487	MONOARTICULAR	FLAT	Static			/static/exercises/d483a4b4-9b78-4135-ae09-348de96db487_225df1b9.gif	\N	bodyweight	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.453974	2025-12-08 22:36:51.474747	Plank	Plancha	Isometric plank hold for core stability	Plancha isométrica para estabilidad del core
93523bc4-42be-47da-8286-fb628887bf5f	MULTIARTICULAR	ASCENDING	Press			/static/exercises/93523bc4-42be-47da-8286-fb628887bf5f_ecdc1eea.gif	\N	barbell, bench	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.425865	2025-12-08 23:24:48.722078	Flat Barbell Bench Press	Press de Banca Plano con Barra	Lie on flat bench, grip bar slightly wider than shoulder width, lower to chest and press up	Acostado en banco plano, agarra la barra ligeramente más ancho que los hombros, baja al pecho y empuja hacia arriba
9da2b8ad-0895-4665-987f-7b3b4cbd8cb1	MONOARTICULAR	FLAT	Pull	https://res.cloudinary.com/dhaagdr7e/video/upload/v1764901192/facepull_dykwqo.mp4		/static/exercises/9da2b8ad-0895-4665-987f-7b3b4cbd8cb1_eeaf8235.gif	\N	cables, rope attachment	beginner	strength	\N	\N	\N	\N	\N	2025-11-29 21:38:11.431043	2025-12-09 04:02:27.284418	Face Pull	Jalón al rostro	Cable face pull for rear delts and rotator cuff	Tirón facial en polea para deltoides posterior y manguito rotador
\.


--
-- Data for Name: macrocycles; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.macrocycles (id, name, description, objective, start_date, end_date, status, trainer_id, client_id, created_at, updated_at) FROM stdin;
550e8400-e29b-41d4-a716-446655440001	Programa Recomposición Corporal - Itzel	Programa de 8 semanas enfocado en desarrollo de glúteos y pérdida de grasa	fat_loss	2025-12-02	2026-01-26	ACTIVE	2943c951-31ca-472f-bc1e-64b09bd580f2	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	2025-11-29 22:23:12.293592	2025-11-29 22:23:12.293592
273c9a88-ba88-4cef-a6db-9e4588f7965d	Programa Glúteos y Fat Loss - Yubana	Programa personalizado enfocado en desarrollo de glúteos y pérdida de grasa. Diseñado para principiante con alta frecuencia de glúteos y cardio para fat loss.	fat_loss	2025-12-08	2025-12-14	DRAFT	2943c951-31ca-472f-bc1e-64b09bd580f2	d9db0550-0b04-45cd-b3ed-92ecea0fe11c	2025-12-05 13:17:09.570739	2025-12-08 20:13:31.698923
66582a89-3b48-458e-a7c4-3deba4be68fd	Plan Hipertrofia	Programa enfocado en desarrollo muscular general. Frecuencia 4 (Upper/Lower).	hypertrophy	2025-12-07	2026-03-01	ACTIVE	2943c951-31ca-472f-bc1e-64b09bd580f2	231ed91b-0207-41e4-a741-3b396a84ef3e	2025-12-08 23:04:25.417131	2025-12-09 02:02:15.425531
\.


--
-- Data for Name: mesocycles; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.mesocycles (id, macrocycle_id, block_number, name, description, start_date, end_date, focus, notes, created_at, updated_at) FROM stdin;
550e8400-e29b-41d4-a716-446655440010	550e8400-e29b-41d4-a716-446655440001	1	Fase de Acumulación	Volumen de trabajo y técnica	2025-12-02	2025-12-29	Volumen	\N	2025-11-29 22:23:18.540653	2025-11-29 22:23:18.540653
550e8400-e29b-41d4-a716-446655440020	550e8400-e29b-41d4-a716-446655440001	2	Fase de Intensificación	Fuerza y definición	2025-12-30	2026-01-26	Intensidad	\N	2025-11-29 22:23:18.540653	2025-11-29 22:23:18.540653
c29b302b-90c5-4d0e-8f64-bbce4aff9352	273c9a88-ba88-4cef-a6db-9e4588f7965d	1	Bloque 1: Adaptación y Desarrollo	Semana de adaptación con enfoque en glúteos y fat loss	2025-12-09	2025-12-15	Hypertrophy	RIR 2-3 para adaptación inicial. Alta frecuencia de glúteos.	2025-12-05 13:17:09.578168	2025-12-05 13:17:09.57817
da202df9-339f-45c3-a8d6-84948cf79864	66582a89-3b48-458e-a7c4-3deba4be68fd	1	Mesociclo 1 - Acumulación	Foco en volumen y técnica. RIR 2-3.	2025-12-08	2026-01-05	Hypertrophy	\N	2025-12-08 23:04:25.425691	2025-12-08 23:04:25.425692
\.


--
-- Data for Name: microcycles; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.microcycles (id, mesocycle_id, week_number, name, start_date, end_date, intensity_level, notes, created_at, updated_at) FROM stdin;
550e8400-e29b-41d4-a716-446655440101	550e8400-e29b-41d4-a716-446655440010	1	Semana 1 - Adaptación	2025-12-02	2025-12-08	LOW	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440102	550e8400-e29b-41d4-a716-446655440010	2	Semana 2 - Progresión	2025-12-09	2025-12-15	MEDIUM	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440103	550e8400-e29b-41d4-a716-446655440010	3	Semana 3 - Intensificación	2025-12-16	2025-12-22	HIGH	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440104	550e8400-e29b-41d4-a716-446655440010	4	Semana 4 - Descarga	2025-12-23	2025-12-29	DELOAD	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440201	550e8400-e29b-41d4-a716-446655440020	5	Semana 5 - Adaptación	2025-12-30	2026-01-05	LOW	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440202	550e8400-e29b-41d4-a716-446655440020	6	Semana 6 - Progresión	2026-01-06	2026-01-12	MEDIUM	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440203	550e8400-e29b-41d4-a716-446655440020	7	Semana 7 - Intensificación	2026-01-13	2026-01-19	HIGH	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
550e8400-e29b-41d4-a716-446655440204	550e8400-e29b-41d4-a716-446655440020	8	Semana 8 - Descarga Final	2026-01-20	2026-01-26	DELOAD	\N	2025-11-29 22:23:42.804548	2025-11-29 22:23:42.804548
e6167a64-438e-42f5-afcc-e9d8020dc70c	c29b302b-90c5-4d0e-8f64-bbce4aff9352	1	Semana 1 - Adaptación	2025-12-09	2025-12-15	LOW	Semana de adaptación con volumen moderado	2025-12-05 13:17:09.580184	2025-12-05 13:17:09.580186
d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	da202df9-339f-45c3-a8d6-84948cf79864	1	Semana 1	2025-12-08	2025-12-15	MEDIUM	\N	2025-12-08 23:04:25.43407	2025-12-08 23:04:25.434071
\.


--
-- Data for Name: muscles; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.muscles (id, name, display_name_es, display_name_en, body_region, muscle_category, svg_ids, sort_order, created_at, updated_at) FROM stdin;
91652340-844c-43d3-80da-de1ce7304a48	chest	Pecho	Chest	upper_body	chest	\N	1	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
d768ffc4-b0a1-4c75-8c11-c886daf0e2cc	lats	Dorsales	Lats	upper_body	back	\N	2	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
b0a3a331-9c53-4ff3-b4d1-4dba6cb4e352	upper_back	Espalda Superior	Upper Back	upper_body	back	\N	3	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
abadd271-e2cb-4f4f-9aa4-9aabae72db67	lower_back	Espalda Baja	Lower Back	core	back	\N	4	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
936a7751-7076-4802-821c-33fc87546897	anterior_deltoid	Deltoides Anterior	Anterior Deltoid	upper_body	shoulders	\N	5	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
7ae11464-3f30-47ce-ab9e-5fae4a225805	posterior_deltoid	Deltoides Posterior	Posterior Deltoid	upper_body	shoulders	\N	6	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
a70b9f88-0317-4c0f-9de1-01679cfaedcb	biceps	Bíceps	Biceps	upper_body	arms	\N	7	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
42193381-087e-4fb5-bfb1-ae4edba6aa4a	triceps	Tríceps	Triceps	upper_body	arms	\N	8	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
b8a7caad-178d-4ae4-b345-fb1d73b9ad2b	quadriceps	Cuádriceps	Quadriceps	lower_body	legs	\N	9	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
99e28019-b7bc-4278-b4eb-0b9bb53878f6	hamstrings	Isquiotibiales	Hamstrings	lower_body	legs	\N	10	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
c1b71264-dafc-4e42-99f9-92df8b91fe5d	glutes	Glúteos	Glutes	lower_body	legs	\N	11	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
2a06511f-22fd-49cc-85da-99a0d7bd0df1	calves	Pantorrillas	Calves	lower_body	legs	\N	12	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
647be680-283b-4014-a57c-03eb2feb33f4	adductors	Aductores	Adductors	lower_body	legs	\N	13	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
3a83a736-9869-432f-985f-5430456ba7c1	tibialis	Tibial Anterior	Tibialis	lower_body	legs	\N	14	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
a882ad41-4a86-4c6d-93ac-6a3bd4c55bcd	abs	Abdominales	Abs	core	core	\N	15	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
018c8d48-0ec8-4e81-ad52-43b091840c45	obliques	Oblicuos	Obliques	core	core	\N	16	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
f4e8c7a3-5b92-4d61-a8f3-9c7e2d1b0a45	forearms	Antebrazos	Forearms	upper_body	arms	\N	17	2025-11-29 21:37:47.704205	2025-11-29 21:37:47.704205
\.


--
-- Data for Name: training_days; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.training_days (id, microcycle_id, day_number, date, name, focus, rest_day, notes, created_at, updated_at) FROM stdin;
550e8400-e29b-41d4-a716-446655441011	550e8400-e29b-41d4-a716-446655440101	1	2025-12-02	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:23:52.789118	2025-11-29 22:23:52.789118
550e8400-e29b-41d4-a716-446655441012	550e8400-e29b-41d4-a716-446655440101	2	2025-12-03	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:23:52.789118	2025-11-29 22:23:52.789118
550e8400-e29b-41d4-a716-446655441013	550e8400-e29b-41d4-a716-446655440101	3	2025-12-04	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:23:52.789118	2025-11-29 22:23:52.789118
550e8400-e29b-41d4-a716-446655441014	550e8400-e29b-41d4-a716-446655440101	4	2025-12-05	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:23:52.789118	2025-11-29 22:23:52.789118
550e8400-e29b-41d4-a716-446655441015	550e8400-e29b-41d4-a716-446655440101	5	2025-12-06	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:23:52.789118	2025-11-29 22:23:52.789118
550e8400-e29b-41d4-a716-446655441021	550e8400-e29b-41d4-a716-446655440102	1	2025-12-09	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441022	550e8400-e29b-41d4-a716-446655440102	2	2025-12-10	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441023	550e8400-e29b-41d4-a716-446655440102	3	2025-12-11	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441024	550e8400-e29b-41d4-a716-446655440102	4	2025-12-12	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441025	550e8400-e29b-41d4-a716-446655440102	5	2025-12-13	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441031	550e8400-e29b-41d4-a716-446655440103	1	2025-12-16	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441032	550e8400-e29b-41d4-a716-446655440103	2	2025-12-17	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441033	550e8400-e29b-41d4-a716-446655440103	3	2025-12-18	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441034	550e8400-e29b-41d4-a716-446655440103	4	2025-12-19	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441035	550e8400-e29b-41d4-a716-446655440103	5	2025-12-20	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441041	550e8400-e29b-41d4-a716-446655440104	1	2025-12-23	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441042	550e8400-e29b-41d4-a716-446655440104	2	2025-12-24	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441043	550e8400-e29b-41d4-a716-446655440104	3	2025-12-25	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441044	550e8400-e29b-41d4-a716-446655440104	4	2025-12-26	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441045	550e8400-e29b-41d4-a716-446655440104	5	2025-12-27	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:22.697055	2025-11-29 22:25:22.697055
550e8400-e29b-41d4-a716-446655441051	550e8400-e29b-41d4-a716-446655440201	1	2025-12-30	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441052	550e8400-e29b-41d4-a716-446655440201	2	2025-12-31	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441053	550e8400-e29b-41d4-a716-446655440201	3	2026-01-01	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441054	550e8400-e29b-41d4-a716-446655440201	4	2026-01-02	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441055	550e8400-e29b-41d4-a716-446655440201	5	2026-01-03	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441061	550e8400-e29b-41d4-a716-446655440202	1	2026-01-06	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441062	550e8400-e29b-41d4-a716-446655440202	2	2026-01-07	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441063	550e8400-e29b-41d4-a716-446655440202	3	2026-01-08	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441064	550e8400-e29b-41d4-a716-446655440202	4	2026-01-09	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441065	550e8400-e29b-41d4-a716-446655440202	5	2026-01-10	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441071	550e8400-e29b-41d4-a716-446655440203	1	2026-01-13	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441072	550e8400-e29b-41d4-a716-446655440203	2	2026-01-14	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441073	550e8400-e29b-41d4-a716-446655440203	3	2026-01-15	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441074	550e8400-e29b-41d4-a716-446655440203	4	2026-01-16	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441075	550e8400-e29b-41d4-a716-446655440203	5	2026-01-17	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441081	550e8400-e29b-41d4-a716-446655440204	1	2026-01-20	Lower Body - Énfasis Glúteos	Glúteos, Isquiotibiales	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441082	550e8400-e29b-41d4-a716-446655440204	2	2026-01-21	Upper Body - Push + Postura	Pecho, Hombros, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441083	550e8400-e29b-41d4-a716-446655440204	3	2026-01-22	Lower Body - Cuádriceps	Cuádriceps, Glúteos	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441084	550e8400-e29b-41d4-a716-446655440204	4	2026-01-23	Upper Body - Pull + Postura	Espalda, Bíceps, Postura	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
550e8400-e29b-41d4-a716-446655441085	550e8400-e29b-41d4-a716-446655440204	5	2026-01-24	Full Body - Glúteos + Core	Glúteos, Core	f	\N	2025-11-29 22:25:40.354152	2025-11-29 22:25:40.354152
ea9581e2-d848-495d-bf0b-b7e7708f634f	e6167a64-438e-42f5-afcc-e9d8020dc70c	1	2025-12-09	Lower Body A - Enfoque Glúteos	Glúteos y Cadena Posterior	f	Día de enfoque en glúteos con cardio post-entrenamiento	2025-12-05 13:17:09.581461	2025-12-05 13:17:09.581462
d3a3267e-7da8-47f2-a688-6b63c8d0d9c1	e6167a64-438e-42f5-afcc-e9d8020dc70c	5	2025-12-13	Lower Body D - Full Legs + Glúteos	Piernas Completas	f	Día de piernas completas con énfasis en glúteos y cardio extendido	2025-12-05 13:17:09.594129	2025-12-05 13:17:09.59413
7ae61469-78c1-4af6-9b84-5b89dee5103c	e6167a64-438e-42f5-afcc-e9d8020dc70c	2	2025-12-10	Upper body A	Cuádriceps e Isquiotibiales	f	Día de enfoque en cuádriceps con trabajo de glúteos complementario	2025-12-05 13:17:09.582746	2025-12-08 20:44:06.873287
1413e724-153d-4618-9d90-125710fd321e	e6167a64-438e-42f5-afcc-e9d8020dc70c	3	2025-12-11	Descanso Activo - Cardio y ABS	Recuperación y Fat Loss	f	Día de descanso activo con cardio de baja intensidad	2025-12-05 13:17:09.588754	2025-12-08 22:02:14.020517
51940114-1276-49d0-8f3d-221ec70d8254	e6167a64-438e-42f5-afcc-e9d8020dc70c	4	2025-12-12	Upper body B	Glúteos y Piernas	f	Segundo día enfocado en glúteos de la semana	2025-12-05 13:17:09.592173	2025-12-08 22:39:29.621312
32150047-3d57-456f-bc05-9193188ab3fa	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	1	2025-12-08	Upper Body Strength	Torso Fuerza	f	\N	2025-12-08 23:04:25.441046	2025-12-08 23:04:25.441048
dc2d38c0-0d15-45b8-ad3b-78b882247948	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	2	2025-12-09	Lower Body Squat Focus	Pierna Enfasis Sentadilla	f	\N	2025-12-08 23:04:25.467452	2025-12-08 23:04:25.467454
b65912a8-33bc-460e-8d5b-ce983e2f9275	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	3	2025-12-10	Descanso	Recuperación	t	\N	2025-12-08 23:04:25.482497	2025-12-08 23:04:25.482499
3a755073-7581-45e8-8846-e43b1b6abd7f	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	4	2025-12-11	Upper Body Hypertrophy	Torso Hipertrofia	f	\N	2025-12-08 23:04:25.487123	2025-12-08 23:04:25.487125
5a5e7ca7-e0aa-4dea-b66c-b742c227684a	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	5	2025-12-12	Lower Body Hinge Focus	Pierna Cadena Posterior	f	\N	2025-12-08 23:04:25.501348	2025-12-08 23:04:25.501349
d82bddaf-0cb0-4858-822c-83ae56bd4778	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	6	2025-12-13	Descanso	Recuperación	t	\N	2025-12-08 23:04:25.516398	2025-12-08 23:04:25.516399
ede18304-d400-4553-b60d-04911f2b1628	d711ebe5-12cd-4d12-ba12-f90e2e81fb8d	7	2025-12-14	Descanso	Recuperación	t	\N	2025-12-08 23:04:25.521001	2025-12-08 23:04:25.521002
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.users (id, email, hashed_password, full_name, role, preferred_language, is_active, is_verified, created_at, updated_at, profile_image_url) FROM stdin;
231ed91b-0207-41e4-a741-3b396a84ef3e	yair.leal@hotmail.com	$argon2id$v=19$m=65536,t=3,p=4$6b33npOyFqL0fi9lzFmLUQ$LdGJXelWmxDcroFpTkjbX3wRH1N2YfXyYRru87Vq57Y	Yahir Leal Zamago	CLIENT	es	t	f	2025-12-08 22:48:59.724556	2025-12-08 22:48:59.724559	\N
2943c951-31ca-472f-bc1e-64b09bd580f2	admin@fitpilot.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Admin User	ADMIN	es	t	t	2025-11-29 21:38:27.670731	2025-12-09 02:03:00.853733	\N
e4244715-20b9-4103-beca-6da91ce89338	trainer1@fitpilot.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Carlos Rodriguez	TRAINER	es	t	t	2025-11-29 21:38:27.670741	2025-11-29 21:38:27.670741	\N
8ad0f894-092e-448c-bc57-15cced818d58	trainer2@fitpilot.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Maria Garcia	TRAINER	es	t	t	2025-11-29 21:38:27.670746	2025-11-29 21:38:27.670746	\N
b0245a5f-7e07-4e27-85d7-1c1cccc0f879	client1@fitpilot.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Juan Perez	CLIENT	es	t	t	2025-11-29 21:38:27.670753	2025-11-29 21:38:27.670754	\N
5bb507ce-5090-4466-8296-7ebbb695ba20	client2@fitpilot.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Ana Martinez	CLIENT	es	t	t	2025-11-29 21:38:27.670758	2025-11-29 21:38:27.670759	\N
6a64e807-0bc6-4248-aec1-55015b2e6b4e	client3@fitpilot.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Luis Sanchez	CLIENT	es	t	f	2025-11-29 21:38:27.670762	2025-11-29 21:38:27.670762	\N
d9db0550-0b04-45cd-b3ed-92ecea0fe11c	yubbi2629@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Yubana Brahams Lorenzo	CLIENT	es	t	f	2025-12-02 02:29:23.363812	2025-12-02 02:29:23.363815	\N
ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	Itzy2908@hotmail.com	$argon2id$v=19$m=65536,t=3,p=4$QiilNAaAEOI853yvNcaYUw$9Z7hnOcmHLPH+7CoiQU8gPSjRwzCeaf0LnG+FapMdpA	Itzel Britney Rodríguez Brahams	CLIENT	es	t	f	2025-11-29 21:59:50.875114	2025-11-29 21:59:50.875118	\N
\.


--
-- Data for Name: workout_logs; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.workout_logs (id, client_id, training_day_id, started_at, completed_at, status, notes, created_at, updated_at, abandon_reason, abandon_notes, rescheduled_to_date) FROM stdin;
71392227-b8a3-402a-adff-0edc4a129b6e	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441011	2025-12-02 04:09:45.335851	2025-12-02 04:17:49.258336	completed	\N	2025-12-02 04:09:45.335853	2025-12-02 04:17:49.259335	\N	\N	\N
d2e9fde8-f093-4565-a987-20acc413e84a	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-02 04:28:42.417634	\N	abandoned	\N	2025-12-02 04:28:42.417637	2025-12-02 04:28:47.963115	\N	\N	\N
93cd4e31-68a6-4715-93d5-aa71356b73d1	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-02 17:16:11.378146	\N	abandoned	\N	2025-12-02 17:16:11.37815	2025-12-03 03:10:55.59099	\N	\N	\N
089cb89b-9653-47b0-9243-21d1510c34e2	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-03 03:11:00.17898	\N	abandoned	\N	2025-12-03 03:11:00.178982	2025-12-03 03:12:40.035385	\N	\N	\N
02a5a483-b447-417d-8e4c-02071b32fe69	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-03 03:14:41.1037	\N	abandoned	\N	2025-12-03 03:14:41.103702	2025-12-03 03:14:56.622206	\N	\N	\N
ea19c26e-31de-45c6-b8b6-531c958cb1fc	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-03 03:14:58.242989	\N	abandoned	\N	2025-12-03 03:14:58.24299	2025-12-03 03:15:15.941616	\N	\N	\N
c995a1c1-6dd1-4524-8fe7-c9234fb1c1da	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-03 03:29:59.989076	\N	abandoned	\N	2025-12-03 03:29:59.989079	2025-12-03 13:54:32.159304	\N	\N	\N
ac232689-8b16-4fab-81c4-7ba8a56f702d	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-03 16:41:26.618899	\N	abandoned	\N	2025-12-03 16:41:26.618901	2025-12-03 16:41:40.431251	\N	\N	\N
bd36152e-ff0e-4406-8f13-c70460ce50f7	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441012	2025-12-03 17:01:09.749365	2025-12-03 17:38:49.269019	completed	\N	2025-12-03 17:01:09.749366	2025-12-03 17:38:49.269826	\N	\N	\N
852df412-afac-44c8-8536-8b44460e9f39	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-03 17:41:21.366717	\N	abandoned	\N	2025-12-03 17:41:21.366719	2025-12-03 18:14:07.093379	\N	\N	\N
329de414-a445-4af9-a387-697f508c7d3b	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-03 20:15:21.665685	\N	abandoned	\N	2025-12-03 20:15:21.665687	2025-12-03 20:15:28.561954	\N	\N	\N
7b678572-0537-435d-affb-dfb70aebd59d	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 01:16:33.104339	\N	abandoned	\N	2025-12-04 01:16:33.104341	2025-12-04 01:32:00.094574	\N	\N	\N
7f4cbcc8-0159-46d0-9281-155e69b3b641	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 01:32:18.995768	\N	abandoned	\N	2025-12-04 01:32:18.995769	2025-12-04 01:34:58.213386	\N	\N	\N
1174faa0-7373-48f4-81f3-69c898b983da	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 01:38:15.659513	\N	abandoned	\N	2025-12-04 01:38:15.659515	2025-12-04 01:42:55.202447	\N	\N	\N
0cf3b350-4be2-4d8b-9523-c2628bb0c65b	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 01:42:59.567376	\N	abandoned	\N	2025-12-04 01:42:59.567377	2025-12-04 02:44:59.026217	\N	\N	\N
eb492bd3-557b-486a-88ed-a9e12866181a	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 02:58:59.100564	\N	abandoned	\N	2025-12-04 02:58:59.100565	2025-12-04 02:59:21.160136	\N	\N	\N
40a31804-794f-414e-969a-b41d851da1be	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 02:59:25.227794	\N	abandoned	\N	2025-12-04 02:59:25.227796	2025-12-04 03:01:23.014864	\N	\N	\N
b680aada-5756-40f3-abcd-5a6a8b927a1d	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 03:01:25.190466	\N	abandoned	\N	2025-12-04 03:01:25.190467	2025-12-04 03:01:53.274278	\N	\N	\N
b9a15c6b-03b4-4176-8c12-d97fa3976914	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 03:48:46.689277	\N	abandoned	\N	2025-12-04 03:48:46.689279	2025-12-04 04:07:44.574862	\N	\N	\N
c2178bee-6588-4049-927f-af30d9412d3c	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 04:07:55.989063	\N	abandoned	\N	2025-12-04 04:07:55.989064	2025-12-04 13:41:34.479017	\N	\N	\N
65a81dea-3ee8-42e1-a3dc-b5382239ce4a	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 17:14:30.876097	\N	abandoned	\N	2025-12-04 17:14:30.876098	2025-12-04 19:06:38.417262	\N	\N	\N
b9551cfd-9a6f-4c59-ae4b-78478cd0ab14	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 19:06:40.748108	\N	abandoned	\N	2025-12-04 19:06:40.748109	2025-12-04 19:15:52.631031	\N	\N	\N
817b748a-c69f-4acd-b389-92898d00a960	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 19:15:55.838012	\N	abandoned	\N	2025-12-04 19:15:55.838014	2025-12-04 19:20:58.373217	\N	\N	\N
d39c36e8-6277-4d49-84d5-6164d7382668	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-04 19:22:45.66803	\N	abandoned	\N	2025-12-04 19:22:45.668031	2025-12-05 02:07:04.437754	\N	\N	\N
8c597822-0df8-4eae-8aa0-bbe823247eb4	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 02:07:06.684042	\N	abandoned	\N	2025-12-05 02:07:06.684043	2025-12-05 02:20:49.783647	\N	\N	\N
cdc39b26-25a7-45c4-86bd-85e6282f568b	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 02:21:20.535365	\N	abandoned	\N	2025-12-05 02:21:20.535367	2025-12-05 02:26:47.393361	\N	\N	\N
25ecc33b-0f81-4cb7-a86c-3a96438510df	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 02:41:30.520402	\N	abandoned	\N	2025-12-05 02:41:30.520404	2025-12-05 02:45:16.338735	\N	\N	\N
5791a837-76c7-41d7-8a3f-5f0b53d7c2f9	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 02:50:08.336439	\N	abandoned	\N	2025-12-05 02:50:08.33644	2025-12-05 03:27:16.688378	\N	\N	\N
360b7e5b-983d-4c1a-9074-12be61a840f9	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 03:27:53.087054	\N	abandoned	\N	2025-12-05 03:27:53.087055	2025-12-05 04:17:31.090502	\N	\N	\N
cf30db01-7df3-4d1b-801e-818e74ebf4a4	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 04:28:32.072568	\N	abandoned	\N	2025-12-05 04:28:32.07257	2025-12-05 13:24:19.739222	\N	\N	\N
712c47ed-e2b4-41a8-a5fa-7a5de037613d	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 13:24:38.296495	\N	abandoned	\N	2025-12-05 13:24:38.296497	2025-12-05 13:25:02.927593	\N	\N	\N
d6c0367b-6c2c-49af-8215-1b24bc2e5469	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441013	2025-12-05 13:29:09.731697	2025-12-05 19:52:03.938246	completed	\N	2025-12-05 13:29:09.731698	2025-12-05 19:52:03.939601	\N	\N	\N
d67a67b3-427f-4e0e-9df4-69361a9acea2	ca37fdfa-a6ce-4a8f-a904-1a19bb3de92c	550e8400-e29b-41d4-a716-446655441014	2025-12-09 03:21:34.462388	\N	abandoned	\N	2025-12-09 03:21:34.46239	2025-12-09 03:22:01.671989	\N	\N	\N
\.


--
-- Name: client_interviews client_interviews_client_id_key; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_interviews
    ADD CONSTRAINT client_interviews_client_id_key UNIQUE (client_id);


--
-- Name: client_interviews client_interviews_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_interviews
    ADD CONSTRAINT client_interviews_pkey PRIMARY KEY (id);


--
-- Name: client_metrics client_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_metrics
    ADD CONSTRAINT client_metrics_pkey PRIMARY KEY (id);


--
-- Name: day_exercises day_exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.day_exercises
    ADD CONSTRAINT day_exercises_pkey PRIMARY KEY (id);


--
-- Name: exercise_muscles exercise_muscles_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_muscles
    ADD CONSTRAINT exercise_muscles_pkey PRIMARY KEY (id);


--
-- Name: exercise_set_logs exercise_set_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_set_logs
    ADD CONSTRAINT exercise_set_logs_pkey PRIMARY KEY (id);


--
-- Name: exercises exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: macrocycles macrocycles_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.macrocycles
    ADD CONSTRAINT macrocycles_pkey PRIMARY KEY (id);


--
-- Name: mesocycles mesocycles_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.mesocycles
    ADD CONSTRAINT mesocycles_pkey PRIMARY KEY (id);


--
-- Name: microcycles microcycles_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.microcycles
    ADD CONSTRAINT microcycles_pkey PRIMARY KEY (id);


--
-- Name: muscles muscles_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.muscles
    ADD CONSTRAINT muscles_pkey PRIMARY KEY (id);


--
-- Name: training_days training_days_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.training_days
    ADD CONSTRAINT training_days_pkey PRIMARY KEY (id);


--
-- Name: exercise_muscles uq_exercise_muscle; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_muscles
    ADD CONSTRAINT uq_exercise_muscle UNIQUE (exercise_id, muscle_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workout_logs workout_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.workout_logs
    ADD CONSTRAINT workout_logs_pkey PRIMARY KEY (id);


--
-- Name: idx_exercise_set_logs_day_exercise_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_exercise_set_logs_day_exercise_id ON public.exercise_set_logs USING btree (day_exercise_id);


--
-- Name: idx_exercise_set_logs_workout_log_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_exercise_set_logs_workout_log_id ON public.exercise_set_logs USING btree (workout_log_id);


--
-- Name: idx_exercises_class; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_exercises_class ON public.exercises USING btree (exercise_class);


--
-- Name: idx_exercises_name_en; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_exercises_name_en ON public.exercises USING btree (name_en);


--
-- Name: idx_unique_set_per_exercise; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX idx_unique_set_per_exercise ON public.exercise_set_logs USING btree (workout_log_id, day_exercise_id, set_number);


--
-- Name: idx_workout_logs_client_created; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_workout_logs_client_created ON public.workout_logs USING btree (client_id, created_at);


--
-- Name: idx_workout_logs_client_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_workout_logs_client_id ON public.workout_logs USING btree (client_id);


--
-- Name: idx_workout_logs_client_status; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_workout_logs_client_status ON public.workout_logs USING btree (client_id, status);


--
-- Name: idx_workout_logs_started_at; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_workout_logs_started_at ON public.workout_logs USING btree (started_at);


--
-- Name: idx_workout_logs_status; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_workout_logs_status ON public.workout_logs USING btree (status);


--
-- Name: idx_workout_logs_training_day_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX idx_workout_logs_training_day_id ON public.workout_logs USING btree (training_day_id);


--
-- Name: ix_client_metrics_client_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_client_metrics_client_id ON public.client_metrics USING btree (client_id);


--
-- Name: ix_exercise_muscles_exercise_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_exercise_muscles_exercise_id ON public.exercise_muscles USING btree (exercise_id);


--
-- Name: ix_exercise_muscles_muscle_id; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_exercise_muscles_muscle_id ON public.exercise_muscles USING btree (muscle_id);


--
-- Name: ix_exercises_exercise_class; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_exercises_exercise_class ON public.exercises USING btree (exercise_class);


--
-- Name: ix_exercises_name_en; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_exercises_name_en ON public.exercises USING btree (name_en);


--
-- Name: ix_exercises_name_es; Type: INDEX; Schema: public; Owner: admin
--

CREATE INDEX ix_exercises_name_es ON public.exercises USING btree (name_es);


--
-- Name: ix_muscles_name; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_muscles_name ON public.muscles USING btree (name);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: client_interviews client_interviews_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_interviews
    ADD CONSTRAINT client_interviews_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: client_metrics client_metrics_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.client_metrics
    ADD CONSTRAINT client_metrics_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: day_exercises day_exercises_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.day_exercises
    ADD CONSTRAINT day_exercises_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id);


--
-- Name: day_exercises day_exercises_training_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.day_exercises
    ADD CONSTRAINT day_exercises_training_day_id_fkey FOREIGN KEY (training_day_id) REFERENCES public.training_days(id);


--
-- Name: exercise_muscles exercise_muscles_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_muscles
    ADD CONSTRAINT exercise_muscles_exercise_id_fkey FOREIGN KEY (exercise_id) REFERENCES public.exercises(id) ON DELETE CASCADE;


--
-- Name: exercise_muscles exercise_muscles_muscle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_muscles
    ADD CONSTRAINT exercise_muscles_muscle_id_fkey FOREIGN KEY (muscle_id) REFERENCES public.muscles(id) ON DELETE RESTRICT;


--
-- Name: exercise_set_logs exercise_set_logs_day_exercise_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_set_logs
    ADD CONSTRAINT exercise_set_logs_day_exercise_id_fkey FOREIGN KEY (day_exercise_id) REFERENCES public.day_exercises(id) ON DELETE CASCADE;


--
-- Name: exercise_set_logs exercise_set_logs_workout_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.exercise_set_logs
    ADD CONSTRAINT exercise_set_logs_workout_log_id_fkey FOREIGN KEY (workout_log_id) REFERENCES public.workout_logs(id) ON DELETE CASCADE;


--
-- Name: macrocycles macrocycles_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.macrocycles
    ADD CONSTRAINT macrocycles_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.users(id);


--
-- Name: macrocycles macrocycles_trainer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.macrocycles
    ADD CONSTRAINT macrocycles_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES public.users(id);


--
-- Name: mesocycles mesocycles_macrocycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.mesocycles
    ADD CONSTRAINT mesocycles_macrocycle_id_fkey FOREIGN KEY (macrocycle_id) REFERENCES public.macrocycles(id);


--
-- Name: microcycles microcycles_mesocycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.microcycles
    ADD CONSTRAINT microcycles_mesocycle_id_fkey FOREIGN KEY (mesocycle_id) REFERENCES public.mesocycles(id);


--
-- Name: training_days training_days_microcycle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.training_days
    ADD CONSTRAINT training_days_microcycle_id_fkey FOREIGN KEY (microcycle_id) REFERENCES public.microcycles(id);


--
-- Name: workout_logs workout_logs_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.workout_logs
    ADD CONSTRAINT workout_logs_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: workout_logs workout_logs_training_day_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.workout_logs
    ADD CONSTRAINT workout_logs_training_day_id_fkey FOREIGN KEY (training_day_id) REFERENCES public.training_days(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ClIIKY6BiqirmmDLvpOuMSaUNmEQcH9CccV5pdNImSRRoQhhfdhjOAA7h1ePiWv

