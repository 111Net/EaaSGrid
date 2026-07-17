#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
MIGRATION_FILE="$PROJECT_ROOT/database/migrations/001_initial_schema.sql"

get_env_value() {
  local key="$1"

  grep -E "^${key}=" "$ENV_FILE" 2>/dev/null \
    | head -n 1 \
    | sed "s/^${key}=//" \
    | sed 's/^"//; s/"$//' \
    | sed "s/^'//; s/'$//"
}

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

MIGRATION_CHECKSUM="$(sha256sum "$MIGRATION_FILE" | awk '{print $1}')"

CURRENT_VERSION="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT version_num
        FROM public.alembic_version
        LIMIT 1;"
)"

echo "=============================================="
echo " EaaSGrid Automated Baseline Repair"
echo "=============================================="
echo "Database: $PGDATABASE"
echo "Alembic revision: $CURRENT_VERSION"
echo

BASELINE_EXISTS="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM public.eaasgrid_migration_baseline
        WHERE migration_file = '$MIGRATION_FILE';"
)"

if [[ "$BASELINE_EXISTS" -gt 0 ]]; then
  echo "[PASS] Baseline already exists"
else

  psql -v ON_ERROR_STOP=1 \
    -c "INSERT INTO public.eaasgrid_migration_baseline
        (
          migration_file,
          migration_checksum,
          alembic_revision
        )
        VALUES
        (
          '$MIGRATION_FILE',
          '$MIGRATION_CHECKSUM',
          '$CURRENT_VERSION'
        );"

  echo "[PASS] Initial schema baseline recorded"
fi

VERIFY_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM public.eaasgrid_migration_baseline
        WHERE migration_file = '$MIGRATION_FILE'
        AND migration_checksum = '$MIGRATION_CHECKSUM'
        AND alembic_revision = '$CURRENT_VERSION';"
)"

if [[ "$VERIFY_COUNT" -eq 1 ]]; then
  echo "[PASS] Baseline record verified"
else
  echo "[FAIL] Baseline verification failed"
  exit 1
fi

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "BASELINE REPAIR STATUS: PASS"
echo "No migration was replayed."
echo "No existing schema was modified."
