#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-sql-migration-inventory-report.txt"

PASS=0
WARN=0

pass() {
  echo "[PASS] $1"
  PASS=$((PASS + 1))
}

warn() {
  echo "[WARN] $1"
  WARN=$((WARN + 1))
}

echo "=============================================="
echo " EaaSGrid Automated SQL Migration Inventory"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

{
  echo "EaaSGrid SQL Migration Inventory"
  echo "================================"
  echo "Generated: $(date)"
  echo

  echo "=== MIGRATION DIRECTORIES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type d \
    \( -iname "migrations" -o -iname "migration" \) \
    -print | sort

  echo
  echo "=== SQL FILES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f -iname "*.sql" \
    -printf '%p\n' | sort

  echo
  echo "=== SQL FILE METADATA ==="
  while IFS= read -r file; do
    echo
    echo "--- FILE: $file ---"
    stat -c 'Size: %s bytes | Modified: %y' "$file"
    echo "First 20 lines:"
    sed -n '1,20p' "$file"
  done < <(
    find "$PROJECT_ROOT" \
      -path "$PROJECT_ROOT/node_modules" -prune -o \
      -path "$PROJECT_ROOT/.git" -prune -o \
      -type f -iname "*.sql" \
      -print | sort
  )

  echo
  echo "=== SQL OBJECTS ==="
  grep -RInE \
    --include='*.sql' \
    '(CREATE TABLE|ALTER TABLE|CREATE INDEX|CREATE TYPE|CREATE FUNCTION|CREATE VIEW|CREATE SCHEMA|INSERT INTO|DROP TABLE)' \
    "$PROJECT_ROOT" 2>/dev/null || true

  echo
  echo "=== MIGRATION VERSIONING REFERENCES ==="
  grep -RInE \
    --exclude-dir=node_modules \
    --exclude-dir=.git \
    '(migration_history|schema_migrations|migration_version|version.*migration|applied.*migration|checksum)' \
    "$PROJECT_ROOT" 2>/dev/null || true

} > "$REPORT_FILE"

SQL_COUNT=$(find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type f -iname "*.sql" -print | wc -l)

if [[ "$SQL_COUNT" -gt 0 ]]; then
  pass "$SQL_COUNT SQL files inventoried"
else
  warn "No SQL files found"
fi

if grep -qE \
  '(CREATE TABLE|ALTER TABLE|CREATE INDEX|CREATE TYPE|CREATE FUNCTION|CREATE VIEW)' \
  "$REPORT_FILE"; then
  pass "SQL schema objects detected"
else
  warn "No standard SQL schema objects detected"
fi

if grep -qE \
  '(migration_history|schema_migrations|migration_version|checksum)' \
  "$REPORT_FILE"; then
  pass "Migration versioning mechanism detected"
else
  warn "No migration versioning mechanism detected"
fi

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "Report: $REPORT_FILE"
echo
echo "No database changes were made."
