#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-discovery-report.txt"
PLAN_FILE="$PROJECT_ROOT/eaasgrid-migration-plan.txt"

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
echo " EaaSGrid Automated Migration Plan"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

if [[ ! -f "$REPORT_FILE" ]]; then
  fail "Migration discovery report not found"
  echo
  echo "Run first:"
  echo "./scripts/eaas-migration-discovery.sh"
  exit 1
fi

{
  echo "EaaSGrid Automated Migration Plan"
  echo "================================="
  echo "Project: $PROJECT_ROOT"
  echo "Generated: $(date)"
  echo

  echo "=== DETECTED TECHNOLOGY REFERENCES ==="
  grep -iE \
    '(sequelize|typeorm|knex|drizzle|alembic|flyway|liquibase|migration|migrate|db:|database:)' \
    "$REPORT_FILE" | head -n 200 || true

  echo
  echo "=== DETECTED DATABASE CONFIGURATION ==="
  grep -iE \
    '(DATABASE_URL|PGHOST|PGPORT|PGDATABASE|PGUSER|PGPASSWORD|postgresql://|postgres://)' \
    "$REPORT_FILE" | head -n 200 || true

  echo
  echo "=== DETECTED MIGRATION FILES ==="
  grep -A 200 \
    '=== MIGRATION FILES ===' \
    "$REPORT_FILE" | head -n 250 || true

  echo
  echo "=== DETECTED PACKAGE CONFIGURATION ==="
  grep -A 200 \
    '=== PACKAGE.JSON FILES ===' \
    "$REPORT_FILE" | head -n 250 || true

  echo
  echo "=== RECOMMENDED NEXT ACTION ==="

  if grep -qiE 'prisma' "$REPORT_FILE"; then
    echo "Migration system: PRISMA"
    echo "Recommended action: use Prisma migration workflow"

  elif grep -qiE 'sequelize' "$REPORT_FILE"; then
    echo "Migration system: SEQUELIZE"
    echo "Recommended action: use Sequelize migration workflow"

  elif grep -qiE 'typeorm' "$REPORT_FILE"; then
    echo "Migration system: TYPEORM"
    echo "Recommended action: use TypeORM migration workflow"

  elif grep -qiE 'knex' "$REPORT_FILE"; then
    echo "Migration system: KNEX"
    echo "Recommended action: use Knex migration workflow"

  elif grep -qiE 'drizzle' "$REPORT_FILE"; then
    echo "Migration system: DRIZZLE"
    echo "Recommended action: use Drizzle migration workflow"

  elif grep -qiE 'alembic' "$REPORT_FILE"; then
    echo "Migration system: ALEMBIC"
    echo "Recommended action: use Alembic migration workflow"

  elif grep -qiE 'flyway' "$REPORT_FILE"; then
    echo "Migration system: FLYWAY"
    echo "Recommended action: use Flyway migration workflow"

  elif grep -qiE 'liquibase' "$REPORT_FILE"; then
    echo "Migration system: LIQUIBASE"
    echo "Recommended action: use Liquibase migration workflow"

  elif grep -qiE '\.sql|migration\.sql|migrations/' "$REPORT_FILE"; then
    echo "Migration system: RAW SQL / SQL MIGRATIONS"
    echo "Recommended action: create a controlled SQL migration runner"

  else
    echo "Migration system: NOT CONFIDENTLY IDENTIFIED"
    echo "Recommended action: inspect repository structure before applying migrations"
  fi

  echo
  echo "=== SAFETY REQUIREMENTS FOR MIGRATION RUNNER ==="
  echo "1. Validate .env without sourcing arbitrary content"
  echo "2. Verify PostgreSQL service"
  echo "3. Verify database connection"
  echo "4. Create a database backup before changes"
  echo "5. Detect migration technology"
  echo "6. Check migration status"
  echo "7. Apply only pending migrations"
  echo "8. Verify schema after migration"
  echo "9. Run automated database tests"
  echo "10. Generate a consolidated PASS/FAIL report"

} > "$PLAN_FILE"

echo "[PASS] Migration plan generated"

if grep -qiE \
  '(PRISMA|SEQUELIZE|TYPEORM|KNEX|DRIZZLE|ALEMBIC|FLYWAY|LIQUIBASE|RAW SQL)' \
  "$PLAN_FILE"; then
  pass "Migration technology identified"
else
  warn "Migration technology not confidently identified"
fi

if grep -q \
  'SAFETY REQUIREMENTS FOR MIGRATION RUNNER' \
  "$PLAN_FILE"; then
  pass "Migration safety requirements generated"
else
  fail "Migration safety requirements missing"
fi

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo "Plan: $PLAN_FILE"

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION PLAN STATUS: PASS"
  exit 0
else
  echo
  echo "MIGRATION PLAN STATUS: FAIL"
  exit 1
fi
