#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/data/eaasgrid-platform"
VALIDATION_DB="eaas_advanced_schema_parity_validation"
MIGRATION_FILE="$REPO_ROOT/database/migrations/001_initial_schema.sql"

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
echo "EAASGRID ADVANCED SCHEMA PARITY AUDIT"
echo "=============================================="
echo "Legacy database: eaas_db"
echo "Validation database: $VALIDATION_DB"
echo

echo "[1/8] Creating clean validation database..."

sudo -u postgres dropdb --if-exists "$VALIDATION_DB" >/dev/null 2>&1 || true
sudo -u postgres createdb "$VALIDATION_DB"

echo "[PASS] Validation database created"

echo
echo "[2/8] Applying migration..."

sudo -u postgres psql \
  --dbname="$VALIDATION_DB" \
  --file="$MIGRATION_FILE" \
  >/dev/null

echo "[PASS] Migration applied"

echo
echo "[3/8] Comparing sequences..."

LEGACY_SEQUENCES=$(
  sudo -u postgres psql \
    --dbname=eaas_db \
    --tuples-only \
    --no-align \
    --command="
      SELECT sequence_name
      FROM information_schema.sequences
      WHERE sequence_schema = 'public'
      ORDER BY sequence_name;
    "
)

TARGET_SEQUENCES=$(
  sudo -u postgres psql \
    --dbname="$VALIDATION_DB" \
    --tuples-only \
    --no-align \
    --command="
      SELECT sequence_name
      FROM information_schema.sequences
      WHERE sequence_schema = 'public'
      ORDER BY sequence_name;
    "
)

if [ "$LEGACY_SEQUENCES" = "$TARGET_SEQUENCES" ]; then
  echo "[PASS] Sequence definitions match"
  SEQUENCE_PARITY=PASS
else
  echo "[FAIL] Sequence definitions differ"
  echo
  echo "LEGACY:"
  echo "$LEGACY_SEQUENCES"
  echo
  echo "TARGET:"
  echo "$TARGET_SEQUENCES"
  SEQUENCE_PARITY=FAIL
fi

echo
echo "[4/8] Comparing column defaults..."

LEGACY_DEFAULTS=$(
  sudo -u postgres psql \
    --dbname=eaas_db \
    --tuples-only \
    --no-align \
    --command="
      SELECT
        table_name || '|' ||
        column_name || '|' ||
        COALESCE(column_default, '')
      FROM information_schema.columns
      WHERE table_schema = 'public'
      ORDER BY table_name, ordinal_position;
    "
)

TARGET_DEFAULTS=$(
  sudo -u postgres psql \
    --dbname="$VALIDATION_DB" \
    --tuples-only \
    --no-align \
    --command="
      SELECT
        table_name || '|' ||
        column_name || '|' ||
        COALESCE(column_default, '')
      FROM information_schema.columns
      WHERE table_schema = 'public'
      ORDER BY table_name, ordinal_position;
    "
)

if [ "$LEGACY_DEFAULTS" = "$TARGET_DEFAULTS" ]; then
  echo "[PASS] Column defaults match"
  DEFAULT_PARITY=PASS
else
  echo "[FAIL] Column defaults differ"
  DEFAULT_PARITY=FAIL
fi

echo
echo "[5/8] Comparing check constraints..."

LEGACY_CHECKS=$(
  sudo -u postgres psql \
    --dbname=eaas_db \
    --tuples-only \
    --no-align \
    --command="
      SELECT conname || '|' || pg_get_constraintdef(oid)
      FROM pg_constraint
      WHERE contype = 'c'
      ORDER BY conname;
    "
)

TARGET_CHECKS=$(
  sudo -u postgres psql \
    --dbname="$VALIDATION_DB" \
    --tuples-only \
    --no-align \
    --command="
      SELECT conname || '|' || pg_get_constraintdef(oid)
      FROM pg_constraint
      WHERE contype = 'c'
      ORDER BY conname;
    "
)

if [ "$LEGACY_CHECKS" = "$TARGET_CHECKS" ]; then
  echo "[PASS] Check constraints match"
  CHECK_PARITY=PASS
else
  echo "[FAIL] Check constraints differ"
  CHECK_PARITY=FAIL
fi

echo
echo "[6/8] Comparing triggers..."

LEGACY_TRIGGERS=$(
  sudo -u postgres psql \
    --dbname=eaas_db \
    --tuples-only \
    --no-align \
    --command="
      SELECT event_object_table || '|' || trigger_name
      FROM information_schema.triggers
      WHERE trigger_schema = 'public'
      ORDER BY event_object_table, trigger_name;
    "
)

TARGET_TRIGGERS=$(
  sudo -u postgres psql \
    --dbname="$VALIDATION_DB" \
    --tuples-only \
    --no-align \
    --command="
      SELECT event_object_table || '|' || trigger_name
      FROM information_schema.triggers
      WHERE trigger_schema = 'public'
      ORDER BY event_object_table, trigger_name;
    "
)

if [ "$LEGACY_TRIGGERS" = "$TARGET_TRIGGERS" ]; then
  echo "[PASS] Trigger definitions match"
  TRIGGER_PARITY=PASS
else
  echo "[FAIL] Trigger definitions differ"
  TRIGGER_PARITY=FAIL
fi

echo
echo "[7/8] Comparing views..."

LEGACY_VIEWS=$(
  sudo -u postgres psql \
    --dbname=eaas_db \
    --tuples-only \
    --no-align \
    --command="
      SELECT table_name
      FROM information_schema.views
      WHERE table_schema = 'public'
      ORDER BY table_name;
    "
)

TARGET_VIEWS=$(
  sudo -u postgres psql \
    --dbname="$VALIDATION_DB" \
    --tuples-only \
    --no-align \
    --command="
      SELECT table_name
      FROM information_schema.views
      WHERE table_schema = 'public'
      ORDER BY table_name;
    "
)

if [ "$LEGACY_VIEWS" = "$TARGET_VIEWS" ]; then
  echo "[PASS] View definitions match"
  VIEW_PARITY=PASS
else
  echo "[FAIL] View definitions differ"
  VIEW_PARITY=FAIL
fi

echo
echo "[8/8] Final advanced parity gate..."

echo "SEQUENCE_PARITY=$SEQUENCE_PARITY"
echo "DEFAULT_PARITY=$DEFAULT_PARITY"
echo "CHECK_PARITY=$CHECK_PARITY"
echo "TRIGGER_PARITY=$TRIGGER_PARITY"
echo "VIEW_PARITY=$VIEW_PARITY"

if [ "$SEQUENCE_PARITY" = "PASS" ] && \
   [ "$DEFAULT_PARITY" = "PASS" ] && \
   [ "$CHECK_PARITY" = "PASS" ] && \
   [ "$TRIGGER_PARITY" = "PASS" ] && \
   [ "$VIEW_PARITY" = "PASS" ]; then

  echo "ADVANCED_SCHEMA_PARITY=PASS"

  echo
  echo "=============================================="
  echo "FINAL STATUS: PASS"
  echo "=============================================="
else
  echo "ADVANCED_SCHEMA_PARITY=FAIL"

  echo
  echo "=============================================="
  echo "FINAL STATUS: FAIL"
  echo "=============================================="

  exit 1
fi
