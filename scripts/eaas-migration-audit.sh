#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-audit-report.txt"

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

echo "=============================================="
echo " EaaSGrid Automated Migration Audit"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

{
  echo "EaaSGrid Automated Migration Audit Report"
  echo "========================================="
  echo "Project: $PROJECT_ROOT"
  echo "Timestamp: $(date)"
  echo

  echo "=== PROJECT STRUCTURE ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f \
    \( -name "schema.prisma" \
       -o -name "migration.sql" \
       -o -name "package.json" \
       -o -name "drizzle.config.*" \
       -o -name "knexfile.*" \
       -o -name "sequelize.config.*" \
       -o -name "alembic.ini" \
       -o -name "docker-compose.yml" \
       -o -name "docker-compose.yaml" \) \
    -print | sort

  echo
  echo "=== MIGRATION DIRECTORIES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type d \
    \( -iname "migrations" \
       -o -iname "migration" \
       -o -iname "prisma" \
       -o -iname "alembic" \) \
    -print | sort

  echo
  echo "=== DATABASE-RELATED PACKAGE CONFIGURATION ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name "package.json" \
    -print \
    -exec grep -HnEi \
      '"(prisma|drizzle|sequelize|typeorm|knex|migration|migrate|db:)' \
      {} \; 2>/dev/null || true

  echo
  echo "=== PRISMA SCHEMAS ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -name "schema.prisma" \
    -print \
    -exec sed -n '1,240p' {} \; 2>/dev/null || true

} > "$REPORT_FILE"

pass "Migration audit report generated"

if find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type f -name "schema.prisma" -print -quit | grep -q .; then
  pass "Prisma schema detected"
else
  warn "No Prisma schema detected"
fi

if find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/node_modules" -prune -o \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type d -iname "migrations" -print -quit | grep -q .; then
  pass "Migration directory detected"
else
  warn "No migration directory detected"
fi

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo "Report: $REPORT_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION AUDIT STATUS: PASS"
  exit 0
else
  echo
  echo "MIGRATION AUDIT STATUS: FAIL"
  exit 1
fi
