#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-readiness-report.txt"

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
echo " EaaSGrid Automated Migration Readiness"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

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

MIGRATION_DIR="$PROJECT_ROOT/database/migrations"

if [[ ! -d "$MIGRATION_DIR" ]]; then
  fail "Migration directory not found"
  exit 1
fi

mapfile -t MIGRATIONS < <(
  find "$MIGRATION_DIR" \
    -maxdepth 1 \
    -type f \
    -name "*.sql" \
    -printf "%f\n" \
    | sort
)

if [[ "${#MIGRATIONS[@]}" -eq 0 ]]; then
  fail "No migration files found"
  exit 1
fi

pass "${#MIGRATIONS[@]} migration file(s) detected"

echo
echo "Migration files:"
printf '  - %s\n' "${MIGRATIONS[@]}"

TABLE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema NOT IN ('pg_catalog', 'information_schema');"
)"

pass "Current database contains $TABLE_COUNT application table(s)"

if psql -tA -v ON_ERROR_STOP=1 \
  -c "SELECT to_regclass('public.eaasgrid_schema_migrations');" \
  | grep -q "eaasgrid_schema_migrations"; then

  pass "Migration tracking table exists"

  APPLIED_COUNT="$(
    psql -tA -v ON_ERROR_STOP=1 \
      -c "SELECT COUNT(*) FROM public.eaasgrid_schema_migrations;"
  )"

  echo "Applied migration records: $APPLIED_COUNT"

else
  warn "Migration tracking table does not yet exist"
  APPLIED_COUNT=0
fi

INITIAL_MIGRATION="$MIGRATION_DIR/001_initial_schema.sql"

if [[ -f "$INITIAL_MIGRATION" ]]; then
  pass "Initial migration file found"

  echo
  echo "=== INITIAL MIGRATION OBJECTS ==="

  grep -E \
    '^[[:space:]]*(CREATE TABLE|CREATE TYPE|CREATE INDEX|ALTER TABLE)' \
    "$INITIAL_MIGRATION" \
    | sed 's/^[[:space:]]*/  /' \
    || true

  INITIAL_TABLE_COUNT="$(
    grep -Ec \
      '^[[:space:]]*CREATE TABLE' \
      "$INITIAL_MIGRATION" || true
  )"

  echo
  echo "Tables defined by initial migration: $INITIAL_TABLE_COUNT"

  if [[ "$TABLE_COUNT" -eq 0 ]]; then
    pass "Database appears empty and is ready for initial migration"
  else
    warn "Database already contains application tables"
    warn "Initial migration should not be blindly replayed"
  fi

else
  fail "Initial migration file not found"
fi

{
  echo "EaaSGrid Migration Readiness Report"
  echo "==================================="
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Migration directory: $MIGRATION_DIR"
  echo "Migration files: ${#MIGRATIONS[@]}"
  echo "Current application tables: $TABLE_COUNT"
  echo "Applied migration records: $APPLIED_COUNT"
  echo
  echo "Migration files:"
  printf '%s\n' "${MIGRATIONS[@]}"
  echo
  echo "Initial migration table definitions: $INITIAL_TABLE_COUNT"
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
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION READINESS STATUS: COMPLETE"
  exit 0
else
  echo
  echo "MIGRATION READINESS STATUS: BLOCKED"
  exit 1
fi
