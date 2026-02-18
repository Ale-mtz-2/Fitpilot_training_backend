"""
Service for mapping ClientInterview data to AI Generator request format.
"""
from typing import Optional, Dict, Any, List
from models.client_interview import ClientInterview
from schemas.ai_generator import (
    UserProfile, TrainingGoals, Availability, Equipment, Restrictions,
    FitnessLevel, PrimaryGoal, MuscleGroupPreference, EquipmentType, Gender
)


class InterviewToAIRequestMapper:
    """
    Maps ClientInterview data to the format required by AIWorkoutRequest.
    """

    @staticmethod
    def map_experience_to_fitness_level(experience_level: str) -> FitnessLevel:
        """Map experience_level enum to fitness_level enum."""
        mapping = {
            "beginner": FitnessLevel.BEGINNER,
            "intermediate": FitnessLevel.INTERMEDIATE,
            "advanced": FitnessLevel.ADVANCED,
        }
        return mapping.get(experience_level.lower(), FitnessLevel.BEGINNER)

    @staticmethod
    def map_gender(gender: str) -> Optional[Gender]:
        """Map gender enum."""
        if not gender:
            return None
        mapping = {
            "male": Gender.MALE,
            "female": Gender.FEMALE,
            "other": Gender.OTHER,
        }
        return mapping.get(gender.lower())

    @staticmethod
    def map_primary_goal(goal: str) -> Optional[PrimaryGoal]:
        """Map primary_goal enum."""
        if not goal:
            return None
        mapping = {
            "hypertrophy": PrimaryGoal.HYPERTROPHY,
            "strength": PrimaryGoal.STRENGTH,
            "power": PrimaryGoal.POWER,
            "endurance": PrimaryGoal.ENDURANCE,
            "fat_loss": PrimaryGoal.FAT_LOSS,
            "general_fitness": PrimaryGoal.GENERAL_FITNESS,
        }
        return mapping.get(goal.lower())

    @staticmethod
    def map_muscle_groups(groups: List[str]) -> List[MuscleGroupPreference]:
        """Map muscle group strings to enum values."""
        if not groups:
            return []
        mapping = {
            "chest": MuscleGroupPreference.CHEST,
            "back": MuscleGroupPreference.BACK,
            "shoulders": MuscleGroupPreference.SHOULDERS,
            "biceps": MuscleGroupPreference.ARMS,
            "triceps": MuscleGroupPreference.ARMS,
            "legs": MuscleGroupPreference.LEGS,
            "core": MuscleGroupPreference.CORE,
            "glutes": MuscleGroupPreference.LEGS,
            "arms": MuscleGroupPreference.ARMS,
        }
        result = []
        for group in groups:
            mapped = mapping.get(group.lower())
            if mapped and mapped not in result:
                result.append(mapped)
        return result

    @staticmethod
    def map_equipment(equipment_list: List[str]) -> List[EquipmentType]:
        """Map equipment strings to enum values."""
        if not equipment_list:
            return [EquipmentType.BODYWEIGHT]
        mapping = {
            "barbell": EquipmentType.BARBELL,
            "dumbbells": EquipmentType.DUMBBELLS,
            "cables": EquipmentType.CABLES,
            "machines": EquipmentType.MACHINES,
            "kettlebells": EquipmentType.KETTLEBELLS,
            "resistance_bands": EquipmentType.RESISTANCE_BANDS,
            "pull_up_bar": EquipmentType.PULL_UP_BAR,
            "bench": EquipmentType.BENCH,
            "squat_rack": EquipmentType.SQUAT_RACK,
            "bodyweight": EquipmentType.BODYWEIGHT,
        }
        result = []
        for equip in equipment_list:
            mapped = mapping.get(equip.lower())
            if mapped:
                result.append(mapped)
        return result if result else [EquipmentType.BODYWEIGHT]

    @staticmethod
    def format_injuries(injury_areas: List[str], injury_details: Optional[str]) -> List[str]:
        """Format injury areas and details into a list of strings."""
        if not injury_areas:
            return []

        area_labels = {
            "shoulder": "Hombro",
            "knee": "Rodilla",
            "lower_back": "Espalda baja",
            "upper_back": "Espalda alta",
            "hip": "Cadera",
            "ankle": "Tobillo",
            "wrist": "Muñeca",
            "elbow": "Codo",
            "neck": "Cuello",
            "other": "Otro",
        }

        injuries = []
        for area in injury_areas:
            label = area_labels.get(area.lower(), area)
            injuries.append(f"Lesión en {label}")

        if injury_details:
            injuries.append(f"Detalles: {injury_details}")

        return injuries

    @classmethod
    def build_user_profile(cls, interview: ClientInterview) -> UserProfile:
        """Build UserProfile from interview data."""
        return UserProfile(
            fitness_level=cls.map_experience_to_fitness_level(
                interview.experience_level.value if interview.experience_level else "beginner"
            ),
            age=interview.age,
            weight_kg=interview.weight_kg,
            height_cm=interview.height_cm,
            gender=cls.map_gender(interview.gender.value if interview.gender else None),
            training_experience_months=interview.training_experience_months,
        )

    @classmethod
    def build_training_goals(cls, interview: ClientInterview) -> TrainingGoals:
        """Build TrainingGoals from interview data."""
        # Parse specific goals from text
        specific_goals = []
        if interview.specific_goals_text:
            specific_goals = [interview.specific_goals_text]

        return TrainingGoals(
            primary_goal=cls.map_primary_goal(
                interview.primary_goal.value if interview.primary_goal else "general_fitness"
            ),
            specific_goals=specific_goals,
            target_muscle_groups=cls.map_muscle_groups(interview.target_muscle_groups or []),
        )

    @classmethod
    def build_availability(cls, interview: ClientInterview) -> Availability:
        """Build Availability from interview data."""
        return Availability(
            days_per_week=interview.days_per_week or 3,
            session_duration_minutes=interview.session_duration_minutes or 60,
            preferred_days=interview.preferred_days or [],
        )

    @classmethod
    def build_equipment(cls, interview: ClientInterview) -> Equipment:
        """Build Equipment from interview data."""
        return Equipment(
            has_gym_access=interview.has_gym_access if interview.has_gym_access is not None else False,
            available_equipment=cls.map_equipment(interview.available_equipment or []),
            equipment_notes=interview.equipment_notes,
        )

    @classmethod
    def build_restrictions(cls, interview: ClientInterview) -> Optional[Restrictions]:
        """Build Restrictions from interview data."""
        injuries = cls.format_injuries(
            interview.injury_areas or [],
            interview.injury_details
        )

        # Only return restrictions if there's something to restrict
        if not injuries and not interview.excluded_exercises and not interview.medical_conditions and not interview.mobility_limitations:
            return None

        return Restrictions(
            injuries=injuries,
            excluded_exercises=interview.excluded_exercises or [],
            medical_conditions=interview.medical_conditions or [],
            mobility_limitations=interview.mobility_limitations,
        )

    @classmethod
    def map_interview_to_ai_sections(cls, interview: ClientInterview) -> Dict[str, Any]:
        """
        Map a complete ClientInterview to AI request sections.

        Returns a dictionary with:
        - user_profile: UserProfile
        - goals: TrainingGoals
        - availability: Availability
        - equipment: Equipment
        - restrictions: Optional[Restrictions]
        """
        return {
            "user_profile": cls.build_user_profile(interview),
            "goals": cls.build_training_goals(interview),
            "availability": cls.build_availability(interview),
            "equipment": cls.build_equipment(interview),
            "restrictions": cls.build_restrictions(interview),
        }

    @classmethod
    def validate_interview_for_ai(cls, interview: Optional[ClientInterview]) -> Dict[str, Any]:
        """
        Validate if an interview has all required fields for AI generation.

        Returns:
        - is_complete: bool
        - missing_fields: list of field names
        - has_interview: bool
        """
        if not interview:
            return {
                "is_complete": False,
                "missing_fields": ["No existe entrevista para este cliente"],
                "has_interview": False,
            }

        is_complete, missing_fields = interview.is_complete_for_ai()

        # Translate field names to Spanish for user-friendly messages
        field_translations = {
            "experience_level": "Nivel de experiencia",
            "primary_goal": "Objetivo principal",
            "days_per_week": "Días por semana",
            "session_duration_minutes": "Duración de sesión",
            "has_gym_access": "Acceso a gimnasio",
            "available_equipment": "Equipamiento disponible",
        }

        translated_missing = [
            field_translations.get(f, f) for f in missing_fields
        ]

        return {
            "is_complete": is_complete,
            "missing_fields": translated_missing,
            "has_interview": True,
        }
