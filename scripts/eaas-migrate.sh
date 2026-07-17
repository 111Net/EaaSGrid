#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-run-report.txt"
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
echo " EaaSGrid Automated Migration Runner"
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

if ! PGPASSWORD="$PGPASSWORD" psql \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  -v ON_ERROR_STOP=1 \
  -c "SELECT 1;" >/dev/null; then
  fail "Database connection failed"
  exit 1
fi

pass "Database connection verified"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/eaas_db_$(date +%Y%m%d_%H%M%S).sql"

echo "[INFO] Creating database backup..."

if PGPASSWORD="$PGPASSWORD" pg_dump \
  -h "$PGHOST" \
  -p "$PGPORT" \
  -U "$PGUSER" \
  -d "$PGDATABASE" \
  --no-owner \
  --no-privileges \
  > "$BACKUP_FILE"; then
  pass "Database backup created"
else
  fail "Database backup failed"
  exit 1
fi

MIGRATION_SYSTEM="UNKNOWN"

if grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  "prisma" \
  "$PROJECT_ROOT" 2>/dev/null | grep -q .; then
  MIGRATION_SYSTEM="PRISMA"

elif grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  "sequelize" \
  "$PROJECT_ROOT" 2>/dev/null | grep -q .; then
  MIGRATION_SYSTEM="SEQUELIZE"

elif grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  "typeorm" \
  "$PROJECT_ROOT" 2>/dev/null | grep -q .; then
  MIGRATION_SYSTEM="TYPEORM"

elif grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  "knex" \
  "$PROJECT_ROOT" 2>/dev/null | grep -q .; then
  MIGRATION_SYSTEM="KNEX"

elif grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  "drizzle" \
  "$PROJECT_ROOT" 2>/dev/null | grep -q .; then
  MIGRATION_SYSTEM="DRIZZLE"

elif find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type f -name "*.sql" -print -quit | grep -q .; then
  MIGRATION_SYSTEM="RAW_SQL"
fi

echo "Detected migration system: $MIGRATION_SYSTEM"

case "$MIGRATION_SYSTEM" in

  PRISMA)
    fail "Prisma detected but no schema was found. Migration execution blocked for safety."
    ;;

  SEQUELIZE)
    warn "Sequelize detected. Migration command requires explicit repository configuration."
    ;;

  TYPEORM)
    warn "TypeORM detected. Migration command requires explicit repository configuration."
    ;;

  KNEX)
    warn "Knex detected. Migration command requires explicit repository configuration."
    ;;

  DRIZZLE)
    warn "Drizzle detected. Migration command requires explicit repository configuration."
    ;;

  RAW_SQL)
    warn "Raw SQL migration files detected. Automatic execution requires migration ordering validation."
    ;;

  *)
    warn "Migration system could not be safely identified."
    ;;
esac

{
  echo "EaaSGrid Automated Migration Run Report"
  echo "======================================="
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Host: $PGHOST"
  echo "Port: $PGPORT"
  echo "User: $PGUSER"
  echo "Migration system: $MIGRATION_SYSTEM"
  echo "Backup: $BACKUP_FILE"
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
echo "Backup: $BACKUP_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION RUN STATUS: SAFE CHECK COMPLETE"
  echo "No migration was executed automatically until the migration framework is confirmed."
  exit 0
else
  echo
  echo "MIGRATION RUN STATUS: BLOCKED"
  exit 1
fi
