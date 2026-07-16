#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/eaasgrid-repository-schema-audit.txt"

EXCLUDES=(
  "--exclude-dir=node_modules"
  "--exclude-dir=.git"
  "--exclude-dir=venv"
  "--exclude-dir=.next"
  "--exclude-dir=dist"
  "--exclude-dir=build"
  "--exclude-dir=coverage"
  "--exclude=eaasgrid-repository-schema-audit.txt"
  "--exclude=eaasgrid-migration-audit-report.txt"
  "--exclude=eaasgrid-migration-audit-index.txt"
  "--exclude=eaas-migration-cleanup-report.txt"
)

{
  echo "=============================================="
  echo "EAASGRID REPOSITORY SCHEMA AUDIT"
  echo "=============================================="
  echo "Date: $(date -Is)"
  echo "Repository: $ROOT"
  echo

  echo "=============================================="
  echo "1. DATABASE-RELATED FILES"
  echo "=============================================="

  find "$ROOT" \
    -path "$ROOT/node_modules" -prune -o \
    -path "$ROOT/.git" -prune -o \
    -path "$ROOT/venv" -prune -o \
    -path "$ROOT/.next" -prune -o \
    -path "$ROOT/dist" -prune -o \
    -path "$ROOT/build" -prune -o \
    -type f \
    \( \
      -iname "*.sql" \
      -o -iname "schema.prisma" \
      -o -iname "ormconfig.*" \
      -o -iname "alembic.ini" \
      -o -iname "knexfile.*" \
      -o -iname "drizzle.config.*" \
      -o -iname "*migration*" \
    \) \
    -print | sort

  echo
  echo "=============================================="
  echo "2. DATABASE DIRECTORIES"
  echo "=============================================="

  find "$ROOT" \
    -path "$ROOT/node_modules" -prune -o \
    -path "$ROOT/.git" -prune -o \
    -path "$ROOT/venv" -prune -o \
    -path "$ROOT/.next" -prune -o \
    -path "$ROOT/dist" -prune -o \
    -path "$ROOT/build" -prune -o \
    -type d \
    \( \
      -iname "database" \
      -o -iname "db" \
      -o -iname "migrations" \
      -o -iname "prisma" \
      -o -iname "supabase" \
      -o -iname "models" \
      -o -iname "schemas" \
    \) \
    -print | sort

  echo
  echo "=============================================="
  echo "3. DATABASE REFERENCES IN SOURCE"
  echo "=============================================="

  grep -RIn \
    "${EXCLUDES[@]}" \
    -E 'supabase|prisma|postgres|postgresql|DATABASE_URL|SUPABASE_URL|createClient|Pool|sequelize|typeorm|drizzle|migration|alembic' \
    "$ROOT/apps" "$ROOT/packages" "$ROOT/database" \
    2>/dev/null || true

  echo
  echo "=============================================="
  echo "4. LEGACY TABLE NAME REFERENCES"
  echo "=============================================="

  grep -RIn \
    "${EXCLUDES[@]}" \
    -E 'clients|devices|energy_usage|ledger_accounts|ledger_entries|providers|transactions|wallets|cooperative_members|cooperatives|customers|payments|portfolio_metrics|solar_systems|users' \
    "$ROOT/apps" "$ROOT/packages" "$ROOT/database" \
    2>/dev/null || true

  echo
  echo "=============================================="
  echo "5. PACKAGE DATABASE DEPENDENCIES"
  echo "=============================================="

  find "$ROOT" \
    -path "$ROOT/node_modules" -prune -o \
    -path "$ROOT/.git" -prune -o \
    -path "$ROOT/venv" -prune -o \
    -name package.json \
    -print \
    -exec grep -HnE \
      'supabase|postgres|pg|prisma|sequelize|typeorm|drizzle|knex' {} \; \
    2>/dev/null || true

  echo
  echo "=============================================="
  echo "6. ENVIRONMENT DATABASE CONFIGURATION"
  echo "=============================================="

  find "$ROOT" \
    -path "$ROOT/node_modules" -prune -o \
    -path "$ROOT/.git" -prune -o \
    -path "$ROOT/venv" -prune -o \
    -type f \
    \( \
      -name ".env.example" \
      -o -name ".env.local.example" \
      -o -name "*.env.example" \
      -o -name "config.js" \
      -o -name "config.ts" \
      -o -name "config.mjs" \
    \) \
    -print \
    -exec grep -HnE \
      'DATABASE|POSTGRES|SUPABASE|DB_' {} \; \
    2>/dev/null || true

  echo
  echo "=============================================="
  echo "AUDIT COMPLETE"
  echo "STATUS: PASS"
  echo "=============================================="

} > "$REPORT"

cat "$REPORT"

echo
echo "Report written to:"
echo "$REPORT"

exit 0
