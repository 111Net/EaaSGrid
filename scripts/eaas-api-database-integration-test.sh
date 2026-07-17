#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_DIR="$PROJECT_ROOT/apps/api"
ENV_FILE="$PROJECT_ROOT/.env"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-api-database-integration-report.txt"

PASS=0
WARN=0
FAIL=0
API_PID=""

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

cleanup() {
  echo
  echo "[INFO] Cleaning up API integration test..."

  if [[ -n "${API_PID:-}" ]] && kill -0 "$API_PID" 2>/dev/null; then
    kill "$API_PID" 2>/dev/null || true
    wait "$API_PID" 2>/dev/null || true
  fi

  if [[ -f "$PROJECT_ROOT/.eaas-api-test.log" ]]; then
    rm -f "$PROJECT_ROOT/.eaas-api-test.log"
  fi

  echo "[PASS] API integration test cleanup completed"
}

trap cleanup EXIT

echo "=============================================="
echo " EaaSGrid API–Database Integration Test"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

echo "=============================================="
echo " 1. API Structure"
echo "=============================================="

if [[ -d "$API_DIR" ]]; then
  pass "API application directory detected"
else
  fail "API application directory missing"
  exit 1
fi

if [[ -f "$API_DIR/src/server.js" ]]; then
  pass "API server entrypoint detected"
else
  fail "API server entrypoint missing"
  exit 1
fi

if [[ -f "$API_DIR/package.json" ]]; then
  pass "API package configuration detected"
else
  fail "API package.json missing"
  exit 1
fi

echo
echo "=============================================="
echo " 2. Database Configuration"
echo "=============================================="

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

if [[ -n "${PGPASSWORD:-}" ]]; then
  pass "Database password loaded from .env"
else
  fail "Database password unavailable"
  exit 1
fi

if [[ -n "$(get_env_value PORT)" ]]; then
  API_PORT="$(get_env_value PORT)"
else
  API_PORT="4000"
fi

pass "API port configured: $API_PORT"

echo
echo "=============================================="
echo " 3. Direct Database Connectivity"
echo "=============================================="

if psql -v ON_ERROR_STOP=1 -c "SELECT 1;" >/dev/null 2>&1; then
  pass "API database environment can connect to PostgreSQL"
else
  fail "API database environment cannot connect to PostgreSQL"
  exit 1
fi

echo
echo "=============================================="
echo " 4. API Dependencies"
echo "=============================================="

API_NODE_MODULES="$(cd "$API_DIR" && npm root 2>/dev/null || true)"

if [[ -n "$API_NODE_MODULES" && -d "$API_NODE_MODULES" ]]; then
  REQUIRED_PACKAGES=(
    express
    cors
    dotenv
    express-validator
    joi
    pg
    ws
  )

  MISSING_PACKAGES=()

  for PACKAGE in "${REQUIRED_PACKAGES[@]}"; do
    if [[ ! -d "$API_NODE_MODULES/$PACKAGE" ]]; then
      MISSING_PACKAGES+=("$PACKAGE")
    fi
  done

  if [[ "${#MISSING_PACKAGES[@]}" -eq 0 ]]; then
    pass "API dependencies installed and resolvable from: $API_NODE_MODULES"
  else
    fail "Required API packages missing: ${MISSING_PACKAGES[*]}"
    exit 1
  fi
else
  fail "npm dependency root could not be resolved"
  exit 1
fi

echo
echo "=============================================="
echo " 5. API Syntax"
echo "=============================================="

if node --check "$API_DIR/src/server.js" >/dev/null 2>&1; then
  pass "API server syntax verified"
else
  fail "API server syntax check failed"
  exit 1
fi

echo
echo "=============================================="
echo " 6. API Startup"
echo "=============================================="

(
  cd "$API_DIR"
  node src/server.js
) > "$PROJECT_ROOT/.eaas-api-test.log" 2>&1 &

API_PID=$!

echo "[INFO] Waiting for API process and port ${API_PORT}..."

API_READY=0

for attempt in {1..20}; do

  if ! kill -0 "$API_PID" 2>/dev/null; then
    break
  fi

  if (echo >"/dev/tcp/127.0.0.1/${API_PORT}") >/dev/null 2>&1; then
    API_READY=1
    break
  fi

  sleep 1
done

if [[ "$API_READY" -eq 1 ]]; then
  pass "API process started and port ${API_PORT} is listening"
else
  fail "API failed to listen on port ${API_PORT}"
  cat "$PROJECT_ROOT/.eaas-api-test.log"
  exit 1
fi

echo
echo "=============================================="
echo " 7. API Health/Availability Endpoint"
echo "=============================================="

HEALTH_RESPONSE=""

for HEALTH_PATH in   "/health"   "/api/v1/health"   "/api/health"   "/api/v1/database"   "/database"
do

  RESPONSE="$(
    curl -fsS       --max-time 10       "http://127.0.0.1:${API_PORT}${HEALTH_PATH}"       2>/dev/null || true
  )"

  if [[ -n "$RESPONSE" ]]; then
    HEALTH_RESPONSE="$RESPONSE"
    HEALTH_ENDPOINT="$HEALTH_PATH"
    break
  fi

done

if [[ -n "$HEALTH_RESPONSE" ]]; then
  pass "API availability endpoint responded: ${HEALTH_ENDPOINT}"
else
  fail "No API availability endpoint responded"
fi

echo
echo "=============================================="
echo " 8. Database Endpoint"
echo "=============================================="

DATABASE_RESPONSE="$(
  curl -fsS \
    --max-time 10 \
    "http://127.0.0.1:${API_PORT}/api/v1/database" \
    2>/dev/null || true
)"

if [[ -n "$DATABASE_RESPONSE" ]]; then
  pass "API database endpoint responded"
else
  warn "API database endpoint did not return a response"
fi

echo
echo "=============================================="
echo " 9. Database Schema Query"
echo "=============================================="

TABLE_COUNT="$(
  psql -tA -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE';"
)"

if [[ "$TABLE_COUNT" -ge 9 ]]; then
  pass "API database schema is available: $TABLE_COUNT public tables"
else
  fail "Unexpected database schema table count: $TABLE_COUNT"
fi

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="

echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"

{
  echo "EaaSGrid API–Database Integration Test Report"
  echo "=============================================="
  echo "Project: $PROJECT_ROOT"
  echo "Started: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Database User: $PGUSER"
  echo "API Port: $API_PORT"
  echo
  echo "Health Response:"
  echo "$HEALTH_RESPONSE"
  echo
  echo "Database Response:"
  echo "$DATABASE_RESPONSE"
  echo
  echo "Public Tables: $TABLE_COUNT"
  echo
  echo "PASS: $PASS"
  echo "WARN: $WARN"
  echo "FAIL: $FAIL"
} > "$REPORT_FILE"

echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "API–DATABASE INTEGRATION TEST: PASS"
  exit 0
else
  echo
  echo "API–DATABASE INTEGRATION TEST: FAIL"
  exit 1
fi
