#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-diagnosis-report.txt"

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
echo " EaaSGrid Automated Migration Diagnosis"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

{
  echo "EaaSGrid Migration Diagnosis Report"
  echo "==================================="
  echo "Generated: $(date)"
  echo

  echo "=== PRISMA EVIDENCE ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f \
    \( -name "schema.prisma" \
       -o -name "prisma.config.*" \
       -o -name "prisma.schema.*" \) \
    -print

  echo
  echo "=== PRISMA REFERENCES IN PACKAGE FILES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name "package.json" \
    -exec grep -HnEi \
      '"(@prisma|prisma|prisma-client)' \
      {} \; 2>/dev/null || true

  echo
  echo "=== ALL MIGRATION DIRECTORIES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type d \
    \( -iname "migrations" -o -iname "migration" \) \
    -print | sort

  echo
  echo "=== ALL SQL FILES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f -iname "*.sql" \
    -print | sort

  echo
  echo "=== DATABASE PACKAGES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name "package.json" \
    -exec grep -HnEi \
      '"(pg|postgres|postgresql|sequelize|typeorm|knex|drizzle|mikro-orm|kysely)' \
      {} \; 2>/dev/null || true

  echo
  echo "=== DATABASE SCRIPT DEFINITIONS ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name "package.json" \
    -exec grep -HnEi \
      '"[^"]*(db|database|migration|migrate|schema)[^"]*":' \
      {} \; 2>/dev/null || true

} > "$REPORT_FILE"

PRISMA_SCHEMA_COUNT=$(find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type f -name "schema.prisma" -print | wc -l)

SQL_COUNT=$(find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type f -iname "*.sql" -print | wc -l)

MIGRATION_DIR_COUNT=$(find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type d \
  \( -iname "migrations" -o -iname "migration" \) \
  -print | wc -l)

if [[ "$PRISMA_SCHEMA_COUNT" -gt 0 ]]; then
  pass "Actual Prisma schema detected"
else
  warn "No actual Prisma schema.prisma detected"
fi

if [[ "$SQL_COUNT" -gt 0 ]]; then
  pass "SQL files detected"
else
  warn "No SQL files detected"
fi

if [[ "$MIGRATION_DIR_COUNT" -gt 0 ]]; then
  pass "Migration directory detected"
else
  warn "No migration directory detected"
fi

echo
echo "=============================================="
echo " DIAGNOSIS SUMMARY"
echo "=============================================="
echo "Prisma schemas: $PRISMA_SCHEMA_COUNT"
echo "SQL files: $SQL_COUNT"
echo "Migration directories: $MIGRATION_DIR_COUNT"
echo "Report: $REPORT_FILE"
echo
echo "No database changes were made."
