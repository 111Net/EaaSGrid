#!/usr/bin/env bash
set -euo pipefail

LEGACY_DB="eaas_db"
VALIDATION_DB="eaas_index_parity_validation"
MIGRATION_FILE="/data/eaasgrid-platform/database/migrations/001_initial_schema.sql"

echo "=============================================="
echo "EAASGRID INDEX PARITY AUDIT"
echo "=============================================="
echo "Legacy database: $LEGACY_DB"
echo "Validation database: $VALIDATION_DB"
echo

cleanup() {
  sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "[1/5] Creating clean validation database..."
sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
sudo -u postgres createdb "$VALIDATION_DB"
echo "[PASS] Validation database created"

echo
echo "[2/5] Applying migration..."
sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --set ON_ERROR_STOP=1 \
  --file="$MIGRATION_FILE" \
  >/dev/null
echo "[PASS] Migration applied"

echo
echo "[3/5] Extracting legacy indexes..."

sudo -u postgres psql \
  --dbname="$LEGACY_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT
      tablename || '|' ||
      indexname || '|' ||
      indexdef
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND tablename NOT IN (
          'eaasgrid_migration_baseline',
          'eaasgrid_migration_history'
      )
      AND tablename NOT IN (
          'eaasgrid_migration_baseline',
          'eaasgrid_migration_history'
      )
      AND tablename <> 'alembic_version'
    ORDER BY tablename, indexname;
  " > /tmp/eaasgrid-legacy-indexes.txt

echo "[PASS] Legacy indexes extracted"

echo
echo "[4/5] Extracting target indexes..."

sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT
      tablename || '|' ||
      indexname || '|' ||
      indexdef
    FROM pg_indexes
    WHERE schemaname = 'public'
      AND tablename NOT IN (
          'eaasgrid_migration_baseline',
          'eaasgrid_migration_history'
      )
      AND tablename NOT IN (
          'eaasgrid_migration_baseline',
          'eaasgrid_migration_history'
      )
      AND tablename <> 'alembic_version'
    ORDER BY tablename, indexname;
  " > /tmp/eaasgrid-target-indexes.txt

echo "[PASS] Target indexes extracted"

echo
echo "=== LEGACY INDEX COUNT ==="
LEGACY_INDEX_COUNT=$(grep -c . /tmp/eaasgrid-legacy-indexes.txt || true)
echo "$LEGACY_INDEX_COUNT"

echo
echo "=== TARGET INDEX COUNT ==="
TARGET_INDEX_COUNT=$(grep -c . /tmp/eaasgrid-target-indexes.txt || true)
echo "$TARGET_INDEX_COUNT"

echo
echo "[5/5] Comparing index definitions..."

if diff -u \
  /tmp/eaasgrid-legacy-indexes.txt \
  /tmp/eaasgrid-target-indexes.txt \
  > /tmp/eaasgrid-index-diff.txt; then

  echo "[PASS] Index definitions match"
  INDEX_PARITY=PASS

else

  echo "[FAIL] Index definitions differ"
  INDEX_PARITY=FAIL

  echo
  echo "=== INDEX DIFFERENCES ==="
  cat /tmp/eaasgrid-index-diff.txt
fi

echo
echo "=============================================="
echo "FINAL INDEX PARITY RESULT"
echo "=============================================="

echo "LEGACY_INDEX_COUNT=$LEGACY_INDEX_COUNT"
echo "TARGET_INDEX_COUNT=$TARGET_INDEX_COUNT"
echo "INDEX_PARITY=$INDEX_PARITY"

if [ "$INDEX_PARITY" = "PASS" ]; then
  echo "SCHEMA_INDEX_PARITY=PASS"
  echo
  echo "FINAL STATUS: PASS"
else
  echo "SCHEMA_INDEX_PARITY=FAIL"
  echo
  echo "FINAL STATUS: FAIL"
  exit 1
fi
