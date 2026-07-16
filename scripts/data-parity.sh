#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/data/eaasgrid-platform"
VALIDATION_DB="eaas_data_parity_validation"
MIGRATION_FILE="$REPO_ROOT/database/migrations/001_initial_schema.sql"
DATA_FILE="$REPO_ROOT/database/legacy-snapshot/eaas_db-data.sql"

APPLICATION_TABLES=(
  clients
  devices
  energy_usage
  ledger_accounts
  ledger_entries
  providers
  transactions
  wallets
)

cleanup() {
  echo
  echo "Cleaning up validation database..."
  sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
}

trap cleanup EXIT

cd "$REPO_ROOT"

echo "=============================================="
echo "EAASGRID DATA PARITY AUDIT"
echo "=============================================="
echo "Legacy database: eaas_db"
echo "Validation database: $VALIDATION_DB"
echo

echo "[1/6] Checking required files..."

if [ ! -s "$MIGRATION_FILE" ]; then
  echo "[FAIL] Migration file missing or empty"
  exit 1
fi
echo "[PASS] Migration file exists"

if [ ! -s "$DATA_FILE" ]; then
  echo "[FAIL] Legacy data snapshot missing or empty"
  exit 1
fi
echo "[PASS] Legacy data snapshot exists"

echo
echo "[2/6] Creating clean validation database..."

sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
sudo -u postgres createdb "$VALIDATION_DB"

echo "[PASS] Validation database created"

echo
echo "[3/6] Applying migration..."

sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --file="$MIGRATION_FILE" \
  >/dev/null

echo "[PASS] Migration applied"

echo
echo "[4/6] Importing legacy data..."

if ! sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --file="$DATA_FILE" \
  >/tmp/eaasgrid-data-parity-import.log 2>&1; then

  echo "[FAIL] Legacy data import failed"
  echo
  cat /tmp/eaasgrid-data-parity-import.log
  exit 1
fi

echo "[PASS] Legacy data imported successfully"

echo
echo "=== ROW COUNT COMPARISON ==="

DATA_PARITY=PASS

for table in "${APPLICATION_TABLES[@]}"; do

  LEGACY_COUNT=$(
    sudo -u postgres psql \
      --dbname=eaas_db \
      --tuples-only \
      --no-align \
      --command="SELECT COUNT(*) FROM \"$table\";"
  )

  TARGET_COUNT=$(
    sudo -u postgres psql \
      --dbname="$VALIDATION_DB" \
      --tuples-only \
      --no-align \
      --command="SELECT COUNT(*) FROM \"$table\";"
  )

  LEGACY_COUNT=$(echo "$LEGACY_COUNT" | tr -d '[:space:]')
  TARGET_COUNT=$(echo "$TARGET_COUNT" | tr -d '[:space:]')

  if [ "$LEGACY_COUNT" = "$TARGET_COUNT" ]; then
    echo "[PASS] $table: $LEGACY_COUNT rows"
  else
    echo "[FAIL] $table: legacy=$LEGACY_COUNT target=$TARGET_COUNT"
    DATA_PARITY=FAIL
  fi

done

echo
echo "[5/6] Validating imported data integrity..."

if sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --tuples-only \
  --no-align \
  --command="
    SELECT
      CASE
        WHEN COUNT(*) = 0 THEN 'PASS'
        ELSE 'FAIL'
      END
    FROM pg_constraint c
    JOIN pg_class t ON t.oid = c.conrelid
    WHERE c.contype IN ('p','f')
      AND NOT c.convalidated;
  " | grep -q "PASS"; then

  echo "[PASS] Primary-key and foreign-key constraints valid"
else
  echo "[FAIL] Constraint validation failed"
  DATA_PARITY=FAIL
fi

echo
echo "[6/6] Final data parity gate..."

echo "DATA_PARITY=$DATA_PARITY"

if [ "$DATA_PARITY" = "PASS" ]; then
  echo "DATA_IMPORT=PASS"
  echo "DATA_PARITY_STATUS=PASS"

  echo
  echo "=============================================="
  echo "FINAL STATUS: PASS"
  echo "=============================================="
else
  echo "DATA_IMPORT=FAIL"
  echo "DATA_PARITY_STATUS=FAIL"

  echo
  echo "=============================================="
  echo "FINAL STATUS: FAIL"
  echo "=============================================="

  exit 1
fi
