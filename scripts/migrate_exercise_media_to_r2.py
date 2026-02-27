"""
Migrate legacy exercise media URLs (/static/...) to Cloudflare R2 public URLs.

Usage:
  python scripts/migrate_exercise_media_to_r2.py           # dry-run
  python scripts/migrate_exercise_media_to_r2.py --apply   # execute migration
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass, field
from typing import Dict, List
import sys
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from sqlalchemy import text
from models.base import SessionLocal
from services.exercise_media_storage import (
    StorageError,
    is_legacy_static_exercise_url,
    static_exercise_path_from_url,
    upload_local_file_to_r2,
)

MEDIA_COLUMNS = ("image_url", "thumbnail_url", "anatomy_image_url")


def detect_exercises_schema(db) -> str:
    query = text(
        """
        SELECT table_schema
        FROM information_schema.tables
        WHERE table_name = 'exercises'
          AND table_schema IN ('training', 'public')
        ORDER BY CASE WHEN table_schema = 'training' THEN 0 ELSE 1 END
        LIMIT 1
        """
    )
    schema = db.execute(query).scalar()
    if not schema:
        raise RuntimeError("Could not find exercises table in training/public schemas")
    return schema


def detect_media_columns(db, schema: str) -> list[str]:
    query = text(
        """
        SELECT column_name
        FROM information_schema.columns
        WHERE table_schema = :schema
          AND table_name = 'exercises'
          AND column_name IN ('image_url', 'thumbnail_url', 'anatomy_image_url')
        ORDER BY CASE column_name
            WHEN 'image_url' THEN 1
            WHEN 'thumbnail_url' THEN 2
            WHEN 'anatomy_image_url' THEN 3
            ELSE 99
        END
        """
    )
    return [row[0] for row in db.execute(query, {"schema": schema}).all()]


@dataclass
class MigrationAudit:
    scanned_exercises: int = 0
    legacy_urls_found: int = 0
    updated_urls: int = 0
    missing_files: int = 0
    upload_errors: int = 0
    missing_details: List[str] = field(default_factory=list)
    error_details: List[str] = field(default_factory=list)


def migrate(apply_changes: bool) -> MigrationAudit:
    db = SessionLocal()
    audit = MigrationAudit()
    migrated_cache: Dict[str, str] = {}

    try:
        exercises_schema = detect_exercises_schema(db)
        media_columns = detect_media_columns(db, exercises_schema)

        if not media_columns:
            raise RuntimeError(
                f"No media columns found in {exercises_schema}.exercises (expected one of {', '.join(MEDIA_COLUMNS)})"
            )

        select_columns_sql = ", ".join(["id"] + media_columns)
        rows = db.execute(
            text(
                f"""
                SELECT {select_columns_sql}
                FROM {exercises_schema}.exercises
                """
            )
        ).mappings().all()
        audit.scanned_exercises = len(rows)

        for row in rows:
            exercise_id = str(row["id"])
            for column in media_columns:
                current_url = row.get(column)
                if not is_legacy_static_exercise_url(current_url):
                    continue

                audit.legacy_urls_found += 1
                local_path = static_exercise_path_from_url(current_url)

                if not local_path.exists():
                    audit.missing_files += 1
                    audit.missing_details.append(
                        f"{exercise_id}::{column} -> missing file {local_path}"
                    )
                    continue

                if current_url in migrated_cache:
                    new_url = migrated_cache[current_url]
                elif apply_changes:
                    try:
                        new_url = upload_local_file_to_r2(
                            local_file_path=local_path,
                            exercise_id=exercise_id,
                            source_filename=local_path.name,
                        )
                        migrated_cache[current_url] = new_url
                    except StorageError as exc:
                        audit.upload_errors += 1
                        audit.error_details.append(
                            f"{exercise_id}::{column} -> {exc}"
                        )
                        continue
                else:
                    # dry-run placeholder URL to show deterministic change intent
                    new_url = f"<R2_UPLOAD:{local_path.name}>"

                if apply_changes:
                    db.execute(
                        text(
                            f"""
                            UPDATE {exercises_schema}.exercises
                            SET {column} = :new_url
                            WHERE id = :exercise_id
                            """
                        ),
                        {"new_url": new_url, "exercise_id": exercise_id},
                    )
                audit.updated_urls += 1

        if apply_changes:
            db.commit()
        else:
            db.rollback()
    finally:
        db.close()

    return audit


def print_audit(audit: MigrationAudit, apply_changes: bool) -> None:
    mode = "APPLY" if apply_changes else "DRY-RUN"
    print(f"\n=== Exercise Media Migration ({mode}) ===")
    print(f"Exercises scanned: {audit.scanned_exercises}")
    print(f"Legacy URLs found: {audit.legacy_urls_found}")
    print(f"URLs updated: {audit.updated_urls}")
    print(f"Missing files: {audit.missing_files}")
    print(f"Upload errors: {audit.upload_errors}")

    if audit.missing_details:
        print("\nMissing file details (first 20):")
        for line in audit.missing_details[:20]:
            print(f" - {line}")

    if audit.error_details:
        print("\nUpload error details (first 20):")
        for line in audit.error_details[:20]:
            print(f" - {line}")

    print("=== End Report ===\n")


def main() -> None:
    parser = argparse.ArgumentParser(description="Migrate /static exercise media URLs to R2")
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Apply migration updates. Without this flag runs dry-run only.",
    )
    args = parser.parse_args()

    audit = migrate(apply_changes=args.apply)
    print_audit(audit, apply_changes=args.apply)


if __name__ == "__main__":
    main()
