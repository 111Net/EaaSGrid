#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-sql-migration-run-report.txt"
BACKUP_DIR="$PROJECT_ROOT/backups/database"

PASS=0
WARN=0
FAIL=0

pass() {
  echo "[PASS] $1"
  PASS=$((PASS + 1))
}

warn() {
  echo "[WARN] $1"
  WARN=$((WARN + 1))
}

fail() {
  echo "[FAIL] $1"
  FAIL=$((FAIL + 1))
}

get_env_value() {
  local key="$1"

  grep -E "^${key}=" "$ENV_FILE" 2>/dev/null \
    | head -n 1 \
    | sed "s/^${key}=//" \
    | sed 's/^"//; s/"$//' \
    | sed "s/^'//; s/'$//"
}

echo "=============================================="
echo " EaaSGrid Automated SQL Migration Runner"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

if [[ ! -f "$ENV_FILE" ]]; then
  fail ".env file not found"
  exit 1
fi

PGHOST="$(get_env_value PGHOST)"
PGPORT="$(get_env_value PGPORT)"
PGDATABASE="$(get_env_value PGDATABASE)"
PGUSER="$(get_env_value PGUSER)"
PGPASSWORD="$(get_env_value PGPASSWORD)"

PGHOST="${PGHOST:-127.0.0.1}"
PGPORT="${PGPORT:-5432}"
PGDATABASE="${PGDATABASE:-eaas_db}"
PGUSER="${PGUSER:-eaas_user}"

if [[ -z "$PGPASSWORD" ]]; then
  fail "PGPASSWORD missing from .env"
  exit 1
fi

export PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD

if ! systemctl is-active --quiet postgresql; then
  echo "[INFO] Starting PostgreSQL..."
  sudo systemctl start postgresql
fi

if systemctl is-active --quiet postgresql; then
  pass "PostgreSQL service is running"
else
  fail "PostgreSQL service unavailable"
  exit 1
fi

if ! psql -v ON_ERROR_STOP=1 -c "SELECT 1;" >/dev/null; then
  fail "Database connection failed"
  exit 1
fi

pass "Database connection verified"

MIGRATION_DIR="$(
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type d -iname "migrations" \
    -print -quit
)"

if [[ -z "$MIGRATION_DIR" ]]; then
  fail "Migration directory not found"
  exit 1
fi

pass "Migration directory detected: $MIGRATION_DIR"

mapfile -t MIGRATION_FILES < <(
  find "$MIGRATION_DIR" \
    -maxdepth 1 \
    -type f \
    -iname "*.sql" \
    -printf "%f\n" \
    | sort
)

if [[ "${#MIGRATION_FILES[@]}" -eq 0 ]]; then
  fail "No SQL migration files found"
  exit 1
fi

pass "${#MIGRATION_FILES[@]} SQL migration files detected"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/${PGDATABASE}_pre_migration_$(date +%Y%m%d_%H%M%S).sql"

echo "[INFO] Creating pre-migration backup..."

if pg_dump \
  --no-owner \
  --no-privileges \
  > "$BACKUP_FILE"; then
  pass "Pre-migration database backup created"
else
  fail "Database backup failed"
  exit 1
fi

echo "[INFO] Verifying migration tracking table..."

psql -v ON_ERROR_STOP=1 <<'SQL'
CREATE TABLE IF NOT EXISTS public.eaasgrid_schema_migrations (
    id BIGSERIAL PRIMARY KEY,
    migration_name TEXT NOT NULL UNIQUE,
    checksum TEXT NOT NULL,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
SQL

pass "Migration tracking table verified"

APPLIED_COUNT=0
PENDING_COUNT=0

for migration_name in "${MIGRATION_FILES[@]}"; do

  migration_path="$MIGRATION_DIR/$migration_name"
  checksum="$(sha256sum "$migration_path" | awk '{print $1}')"

  applied_checksum="$(
    psql -tA -v ON_ERROR_STOP=1 \
      -c "SELECT checksum
          FROM public.eaasgrid_schema_migrations
          WHERE migration_name = '$migration_name'
          LIMIT 1;"
  )"

  if [[ -n "$applied_checksum" ]]; then

    if [[ "$applied_checksum" == "$checksum" ]]; then
      echo "[SKIP] $migration_name already applied"
      APPLIED_COUNT=$((APPLIED_COUNT + 1))
      continue
    else
      fail "Checksum changed for already-applied migration: $migration_name"
      exit 1
    fi
  fi

  echo "[INFO] Applying migration: $migration_name"

  if psql \
    -v ON_ERROR_STOP=1 \
    -v migration_name="$migration_name" \
    -v checksum="$checksum" \
    -1 \
    -f "$migration_path" && \
    psql \
      -v ON_ERROR_STOP=1 \
      -c "INSERT INTO public.eaasgrid_schema_migrations
           (migration_name, checksum)
           VALUES ('$migration_name', '$checksum');"; then

    pass "Migration applied: $migration_name"
    PENDING_COUNT=$((PENDING_COUNT + 1))

  else
    fail "Migration failed: $migration_name"
    exit 1
  fi

done

echo
echo "[INFO] Running post-migration verification..."

TABLE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema NOT IN ('pg_catalog', 'information_schema');"
)"

MIGRATION_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM public.eaasgrid_schema_migrations;"
)"

if [[ "$TABLE_COUNT" =~ ^[0-9]+$ ]]; then
  pass "Schema verification completed: $TABLE_COUNT application tables"
else
  fail "Schema verification failed"
fi

if [[ "$MIGRATION_COUNT" =~ ^[0-9]+$ ]]; then
  pass "Migration history verified: $MIGRATION_COUNT migrations recorded"
else
  fail "Migration history verification failed"
fi

{
  echo "EaaSGrid SQL Migration Run Report"
  echo "================================="
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Host: $PGHOST"
  echo "Port: $PGPORT"
  echo "User: $PGUSER"
  echo "Migration directory: $MIGRATION_DIR"
  echo "Backup: $BACKUP_FILE"
  echo
  echo "Migration files: ${#MIGRATION_FILES[@]}"
  echo "Previously applied: $APPLIED_COUNT"
  echo "Applied this run: $PENDING_COUNT"
  echo "Application tables: $TABLE_COUNT"
  echo "Recorded migrations: $MIGRATION_COUNT"
  echo
  echo "PASS: $PASS"
  echo "WARN: $WARN"
  echo "FAIL: $FAIL"
} > "$REPORT_FILE"

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo "Previously applied: $APPLIED_COUNT"
echo "Applied this run: $PENDING_COUNT"
echo "Backup: $BACKUP_FILE"
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "SQL MIGRATION STATUS: PASS"
  exit 0
else
  echo
  echo "SQL MIGRATION STATUS: FAIL"
  exit 1
fi
