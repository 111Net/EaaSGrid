#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
BACKUP_DIR="$PROJECT_ROOT/backups/database"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-database-backup-verification-report.txt"

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

TEST_DATABASE="eaas_backup_restore_test_$(date +%s)"

cleanup() {
  echo
  echo "[INFO] Cleaning up temporary restore database..."

  dropdb \
    --if-exists \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username="$PGUSER" \
    --maintenance-db=postgres \
    "$TEST_DATABASE" \
    >/dev/null 2>&1 || true

  echo "[PASS] Temporary restore database cleanup completed"
}

trap cleanup EXIT

echo "=============================================="
echo " EaaSGrid Automated Backup Verification"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

mkdir -p "$BACKUP_DIR"
pass "Backup directory detected"

LATEST_BACKUP="$(
  find "$BACKUP_DIR" \
    -maxdepth 1 \
    -type f \
    -name "*.sql" \
    -printf "%T@ %p\n" \
    | sort -nr \
    | head -n 1 \
    | cut -d' ' -f2-
)"

if [[ -z "$LATEST_BACKUP" ]]; then
  fail "No SQL database backup found"
  exit 1
fi

pass "Latest backup detected"

BACKUP_SIZE="$(stat -c%s "$LATEST_BACKUP")"

if [[ "$BACKUP_SIZE" -gt 1000 ]]; then
  pass "Backup file size valid: $BACKUP_SIZE bytes"
else
  fail "Backup file appears too small: $BACKUP_SIZE bytes"
  exit 1
fi

if grep -q "PostgreSQL database dump" "$LATEST_BACKUP"; then
  pass "PostgreSQL dump signature verified"
else
  fail "PostgreSQL dump signature not found"
  exit 1
fi

BACKUP_CHECKSUM="$(sha256sum "$LATEST_BACKUP" | awk '{print $1}')"
pass "Backup SHA-256 checksum calculated"

echo
echo "=============================================="
echo " RESTORE TEST"
echo "=============================================="

if createdb \
  --host="$PGHOST" \
  --port="$PGPORT" \
  --username="$PGUSER" \
  --maintenance-db=postgres \
  "$TEST_DATABASE"; then

  pass "Temporary restore database created"
else
  fail "Temporary restore database creation failed"
  exit 1
fi

RESTORE_ERRORS="$PROJECT_ROOT/.eaas-backup-restore-errors.tmp"

if psql \
  --host="$PGHOST" \
  --port="$PGPORT" \
  --username="$PGUSER" \
  --dbname="$TEST_DATABASE" \
  -v ON_ERROR_STOP=1 \
  -f "$LATEST_BACKUP" \
  2>"$RESTORE_ERRORS"; then

  pass "Backup restored successfully"

else

  echo "Restore errors:"
  cat "$RESTORE_ERRORS"

  fail "Backup restore failed"
  exit 1
fi

rm -f "$RESTORE_ERRORS"

RESTORED_TABLE_COUNT="$(
  psql \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username="$PGUSER" \
    --dbname="$TEST_DATABASE" \
    -tA \
    -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE';"
)"

if [[ "$RESTORED_TABLE_COUNT" -ge 9 ]]; then
  pass "Restored schema verified: $RESTORED_TABLE_COUNT public tables"
else
  fail "Restored schema has too few tables: $RESTORED_TABLE_COUNT"
fi

RESTORED_INDEX_COUNT="$(
  psql \
    --host="$PGHOST" \
    --port="$PGPORT" \
    --username="$PGUSER" \
    --dbname="$TEST_DATABASE" \
    -tA \
    -v ON_ERROR_STOP=1 \
    -c "SELECT COUNT(*)
        FROM pg_indexes
        WHERE schemaname = 'public';"
)"

if [[ "$RESTORED_INDEX_COUNT" -gt 0 ]]; then
  pass "Restored indexes verified: $RESTORED_INDEX_COUNT"
else
  warn "No restored indexes detected"
fi

{
  echo "EaaSGrid Database Backup Verification Report"
  echo "============================================="
  echo "Timestamp: $(date)"
  echo
  echo "Source database: $PGDATABASE"
  echo "Backup file: $LATEST_BACKUP"
  echo "Backup size: $BACKUP_SIZE bytes"
  echo "SHA-256: $BACKUP_CHECKSUM"
  echo
  echo "Restored tables: $RESTORED_TABLE_COUNT"
  echo "Restored indexes: $RESTORED_INDEX_COUNT"
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
echo "Backup: $LATEST_BACKUP"
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "DATABASE BACKUP VERIFICATION: PASS"
  exit 0
else
  echo
  echo "DATABASE BACKUP VERIFICATION: FAIL"
  exit 1
fi
