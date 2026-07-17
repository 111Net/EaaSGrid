#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-database-verification-report.txt"

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

get_env_value() {
  local key="$1"

  grep -E "^${key}=" "$ENV_FILE" 2>/dev/null \
    | head -n 1 \
    | sed "s/^${key}=//" \
    | sed 's/^"//; s/"$//' \
    | sed "s/^'//; s/'$//"
}

echo "=============================================="
echo " EaaSGrid Automated Database Bootstrap"
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
  fail "PGPASSWORD is missing from .env"
  exit 1
fi

export PGHOST PGPORT PGDATABASE PGUSER PGPASSWORD

echo "Configuration:"
echo "  Host:     $PGHOST"
echo "  Port:     $PGPORT"
echo "  Database: $PGDATABASE"
echo "  User:     $PGUSER"
echo "  Password: [loaded from .env]"
echo

if systemctl is-active --quiet postgresql; then
  pass "PostgreSQL service is running"
else
  echo "[INFO] PostgreSQL is not running. Attempting to start it..."
  sudo systemctl start postgresql

  if systemctl is-active --quiet postgresql; then
    pass "PostgreSQL service started"
  else
    fail "Unable to start PostgreSQL"
    exit 1
  fi
fi

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname='$PGUSER'" | grep -q 1; then
  pass "PostgreSQL role '$PGUSER' exists"
else
  echo "[INFO] Creating PostgreSQL role '$PGUSER'..."
  sudo -u postgres psql -v ON_ERROR_STOP=1 \
    -c "CREATE ROLE \"$PGUSER\" LOGIN PASSWORD '$PGPASSWORD';"
  pass "PostgreSQL role '$PGUSER' created"
fi

sudo -u postgres psql -v ON_ERROR_STOP=1 \
  -c "ALTER ROLE \"$PGUSER\" WITH LOGIN PASSWORD '$PGPASSWORD';" >/dev/null

pass "PostgreSQL role password synchronized from .env"

if sudo -u postgres psql -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$PGDATABASE'" | grep -q 1; then
  pass "Database '$PGDATABASE' exists"
else
  echo "[INFO] Creating database '$PGDATABASE'..."
  sudo -u postgres createdb -O "$PGUSER" "$PGDATABASE"
  pass "Database '$PGDATABASE' created"
fi

sudo -u postgres psql -v ON_ERROR_STOP=1 \
  -c "ALTER DATABASE \"$PGDATABASE\" OWNER TO \"$PGUSER\";" >/dev/null

pass "Database ownership verified"

if PGPASSWORD="$PGPASSWORD" psql \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -v ON_ERROR_STOP=1 \
  -c "SELECT current_user, current_database();" >/dev/null; then
  pass "Application database connection successful"
else
  fail "Application database connection failed"
  exit 1
fi

echo
echo "=============================================="
echo " Running Database Schema Audit"
echo "=============================================="

{
  echo "EaaSGrid Automated Database Verification Report"
  echo "=============================================="
  echo "Timestamp: $(date)"
  echo

  echo "=== CONNECTION ==="
  psql -v ON_ERROR_STOP=1 -c \
    "SELECT current_user, current_database(), version();"

  echo
  echo "=== SCHEMAS ==="
  psql -v ON_ERROR_STOP=1 -c \
    "SELECT schema_name
     FROM information_schema.schemata
     WHERE schema_name NOT IN ('pg_catalog', 'information_schema')
     ORDER BY schema_name;"

  echo
  echo "=== TABLES ==="
  psql -v ON_ERROR_STOP=1 -c \
    "SELECT table_schema, table_name
     FROM information_schema.tables
     WHERE table_schema NOT IN ('pg_catalog', 'information_schema')
     ORDER BY table_schema, table_name;"

  echo
  echo "=== TABLE ROW COUNTS ==="
  psql -v ON_ERROR_STOP=1 -c \
    "SELECT schemaname, relname AS table_name, n_live_tup AS estimated_rows
     FROM pg_stat_user_tables
     ORDER BY schemaname, relname;"

} > "$REPORT_FILE"

pass "Database audit report generated"

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "FAIL: $FAIL"
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "DATABASE BOOTSTRAP STATUS: PASS"
  exit 0
else
  echo
  echo "DATABASE BOOTSTRAP STATUS: FAIL"
  exit 1
fi
