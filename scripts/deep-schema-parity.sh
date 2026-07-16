#!/usr/bin/env bash
set -euo pipefail

LEGACY_DB="eaas_db"
VALIDATION_DB="eaas_schema_parity_validation"
MIGRATION_FILE="/data/eaasgrid-platform/database/migrations/001_initial_schema.sql"

echo "=============================================="
echo "EAASGRID DEEP SCHEMA PARITY AUDIT"
echo "=============================================="
echo "Legacy database: $LEGACY_DB"
echo "Validation database: $VALIDATION_DB"
echo

cleanup() {
  sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "[1/7] Creating clean validation database..."
sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
sudo -u postgres createdb "$VALIDATION_DB"
echo "[PASS] Validation database created"

echo
echo "[2/7] Applying migration..."
sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --set ON_ERROR_STOP=1 \
  --file="$MIGRATION_FILE" \
  >/dev/null
echo "[PASS] Migration applied"

echo
echo "[3/7] Comparing table names..."

LEGACY_TABLES=$(sudo -u postgres psql \
  --dbname="$LEGACY_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name <> 'alembic_version'
      AND table_type = 'BASE TABLE'
    ORDER BY table_name;
  ")

TARGET_TABLES=$(sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name <> 'alembic_version'
      AND table_type = 'BASE TABLE'
    ORDER BY table_name;
  ")

if [ "$LEGACY_TABLES" = "$TARGET_TABLES" ]; then
  echo "[PASS] Application table names match"
  TABLE_PARITY=PASS
else
  echo "[FAIL] Application table names differ"
  echo "--- LEGACY ---"
  echo "$LEGACY_TABLES"
  echo "--- TARGET ---"
  echo "$TARGET_TABLES"
  TABLE_PARITY=FAIL
fi

echo
echo "[4/7] Comparing column definitions..."

LEGACY_COLUMNS=$(sudo -u postgres psql \
  --dbname="$LEGACY_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT table_name || '|' ||
           column_name || '|' ||
           data_type || '|' ||
           is_nullable
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name <> 'alembic_version'
    ORDER BY table_name, ordinal_position;
  ")

TARGET_COLUMNS=$(sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT table_name || '|' ||
           column_name || '|' ||
           data_type || '|' ||
           is_nullable
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name <> 'alembic_version'
    ORDER BY table_name, ordinal_position;
  ")

if [ "$LEGACY_COLUMNS" = "$TARGET_COLUMNS" ]; then
  echo "[PASS] Column definitions match"
  COLUMN_PARITY=PASS
else
  echo "[FAIL] Column definitions differ"
  COLUMN_PARITY=FAIL

  echo
  echo "--- LEGACY COLUMNS ---"
  echo "$LEGACY_COLUMNS"

  echo
  echo "--- TARGET COLUMNS ---"
  echo "$TARGET_COLUMNS"
fi

echo
echo "[5/7] Comparing primary keys..."

LEGACY_PK=$(sudo -u postgres psql \
  --dbname="$LEGACY_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT tc.table_name || '|' || kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
     AND tc.table_schema = kcu.table_schema
    WHERE tc.constraint_type = 'PRIMARY KEY'
      AND tc.table_schema = 'public'
    ORDER BY tc.table_name, kcu.ordinal_position;
  ")

TARGET_PK=$(sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT tc.table_name || '|' || kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
     AND tc.table_schema = kcu.table_schema
    WHERE tc.constraint_type = 'PRIMARY KEY'
      AND tc.table_schema = 'public'
    ORDER BY tc.table_name, kcu.ordinal_position;
  ")

if [ "$LEGACY_PK" = "$TARGET_PK" ]; then
  echo "[PASS] Primary keys match"
  PK_PARITY=PASS
else
  echo "[FAIL] Primary keys differ"
  PK_PARITY=FAIL
fi

echo
echo "[6/7] Comparing foreign keys..."

LEGACY_FK=$(sudo -u postgres psql \
  --dbname="$LEGACY_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT tc.table_name || '|' ||
           kcu.column_name || '|' ||
           ccu.table_name || '|' ||
           ccu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
     AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage ccu
      ON ccu.constraint_name = tc.constraint_name
     AND ccu.table_schema = tc.table_schema
    WHERE tc.constraint_type = 'FOREIGN KEY'
      AND tc.table_schema = 'public'
    ORDER BY tc.table_name, kcu.column_name;
  ")

TARGET_FK=$(sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT tc.table_name || '|' ||
           kcu.column_name || '|' ||
           ccu.table_name || '|' ||
           ccu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
     AND tc.table_schema = kcu.table_schema
    JOIN information_schema.constraint_column_usage ccu
      ON ccu.constraint_name = tc.constraint_name
     AND ccu.table_schema = tc.table_schema
    WHERE tc.constraint_type = 'FOREIGN KEY'
      AND tc.table_schema = 'public'
    ORDER BY tc.table_name, kcu.column_name;
  ")

if [ "$LEGACY_FK" = "$TARGET_FK" ]; then
  echo "[PASS] Foreign keys match"
  FK_PARITY=PASS
else
  echo "[FAIL] Foreign keys differ"
  FK_PARITY=FAIL
fi

echo
echo "[7/7] Final parity gate..."

if [ "$TABLE_PARITY" = "PASS" ] && \
   [ "$COLUMN_PARITY" = "PASS" ] && \
   [ "$PK_PARITY" = "PASS" ] && \
   [ "$FK_PARITY" = "PASS" ]; then

  echo "TABLE_PARITY=PASS"
  echo "COLUMN_PARITY=PASS"
  echo "PRIMARY_KEY_PARITY=PASS"
  echo "FOREIGN_KEY_PARITY=PASS"
  echo "SCHEMA_PARITY=PASS"
  echo
  echo "=============================================="
  echo "FINAL STATUS: PASS"
  echo "=============================================="
else
  echo "TABLE_PARITY=$TABLE_PARITY"
  echo "COLUMN_PARITY=$COLUMN_PARITY"
  echo "PRIMARY_KEY_PARITY=$PK_PARITY"
  echo "FOREIGN_KEY_PARITY=$FK_PARITY"
  echo "SCHEMA_PARITY=FAIL"
  echo
  echo "=============================================="
  echo "FINAL STATUS: FAIL"
  echo "=============================================="
  exit 1
fi
