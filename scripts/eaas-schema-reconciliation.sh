#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
MIGRATION_FILE="$PROJECT_ROOT/database/migrations/001_initial_schema.sql"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-schema-reconciliation-report.txt"

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
echo " EaaSGrid Automated Schema Reconciliation"
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

export PGHOST PGPORT PGDATABASE PGPGUSER PGPASSWORD
export PGUSER

if [[ ! -f "$MIGRATION_FILE" ]]; then
  fail "Initial migration file not found"
  exit 1
fi

pass "Initial migration file found"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

LIVE_TABLES="$TMP_DIR/live_tables.txt"
MIGRATION_TABLES="$TMP_DIR/migration_tables.txt"
LIVE_INDEXES="$TMP_DIR/live_indexes.txt"
MIGRATION_INDEXES="$TMP_DIR/migration_indexes.txt"

psql -At -v ON_ERROR_STOP=1 \
  -c "SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE'
      ORDER BY table_name;" \
  > "$LIVE_TABLES"

grep -E \
  '^[[:space:]]*CREATE TABLE (IF NOT EXISTS )?public\.' \
  "$MIGRATION_FILE" \
  | sed -E 's/.*CREATE TABLE (IF NOT EXISTS )?public\.([^ (]+).*/\2/' \
  | sort -u \
  > "$MIGRATION_TABLES"

psql -At -v ON_ERROR_STOP=1 \
  -c "SELECT indexname
      FROM pg_indexes
      WHERE schemaname = 'public'
      ORDER BY indexname;" \
  > "$LIVE_INDEXES"

grep -E \
  '^[[:space:]]*CREATE INDEX ' \
  "$MIGRATION_FILE" \
  | sed -E 's/.*CREATE INDEX ([^ ]+).*/\1/' \
  | sort -u \
  > "$MIGRATION_INDEXES"

echo
echo "=== TABLE COMPARISON ==="

echo "Live database tables:"
sed 's/^/  /' "$LIVE_TABLES"

echo
echo "Migration-defined tables:"
sed 's/^/  /' "$MIGRATION_TABLES"

MISSING_TABLES="$TMP_DIR/missing_tables.txt"
EXTRA_TABLES="$TMP_DIR/extra_tables.txt"

comm -23 "$MIGRATION_TABLES" "$LIVE_TABLES" > "$MISSING_TABLES"
comm -13 "$MIGRATION_TABLES" "$LIVE_TABLES" > "$EXTRA_TABLES"

if [[ ! -s "$MISSING_TABLES" ]]; then
  pass "No migration-defined tables are missing from database"
else
  warn "Migration-defined tables missing from database:"
  sed 's/^/  - /' "$MISSING_TABLES"
fi

if [[ ! -s "$EXTRA_TABLES" ]]; then
  pass "No extra public tables detected"
else
  warn "Extra public tables detected:"
  sed 's/^/  + /' "$EXTRA_TABLES"
fi

echo
echo "=== INDEX COMPARISON ==="

MISSING_INDEXES="$TMP_DIR/missing_indexes.txt"

comm -23 "$MIGRATION_INDEXES" "$LIVE_INDEXES" > "$MISSING_INDEXES"

if [[ ! -s "$MISSING_INDEXES" ]]; then
  pass "No migration-defined indexes are missing"
else
  warn "Migration-defined indexes missing from database:"
  sed 's/^/  - /' "$MISSING_INDEXES"
fi

echo
echo "=== COLUMN COMPARISON ==="

COLUMN_MISMATCHES="$TMP_DIR/column_mismatches.txt"
touch "$COLUMN_MISMATCHES"

while IFS= read -r table; do
  [[ -z "$table" ]] && continue

  migration_columns="$(
    awk -v target="CREATE TABLE public.$table" '
      $0 ~ target { inside=1; next }
      inside && /^\);/ { inside=0 }
      inside { print }
    ' "$MIGRATION_FILE" \
    | grep -E '^[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]* ' \
    | sed -E 's/^[[:space:]]+([a-zA-Z_][a-zA-Z0-9_]*).*/\1/' \
    | sort -u || true
  )"

  live_columns="$(
    psql -At -v ON_ERROR_STOP=1 \
      -c "SELECT column_name
          FROM information_schema.columns
          WHERE table_schema = 'public'
          AND table_name = '$table'
          ORDER BY column_name;"
  )"

  while IFS= read -r column; do
    [[ -z "$column" ]] && continue

    if ! grep -Fxq "$column" <<< "$live_columns"; then
      echo "$table.$column" >> "$COLUMN_MISMATCHES"
    fi
  done <<< "$migration_columns"

done < "$MIGRATION_TABLES"

if [[ ! -s "$COLUMN_MISMATCHES" ]]; then
  pass "No obvious migration-defined columns are missing"
else
  warn "Potential missing columns detected:"
  sed 's/^/  - /' "$COLUMN_MISMATCHES"
fi

{
  echo "EaaSGrid Schema Reconciliation Report"
  echo "======================================"
  echo "Timestamp: $(date)"
  echo
  echo "Database: $PGDATABASE"
  echo "Migration: $MIGRATION_FILE"
  echo
  echo "=== LIVE TABLES ==="
  cat "$LIVE_TABLES"
  echo
  echo "=== MIGRATION TABLES ==="
  cat "$MIGRATION_TABLES"
  echo
  echo "=== MISSING TABLES ==="
  cat "$MISSING_TABLES" || true
  echo
  echo "=== EXTRA TABLES ==="
  cat "$EXTRA_TABLES" || true
  echo
  echo "=== MISSING INDEXES ==="
  cat "$MISSING_INDEXES" || true
  echo
  echo "=== POTENTIAL MISSING COLUMNS ==="
  cat "$COLUMN_MISMATCHES" || true
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
  echo "SCHEMA RECONCILIATION STATUS: COMPLETE"
  exit 0
else
  echo
  echo "SCHEMA RECONCILIATION STATUS: BLOCKED"
  exit 1
fi
