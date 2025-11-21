# Fit Pilot

**AI-Powered Workout Routine Management System**

Fit Pilot is a comprehensive web and mobile application for creating and managing workout routines with hierarchical structure (Macrocycle → Microcycle → Training Day → Exercises). It combines AI-powered routine generation with manual drag-and-drop editing for maximum flexibility.

## Features

- **AI-Powered Routine Generation**: Create personalized workout programs using OpenAI/Claude AI
- **Hierarchical Structure**: Organize workouts in Macrocycles, Microcycles, and Training Days
- **Drag & Drop Editor**: Intuitive interface for manual routine customization
- **Exercise Library**: Comprehensive catalog with video demonstrations
- **Progress Tracking**: Monitor client progress with detailed analytics
- **Multi-Tenant**: Support for trainers managing multiple clients
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

- Docker & Docker Compose
- Node.js 18+ (for local development)
- Python 3.11+ (for local development)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd Fit-pilot1.0
```

2. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

3. **Start with Docker Compose**
```bash
docker-compose up -d
```

The services will be available at:
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Frontend**: http://localhost:3000
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

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
- [ ] Authentication system
- [ ] Basic CRUD operations for exercises
- [ ] Basic CRUD operations for routines
- [ ] Drag & drop interface

### Phase 2: Core Features (Weeks 5-8)
- [ ] AI routine generation
- [ ] Progress tracking system
- [ ] Client dashboard
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

---

**Built with ❤️ for fitness professionals and enthusiasts**
