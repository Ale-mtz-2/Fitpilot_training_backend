# FitPilot

**AI-Powered Workout Routine Management System**

FitPilot is a comprehensive web and mobile application for creating and managing workout routines with hierarchical structure (Macrocycle → Microcycle → Training Day → Exercises). It combines AI-powered routine generation with manual drag-and-drop editing for maximum flexibility.

## Features

- **AI-Powered Routine Generation**: Create personalized workout programs using Claude AI (Anthropic) with intelligent exercise selection
- **Hierarchical Structure**: Organize workouts in Macrocycles → Mesocycles → Microcycles → Training Days → Exercises
- **Drag & Drop Editor**: Intuitive interface for manual routine customization using @dnd-kit
- **Exercise Library**: Comprehensive catalog with muscle group associations and bilingual support (ES/EN)
- **Client Management**: Full client interview system to capture goals, availability, equipment, and restrictions
- **Template System**: Create reusable training templates and assign them to clients
- **Multi-language**: Full i18n support with Spanish and English interfaces
- **Role-Based Access**: Admin, Trainer, and Client roles with appropriate permissions
- **Progress Tracking**: Monitor client progress with detailed analytics (coming soon)
- **Mobile App**: React Native app for clients (coming soon)

## Tech Stack

### Backend
- **Framework**: FastAPI (Python 3.11+)
- **Database**: PostgreSQL 15+
- **ORM**: SQLAlchemy 2.0+
- **Cache**: Redis
- **Authentication**: JWT + OAuth2
- **AI Integration**: OpenAI API / Anthropic Claude API

### Frontend
- **Framework**: React 18 + TypeScript
- **Build Tool**: Vite
- **Styling**: Tailwind CSS
- **Drag & Drop**: @dnd-kit
- **State Management**: Zustand
- **Data Fetching**: React Query
- **Forms**: React Hook Form + Zod

### DevOps
- **Containerization**: Docker + Docker Compose
- **Deployment**: AWS / Vercel

## Quick Start

### Prerequisites

- Docker & Docker Compose instalado y corriendo
- Git (para clonar el repositorio)

### 🚀 Instalación Rápida

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd Fit-pilot1.0
```

2. **Iniciar todos los servicios con Docker**
```bash
# Iniciar todos los servicios (backend, postgres, redis)
docker-compose up -d

# Ver los logs en tiempo real
docker-compose logs -f
```

3. **Poblar la base de datos con datos de ejemplo**
```bash
# Crear usuarios mock (admin, trainers, clients)
docker exec -i fitpilot_backend python scripts/seed_users.py <<< "yes"

# Crear 32 ejercicios de ejemplo
docker exec fitpilot_backend python scripts/seed_exercises.py
```

4. **¡Listo! Accede a los servicios:**
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **PostgreSQL**: localhost:5433 (nota: puerto 5433, no 5432)
- **Redis**: localhost:6379

### 🔑 Credenciales de Prueba

Todos los usuarios mock tienen la contraseña: `password123`

| Rol | Email | Descripción |
|-----|-------|-------------|
| **Admin** | `admin@fitpilot.com` | Acceso completo |
| **Trainer** | `trainer1@fitpilot.com` | Puede crear/editar ejercicios |
| **Trainer** | `trainer2@fitpilot.com` | Puede crear/editar ejercicios |
| **Client** | `client1@fitpilot.com` | Usuario estándar |
| **Client** | `client2@fitpilot.com` | Usuario estándar |

Ver [backend/MOCK_USERS.md](backend/MOCK_USERS.md) para más detalles.

### 🧪 Probar la API

```bash
# 1. Login como trainer
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "trainer1@fitpilot.com", "password": "password123"}'

# 2. Listar ejercicios
curl http://localhost:8000/api/exercises

# 3. Filtrar ejercicios por grupo muscular
curl "http://localhost:8000/api/exercises?muscle_group=chest"
```

### 🛑 Comandos Útiles

```bash
# Ver estado de contenedores
docker-compose ps

# Detener todos los servicios
docker-compose stop

# Reiniciar servicios
docker-compose restart

# Reconstruir después de cambios en código
docker-compose up -d --build

# Ver logs de un servicio específico
docker-compose logs -f backend

# Detener y eliminar todo (mantiene datos)
docker-compose down

# Detener y eliminar todo incluyendo datos
docker-compose down -v
```

### Local Development (without Docker)

#### Backend Setup

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn api.main:app --reload
```

#### Frontend Setup

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

## Project Structure

```
Fit-pilot1.0/
├── backend/
│   ├── api/              # API endpoints
│   ├── core/             # Core configuration
│   ├── models/           # Database models
│   ├── schemas/          # Pydantic schemas
│   ├── services/         # Business logic
│   └── tests/            # Backend tests
├── frontend/
│   ├── src/
│   │   ├── components/   # React components
│   │   ├── hooks/        # Custom hooks
│   │   ├── pages/        # Page components
│   │   ├── services/     # API services
│   │   ├── store/        # State management
│   │   └── types/        # TypeScript types
│   └── public/           # Static assets
├── mobile/               # React Native app (coming soon)
├── database/
│   ├── migrations/       # Database migrations
│   └── seeds/            # Seed data
├── docker/               # Docker configurations
├── docs/                 # Documentation
└── docker-compose.yml
```

## API Documentation

Once the backend is running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Development Roadmap

### Phase 1: MVP (Weeks 1-4)
- [x] Project setup and structure
- [x] Database schema design
- [x] Authentication system (JWT + Argon2)
- [x] Basic CRUD operations for exercises
- [x] Exercise filtering and pagination
- [x] Role-based access control
- [x] Mock data seeds (users & exercises)
- [x] Basic CRUD operations for routines (Macrocycle → Mesocycle → Microcycle → TrainingDay → DayExercise)
- [x] Drag & drop interface (MesocycleEditorPage with @dnd-kit)

### Phase 2: Core Features (Weeks 5-8)
- [x] AI routine generation (Claude API with prompt caching & phased generation)
- [x] Client management system
- [x] Client interview system (pre-generation questionnaire)
- [x] Template vs Client program distinction
- [x] Internationalization (i18n - Spanish/English)
- [ ] Progress tracking system
- [ ] Exercise video integration
- [ ] Advanced analytics

### Phase 3: Polish (Weeks 9-12)
- [ ] Mobile app development
- [ ] Notification system
- [ ] Performance optimization
- [ ] Multi-tenant architecture

### Phase 4: Launch (Weeks 13-16)
- [ ] Comprehensive testing
- [ ] Documentation
- [ ] CI/CD pipeline
- [ ] Production deployment
- [ ] Monitoring and alerting

## Testing

### Backend Tests
```bash
cd backend
pytest tests/ -v --cov
```

### Frontend Tests
```bash
cd frontend
npm test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is proprietary software. All rights reserved.

## Contact

For questions or support, please contact the development team.

## Changelog

### v0.3.0 - AI Generation Flow Simplification
- **Eliminado**: Componente `WorkoutPreview.tsx` - ya no hay paso de preview
- **Nuevo flujo**: Generar → Guardar automáticamente como borrador → Redirigir a editor
- **Mejorado**: `GenerationProgress` ahora muestra fases dinámicas incluyendo "Guardando en base de datos"
- **Actualizado**: `AIGeneratorPage` - flujo simplificado sin paso de preview
- **Actualizado**: `aiStore` - eliminado `showPreview` state, `saveWorkout` retorna ID para navegación

### v0.2.0 - AI Workout Generation
- **Implementado**: Generación de rutinas con Claude API (claude-sonnet-4-5-20250929)
- **Optimizaciones**: Prompt Caching, salida comprimida, filtrado de catálogo, generación por fases
- **Implementado**: Sistema de entrevistas de cliente para pre-llenar cuestionarios
- **Implementado**: Distinción entre plantillas (templates) y programas de cliente
- **Implementado**: Internacionalización (i18n) con soporte para español e inglés

### v0.1.0 - Initial Release
- **Implementado**: Sistema de autenticación JWT con Argon2
- **Implementado**: CRUD completo para ejercicios con filtrado y paginación
- **Implementado**: Estructura jerárquica de entrenamientos (Macrocycle → Mesocycle → Microcycle → TrainingDay → DayExercise)
- **Implementado**: Editor drag & drop con @dnd-kit
- **Implementado**: Sistema de roles (Admin, Trainer, Client)
- **Implementado**: Seeds de datos de prueba

---

**Built with ❤️ for fitness professionals and enthusiasts**
