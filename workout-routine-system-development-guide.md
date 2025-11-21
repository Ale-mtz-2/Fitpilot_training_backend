# 🏋️ Fit Pilot - Guía de Desarrollo con IA CLI

## 📋 Índice
1. [Visión General del Proyecto](#visión-general-del-proyecto)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Configuración Inicial](#configuración-inicial)
4. [Desarrollo del Backend](#desarrollo-del-backend)
5. [Desarrollo del Frontend](#desarrollo-del-frontend)
6. [Integración con IA](#integración-con-ia)
7. [Testing y Despliegue](#testing-y-despliegue)
8. [Prompts para IA CLI](#prompts-para-ia-cli)

## 🎯 Visión General del Proyecto

### Descripción
Sistema web/móvil para la creación y gestión de rutinas de entrenamiento con estructura jerárquica (Macrociclo → Microciclo → Día → Ejercicios), permitiendo creación híbrida mediante IA y edición manual con drag-and-drop.

### Stack Tecnológico
- **Backend**: FastAPI (Python 3.11+)
- **Base de Datos**: PostgreSQL 15+
- **Frontend Web**: React 18 + TypeScript + @dnd-kit
- **App Móvil**: React Native / Flutter
- **IA**: OpenAI API / Claude API / Llama local
- **Cache**: Redis
- **Autenticación**: JWT + OAuth2
- **Deployment**: Docker + Kubernetes / AWS / Vercel

### Características Principales
- ✅ Creación de rutinas con IA
- ✅ Editor drag-and-drop
- ✅ Gestión jerárquica (Macro/Micro/Días)
- ✅ Catálogo de ejercicios con videos
- ✅ Tracking de progreso
- ✅ Multi-tenant (entrenadores/clientes)

## 🏗️ Arquitectura del Sistema

```
┌─────────────────┐     ┌─────────────────┐
│   Web App       │     │   Mobile App    │
│   (React)       │     │ (React Native)  │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │  API Gateway │
              │   (Nginx)    │
              └──────┬───────┘
                     │
         ┌───────────▼────────────┐
         │   FastAPI Backend      │
         │  - Auth Service        │
         │  - Routine Service     │
         │  - Exercise Service    │
         │  - AI Service          │
         └───────────┬────────────┘
                     │
      ┌──────────────┼──────────────┐
      │              │              │
┌─────▼─────┐  ┌────▼────┐  ┌─────▼─────┐
│PostgreSQL │  │  Redis  │  │ S3/CDN    │
│    DB     │  │  Cache  │  │  Storage  │
└───────────┘  └─────────┘  └───────────┘
```

## 🚀 Configuración Inicial

### 1. Crear Estructura del Proyecto

```bash
mkdir fit-pilot
cd fit-pilot

# Crear estructura de directorios
mkdir -p backend/{api,core,models,schemas,services,tests}
mkdir -p frontend/{src/{components,hooks,pages,services,store,types},public}
mkdir -p mobile/{src,assets}
mkdir -p database/{migrations,seeds}
mkdir -p docker
mkdir -p docs
mkdir -p .github/workflows
```

### 2. Inicializar Repositorio Git

```bash
git init
echo "# Fit Pilot" > README.md

# Crear .gitignore
cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
.env
venv/
env/
.pytest_cache/

# Node
node_modules/
dist/
build/
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Docker
*.pid
EOF

git add .
git commit -m "Initial commit: Project structure"
```

### 3. Configuración del Entorno

```bash
# Crear archivo de variables de entorno
cat > .env.example << 'EOF'
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/fitpilot_db
REDIS_URL=redis://localhost:6379

# API Keys
OPENAI_API_KEY=your_key_here
ANTHROPIC_API_KEY=your_key_here

# JWT
SECRET_KEY=your-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# AWS S3 (for videos/images)
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
AWS_BUCKET_NAME=fitpilot-videos

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_password

# Frontend URLs
FRONTEND_URL=http://localhost:3000
MOBILE_SCHEME=fitpilot://
EOF

cp .env.example .env
```

## 💻 Desarrollo del Backend

### 1. Setup Backend con FastAPI

```bash
cd backend

# Crear entorno virtual
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# Crear requirements.txt
cat > requirements.txt << 'EOF'
fastapi==0.109.0
uvicorn[standard]==0.27.0
sqlalchemy==2.0.25
alembic==1.13.1
psycopg2-binary==2.9.9
pydantic==2.5.3
pydantic-settings==2.1.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
redis==5.0.1
celery==5.3.4
httpx==0.26.0
openai==1.9.0
anthropic==0.8.1
boto3==1.34.20
pillow==10.2.0
pytest==7.4.4
pytest-asyncio==0.23.3
python-dotenv==1.0.0
email-validator==2.1.0
jinja2==3.1.3
aiofiles==23.2.1
pandas==2.1.4
numpy==1.26.3
EOF

pip install -r requirements.txt
```

### 2. Estructura de Modelos SQLAlchemy

```bash
# Crear modelos de base de datos
cat > models/base.py << 'EOF'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from core.config import settings

SQLALCHEMY_DATABASE_URL = settings.DATABASE_URL

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOF
```

### 3. Crear API Endpoints

```bash
# Crear estructura de routers
cat > api/main.py << 'EOF'
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.routers import auth, exercises, routines, ai_generator

app = FastAPI(title="Fit Pilot API", version="1.0.0")

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(exercises.router, prefix="/api/exercises", tags=["exercises"])
app.include_router(routines.router, prefix="/api/routines", tags=["routines"])
app.include_router(ai_generator.router, prefix="/api/ai", tags=["ai"])

@app.get("/")
def read_root():
    return {"message": "Fit Pilot API"}
EOF
```

### 4. Inicializar Base de Datos

```bash
# Crear script de migración
cat > database/init_db.sql << 'EOF'
-- Copiar aquí todo el SQL de la estructura de base de datos proporcionada anteriormente
EOF

# Ejecutar migraciones con Alembic
alembic init alembic
alembic revision --autogenerate -m "Initial migration"
alembic upgrade head
```

## 🎨 Desarrollo del Frontend

### 1. Setup Frontend con React y TypeScript

```bash
cd ../frontend

# Inicializar proyecto React con TypeScript
npx create-react-app . --template typescript

# Instalar dependencias principales
npm install \
  @dnd-kit/core \
  @dnd-kit/sortable \
  @dnd-kit/utilities \
  @tanstack/react-query \
  axios \
  react-router-dom \
  react-hook-form \
  zod \
  @hookform/resolvers \
  zustand \
  date-fns \
  framer-motion \
  react-hot-toast \
  tailwindcss \
  @headlessui/react \
  @heroicons/react \
  recharts

# Instalar dependencias de desarrollo
npm install -D \
  @types/react \
  @types/react-dom \
  @types/node \
  prettier \
  eslint \
  @typescript-eslint/parser \
  @typescript-eslint/eslint-plugin
```

### 2. Configurar Tailwind CSS

```bash
npx tailwindcss init -p

# Actualizar tailwind.config.js
cat > tailwind.config.js << 'EOF'
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
EOF
```

### 3. Componentes Principales

```bash
# Crear estructura de componentes
mkdir -p src/components/{common,workout,exercises,layout}

# Crear tipos TypeScript
cat > src/types/index.ts << 'EOF'
export interface Exercise {
  id: string;
  name: string;
  type: 'multiarticular' | 'monoarticular';
  resistanceProfile: string;
  category: string;
  muscleGroup: string;
  description: string;
  videoUrl?: string;
}

export interface DayExercise {
  id: string;
  exerciseId: string;
  exercise: Exercise;
  sets: number;
  repsMin: number;
  repsMax: number;
  restSeconds: number;
  effortType: 'RIR' | 'RPE' | 'percentage';
  effortValue: number;
  orderIndex: number;
  notes?: string;
}

export interface TrainingDay {
  id: string;
  dayNumber: number;
  date: Date;
  name: string;
  focus: string;
  exercises: DayExercise[];
  restDay: boolean;
}

export interface Microcycle {
  id: string;
  weekNumber: number;
  name: string;
  startDate: Date;
  endDate: Date;
  trainingDays: TrainingDay[];
  intensityLevel: 'low' | 'medium' | 'high' | 'deload';
}

export interface Macrocycle {
  id: string;
  name: string;
  description: string;
  objective: string;
  startDate: Date;
  endDate: Date;
  microcycles: Microcycle[];
  clientId: string;
  status: 'draft' | 'active' | 'completed' | 'archived';
}
EOF
```

## 🤖 Integración con IA

### 1. Servicio de Generación con IA

```python
# backend/services/ai_generator.py
import openai
from anthropic import Anthropic
from typing import Dict, List
import json

class WorkoutAIGenerator:
    def __init__(self):
        self.openai_client = openai.OpenAI()
        self.anthropic_client = Anthropic()
    
    async def generate_routine(
        self,
        client_profile: Dict,
        goals: List[str],
        duration_weeks: int,
        available_equipment: List[str],
        experience_level: str
    ) -> Dict:
        """
        Genera una rutina completa usando IA
        """
        prompt = self._build_prompt(
            client_profile,
            goals,
            duration_weeks,
            available_equipment,
            experience_level
        )
        
        # Usar Claude o GPT-4 para generar
        response = await self._call_ai(prompt)
        
        # Parsear y estructurar la respuesta
        routine = self._parse_ai_response(response)
        
        return routine
    
    def _build_prompt(self, **kwargs) -> str:
        return f"""
        Genera una rutina de entrenamiento completa con la siguiente estructura:
        - Macrociclo de {kwargs['duration_weeks']} semanas
        - Objetivo principal: {', '.join(kwargs['goals'])}
        - Nivel de experiencia: {kwargs['experience_level']}
        - Equipamiento disponible: {', '.join(kwargs['available_equipment'])}
        
        La respuesta debe incluir:
        1. División por microciclos (semanas)
        2. Cada microciclo con 4-6 días de entrenamiento
        3. Cada día con 5-8 ejercicios
        4. Para cada ejercicio especificar:
           - Tipo (multiarticular/monoarticular)
           - Perfil de resistencia
           - Series y repeticiones
           - RIR/RPE
           - Tiempo de descanso
        
        Formato JSON requerido...
        """
```

### 2. Endpoints de IA

```python
# backend/api/routers/ai_generator.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from services.ai_generator import WorkoutAIGenerator
from models.base import get_db

router = APIRouter()
ai_service = WorkoutAIGenerator()

@router.post("/generate-routine")
async def generate_routine(
    request: RoutineGenerationRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Genera una rutina completa usando IA
    """
    try:
        routine = await ai_service.generate_routine(
            client_profile=request.client_profile,
            goals=request.goals,
            duration_weeks=request.duration_weeks,
            available_equipment=request.equipment,
            experience_level=request.experience_level
        )
        
        # Guardar en base de datos
        saved_routine = save_routine_to_db(db, routine, current_user.id)
        
        return {
            "success": True,
            "routine_id": saved_routine.id,
            "data": routine
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/suggest-exercises")
async def suggest_exercises(
    muscle_group: str,
    equipment: List[str],
    count: int = 5
):
    """
    Sugiere ejercicios basados en criterios
    """
    suggestions = await ai_service.suggest_exercises(
        muscle_group=muscle_group,
        equipment=equipment,
        count=count
    )
    return suggestions

@router.post("/optimize-routine")
async def optimize_routine(
    routine_id: str,
    optimization_goal: str,
    db: Session = Depends(get_db)
):
    """
    Optimiza una rutina existente
    """
    # Lógica de optimización con IA
    pass
```

## 🧪 Testing y Despliegue

### 1. Tests Unitarios y de Integración

```bash
# backend/tests/test_routines.py
cat > backend/tests/test_routines.py << 'EOF'
import pytest
from fastapi.testclient import TestClient
from api.main import app
from models.base import get_db

client = TestClient(app)

@pytest.fixture
def auth_headers(test_user):
    response = client.post("/api/auth/login", json={
        "email": "test@example.com",
        "password": "testpass123"
    })
    token = response.json()["access_token"]
    return {"Authorization": f"Bearer {token}"}

def test_create_macrocycle(auth_headers):
    response = client.post(
        "/api/routines/macrocycles",
        headers=auth_headers,
        json={
            "name": "Hypertrophy Phase 1",
            "description": "12-week hypertrophy program",
            "objective": "hypertrophy",
            "start_date": "2024-02-01",
            "end_date": "2024-04-30",
            "client_id": "test-client-id"
        }
    )
    assert response.status_code == 201
    assert response.json()["name"] == "Hypertrophy Phase 1"

def test_drag_drop_exercise(auth_headers):
    # Test mover ejercicio entre días
    response = client.patch(
        "/api/routines/exercises/move",
        headers=auth_headers,
        json={
            "exercise_id": "exercise-1",
            "from_day_id": "day-1",
            "to_day_id": "day-2",
            "new_position": 3
        }
    )
    assert response.status_code == 200

def test_ai_generation(auth_headers):
    response = client.post(
        "/api/ai/generate-routine",
        headers=auth_headers,
        json={
            "client_profile": {
                "age": 25,
                "experience": "intermediate",
                "injuries": []
            },
            "goals": ["hypertrophy", "strength"],
            "duration_weeks": 12,
            "equipment": ["barbell", "dumbbells", "cables"]
        }
    )
    assert response.status_code == 200
    assert "routine_id" in response.json()
EOF

# Ejecutar tests
pytest backend/tests/ -v --cov=backend
```

### 2. Docker Configuration

```bash
# Dockerfile para backend
cat > backend/Dockerfile << 'EOF'
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
EOF

# Dockerfile para frontend
cat > frontend/Dockerfile << 'EOF'
FROM node:18-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: fitpilot_db
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: secretpass
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./database/init_db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: ./backend
    depends_on:
      - postgres
      - redis
    environment:
      DATABASE_URL: postgresql://admin:secretpass@postgres:5432/fitpilot_db
      REDIS_URL: redis://redis:6379
    ports:
      - "8000:8000"
    volumes:
      - ./backend:/app

  frontend:
    build: ./frontend
    depends_on:
      - backend
    ports:
      - "3000:80"
    environment:
      REACT_APP_API_URL: http://localhost:8000/api

volumes:
  postgres_data:
EOF
```

### 3. CI/CD Pipeline

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: |
          cd backend
          pip install -r requirements.txt
      - name: Run tests
        run: |
          cd backend
          pytest tests/ -v --cov

  test-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Install and test
        run: |
          cd frontend
          npm ci
          npm test -- --watchAll=false
          npm run build

  deploy:
    needs: [test-backend, test-frontend]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # Add deployment commands here
```

## 🤖 Prompts para IA CLI

### Prompts para Claude, GitHub Copilot, o Cursor

#### 1. Generar Servicio de Autenticación Completo

```
Crea un servicio completo de autenticación para FastAPI con:
- Login con email/password
- Registro de usuarios con validación
- JWT tokens con refresh tokens
- OAuth2 con Google y Facebook
- Reset de contraseña por email
- Verificación de email
- Rate limiting
- Roles y permisos (trainer, client, admin)
- Middleware de autenticación
- Tests unitarios con pytest

Usa SQLAlchemy para los modelos, Pydantic para schemas, passlib para hashing, python-jose para JWT.
```

#### 2. Implementar Sistema de Drag & Drop

```
Implementa un sistema completo de drag and drop para el editor de rutinas usando @dnd-kit con:
- Componente WorkoutPlanner que muestre microciclos en tabs
- Cada microciclo con 7 columnas (días)
- Ejercicios como tarjetas arrastrables
- Poder mover ejercicios entre días
- Poder reordenar ejercicios en el mismo día
- Clonar ejercicios con Ctrl+drag
- Animaciones suaves con framer-motion
- Modal de edición al hacer click en ejercicio
- Confirmación antes de eliminar
- Undo/Redo functionality
- Auto-save cada 30 segundos
- TypeScript estricto

Usa React 18, TypeScript, @dnd-kit/core, @dnd-kit/sortable, zustand para estado, react-hook-form para el modal.
```

#### 3. Generar Rutina con IA

```
Crea una función que use la API de OpenAI GPT-4 para generar rutinas de entrenamiento personalizadas.

Input:
- Perfil del cliente (edad, sexo, experiencia, lesiones)
- Objetivos (fuerza, hipertrofia, resistencia, pérdida de grasa)
- Duración en semanas
- Equipamiento disponible
- Días disponibles por semana
- Preferencias de ejercicios

Output en JSON:
- Macrociclo completo con periodización
- Microciclos con progresión de intensidad
- Días con ejercicios detallados
- Series, reps, RIR/RPE, descanso
- Notas técnicas para cada ejercicio
- Progresión semana a semana

Incluye validación de la respuesta, manejo de errores, retry logic, y caching de respuestas.
```

#### 4. Crear Dashboard de Analytics

```
Diseña un dashboard de analytics para entrenadores con:
- Gráficos de progreso de clientes (Chart.js/Recharts)
- Heatmap de adherencia al entrenamiento
- Estadísticas de ejercicios más efectivos
- Comparación antes/después con fotos
- Métricas de volumen total, tonelaje, intensidad
- Predicciones de progreso con regresión lineal
- Exportar reportes en PDF
- Filtros por fecha, cliente, tipo de rutina
- Vista responsive para móvil
- Real-time updates con WebSockets

Usa React Query para fetching, Recharts para gráficos, jsPDF para exportar.
```

#### 5. Implementar Sistema de Notificaciones

```
Implementa un sistema completo de notificaciones:

Backend (FastAPI):
- Notificaciones push con Firebase Cloud Messaging
- Email con templates HTML (Jinja2)
- SMS con Twilio
- Notificaciones in-app con WebSockets
- Cola de tareas con Celery y Redis
- Programación de recordatorios
- Preferencias de usuario por tipo de notificación

Frontend (React):
- Badge de notificaciones no leídas
- Dropdown con lista de notificaciones
- Toast notifications con react-hot-toast
- Push notifications en navegador
- Centro de notificaciones con filtros
- Marcar como leído/no leído
- Configuración de preferencias

Incluye migraciones de DB, tests, y documentación.
```

#### 6. Optimizar Performance

```
Analiza y optimiza el performance de la aplicación:

Backend:
- Implementa caching con Redis (queries frecuentes)
- Añade índices a queries lentas en PostgreSQL
- Implementa paginación con cursor
- Lazy loading de relaciones en SQLAlchemy
- Connection pooling optimizado
- Compresión gzip de respuestas
- Rate limiting por endpoint

Frontend:
- Code splitting con React.lazy()
- Memoización con useMemo y useCallback
- Virtual scrolling para listas largas
- Optimización de imágenes (WebP, lazy loading)
- Service Worker para offline
- Bundle size optimization
- Lighthouse score > 90

Proporciona métricas antes/después y plan de monitoreo.
```

#### 7. Implementar Multi-tenancy

```
Convierte la aplicación en multi-tenant para soportar múltiples gimnasios:

Database:
- Esquema por tenant vs row-level security
- Migraciones automáticas por tenant
- Backup y restore por gimnasio

Backend:
- Middleware para identificar tenant
- Aislamiento de datos por tenant
- Límites y quotas por plan
- Facturación con Stripe
- Admin panel para gestionar tenants

Frontend:
- Theming dinámico por gimnasio
- Subdominios o paths por tenant
- Dashboard de super admin
- Onboarding flow para nuevos gimnasios

Incluye estrategia de escalamiento y consideraciones de seguridad.
```

#### 8. Crear App Móvil

```
Crea una app móvil con React Native para clientes:

Características:
- Login con biometría
- Vista de rutina del día
- Timer para descansos con notificaciones
- Registro de pesos y repeticiones
- Cámara para fotos de progreso
- Gráficos de progreso
- Videos de ejercicios offline
- Sincronización con backend
- Modo offline con SQLite
- Push notifications
- Apple Health / Google Fit integration

Estructura:
- Navigation con React Navigation
- Estado con Redux Toolkit
- Formularios con React Hook Form
- Animaciones con Reanimated 2
- Testing con Jest y Detox

Incluye configuración para iOS y Android, y CI/CD con Fastlane.
```

#### 9. Implementar Video Streaming

```
Implementa un sistema de video streaming para ejercicios:

Backend:
- Upload de videos a S3 con presigned URLs
- Transcoding con AWS MediaConvert
- CDN con CloudFront
- Thumbnails automáticos
- Metadata extraction (duración, resolución)
- Subtítulos automáticos con AWS Transcribe

Frontend:
- Player customizado con Video.js
- Calidad adaptativa (HLS)
- Picture-in-picture
- Velocidad variable
- Marcadores de tiempo para técnicas
- Comentarios timestamped
- Playlist de ejercicios

Incluye optimización de costos y estrategia de caché.
```

#### 10. Sistema de Gamificación

```
Diseña un sistema de gamificación completo:

Features:
- Sistema de niveles y XP
- Achievements/Badges desbloqueables
- Streaks de entrenamiento
- Leaderboards semanales/mensuales
- Retos entre usuarios
- Recompensas virtuales
- Sistema de puntos canjeables
- Misiones diarias/semanales

Backend:
- Motor de reglas para achievements
- Cálculo de XP y niveles
- Sistema de eventos con Redis Pub/Sub
- Cron jobs para retos temporales

Frontend:
- Animaciones de nivel up
- Showcase de badges
- Progress bars animados
- Notificaciones de logros
- Social sharing

Incluye balanceo de economía virtual y A/B testing.
```

### Comandos Útiles para Desarrollo

```bash
# Iniciar todos los servicios
docker-compose up -d

# Ver logs
docker-compose logs -f backend

# Ejecutar migraciones
docker-compose exec backend alembic upgrade head

# Crear nueva migración
docker-compose exec backend alembic revision --autogenerate -m "Add new table"

# Ejecutar tests
docker-compose exec backend pytest

# Linter y formateo
docker-compose exec backend black .
docker-compose exec backend flake8 .
docker-compose exec frontend npm run lint

# Generar documentación API
docker-compose exec backend python -m swagger_generator

# Backup de base de datos
docker-compose exec postgres pg_dump -U admin fitpilot_db > backup.sql

# Restore de base de datos
docker-compose exec -T postgres psql -U admin fitpilot_db < backup.sql

# Monitoreo de performance
docker-compose exec backend python -m profile_endpoints

# Generar reporte de cobertura
docker-compose exec backend pytest --cov=. --cov-report=html
```

## 📚 Recursos Adicionales

### Documentación Importante
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [@dnd-kit Documentation](https://docs.dndkit.com/)
- [PostgreSQL Performance Tips](https://wiki.postgresql.org/wiki/Performance_Optimization)
- [React Query Patterns](https://tkdodo.eu/blog/practical-react-query)
- [Clean Architecture in Python](https://www.cosmicpython.com/)

### Herramientas de Desarrollo
- **pgAdmin** - Gestión de PostgreSQL
- **Postman/Insomnia** - Testing de APIs
- **React DevTools** - Debug de React
- **Redux DevTools** - Si usas Redux
- **Docker Desktop** - Gestión de contenedores

### Mejores Prácticas
1. **Commits semánticos**: feat:, fix:, docs:, style:, refactor:, test:, chore:
2. **Code Review**: Todos los PRs requieren al menos 1 aprobación
3. **Testing**: Mínimo 80% de cobertura
4. **Documentación**: Mantener README y API docs actualizados
5. **Seguridad**: Escaneo regular con Snyk o similar
6. **Performance**: Monitoring con Sentry y New Relic

## 🎯 Checklist de Desarrollo

### Fase 1: MVP (Semanas 1-4)
- [ ] Setup inicial del proyecto
- [ ] Base de datos y migraciones
- [ ] Autenticación básica
- [ ] CRUD de ejercicios
- [ ] CRUD de rutinas básicas
- [ ] Interfaz drag & drop básica

### Fase 2: Features Core (Semanas 5-8)
- [ ] Generación con IA
- [ ] Sistema de tracking
- [ ] Dashboard de progreso
- [ ] Gestión de clientes
- [ ] Videos de ejercicios

### Fase 3: Polish (Semanas 9-12)
- [ ] App móvil
- [ ] Notificaciones
- [ ] Analytics avanzados
- [ ] Optimización de performance
- [ ] Multi-tenancy

### Fase 4: Lanzamiento (Semanas 13-16)
- [ ] Testing exhaustivo
- [ ] Documentación completa
- [ ] CI/CD pipeline
- [ ] Deployment a producción
- [ ] Monitoreo y alertas
- [ ] Plan de escalamiento

## 🚨 Troubleshooting Común

### Problema: Error de conexión a PostgreSQL
```bash
# Verificar que PostgreSQL está corriendo
docker-compose ps
# Revisar logs
docker-compose logs postgres
# Reiniciar servicio
docker-compose restart postgres
```

### Problema: CORS errors en frontend
```python
# Verificar configuración en backend/api/main.py
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Agregar tu URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Problema: Drag & drop no funciona en móvil
```javascript
// Asegurarse de incluir touch-action en CSS
.draggable {
  touch-action: none;
}

// Verificar sensors en @dnd-kit
const sensors = useSensors(
  useSensor(PointerSensor),
  useSensor(TouchSensor),  // Importante para móvil
  useSensor(KeyboardSensor)
);
```

---

## 📞 Contacto y Soporte

Para preguntas específicas sobre el desarrollo, puedes usar los siguientes prompts con tu IA CLI favorita o crear issues en el repositorio del proyecto.

**¡Buena suerte con el desarrollo! 💪**
