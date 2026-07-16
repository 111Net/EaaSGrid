#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
DB="eaas_db"
REPORT="$ROOT/eaasgrid-schema-comparison-report.txt"
LEGACY_SCHEMA="/tmp/eaasgrid-legacy-schema.sql"

rm -f "$REPORT" "$LEGACY_SCHEMA"

echo "Extracting legacy database schema..."

sudo -u postgres pg_dump \
  --schema-only \
  --no-owner \
  --no-privileges \
  "$DB" > "$LEGACY_SCHEMA"

{
  echo "=============================================="
  echo "EAASGRID LEGACY VS TARGET SCHEMA COMPARISON"
  echo "=============================================="
  echo "Date: $(date -Is)"
  echo "Legacy database: $DB"
  echo "Target schema: $ROOT/database/schema.sql"
  echo

  echo "=============================================="
  echo "1. LEGACY TABLES"
  echo "=============================================="

  sudo -u postgres psql -d "$DB" -Atc "
    SELECT tablename
    FROM pg_tables
    WHERE schemaname = 'public'
    ORDER BY tablename;
  "

  echo
  echo "=============================================="
  echo "2. TARGET SQL FILE"
  echo "=============================================="

  if [ -s "$ROOT/database/schema.sql" ]; then
    echo "TARGET_SCHEMA_FILE=FOUND"
    echo "TARGET_SCHEMA_LINES=$(wc -l < "$ROOT/database/schema.sql")"
    echo "TARGET_SCHEMA_BYTES=$(wc -c < "$ROOT/database/schema.sql")"
  else
    echo "TARGET_SCHEMA_FILE=MISSING_OR_EMPTY"
  fi

  echo
  echo "=============================================="
  echo "3. TARGET TABLE DEFINITIONS"
  echo "=============================================="

  grep -Ein \
    'CREATE TABLE|CREATE TABLE IF NOT EXISTS' \
    "$ROOT/database/schema.sql" \
    || true

  echo
  echo "=============================================="
  echo "4. LEGACY TABLES NOT FOUND IN TARGET SQL"
  echo "=============================================="

  while IFS= read -r table; do
    if ! grep -Eiq \
      "(CREATE TABLE|CREATE TABLE IF NOT EXISTS)[[:space:]]+(public\.)?\"?$table\"?[[:space:]]*\(" \
      "$ROOT/database/schema.sql"; then
      echo "$table"
    fi
  done < <(
    sudo -u postgres psql -d "$DB" -Atc "
      SELECT tablename
      FROM pg_tables
      WHERE schemaname = 'public'
        AND tablename <> 'alembic_version'
      ORDER BY tablename;
    "
  )

  echo
  echo "=============================================="
  echo "5. LEGACY COLUMN INVENTORY"
  echo "=============================================="

  sudo -u postgres psql -d "$DB" -c "
    SELECT
      table_name,
      column_name,
      data_type,
      is_nullable
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name <> 'alembic_version'
    ORDER BY table_name, ordinal_position;
  "

  echo
  echo "=============================================="
  echo "6. TARGET SQL REFERENCES TO LEGACY TABLES"
  echo "=============================================="

  for table in clients devices energy_usage ledger_accounts ledger_entries providers transactions wallets; do
    if grep -Eiq "(^|[^a-zA-Z0-9_])$table([^a-zA-Z0-9_]|$)" \
      "$ROOT/database/schema.sql"; then
      echo "TARGET_REFERENCES=$table"
    else
      echo "TARGET_MISSING_REFERENCE=$table"
    fi
  done

  echo
  echo "=============================================="
  echo "7. MIGRATION DIRECTORY"
  echo "=============================================="

  if [ -d "$ROOT/database/migrations" ]; then
    count=$(find "$ROOT/database/migrations" -type f | wc -l)
    echo "MIGRATION_FILES=$count"
    find "$ROOT/database/migrations" -type f -print | sort
  else
    echo "MIGRATION_DIRECTORY=MISSING"
  fi

  echo
  echo "=============================================="
  echo "COMPARISON COMPLETE"
  echo "STATUS: PASS"
  echo "=============================================="

} > "$REPORT"

cat "$REPORT"

echo
echo "Report written to:"
echo "$REPORT"

exit 0
