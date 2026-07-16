#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=============================================="
echo "EAASGRID AUTOMATED QA"
echo "=============================================="
echo "Repository: $ROOT_DIR"
echo

FAIL=0

check_file() {
  local file="$1"

  if [ -f "$ROOT_DIR/$file" ]; then
    echo "[PASS] $file"
  else
    echo "[FAIL] Missing: $file"
    FAIL=$((FAIL + 1))
  fi
}

check_command() {
  local command="$1"

  if command -v "$command" >/dev/null 2>&1; then
    echo "[PASS] Command available: $command"
  else
    echo "[FAIL] Command unavailable: $command"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== 1. REQUIRED DATABASE ARTIFACTS ==="

check_file "database/schema.sql"
check_file "database/seed.sql"
check_file "database/migrations/001_initial_schema.sql"

echo
echo "=== 2. LEGACY SNAPSHOT ARTIFACTS ==="

check_file "database/legacy-snapshot/eaas_db-schema.sql"
check_file "database/legacy-snapshot/eaas_db-data.sql"
check_file "database/legacy-snapshot/eaas_db-full.dump"

echo
echo "=== 3. REQUIRED APPLICATION DIRECTORIES ==="

check_file "apps/api/package.json"
check_file "apps/dashboard/package.json"
check_file "apps/investor-portal/package.json"

echo
echo "=== 4. REQUIRED BUILD TOOLS ==="

check_command "node"
check_command "npm"
check_command "psql"
check_command "createdb"
check_command "sha256sum"

echo
echo "=== 5. POSTGRESQL AVAILABILITY ==="

if pg_isready >/dev/null 2>&1; then
  echo "[PASS] PostgreSQL is accepting connections"
else
  echo "[FAIL] PostgreSQL is unavailable"
  FAIL=$((FAIL + 1))
fi

echo
echo "=== 6. SQL FILE VALIDATION ==="

for sql_file in \
  "$ROOT_DIR/database/schema.sql" \
  "$ROOT_DIR/database/migrations/001_initial_schema.sql"
do
  if [ -s "$sql_file" ]; then
    echo "[PASS] $(basename "$sql_file") is non-empty"
  else
    echo "[FAIL] $(basename "$sql_file") is empty"
    FAIL=$((FAIL + 1))
  fi
done

if [ -s "$ROOT_DIR/database/seed.sql" ]; then
  echo "[PASS] seed.sql is non-empty"
else
  echo "[INFO] seed.sql is currently empty; legacy data snapshot is the migration data source"
fi

echo
echo "=============================================="
echo "EAASGRID AUTOMATED QA RESULT"
echo "=============================================="

if [ "$FAIL" -eq 0 ]; then
  echo "QA_STATUS=PASS"
  exit 0
else
  echo "QA_STATUS=FAIL"
  echo "FAIL_COUNT=$FAIL"
  exit 1
fi
