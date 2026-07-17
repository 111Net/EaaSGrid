#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MIGRATION_DIR="$PROJECT_ROOT/database/migrations"
CONTROLLER="$PROJECT_ROOT/scripts/eaas-migration-controller.sh"
ENV_FILE="$PROJECT_ROOT/.env"

get_env_value() {
  local key="$1"

  grep -E "^${key}=" "$ENV_FILE" 2>/dev/null     | head -n 1     | sed "s/^${key}=//"     | sed 's/^"//; s/"$//'     | sed "s/^'//; s/'$//"
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

TEST_MIGRATION="$MIGRATION_DIR/999_test_controller_migration.sql"
TEST_TABLE="eaasgrid_migration_controller_test"

PASS=0
FAIL=0

pass() {
  echo "[PASS] $1"
  PASS=$((PASS + 1))
}

fail() {
  echo "[FAIL] $1"
  FAIL=$((FAIL + 1))
}

cleanup() {
  echo
  echo "[INFO] Cleaning up migration controller test..."

  psql -v ON_ERROR_STOP=1 \
    -c "DROP TABLE IF EXISTS public.$TEST_TABLE CASCADE;" \
    >/dev/null 2>&1 || true

  psql -v ON_ERROR_STOP=1 \
    -c "DELETE FROM public.eaasgrid_migration_history
        WHERE migration_name = '999_test_controller_migration.sql';" \
    >/dev/null 2>&1 || true

  rm -f "$TEST_MIGRATION"

  echo "[PASS] Test cleanup completed"
}

trap cleanup EXIT

echo "=============================================="
echo " EaaSGrid Migration Controller End-to-End Test"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

if [[ ! -x "$CONTROLLER" ]]; then
  fail "Migration controller is not executable"
  exit 1
fi

pass "Migration controller detected"

if [[ -f "$TEST_MIGRATION" ]]; then
  fail "Test migration already exists"
  exit 1
fi

cat > "$TEST_MIGRATION" <<SQL
CREATE TABLE public.$TEST_TABLE (
    id BIGSERIAL PRIMARY KEY,
    test_value TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
SQL

pass "Temporary test migration created"

echo
echo "=============================================="
echo " TEST RUN 1: APPLY NEW MIGRATION"
echo "=============================================="

if "$CONTROLLER"; then
  pass "Migration controller completed successfully"
else
  fail "Migration controller failed on new migration"
  exit 1
fi

TABLE_EXISTS="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT EXISTS (
          SELECT 1
          FROM information_schema.tables
          WHERE table_schema = 'public'
          AND table_name = '$TEST_TABLE'
        );"
)"

if [[ "$TABLE_EXISTS" == "t" ]]; then
  pass "Temporary migration created the test table"
else
  fail "Test table was not created"
  exit 1
fi

HISTORY_EXISTS="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT EXISTS (
          SELECT 1
          FROM public.eaasgrid_migration_history
          WHERE migration_name = '999_test_controller_migration.sql'
        );"
)"

if [[ "$HISTORY_EXISTS" == "t" ]]; then
  pass "Migration was recorded in migration history"
else
  fail "Migration was not recorded"
  exit 1
fi

echo
echo "=============================================="
echo " TEST RUN 2: VERIFY IDEMPOTENCY"
echo "=============================================="

if "$CONTROLLER"; then
  pass "Second controller execution completed successfully"
else
  fail "Second controller execution failed"
  exit 1
fi

TABLE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = '$TEST_TABLE';"
)"

if [[ "$TABLE_COUNT" == "1" ]]; then
  pass "Already-applied migration was not replayed"
else
  fail "Test table state is incorrect"
  exit 1
fi

echo
echo "=============================================="
echo " FINAL TEST RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "FAIL: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION CONTROLLER END-TO-END TEST: PASS"
  exit 0
else
  echo
  echo "MIGRATION CONTROLLER END-TO-END TEST: FAIL"
  exit 1
fi
