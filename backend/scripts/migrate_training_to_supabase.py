"""
Training migration tool:
- Source: local fitpilot_db (public training tables with UUID ids)
- Target: Supabase fitpilot (training schema with integer identity ids)
- Users are unified against target public.users

Default mode is dry-run (non-mutating).
Use --apply to execute schema migration + data migration.
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import sys
from collections import defaultdict
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

import psycopg
from psycopg import Connection
from psycopg.rows import dict_row


SOURCE_TABLES = [
    "users",
    "muscles",
    "exercises",
    "exercise_muscles",
    "macrocycles",
    "mesocycles",
    "microcycles",
    "training_days",
    "day_exercises",
    "workout_logs",
    "exercise_set_logs",
    "client_interviews",
    "client_metrics",
    "patient_context_snapshots",
]

TARGET_TRAINING_TABLES = [
    "muscles",
    "exercises",
    "exercise_muscles",
    "macrocycles",
    "mesocycles",
    "microcycles",
    "training_days",
    "day_exercises",
    "workout_logs",
    "exercise_set_logs",
    "client_interviews",
    "client_metrics",
    "patient_context_snapshots",
]

TRUNCATE_ORDER = [
    "exercise_set_logs",
    "workout_logs",
    "day_exercises",
    "training_days",
    "microcycles",
    "mesocycles",
    "macrocycles",
    "exercise_muscles",
    "exercises",
    "muscles",
    "client_interviews",
    "client_metrics",
    "patient_context_snapshots",
]

ROLE_MAP = {
    "CLIENT": "CLIENT",
    "TRAINER": "PROFESSIONAL",
    "ADMIN": "ADMIN",
}

ALLOWED_EXERCISE_CLASSES = {
    "strength",
    "cardio",
    "plyometric",
    "flexibility",
    "mobility",
    "warmup",
}

ALLOWED_EXERCISE_PHASES = {"WARMUP", "MAIN", "COOLDOWN"}
ALLOWED_WORKOUT_STATUS = {"in_progress", "completed", "abandoned"}
ALLOWED_INTENSITY_LEVELS = {"LOW", "MEDIUM", "HIGH", "DELOAD"}
ALLOWED_EXERCISE_TYPE = {"MULTIARTICULAR", "MONOARTICULAR"}


def now_utc_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def split_full_name(full_name: str | None, fallback_email: str | None) -> tuple[str, str | None]:
    name_source = (full_name or "").strip()
    if not name_source and fallback_email:
        name_source = fallback_email.split("@", 1)[0].strip()
    if not name_source:
        return ("Unknown", None)
    parts = name_source.split()
    first = parts[0]
    last = " ".join(parts[1:]) if len(parts) > 1 else None
    return (first, last)


def as_jsonable(value: Any) -> Any:
    if isinstance(value, datetime):
        return value.isoformat()
    if hasattr(value, "isoformat"):
        try:
            return value.isoformat()
        except Exception:
            return str(value)
    if isinstance(value, (list, tuple)):
        return [as_jsonable(v) for v in value]
    if isinstance(value, dict):
        return {k: as_jsonable(v) for k, v in value.items()}
    return value


@dataclass
class MigrationArtifacts:
    backup_dir: Path
    report_path: Path
    unsupported_dir: Path
    users_created: list[dict[str, Any]] = field(default_factory=list)
    users_reused: list[dict[str, Any]] = field(default_factory=list)
    unsupported_fields: dict[str, list[dict[str, Any]]] = field(default_factory=lambda: defaultdict(list))
    validation: dict[str, Any] = field(default_factory=dict)
    counts: dict[str, dict[str, int]] = field(default_factory=dict)
    started_at: str = field(default_factory=now_utc_iso)
    finished_at: str | None = None
    status: str = "running"
    notes: list[str] = field(default_factory=list)

    def dump_unsupported(self) -> None:
        ensure_dir(self.unsupported_dir)
        for key, rows in self.unsupported_fields.items():
            file_path = self.unsupported_dir / f"{key}.json"
            with file_path.open("w", encoding="utf-8") as f:
                json.dump([as_jsonable(r) for r in rows], f, ensure_ascii=False, indent=2)

            csv_path = self.unsupported_dir / f"{key}.csv"
            if rows:
                headers = sorted({k for r in rows for k in r.keys()})
                with csv_path.open("w", newline="", encoding="utf-8") as f:
                    writer = csv.DictWriter(f, fieldnames=headers)
                    writer.writeheader()
                    for row in rows:
                        writer.writerow({h: as_jsonable(row.get(h)) for h in headers})

    def dump_summary_json(self) -> None:
        ensure_dir(self.backup_dir)
        summary_path = self.backup_dir / "migration_summary.json"
        with summary_path.open("w", encoding="utf-8") as f:
            json.dump(
                {
                    "started_at": self.started_at,
                    "finished_at": self.finished_at,
                    "status": self.status,
                    "notes": self.notes,
                    "users_created": self.users_created,
                    "users_reused": self.users_reused,
                    "counts": self.counts,
                    "validation": self.validation,
                },
                f,
                ensure_ascii=False,
                indent=2,
                default=as_jsonable,
            )

    def write_report(self, dry_run: bool) -> None:
        ensure_dir(self.report_path.parent)
        lines: list[str] = []
        lines.append("# Training Migration Report")
        lines.append("")
        lines.append(f"- Generated at: `{now_utc_iso()}`")
        lines.append(f"- Mode: `{'dry-run' if dry_run else 'apply'}`")
        lines.append(f"- Status: `{self.status}`")
        lines.append(f"- Started at: `{self.started_at}`")
        if self.finished_at:
            lines.append(f"- Finished at: `{self.finished_at}`")
        lines.append(f"- Backup dir: `{self.backup_dir.as_posix()}`")
        lines.append("")

        if self.notes:
            lines.append("## Notes")
            for n in self.notes:
                lines.append(f"- {n}")
            lines.append("")

        if self.counts:
            lines.append("## Counts")
            lines.append("")
            lines.append("| Table | Source | Target |")
            lines.append("|---|---:|---:|")
            target_counts = self.counts.get("target", {}) or self.counts.get("target_before", {})
            for table in TARGET_TRAINING_TABLES:
                src = self.counts.get("source", {}).get(table, 0)
                tgt = target_counts.get(table, 0)
                lines.append(f"| `{table}` | {src} | {tgt} |")
            lines.append("")

        lines.append("## Users")
        lines.append(f"- Reused users: `{len(self.users_reused)}`")
        lines.append(f"- Created users: `{len(self.users_created)}`")
        lines.append("")

        if self.validation:
            lines.append("## Validation")
            for key, value in self.validation.items():
                lines.append(f"- `{key}`: `{value}`")
            lines.append("")

        lines.append("## Artifacts")
        lines.append(f"- Unsupported fields folder: `{self.unsupported_dir.as_posix()}`")
        lines.append(f"- Summary JSON: `{(self.backup_dir / 'migration_summary.json').as_posix()}`")
        lines.append("")

        self.report_path.write_text("\n".join(lines), encoding="utf-8")


def fetch_count(conn: Connection[Any], schema: str, table: str) -> int:
    with conn.cursor() as cur:
        cur.execute(f"SELECT COUNT(*) AS c FROM {schema}.{table}")
        row = cur.fetchone()
        return int(row["c"])


def table_exists(conn: Connection[Any], schema: str, table: str) -> bool:
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT EXISTS (
                SELECT 1
                FROM information_schema.tables
                WHERE table_schema = %s
                  AND table_name = %s
            )
            """,
            (schema, table),
        )
        row = cur.fetchone()
        return bool(row["exists"])


def backup_table(conn: Connection[Any], schema: str, table: str, out_file: Path) -> None:
    with conn.cursor(row_factory=dict_row) as cur:
        cur.execute(f"SELECT * FROM {schema}.{table}")
        rows = cur.fetchall()
    with out_file.open("w", encoding="utf-8") as f:
        json.dump([as_jsonable(r) for r in rows], f, ensure_ascii=False, indent=2)


def run_schema_migration(target: Connection[Any], schema_sql_path: Path) -> None:
    sql_text = schema_sql_path.read_text(encoding="utf-8")
    with target.cursor() as cur:
        cur.execute(sql_text)


def load_rows(conn: Connection[Any], table: str) -> list[dict[str, Any]]:
    with conn.cursor(row_factory=dict_row) as cur:
        cur.execute(f"SELECT * FROM public.{table}")
        return cur.fetchall()


def normalize_exercise_type(raw: Any) -> str | None:
    if raw is None:
        return None
    value = str(raw).upper()
    return value if value in ALLOWED_EXERCISE_TYPE else None


def normalize_exercise_class(raw: Any) -> str:
    if raw is None:
        return "strength"
    value = str(raw).lower()
    return value if value in ALLOWED_EXERCISE_CLASSES else "strength"


def normalize_phase(raw: Any) -> str:
    if raw is None:
        return "MAIN"
    value = str(raw).upper()
    return value if value in ALLOWED_EXERCISE_PHASES else "MAIN"


def normalize_status(raw: Any) -> str:
    if raw is None:
        return "in_progress"
    value = str(raw).lower()
    return value if value in ALLOWED_WORKOUT_STATUS else "in_progress"


def normalize_intensity(raw: Any) -> str:
    if raw is None:
        return "MEDIUM"
    value = str(raw).upper()
    return value if value in ALLOWED_INTENSITY_LEVELS else "MEDIUM"


def normalize_role(raw: Any) -> str:
    if raw is None:
        return "CLIENT"
    src = str(raw).upper()
    return ROLE_MAP.get(src, "CLIENT")


def truncate_training_tables(target: Connection[Any]) -> None:
    with target.cursor() as cur:
        for table in TRUNCATE_ORDER:
            if table_exists(target, "training", table):
                cur.execute(f"TRUNCATE TABLE training.{table} RESTART IDENTITY CASCADE")


def lock_training_tables(target: Connection[Any]) -> None:
    lock_list = ", ".join([f"training.{t}" for t in TARGET_TRAINING_TABLES])
    with target.cursor() as cur:
        cur.execute(f"LOCK TABLE {lock_list} IN ACCESS EXCLUSIVE MODE")
        cur.execute("LOCK TABLE public.users IN SHARE ROW EXCLUSIVE MODE")


def gather_source_counts(source: Connection[Any]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for table in TARGET_TRAINING_TABLES:
        counts[table] = fetch_count(source, "public", table)
    return counts


def gather_target_counts(target: Connection[Any]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for table in TARGET_TRAINING_TABLES:
        if table_exists(target, "training", table):
            counts[table] = fetch_count(target, "training", table)
        else:
            counts[table] = 0
    return counts


def create_or_reuse_users(
    source_users: list[dict[str, Any]],
    target: Connection[Any],
    artifacts: MigrationArtifacts,
) -> dict[str, int]:
    user_map: dict[str, int] = {}

    with target.cursor(row_factory=dict_row) as cur:
        cur.execute("SELECT id, email FROM public.users")
        existing_users = cur.fetchall()
    target_by_email = {
        (u["email"] or "").strip().lower(): int(u["id"])
        for u in existing_users
        if u["email"]
    }

    with target.cursor(row_factory=dict_row) as cur:
        for src_user in source_users:
            src_id = str(src_user["id"])
            email = (src_user.get("email") or "").strip().lower()
            if email and email in target_by_email:
                dst_id = target_by_email[email]
                user_map[src_id] = dst_id
                artifacts.users_reused.append(
                    {"source_user_id": src_id, "target_user_id": dst_id, "email": email}
                )
                continue

            first_name, last_name = split_full_name(src_user.get("full_name"), src_user.get("email"))
            role = normalize_role(src_user.get("role"))
            cur.execute(
                """
                INSERT INTO public.users (
                    name,
                    lastname,
                    email,
                    password,
                    created_at,
                    updated_at,
                    is_active,
                    role
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s::public.user_role_enum)
                RETURNING id
                """,
                (
                    first_name,
                    last_name,
                    src_user.get("email"),
                    src_user.get("hashed_password"),
                    src_user.get("created_at"),
                    src_user.get("updated_at"),
                    bool(src_user.get("is_active", True)),
                    role,
                ),
            )
            dst_id = int(cur.fetchone()["id"])
            user_map[src_id] = dst_id
            artifacts.users_created.append(
                {"source_user_id": src_id, "target_user_id": dst_id, "email": src_user.get("email")}
            )

    return user_map


def stringify_array(arr: Any) -> list[str] | None:
    if arr is None:
        return None
    if not isinstance(arr, (list, tuple)):
        return [str(arr)]
    return [str(v) for v in arr]


def build_injury_text(interview: dict[str, Any]) -> str | None:
    if interview.get("injury_details"):
        return str(interview["injury_details"])
    areas = interview.get("injury_areas")
    if isinstance(areas, (list, tuple)) and areas:
        return ", ".join(str(v) for v in areas if v is not None)
    return None


def validate_post_migration(target: Connection[Any], source_counts: dict[str, int]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    target_counts = gather_target_counts(target)
    result["count_mismatches"] = {
        t: {"source": source_counts[t], "target": target_counts.get(t, 0)}
        for t in TARGET_TRAINING_TABLES
        if source_counts[t] != target_counts.get(t, 0)
    }

    orphan_checks = {
        "client_interviews_client_fk": """
            SELECT COUNT(*) AS c
            FROM training.client_interviews ci
            LEFT JOIN public.users u ON u.id = ci.client_id
            WHERE u.id IS NULL
        """,
        "workout_logs_client_fk": """
            SELECT COUNT(*) AS c
            FROM training.workout_logs wl
            LEFT JOIN public.users u ON u.id = wl.client_id
            WHERE u.id IS NULL
        """,
        "macrocycles_trainer_fk": """
            SELECT COUNT(*) AS c
            FROM training.macrocycles m
            LEFT JOIN public.users u ON u.id = m.trainer_id
            WHERE m.trainer_id IS NOT NULL AND u.id IS NULL
        """,
        "macrocycles_client_fk": """
            SELECT COUNT(*) AS c
            FROM training.macrocycles m
            LEFT JOIN public.users u ON u.id = m.client_id
            WHERE m.client_id IS NOT NULL AND u.id IS NULL
        """,
        "client_metrics_client_fk": """
            SELECT COUNT(*) AS c
            FROM training.client_metrics cm
            LEFT JOIN public.users u ON u.id = cm.client_id
            WHERE u.id IS NULL
        """,
        "patient_context_client_fk": """
            SELECT COUNT(*) AS c
            FROM training.patient_context_snapshots pcs
            LEFT JOIN public.users u ON u.id = pcs.client_id
            WHERE u.id IS NULL
        """,
        "patient_context_created_by_fk": """
            SELECT COUNT(*) AS c
            FROM training.patient_context_snapshots pcs
            LEFT JOIN public.users u ON u.id = pcs.created_by
            WHERE pcs.created_by IS NOT NULL AND u.id IS NULL
        """,
    }

    with target.cursor(row_factory=dict_row) as cur:
        for name, sql in orphan_checks.items():
            cur.execute(sql)
            result[name] = int(cur.fetchone()["c"])

        cur.execute(
            """
            SELECT mc.id AS macrocycle_id, mc.name, COUNT(de.id) AS day_exercises
            FROM training.macrocycles mc
            LEFT JOIN training.mesocycles ms ON ms.macrocycle_id = mc.id
            LEFT JOIN training.microcycles mi ON mi.mesocycle_id = ms.id
            LEFT JOIN training.training_days td ON td.microcycle_id = mi.id
            LEFT JOIN training.day_exercises de ON de.training_day_id = td.id
            GROUP BY mc.id, mc.name
            ORDER BY mc.id
            LIMIT 5
            """
        )
        result["sample_macrocycle_chain"] = [dict(r) for r in cur.fetchall()]

        cur.execute(
            """
            SELECT wl.id AS workout_log_id, wl.status, wl.client_id, COUNT(es.id) AS set_rows
            FROM training.workout_logs wl
            LEFT JOIN training.exercise_set_logs es ON es.workout_log_id = wl.id
            GROUP BY wl.id, wl.status, wl.client_id
            ORDER BY wl.id
            LIMIT 5
            """
        )
        result["sample_workout_logs"] = [dict(r) for r in cur.fetchall()]

    return result


def run_migration(
    source_dsn: str,
    target_dsn: str,
    schema_sql_path: Path,
    artifacts: MigrationArtifacts,
    apply: bool,
) -> None:
    source = psycopg.connect(source_dsn, row_factory=dict_row)
    target = psycopg.connect(target_dsn, row_factory=dict_row)
    source.autocommit = True
    target.autocommit = False

    try:
        artifacts.notes.append("Freeze training writes during migration window is required.")
        artifacts.notes.append("Using transaction + table locks for target training tables.")

        source_counts = gather_source_counts(source)
        target_counts_before = gather_target_counts(target)
        artifacts.counts["source"] = source_counts
        artifacts.counts["target_before"] = target_counts_before

        if not apply:
            artifacts.status = "dry_run_ok"
            artifacts.notes.append("Dry-run only: schema/data were not modified.")
            artifacts.validation = {
                "source_connection": "ok",
                "target_connection": "ok",
                "schema_sql_exists": schema_sql_path.exists(),
                "missing_source_tables": [
                    t for t in SOURCE_TABLES if not table_exists(source, "public", t)
                ],
                "missing_target_tables_before_schema_migration": [
                    t for t in TARGET_TRAINING_TABLES if not table_exists(target, "training", t)
                ],
            }
            return

        ensure_dir(artifacts.backup_dir)
        ensure_dir(artifacts.unsupported_dir)

        for table in TARGET_TRAINING_TABLES:
            if table_exists(target, "training", table):
                backup_table(
                    conn=target,
                    schema="training",
                    table=table,
                    out_file=artifacts.backup_dir / f"training_{table}_before.json",
                )

        source_users = load_rows(source, "users")
        source_emails = sorted(
            {(u.get("email") or "").strip().lower() for u in source_users if u.get("email")}
        )
        with target.cursor(row_factory=dict_row) as cur:
            cur.execute("SELECT * FROM public.users WHERE lower(email) = ANY(%s)", (source_emails,))
            users_before = cur.fetchall()
        with (artifacts.backup_dir / "public_users_touched_before.json").open("w", encoding="utf-8") as f:
            json.dump([as_jsonable(u) for u in users_before], f, ensure_ascii=False, indent=2)

        run_schema_migration(target, schema_sql_path)

        lock_training_tables(target)
        truncate_training_tables(target)

        user_id_map = create_or_reuse_users(source_users, target, artifacts)

        src_muscles = load_rows(source, "muscles")
        src_exercises = load_rows(source, "exercises")
        src_exercise_muscles = load_rows(source, "exercise_muscles")
        src_macrocycles = load_rows(source, "macrocycles")
        src_mesocycles = load_rows(source, "mesocycles")
        src_microcycles = load_rows(source, "microcycles")
        src_training_days = load_rows(source, "training_days")
        src_day_exercises = load_rows(source, "day_exercises")
        src_workout_logs = load_rows(source, "workout_logs")
        src_exercise_set_logs = load_rows(source, "exercise_set_logs")
        src_client_interviews = load_rows(source, "client_interviews")
        src_client_metrics = load_rows(source, "client_metrics")
        src_patient_context = load_rows(source, "patient_context_snapshots")

        muscle_id_map: dict[str, int] = {}
        exercise_id_map: dict[str, int] = {}
        macrocycle_id_map: dict[str, int] = {}
        mesocycle_id_map: dict[str, int] = {}
        microcycle_id_map: dict[str, int] = {}
        training_day_id_map: dict[str, int] = {}
        day_exercise_id_map: dict[str, int] = {}
        workout_log_id_map: dict[str, int] = {}

        with target.cursor(row_factory=dict_row) as cur:
            for row in src_muscles:
                cur.execute(
                    """
                    INSERT INTO training.muscles (name, display_name_es, body_region)
                    VALUES (%s, %s, %s)
                    RETURNING id
                    """,
                    (row.get("name"), row.get("display_name_es"), row.get("body_region")),
                )
                muscle_id_map[str(row["id"])] = int(cur.fetchone()["id"])

            for row in src_exercises:
                name_es = row.get("name_es") or row.get("name_en") or f"Exercise {str(row['id'])[:8]}"
                description = row.get("description_es") or row.get("description_en")
                ex_type = normalize_exercise_type(row.get("type"))
                raw_class = row.get("exercise_class")
                ex_class = normalize_exercise_class(raw_class)
                if raw_class is not None and str(raw_class).lower() != ex_class:
                    artifacts.unsupported_fields["exercises_class_remap"].append(
                        {
                            "source_id": str(row["id"]),
                            "source_exercise_class": str(raw_class),
                            "target_exercise_class": ex_class,
                        }
                    )
                cur.execute(
                    """
                    INSERT INTO training.exercises (
                        name_es,
                        name_en,
                        description,
                        type,
                        exercise_class,
                        video_url,
                        image_url,
                        created_at
                    )
                    VALUES (%s, %s, %s, %s::training.exercise_type, %s::training.exercise_class, %s, %s, %s)
                    RETURNING id
                    """,
                    (
                        name_es,
                        row.get("name_en"),
                        description,
                        ex_type,
                        ex_class,
                        row.get("video_url"),
                        row.get("image_url") or row.get("thumbnail_url") or row.get("anatomy_image_url"),
                        row.get("created_at"),
                    ),
                )
                exercise_id_map[str(row["id"])] = int(cur.fetchone()["id"])

            for row in src_exercise_muscles:
                src_exercise_id = str(row.get("exercise_id"))
                src_muscle_id = str(row.get("muscle_id"))
                if src_exercise_id not in exercise_id_map or src_muscle_id not in muscle_id_map:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.exercise_muscles (exercise_id, muscle_id, role)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (exercise_id, muscle_id) DO UPDATE
                    SET role = EXCLUDED.role
                    """,
                    (
                        exercise_id_map[src_exercise_id],
                        muscle_id_map[src_muscle_id],
                        row.get("muscle_role"),
                    ),
                )

            for row in src_macrocycles:
                trainer_src = str(row.get("trainer_id")) if row.get("trainer_id") is not None else None
                client_src = str(row.get("client_id")) if row.get("client_id") is not None else None
                trainer_id = user_id_map.get(trainer_src) if trainer_src else None
                client_id = user_id_map.get(client_src) if client_src else None
                cur.execute(
                    """
                    INSERT INTO training.macrocycles (
                        trainer_id,
                        client_id,
                        name,
                        start_date,
                        end_date,
                        status
                    )
                    VALUES (%s, %s, %s, %s, %s, %s)
                    RETURNING id
                    """,
                    (
                        trainer_id,
                        client_id,
                        row.get("name"),
                        row.get("start_date"),
                        row.get("end_date"),
                        str(row.get("status") or "ACTIVE"),
                    ),
                )
                macrocycle_id_map[str(row["id"])] = int(cur.fetchone()["id"])

            for row in src_mesocycles:
                src_macro = str(row.get("macrocycle_id"))
                if src_macro not in macrocycle_id_map:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.mesocycles (
                        macrocycle_id,
                        name,
                        start_date,
                        end_date,
                        focus
                    )
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING id
                    """,
                    (
                        macrocycle_id_map[src_macro],
                        row.get("name"),
                        row.get("start_date"),
                        row.get("end_date"),
                        row.get("focus"),
                    ),
                )
                mesocycle_id_map[str(row["id"])] = int(cur.fetchone()["id"])

            for row in src_microcycles:
                src_meso = str(row.get("mesocycle_id"))
                if src_meso not in mesocycle_id_map:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.microcycles (
                        mesocycle_id,
                        week_number,
                        intensity_level
                    )
                    VALUES (%s, %s, %s::training.intensity_level)
                    RETURNING id
                    """,
                    (
                        mesocycle_id_map[src_meso],
                        row.get("week_number"),
                        normalize_intensity(row.get("intensity_level")),
                    ),
                )
                microcycle_id_map[str(row["id"])] = int(cur.fetchone()["id"])

            for row in src_training_days:
                src_micro = str(row.get("microcycle_id"))
                if src_micro not in microcycle_id_map:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.training_days (
                        microcycle_id,
                        day_number,
                        name,
                        is_rest_day
                    )
                    VALUES (%s, %s, %s, %s)
                    RETURNING id
                    """,
                    (
                        microcycle_id_map[src_micro],
                        row.get("day_number"),
                        row.get("name"),
                        row.get("rest_day"),
                    ),
                )
                training_day_id_map[str(row["id"])] = int(cur.fetchone()["id"])
                artifacts.unsupported_fields["training_days_dropped_fields"].append(
                    {
                        "source_id": str(row["id"]),
                        "date": row.get("date"),
                        "focus": row.get("focus"),
                        "notes": row.get("notes"),
                        "created_at": row.get("created_at"),
                        "updated_at": row.get("updated_at"),
                    }
                )

            source_day_exercise_by_id = {str(row["id"]): row for row in src_day_exercises}
            for row in src_day_exercises:
                src_day = str(row.get("training_day_id"))
                src_exercise = str(row.get("exercise_id"))
                if src_day not in training_day_id_map or src_exercise not in exercise_id_map:
                    continue
                effort_type = str(row.get("effort_type") or "").upper()
                effort_value = row.get("effort_value")
                rpe_target = effort_value if effort_type == "RPE" else None
                cur.execute(
                    """
                    INSERT INTO training.day_exercises (
                        training_day_id,
                        exercise_id,
                        order_index,
                        phase,
                        sets,
                        reps_min,
                        reps_max,
                        rest_seconds,
                        rpe_target,
                        notes
                    )
                    VALUES (%s, %s, %s, %s::training.exercise_phase, %s, %s, %s, %s, %s, %s)
                    RETURNING id
                    """,
                    (
                        training_day_id_map[src_day],
                        exercise_id_map[src_exercise],
                        row.get("order_index"),
                        normalize_phase(row.get("phase")),
                        row.get("sets"),
                        row.get("reps_min"),
                        row.get("reps_max"),
                        row.get("rest_seconds"),
                        rpe_target,
                        row.get("notes"),
                    ),
                )
                day_exercise_id_map[str(row["id"])] = int(cur.fetchone()["id"])
                if effort_type != "RPE":
                    artifacts.unsupported_fields["day_exercises_non_rpe_effort"].append(
                        {
                            "source_id": str(row["id"]),
                            "effort_type": effort_type,
                            "effort_value": effort_value,
                            "set_type": row.get("set_type"),
                            "tempo": row.get("tempo"),
                            "duration_seconds": row.get("duration_seconds"),
                            "intensity_zone": row.get("intensity_zone"),
                            "distance_meters": row.get("distance_meters"),
                            "target_calories": row.get("target_calories"),
                            "intervals": row.get("intervals"),
                            "work_seconds": row.get("work_seconds"),
                            "interval_rest_seconds": row.get("interval_rest_seconds"),
                        }
                    )

            for row in src_workout_logs:
                src_client = str(row.get("client_id"))
                src_day = str(row.get("training_day_id")) if row.get("training_day_id") is not None else None
                if src_client not in user_id_map:
                    continue
                training_day_id = training_day_id_map.get(src_day) if src_day else None
                cur.execute(
                    """
                    INSERT INTO training.workout_logs (
                        client_id,
                        training_day_id,
                        started_at,
                        completed_at,
                        status,
                        notes
                    )
                    VALUES (%s, %s, %s, %s, %s::training.workout_status, %s)
                    RETURNING id
                    """,
                    (
                        user_id_map[src_client],
                        training_day_id,
                        row.get("started_at"),
                        row.get("completed_at"),
                        normalize_status(row.get("status")),
                        row.get("notes"),
                    ),
                )
                workout_log_id_map[str(row["id"])] = int(cur.fetchone()["id"])
                artifacts.unsupported_fields["workout_logs_dropped_fields"].append(
                    {
                        "source_id": str(row["id"]),
                        "abandon_reason": row.get("abandon_reason"),
                        "abandon_notes": row.get("abandon_notes"),
                        "rescheduled_to_date": row.get("rescheduled_to_date"),
                        "created_at": row.get("created_at"),
                        "updated_at": row.get("updated_at"),
                    }
                )

            for row in src_exercise_set_logs:
                src_workout = str(row.get("workout_log_id"))
                src_day_exercise = str(row.get("day_exercise_id"))
                if src_workout not in workout_log_id_map:
                    continue
                source_day_ex = source_day_exercise_by_id.get(src_day_exercise)
                if source_day_ex is None:
                    continue
                src_exercise = str(source_day_ex.get("exercise_id"))
                if src_exercise not in exercise_id_map:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.exercise_set_logs (
                        workout_log_id,
                        exercise_id,
                        day_exercise_id,
                        set_number,
                        reps,
                        weight_kg,
                        rpe,
                        completed_at
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                    RETURNING id
                    """,
                    (
                        workout_log_id_map[src_workout],
                        exercise_id_map[src_exercise],
                        day_exercise_id_map.get(src_day_exercise),
                        row.get("set_number"),
                        row.get("reps_completed"),
                        row.get("weight_kg"),
                        row.get("effort_value"),
                        row.get("completed_at"),
                    ),
                )
                artifacts.unsupported_fields["exercise_set_logs_dropped_fields"].append(
                    {
                        "source_id": str(row["id"]),
                        "notes": row.get("notes"),
                        "created_at": row.get("created_at"),
                    }
                )

            for row in src_client_interviews:
                src_client = str(row.get("client_id"))
                mapped_client = user_id_map.get(src_client)
                if mapped_client is None:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.client_interviews (
                        client_id,
                        experience_level,
                        primary_goal,
                        days_available,
                        injuries,
                        equipment_available,
                        created_at
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                    """,
                    (
                        mapped_client,
                        str(row.get("experience_level")) if row.get("experience_level") is not None else None,
                        str(row.get("primary_goal")) if row.get("primary_goal") is not None else None,
                        row.get("days_per_week"),
                        build_injury_text(row),
                        stringify_array(row.get("available_equipment")),
                        row.get("created_at"),
                    ),
                )
                artifacts.unsupported_fields["client_interviews_dropped_fields"].append(
                    {
                        "source_client_id": src_client,
                        "source_id": str(row.get("id")),
                        "all_dropped_fields": {
                            k: row.get(k)
                            for k in [
                                "document_id",
                                "age",
                                "gender",
                                "occupation",
                                "phone",
                                "address",
                                "emergency_contact_name",
                                "emergency_contact_phone",
                                "insurance_provider",
                                "policy_number",
                                "weight_kg",
                                "height_cm",
                                "training_experience_months",
                                "target_muscle_groups",
                                "specific_goals_text",
                                "session_duration_minutes",
                                "preferred_days",
                                "has_gym_access",
                                "equipment_notes",
                                "injury_areas",
                                "injury_details",
                                "excluded_exercises",
                                "medical_conditions",
                                "mobility_limitations",
                                "notes",
                                "updated_at",
                            ]
                        },
                    }
                )

            for row in src_client_metrics:
                src_client = str(row.get("client_id"))
                mapped_client = user_id_map.get(src_client)
                if mapped_client is None:
                    continue
                cur.execute(
                    """
                    INSERT INTO training.client_metrics (
                        client_id,
                        metric_type,
                        value,
                        unit,
                        date,
                        created_at,
                        updated_at
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s)
                    """,
                    (
                        mapped_client,
                        str(row.get("metric_type")),
                        row.get("value"),
                        row.get("unit"),
                        row.get("date"),
                        row.get("created_at"),
                        row.get("updated_at"),
                    ),
                )

            for row in src_patient_context:
                src_client = str(row.get("client_id"))
                mapped_client = user_id_map.get(src_client)
                if mapped_client is None:
                    continue
                src_created_by = str(row.get("created_by")) if row.get("created_by") is not None else None
                mapped_created_by = user_id_map.get(src_created_by) if src_created_by else None
                cur.execute(
                    """
                    INSERT INTO training.patient_context_snapshots (
                        id,
                        client_id,
                        version,
                        effective_at,
                        source,
                        data,
                        created_by,
                        created_at
                    )
                    VALUES (%s::uuid, %s, %s, %s, %s, %s::jsonb, %s, %s)
                    """,
                    (
                        str(row.get("id")),
                        mapped_client,
                        row.get("version"),
                        row.get("effective_at"),
                        row.get("source"),
                        json.dumps(as_jsonable(row.get("data"))),
                        mapped_created_by,
                        row.get("created_at"),
                    ),
                )

        validation = validate_post_migration(target, source_counts)
        artifacts.validation = validation
        artifacts.counts["target"] = gather_target_counts(target)

        has_mismatch = bool(validation.get("count_mismatches"))
        has_orphans = any(
            validation.get(k, 0) > 0
            for k in [
                "client_interviews_client_fk",
                "workout_logs_client_fk",
                "macrocycles_trainer_fk",
                "macrocycles_client_fk",
                "client_metrics_client_fk",
                "patient_context_client_fk",
                "patient_context_created_by_fk",
            ]
        )
        if has_mismatch or has_orphans:
            raise RuntimeError(
                f"Post-migration validation failed: mismatches={validation.get('count_mismatches')} "
                f"orphans_present={has_orphans}"
            )

        target.commit()
        artifacts.status = "apply_ok"
    except Exception as exc:
        target.rollback()
        artifacts.status = "failed"
        artifacts.notes.append(f"Migration failed and was rolled back: {exc}")
        raise
    finally:
        artifacts.finished_at = now_utc_iso()
        source.close()
        target.close()


def parse_args(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Migrate training data to Supabase training schema.")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Validate only (default).")
    mode.add_argument("--apply", action="store_true", help="Execute schema + data migration.")
    parser.add_argument(
        "--source-dsn",
        default=os.getenv("SOURCE_DSN", "postgresql://admin:secretpass@localhost:5433/fitpilot_db"),
        help="Source Postgres DSN.",
    )
    parser.add_argument(
        "--target-dsn",
        default=os.getenv(
            "TARGET_DSN",
            "",
        ),
        help="Target Postgres DSN.",
    )
    parser.add_argument(
        "--schema-sql-path",
        default="database/migrations/20260218_training_users_unification.sql",
        help="Path to idempotent schema SQL migration file.",
    )
    parser.add_argument(
        "--report-path",
        default="docs/migrations/training_migration_report_2026-02-18.md",
        help="Markdown report output path.",
    )
    parser.add_argument(
        "--backup-dir",
        default=f"database/backups/training_migration_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
        help="Backup/artifacts directory.",
    )
    return parser.parse_args(list(argv))


def main(argv: Iterable[str]) -> int:
    args = parse_args(argv)
    apply = bool(args.apply)
    if not args.apply and not args.dry_run:
        apply = False

    if not args.target_dsn:
        print("[ERROR] target DSN is required. Set TARGET_DSN or pass --target-dsn.")
        return 2

    schema_sql_path = Path(args.schema_sql_path).resolve()
    report_path = Path(args.report_path).resolve()
    backup_dir = Path(args.backup_dir).resolve()
    unsupported_dir = backup_dir / "unsupported_fields"

    artifacts = MigrationArtifacts(
        backup_dir=backup_dir,
        report_path=report_path,
        unsupported_dir=unsupported_dir,
    )

    try:
        run_migration(
            source_dsn=args.source_dsn,
            target_dsn=args.target_dsn,
            schema_sql_path=schema_sql_path,
            artifacts=artifacts,
            apply=apply,
        )
    except Exception as exc:
        artifacts.status = "failed"
        artifacts.notes.append(f"Error: {exc}")
        artifacts.finished_at = now_utc_iso()
        artifacts.dump_unsupported()
        artifacts.dump_summary_json()
        artifacts.write_report(dry_run=not apply)
        print(f"[ERROR] Migration failed: {exc}")
        return 1

    artifacts.dump_unsupported()
    artifacts.dump_summary_json()
    artifacts.write_report(dry_run=not apply)
    print(f"[OK] Migration {'applied' if apply else 'validated (dry-run)'} successfully.")
    print(f"[OK] Report: {report_path}")
    print(f"[OK] Artifacts: {backup_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
