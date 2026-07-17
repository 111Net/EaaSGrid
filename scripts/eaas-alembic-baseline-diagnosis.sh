#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
MIGRATION_FILE="$PROJECT_ROOT/database/migrations/001_initial_schema.sql"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-alembic-baseline-diagnosis-report.txt"

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
echo " EaaSGrid Automated Alembic Baseline Diagnosis"
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

if [[ ! -f "$MIGRATION_FILE" ]]; then
  fail "Initial migration file not found"
  exit 1
fi

pass "Initial migration file found"

echo
echo "=== ALEMBIC REVISION REFERENCES IN SQL ==="

REVISION_REFERENCES="$(
  grep -Ein \
    '(revision|down_revision|alembic_version)' \
    "$MIGRATION_FILE" \
    || true
)"

if [[ -n "$REVISION_REFERENCES" ]]; then
  echo "$REVISION_REFERENCES"
  pass "Alembic revision references found in migration file"
else
  warn "No explicit Alembic revision metadata found in migration file"
fi

echo
echo "=== CURRENT DATABASE ALEMBIC VERSION ==="

ALEMBIC_TABLE_EXISTS="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT to_regclass('public.alembic_version');"
)"

if [[ "$ALEMBIC_TABLE_EXISTS" == "public.alembic_version" ]]; then

  pass "Database alembic_version table exists"

  ALEMBIC_VERSION="$(
    psql -tA -v ON_ERROR_STOP=1 \
      -c "SELECT version_num
          FROM public.alembic_version
          LIMIT 1;"
  )"

  if [[ -n "$ALEMBIC_VERSION" ]]; then
    pass "Database Alembic version found: $ALEMBIC_VERSION"
  else
    warn "Alembic version table exists but contains no revision"
  fi

else
  fail "Database alembic_version table not found"
fi

echo
echo "=== DATABASE SCHEMA OBJECT COUNT ==="

TABLE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE';"
)"

INDEX_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM pg_indexes
        WHERE schemaname = 'public';"
)"

echo "Public tables: $TABLE_COUNT"
echo "Public indexes: $INDEX_COUNT"

if [[ "$TABLE_COUNT" -ge 9 ]]; then
  pass "Expected application schema is present"
else
  warn "Fewer than 9 public tables detected"
fi

{
  echo "EaaSGrid Alembic Baseline Diagnosis"
  echo "===================================="
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Migration file: $MIGRATION_FILE"
  echo
  echo "Alembic table: $ALEMBIC_TABLE_EXISTS"
  echo "Current Alembic version: ${ALEMBIC_VERSION:-NONE}"
  echo "Public tables: $TABLE_COUNT"
  echo "Public indexes: $INDEX_COUNT"
  echo
  echo "Revision references:"
  echo "$REVISION_REFERENCES"
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
echo
echo "No database changes were made."

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "ALEMBIC BASELINE DIAGNOSIS: COMPLETE"
  exit 0
else
  echo
  echo "ALEMBIC BASELINE DIAGNOSIS: BLOCKED"
  exit 1
fi
