from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api.routers import auth

app = FastAPI(
    title="Fit Pilot API",
    version="1.0.0",
    description="API for workout routine management with AI-powered generation"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])

# TODO: Add more routers
# app.include_router(exercises.router, prefix="/api/exercises", tags=["exercises"])
# app.include_router(routines.router, prefix="/api/routines", tags=["routines"])
# app.include_router(ai_generator.router, prefix="/api/ai", tags=["ai"])


@app.get("/")
def read_root():
    return {
        "message": "Fit Pilot API",
        "version": "1.0.0",
        "status": "running"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}
