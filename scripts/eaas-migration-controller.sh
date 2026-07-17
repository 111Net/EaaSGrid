#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
MIGRATION_DIR="$PROJECT_ROOT/database/migrations"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-controller-report.txt"
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
echo " EaaSGrid Automated Migration Controller"
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

export PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD

echo "Configuration:"
echo "  Host:     $PGHOST"
echo "  Port:     $PGPORT"
echo "  Database: $PGDATABASE"
echo "  User:     $PGUSER"
echo "  Password: [loaded from .env]"
echo

if ! systemctl is-active --quiet postgresql; then
  echo "[INFO] PostgreSQL is not running. Starting service..."
  sudo systemctl start postgresql
fi

if systemctl is-active --quiet postgresql; then
  pass "PostgreSQL service is running"
else
  fail "PostgreSQL service unavailable"
  exit 1
fi

if psql -v ON_ERROR_STOP=1 -c "SELECT 1;" >/dev/null; then
  pass "Application database connection successful"
else
  fail "Application database connection failed"
  exit 1
fi

if [[ ! -d "$MIGRATION_DIR" ]]; then
  fail "Migration directory not found"
  exit 1
fi

pass "Migration directory detected"

mapfile -t MIGRATIONS < <(
  find "$MIGRATION_DIR" \
    -maxdepth 1 \
    -type f \
    -name "*.sql" \
    -printf "%f\n" \
    | sort -V
)

if [[ "${#MIGRATIONS[@]}" -eq 0 ]]; then
  warn "No SQL migrations found"
else
  pass "${#MIGRATIONS[@]} SQL migration(s) detected"
fi

BASELINE_TABLE_EXISTS="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT EXISTS (
          SELECT 1
          FROM information_schema.tables
          WHERE table_schema = 'public'
          AND table_name = 'eaasgrid_migration_baseline'
        );"
)"

if [[ "$BASELINE_TABLE_EXISTS" != "t" ]]; then
  fail "Migration baseline registry not found"
  exit 1
fi

pass "Migration baseline registry verified"

MIGRATION_HISTORY_EXISTS="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT EXISTS (
          SELECT 1
          FROM information_schema.tables
          WHERE table_schema = 'public'
          AND table_name = 'eaasgrid_migration_history'
        );"
)"

if [[ "$MIGRATION_HISTORY_EXISTS" != "t" ]]; then

  psql -v ON_ERROR_STOP=1 <<'SQL'
CREATE TABLE public.eaasgrid_migration_history (
    id BIGSERIAL PRIMARY KEY,
    migration_name TEXT NOT NULL UNIQUE,
    checksum TEXT NOT NULL,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
SQL

  pass "Migration history registry created"

else

pass "Migration history registry verified"
fi

echo
echo "=============================================="
echo " Creating Pre-Migration Backup"
echo "=============================================="

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/${PGDATABASE}_pre_controller_$(date +%Y%m%d_%H%M%S).sql"

if pg_dump \
  --no-owner \
  --no-privileges \
  > "$BACKUP_FILE"; then
  pass "Pre-migration backup created"
else
  fail "Pre-migration backup failed"
  exit 1
fi

echo
echo "=============================================="
echo " Processing Migration Files"
echo "=============================================="

APPLIED=0
SKIPPED=0
NEW=0

for migration_name in "${MIGRATIONS[@]}"; do

  migration_path="$MIGRATION_DIR/$migration_name"
  checksum="$(sha256sum "$migration_path" | awk '{print $1}')"

  baseline_checksum="$(
    psql -tA -v ON_ERROR_STOP=1 \
      -c "SELECT migration_checksum
          FROM public.eaasgrid_migration_baseline
          WHERE migration_file = '$migration_path'
          LIMIT 1;"
  )"

  history_checksum="$(
    psql -tA -v ON_ERROR_STOP=1 \
      -c "SELECT checksum
          FROM public.eaasgrid_migration_history
          WHERE migration_name = '$migration_name'
          LIMIT 1;"
  )"

  if [[ -n "$history_checksum" ]]; then

    if [[ "$history_checksum" == "$checksum" ]]; then
      echo "[SKIP] $migration_name already applied"
      SKIPPED=$((SKIPPED + 1))
      continue
    else
      fail "Checksum changed for applied migration: $migration_name"
      exit 1
    fi

  fi

  if [[ "$migration_name" == "001_initial_schema.sql" &&
        "$baseline_checksum" == "$checksum" ]]; then

    psql -v ON_ERROR_STOP=1 \
      -c "INSERT INTO public.eaasgrid_migration_history
          (migration_name, checksum)
          VALUES
          ('$migration_name', '$checksum');"

    pass "Baseline migration recorded: $migration_name"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  echo "[INFO] Applying new migration: $migration_name"

  if psql \
    -v ON_ERROR_STOP=1 \
    -1 \
    -f "$migration_path"; then

    psql -v ON_ERROR_STOP=1 \
      -c "INSERT INTO public.eaasgrid_migration_history
          (migration_name, checksum)
          VALUES
          ('$migration_name', '$checksum');"

    pass "Migration applied: $migration_name"
    APPLIED=$((APPLIED + 1))
    NEW=$((NEW + 1))

  else

    fail "Migration failed: $migration_name"
    exit 1

  fi

done

echo
echo "=============================================="
echo " Post-Migration Verification"
echo "=============================================="

TABLE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE';"
)"

HISTORY_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM public.eaasgrid_migration_history;"
)"

if [[ "$TABLE_COUNT" -ge 9 ]]; then
  pass "Schema verification successful: $TABLE_COUNT public tables"
else
  fail "Unexpected schema table count: $TABLE_COUNT"
fi

if [[ "$HISTORY_COUNT" -ge 1 ]]; then
  pass "Migration history verified: $HISTORY_COUNT record(s)"
else
  fail "Migration history is empty"
fi

{
  echo "EaaSGrid Migration Controller Report"
  echo "===================================="
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Migration directory: $MIGRATION_DIR"
  echo "Backup: $BACKUP_FILE"
  echo
  echo "Migration files detected: ${#MIGRATIONS[@]}"
  echo "Applied: $APPLIED"
  echo "Skipped: $SKIPPED"
  echo "New migrations: $NEW"
  echo "Public tables: $TABLE_COUNT"
  echo "Migration history records: $HISTORY_COUNT"
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
echo "Applied: $APPLIED"
echo "Skipped: $SKIPPED"
echo "Backup: $BACKUP_FILE"
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION CONTROLLER STATUS: PASS"
  exit 0
else
  echo
  echo "MIGRATION CONTROLLER STATUS: FAIL"
  exit 1
fi
