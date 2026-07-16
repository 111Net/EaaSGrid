#!/usr/bin/env bash
set -euo pipefail

DB_NAME="eaas_migration_validation"
MIGRATION_FILE="/data/eaasgrid-platform/database/migrations/001_initial_schema.sql"

echo "=============================================="
echo "EAASGRID MIGRATION EXECUTION VALIDATION"
echo "=============================================="
echo "Database: $DB_NAME"
echo "Migration: $MIGRATION_FILE"
echo

cleanup() {
  echo
  echo "Cleaning up validation database..."
  sudo -u postgres dropdb --if-exists "$DB_NAME" >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "[1/6] Checking migration file..."
if [ ! -s "$MIGRATION_FILE" ]; then
  echo "[FAIL] Migration file missing or empty"
  exit 1
fi
echo "[PASS] Migration file exists"

echo
echo "[2/6] Creating clean validation database..."
sudo -u postgres dropdb --if-exists "$DB_NAME" >/dev/null 2>&1 || true
sudo -u postgres createdb "$DB_NAME"
echo "[PASS] Clean database created"

echo
echo "[3/6] Applying migration..."
sudo -u postgres psql \
  --dbname="$DB_NAME" \
  --set ON_ERROR_STOP=1 \
  --file="$MIGRATION_FILE" \
  >/tmp/eaasgrid-migration-validation.log

echo "[PASS] Migration executed successfully"

echo
echo "[4/6] Validating table count..."
TABLE_COUNT=$(
  sudo -u postgres psql \
    --dbname="$DB_NAME" \
    --tuples-only \
    --no-align \
    --command="
      SELECT COUNT(*)
      FROM information_schema.tables
      WHERE table_schema = 'public'
      AND table_type = 'BASE TABLE';
    "
)

TABLE_COUNT=$(echo "$TABLE_COUNT" | tr -d '[:space:]')

echo "TARGET_TABLE_COUNT=$TABLE_COUNT"

if [ "$TABLE_COUNT" -eq 9 ]; then
  echo "[PASS] Expected 9 tables created"
else
  echo "[FAIL] Expected 9 tables but found $TABLE_COUNT"
  exit 1
fi

echo
echo "[5/6] Validating application tables..."

EXPECTED_TABLES=(
  "alembic_version"
  "clients"
  "devices"
  "energy_usage"
  "ledger_accounts"
  "ledger_entries"
  "providers"
  "transactions"
  "wallets"
)

for table in "${EXPECTED_TABLES[@]}"; do
  EXISTS=$(
    sudo -u postgres psql \
      --dbname="$DB_NAME" \
      --tuples-only \
      --no-align \
      --command="
        SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = '$table';
      "
  )

  EXISTS=$(echo "$EXISTS" | tr -d '[:space:]')

  if [ "$EXISTS" -eq 1 ]; then
    echo "[PASS] $table"
  else
    echo "[FAIL] $table"
    exit 1
  fi
done

echo
echo "[6/6] Final validation..."

echo "MIGRATION_EXECUTION=PASS"
echo "TABLE_VALIDATION=PASS"
echo "VALIDATION_STATUS=PASS"

echo
echo "=============================================="
echo "FINAL STATUS: PASS"
echo "=============================================="
