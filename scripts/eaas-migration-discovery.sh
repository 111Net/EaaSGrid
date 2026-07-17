#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-discovery-report.txt"

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
echo " EaaSGrid Migration System Discovery"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

{
  echo "EaaSGrid Migration System Discovery Report"
  echo "=========================================="
  echo "Timestamp: $(date)"
  echo

  echo "=== PACKAGE MANAGERS ==="
  command -v npm || true
  command -v pnpm || true
  command -v yarn || true

  echo
  echo "=== PACKAGE.JSON FILES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name package.json \
    -print | sort

  echo
  echo "=== DATABASE DEPENDENCIES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name package.json \
    -exec grep -HnEi \
    '"(pg|postgres|postgresql|mysql|mariadb|sqlite|mongodb|mongoose|sequelize|typeorm|knex|drizzle|mikro-orm|flyway|liquibase|alembic)' \
    {} \; 2>/dev/null || true

  echo
  echo "=== MIGRATION SCRIPTS ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name package.json \
    -exec grep -HnEi \
    '"[^"]*(migration|migrate|db:|database:)[^"]*":' \
    {} \; 2>/dev/null || true

  echo
  echo "=== MIGRATION FILES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f \
    \( -iname "*.sql" \
       -o -iname "*migration*" \
       -o -iname "alembic.ini" \
       -o -iname "drizzle.config.*" \
       -o -iname "knexfile.*" \
       -o -iname "sequelize.config.*" \
       -o -iname "ormconfig.*" \) \
    -print | sort

  echo
  echo "=== DATABASE CONFIGURATION REFERENCES ==="
  grep -RInE \
    --exclude-dir=node_modules \
    --exclude-dir=.git \
    --exclude='*.lock' \
    --exclude='*.map' \
    --exclude='*.min.js' \
    '(DATABASE_URL|PGHOST|PGPORT|PGDATABASE|PGUSER|PGPASSWORD|postgresql://|postgres://|migration|migrate|schema)' \
    "$PROJECT_ROOT" 2>/dev/null | head -n 500 || true

} > "$REPORT_FILE"

if grep -qiE \
  '(sequelize|typeorm|knex|drizzle|alembic|flyway|liquibase)' \
  "$REPORT_FILE"; then
  pass "Migration technology references detected"
else
  warn "No recognized migration framework detected"
fi

if grep -qiE \
  '(migration|migrate|db:|database:)' \
  "$REPORT_FILE"; then
  pass "Migration-related commands or files detected"
else
  warn "No explicit migration command detected"
fi

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "Report: $REPORT_FILE"
echo
echo "DISCOVERY STATUS: COMPLETE"
echo
echo "No database changes were made."
