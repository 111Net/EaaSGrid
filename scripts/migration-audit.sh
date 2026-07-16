#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
DB="eaas_db"
REPORT="$ROOT/eaasgrid-migration-audit-report.txt"

mkdir -p "$ROOT/scripts"

{
  echo "=============================================="
  echo "EAASGRID DATABASE MIGRATION AUDIT"
  echo "=============================================="
  echo "Date: $(date -Is)"
  echo "Database: $DB"
  echo

  echo "=============================================="
  echo "1. DATABASE VERSION"
  echo "=============================================="
  sudo -u postgres psql -d "$DB" -c "SELECT version();"

  echo
  echo "=============================================="
  echo "2. ALEMBIC REVISION"
  echo "=============================================="
  sudo -u postgres psql -d "$DB" -c "SELECT * FROM alembic_version;"

  echo
  echo "=============================================="
  echo "3. TABLE INVENTORY AND ROW COUNTS"
  echo "=============================================="
  sudo -u postgres psql -d "$DB" -c "
    SELECT
      schemaname,
      relname AS table_name,
      n_live_tup AS estimated_rows
    FROM pg_stat_user_tables
    ORDER BY schemaname, relname;
  "

  echo
  echo "=============================================="
  echo "4. COLUMN INVENTORY"
  echo "=============================================="
  sudo -u postgres psql -d "$DB" -c "
    SELECT
      table_name,
      ordinal_position,
      column_name,
      data_type,
      is_nullable
    FROM information_schema.columns
    WHERE table_schema = 'public'
    ORDER BY table_name, ordinal_position;
  "

  echo
  echo "=============================================="
  echo "5. CONSTRAINTS"
  echo "=============================================="
  sudo -u postgres psql -d "$DB" -c "
    SELECT
      tc.table_name,
      tc.constraint_name,
      tc.constraint_type,
      kcu.column_name,
      ccu.table_name AS foreign_table_name,
      ccu.column_name AS foreign_column_name
    FROM information_schema.table_constraints tc
    LEFT JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
      AND tc.table_schema = kcu.table_schema
    LEFT JOIN information_schema.constraint_column_usage ccu
      ON tc.constraint_name = ccu.constraint_name
      AND tc.table_schema = ccu.table_schema
    WHERE tc.table_schema = 'public'
    ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;
  "

  echo
  echo "=============================================="
  echo "6. INDEXES"
  echo "=============================================="
  sudo -u postgres psql -d "$DB" -c "
    SELECT
      tablename,
      indexname,
      indexdef
    FROM pg_indexes
    WHERE schemaname = 'public'
    ORDER BY tablename, indexname;
  "

  echo
  echo "=============================================="
  echo "7. CURRENT REPOSITORY MIGRATIONS"
  echo "=============================================="
  if [ -d "$ROOT/database/migrations" ]; then
    find "$ROOT/database/migrations" -type f -maxdepth 2 -print | sort
  else
    echo "No database/migrations directory found"
  fi

  echo
  echo "=============================================="
  echo "8. MIGRATION FILE COUNT"
  echo "=============================================="
  find "$ROOT/database/migrations" -type f 2>/dev/null | wc -l

  echo
  echo "=============================================="
  echo "AUDIT COMPLETE"
  echo "=============================================="

} | tee "$REPORT"

echo
echo "Audit report written to:"
echo "$REPORT"
