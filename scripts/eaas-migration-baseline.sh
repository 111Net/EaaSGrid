#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
MIGRATION_FILE="$PROJECT_ROOT/database/migrations/001_initial_schema.sql"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-baseline-report.txt"
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
echo " EaaSGrid Automated Migration Baseline"
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
echo "[INFO] Creating safety backup..."

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/${PGDATABASE}_pre_baseline_$(date +%Y%m%d_%H%M%S).sql"

if pg_dump \
  --no-owner \
  --no-privileges \
  > "$BACKUP_FILE"; then
  pass "Database backup created"
else
  fail "Database backup failed"
  exit 1
fi

echo
echo "[INFO] Verifying existing schema..."

EXPECTED_TABLES=(
  alembic_version
  clients
  devices
  energy_usage
  ledger_accounts
  ledger_entries
  providers
  transactions
  wallets
)

for table in "${EXPECTED_TABLES[@]}"; do
  if psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT 1
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = '$table';" \
    | grep -q '^1$'; then

    pass "Table verified: $table"
  else
    fail "Required table missing: $table"
  fi
done

if [[ "$FAIL" -gt 0 ]]; then
  echo
  echo "Baseline aborted because schema verification failed."
  exit 1
fi

MIGRATION_CHECKSUM="$(sha256sum "$MIGRATION_FILE" | awk '{print $1}')"

pass "Initial migration checksum calculated"

echo
echo "[INFO] Reading existing Alembic version..."

CURRENT_VERSION="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT version_num
        FROM public.alembic_version
        LIMIT 1;"
)"

if [[ -n "$CURRENT_VERSION" ]]; then
  pass "Existing Alembic version found: $CURRENT_VERSION"
else
  warn "Alembic version table is empty"
fi

echo
echo "[INFO] Creating EaaSGrid migration baseline registry..."

psql -v ON_ERROR_STOP=1 \
  -v migration_checksum="$MIGRATION_CHECKSUM" \
  -v migration_file="$MIGRATION_FILE" <<'SQL'
CREATE TABLE IF NOT EXISTS public.eaasgrid_migration_baseline (
    id BIGSERIAL PRIMARY KEY,
    migration_file TEXT NOT NULL UNIQUE,
    migration_checksum TEXT NOT NULL,
    alembic_revision TEXT,
    baseline_created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
SQL

pass "Baseline registry verified"

EXISTING_BASELINE="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT migration_file
        FROM public.eaasgrid_migration_baseline
        WHERE migration_file = '$MIGRATION_FILE'
        LIMIT 1;"
)"

if [[ -n "$EXISTING_BASELINE" ]]; then

  pass "Existing baseline record found"

else

  psql -v ON_ERROR_STOP=1 \
    -v migration_file="$MIGRATION_FILE" \
    -v migration_checksum="$MIGRATION_CHECKSUM" \
    -v alembic_revision="$CURRENT_VERSION" \
    -c "INSERT INTO public.eaasgrid_migration_baseline
        (
          migration_file,
          migration_checksum,
          alembic_revision
        )
        VALUES
        (
          :'migration_file',
          :'migration_checksum',
          NULLIF(:'alembic_revision', '')
        );"

  pass "Initial schema baseline recorded"
fi

BASELINE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM public.eaasgrid_migration_baseline;"
)"

if [[ "$BASELINE_COUNT" -ge 1 ]]; then
  pass "Baseline verification completed"
else
  fail "Baseline verification failed"
fi

{
  echo "EaaSGrid Migration Baseline Report"
  echo "==================================="
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Migration file: $MIGRATION_FILE"
  echo "Migration checksum: $MIGRATION_CHECKSUM"
  echo "Current Alembic version: ${CURRENT_VERSION:-NONE}"
  echo "Backup: $BACKUP_FILE"
  echo "Baseline records: $BASELINE_COUNT"
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
echo "Backup: $BACKUP_FILE"
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION BASELINE STATUS: PASS"
  echo "Existing schema was baselined."
  echo "No initial migration was replayed."
  exit 0
else
  echo
  echo "MIGRATION BASELINE STATUS: FAIL"
  exit 1
fi
