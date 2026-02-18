"""
Script de Auditoría de Base de Datos para FitPilot.
Genera documentación automática de la base de datos a partir de los modelos SQLAlchemy.

Uso:
    docker exec fitpilot_backend python scripts/audit_database.py
    docker exec fitpilot_backend python scripts/audit_database.py --output db-audit.md
    docker exec fitpilot_backend python scripts/audit_database.py --compare db-documentation.md
"""
import sys
import os
import argparse
from datetime import datetime
from typing import Dict, List, Any, Optional
import enum

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy import inspect, Column
from sqlalchemy.orm import RelationshipProperty
from sqlalchemy.sql.sqltypes import String, Integer, Float, Boolean, Text, Date, DateTime, Enum
from sqlalchemy import ARRAY

# Import all models
from models import (
    Base, User, UserRole,
    Muscle, BodyRegion, MuscleCategory,
    ExerciseMuscle, MuscleRole,
    Exercise, ExerciseType, ResistanceProfile,
    Macrocycle, Mesocycle, Microcycle, TrainingDay, DayExercise,
    MesocycleStatus, IntensityLevel, EffortType,
    ClientInterview, Gender, ExperienceLevel,
    ClientMetric, MetricType,
    WorkoutLog, ExerciseSetLog, WorkoutStatus,
)
from models.exercise import ExerciseClass, CardioSubclass
from models.workout_log import AbandonReason
from models.mesocycle import TempoType, SetType, ExercisePhase


def get_column_type_name(column: Column) -> str:
    """Obtiene el nombre legible del tipo de columna."""
    col_type = column.type

    if isinstance(col_type, String):
        if hasattr(col_type, 'length') and col_type.length:
            return f"String({col_type.length})"
        return "String (UUID)" if column.primary_key else "String"
    elif isinstance(col_type, Integer):
        return "Integer"
    elif isinstance(col_type, Float):
        return "Float"
    elif isinstance(col_type, Boolean):
        return "Boolean"
    elif isinstance(col_type, Text):
        return "Text"
    elif isinstance(col_type, Date):
        return "Date"
    elif isinstance(col_type, DateTime):
        return "DateTime"
    elif isinstance(col_type, Enum):
        return "Enum"
    elif isinstance(col_type, ARRAY):
        item_type = col_type.item_type
        if isinstance(item_type, String):
            return "ARRAY[String]"
        elif isinstance(item_type, Integer):
            return "ARRAY[Integer]"
        return f"ARRAY[{type(item_type).__name__}]"
    else:
        return type(col_type).__name__


def get_column_constraints(column: Column) -> str:
    """Obtiene los constraints de una columna."""
    constraints = []

    if column.primary_key:
        constraints.append("PK")

    if column.foreign_keys:
        fk = list(column.foreign_keys)[0]
        constraints.append(f"FK → {fk.column.table.name}.{fk.column.name}")

    if column.unique:
        constraints.append("UNIQUE")

    if not column.nullable:
        constraints.append("NOT NULL")
    else:
        constraints.append("NULL")

    if column.index:
        constraints.append("INDEX")

    if column.default is not None:
        if hasattr(column.default, 'arg'):
            default_val = column.default.arg
            if callable(default_val):
                constraints.append("DEFAULT: auto-generated")
            elif hasattr(default_val, 'value'):
                constraints.append(f"DEFAULT: '{default_val.value}'")
            elif default_val is True:
                constraints.append("DEFAULT: True")
            elif default_val is False:
                constraints.append("DEFAULT: False")
            else:
                constraints.append(f"DEFAULT: {default_val}")

    return ", ".join(constraints)


def get_enum_values(enum_class) -> List[str]:
    """Obtiene los valores de un enum."""
    if hasattr(enum_class, '__members__'):
        return [member.value for member in enum_class]
    return []


def audit_model(model_class) -> Dict[str, Any]:
    """Audita un modelo SQLAlchemy y extrae toda su información."""
    mapper = inspect(model_class)

    # Información básica
    info = {
        "class_name": model_class.__name__,
        "table_name": mapper.mapped_table.name,
        "columns": [],
        "relationships": [],
        "enums": [],
        "indexes": [],
    }

    # Extraer columnas
    for column in mapper.columns:
        col_info = {
            "name": column.name,
            "type": get_column_type_name(column),
            "constraints": get_column_constraints(column),
            "description": "",  # No hay docstrings en columnas SQLAlchemy
        }

        # Detectar si es un enum y agregar información
        if isinstance(column.type, Enum):
            enum_type = column.type.enum_class
            if enum_type:
                col_info["enum_class"] = enum_type.__name__
                col_info["enum_values"] = get_enum_values(enum_type)

        info["columns"].append(col_info)

    # Extraer relaciones
    for rel_name, rel_prop in mapper.relationships.items():
        if isinstance(rel_prop, RelationshipProperty):
            rel_info = {
                "name": rel_name,
                "target": rel_prop.mapper.class_.__name__,
                "direction": str(rel_prop.direction.name),
                "cascade": rel_prop.cascade.intersection(['delete', 'delete-orphan']) if rel_prop.cascade else set(),
            }
            info["relationships"].append(rel_info)

    return info


def generate_table_markdown(model_info: Dict[str, Any]) -> str:
    """Genera documentación markdown para una tabla."""
    lines = []

    # Header
    lines.append(f"## {model_info['class_name'].upper()} ({model_info['class_name']})")
    lines.append("")
    lines.append(f"**Tabla:** `{model_info['table_name']}`")
    lines.append("")

    # Columnas
    lines.append("### Columnas")
    lines.append("")
    lines.append("| Columna | Tipo | Constraints | Descripción |")
    lines.append("|---------|------|-------------|-------------|")

    for col in model_info["columns"]:
        lines.append(f"| {col['name']} | {col['type']} | {col['constraints']} | {col['description']} |")

    lines.append("")

    # Enums asociados
    enums_found = []
    for col in model_info["columns"]:
        if "enum_class" in col:
            enums_found.append({
                "name": col["enum_class"],
                "values": col["enum_values"]
            })

    if enums_found:
        lines.append("### Enums Asociados")
        lines.append("")
        for enum_info in enums_found:
            lines.append(f"**{enum_info['name']}:**")
            for val in enum_info["values"]:
                lines.append(f"- `{val}`")
            lines.append("")

    # Relaciones
    if model_info["relationships"]:
        lines.append("### Relaciones")
        lines.append("")
        for rel in model_info["relationships"]:
            cascade_str = f" (CASCADE {', '.join(rel['cascade'])})" if rel['cascade'] else ""
            lines.append(f"- **{rel['direction']}** con `{rel['target']}` → `{rel['name']}`{cascade_str}")
        lines.append("")

    return "\n".join(lines)


def generate_full_audit() -> str:
    """Genera la auditoría completa de todas las tablas."""
    lines = []

    # Header
    lines.append("# Auditoría de Base de Datos - FitPilot")
    lines.append("")
    lines.append(f"**Generado automáticamente:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append("**Script:** `backend/scripts/audit_database.py`")
    lines.append("")
    lines.append("---")
    lines.append("")

    # Lista de modelos a auditar (en orden lógico)
    models_to_audit = [
        User,
        Muscle,
        ExerciseMuscle,
        Exercise,
        Macrocycle,
        Mesocycle,
        Microcycle,
        TrainingDay,
        DayExercise,
        ClientInterview,
        ClientMetric,
        WorkoutLog,
        ExerciseSetLog,
    ]

    # Resumen
    lines.append("## Resumen")
    lines.append("")
    lines.append(f"**Total de tablas:** {len(models_to_audit)}")
    lines.append("")
    lines.append("| # | Tabla | Modelo | Columnas |")
    lines.append("|---|-------|--------|----------|")

    for i, model in enumerate(models_to_audit, 1):
        info = audit_model(model)
        lines.append(f"| {i} | `{info['table_name']}` | {info['class_name']} | {len(info['columns'])} |")

    lines.append("")
    lines.append("---")
    lines.append("")

    # Generar documentación por tabla
    for model in models_to_audit:
        info = audit_model(model)
        lines.append(generate_table_markdown(info))
        lines.append("---")
        lines.append("")

    # Enums globales
    lines.append("## Enums Globales")
    lines.append("")

    all_enums = [
        ("UserRole", UserRole),
        ("BodyRegion", BodyRegion),
        ("MuscleCategory", MuscleCategory),
        ("MuscleRole", MuscleRole),
        ("ExerciseType", ExerciseType),
        ("ResistanceProfile", ResistanceProfile),
        ("ExerciseClass", ExerciseClass),
        ("CardioSubclass", CardioSubclass),
        ("MesocycleStatus", MesocycleStatus),
        ("IntensityLevel", IntensityLevel),
        ("EffortType", EffortType),
        ("TempoType", TempoType),
        ("SetType", SetType),
        ("ExercisePhase", ExercisePhase),
        ("Gender", Gender),
        ("ExperienceLevel", ExperienceLevel),
        ("MetricType", MetricType),
        ("WorkoutStatus", WorkoutStatus),
        ("AbandonReason", AbandonReason),
    ]

    lines.append("| Enum | Valores |")
    lines.append("|------|---------|")

    for enum_name, enum_class in all_enums:
        values = get_enum_values(enum_class)
        values_str = ", ".join([f"`{v}`" for v in values])
        lines.append(f"| {enum_name} | {values_str} |")

    lines.append("")
    lines.append(f"**Total de Enums:** {len(all_enums)}")
    lines.append("")

    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Auditoría de Base de Datos FitPilot")
    parser.add_argument(
        "--output", "-o",
        help="Archivo de salida (default: imprime en consola)",
        default=None
    )
    parser.add_argument(
        "--compare", "-c",
        help="Archivo de documentación existente para comparar",
        default=None
    )

    args = parser.parse_args()

    print("\n🔍 FitPilot Database Auditor")
    print("=" * 40)

    # Generar auditoría
    audit_content = generate_full_audit()

    if args.output:
        # Escribir a archivo
        output_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), args.output)
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(audit_content)
        print(f"✅ Auditoría guardada en: {output_path}")
    else:
        # Imprimir resumen en consola
        lines = audit_content.split('\n')

        # Imprimir solo el resumen
        in_summary = False
        for line in lines:
            if line.startswith("## Resumen"):
                in_summary = True
            elif line.startswith("## ") and in_summary:
                break

            if in_summary:
                print(line)

    # Comparación (si se especifica)
    if args.compare:
        compare_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), args.compare)
        if os.path.exists(compare_path):
            print(f"\n📊 Comparando con: {compare_path}")
            print("-" * 40)

            with open(compare_path, 'r', encoding='utf-8') as f:
                existing_content = f.read()

            # Extraer tablas mencionadas en cada documento
            import re

            audit_tables = set(re.findall(r"Tabla:\s*`(\w+)`", audit_content))
            existing_tables = set(re.findall(r"Tabla:\s*`(\w+)`", existing_content))

            new_tables = audit_tables - existing_tables
            removed_tables = existing_tables - audit_tables

            if new_tables:
                print(f"\n🆕 Tablas NUEVAS (no documentadas):")
                for table in sorted(new_tables):
                    print(f"   - {table}")

            if removed_tables:
                print(f"\n⚠️  Tablas en documentación pero no en modelos:")
                for table in sorted(removed_tables):
                    print(f"   - {table}")

            if not new_tables and not removed_tables:
                print("\n✅ Todas las tablas están documentadas")
        else:
            print(f"❌ Archivo no encontrado: {compare_path}")

    print("\n✨ Auditoría completada!")


if __name__ == "__main__":
    main()
