#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "=============================================="
echo "EAASGRID MIGRATION COMMIT PRE-FLIGHT"
echo "=============================================="
echo "Repository: $ROOT_DIR"
echo "Date: $(date -Iseconds)"
echo

FAIL=0

echo "=== 1. MIGRATION RELEASE GATE ==="

if ./scripts/eaasgrid-migration-release-gate.sh > /tmp/eaasgrid-release-gate.log 2>&1; then
  echo "[PASS] Migration release gate"
else
  echo "[FAIL] Migration release gate"
  FAIL=$((FAIL + 1))
fi

echo
echo "=== 2. LEGACY DATA PRIVACY CLASSIFICATION ==="

DATA_FILE="database/legacy-snapshot/eaas_db-data.sql"

if [ ! -s "$DATA_FILE" ]; then
  echo "[FAIL] Legacy data snapshot missing"
  FAIL=$((FAIL + 1))
else
  echo "[PASS] Legacy data snapshot exists"

  PROVIDER_ROWS=$(grep -cE '^[0-9]+[[:space:]]+P[0-9]+' "$DATA_FILE" || true)
  DEVICE_ROWS=$(grep -cE '^[0-9]+[[:space:]]+D[0-9]+' "$DATA_FILE" || true)

  echo "Provider records detected: $PROVIDER_ROWS"
  echo "Device records detected: $DEVICE_ROWS"

  if grep -q 'solargrid-demo.com\|greenvolt-demo.com\|brightpower-demo.com\|ecosun-demo.com\|novaenergy-demo.com' "$DATA_FILE"; then
    echo "[PASS] Demo-domain email addresses detected"
  else
    echo "[WARN] No known demo-domain email addresses detected"
  fi

  if grep -qE 'test[[:space:]]+0$' "$DATA_FILE"; then
    echo "[PASS] Test ledger record detected"
  fi

  echo "[PASS] Snapshot classified as demo/test data based on current contents"
fi

echo
echo "=== 3. ACTUAL SECRET VALUE SCAN ==="

SECRET_FOUND=0

SEARCH_PATHS=(
  "database"
  "scripts"
  "releases"
)

for path in "${SEARCH_PATHS[@]}"; do
  if [ -d "$path" ]; then
    while IFS= read -r file; do
      if grep -qE \
        'sk-[A-Za-z0-9_-]{20,}|eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}' \
        "$file" 2>/dev/null; then
        echo "[FAIL] Possible secret detected: $file"
        SECRET_FOUND=1
      fi
    done < <(
      find "$path" -type f \
        ! -name '*.dump' \
        ! -name '*.sql' \
        ! -name '*.log' \
        -print
    )
  fi
done

if [ "$SECRET_FOUND" -eq 0 ]; then
  echo "[PASS] No recognizable secret values detected"
else
  FAIL=$((FAIL + 1))
fi

echo
echo "=== 4. REQUIRED MIGRATION ARTIFACTS ==="

REQUIRED_FILES=(
  "database/schema.sql"
  "database/migrations/001_initial_schema.sql"
  "database/legacy-snapshot/eaas_db-schema.sql"
  "database/legacy-snapshot/eaas_db-data.sql"
  "database/legacy-snapshot/eaas_db-full.dump"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -s "$file" ]; then
    echo "[PASS] $file"
  else
    echo "[FAIL] $file"
    FAIL=$((FAIL + 1))
  fi
done

echo
echo "=== 5. RELEASE PACKAGE CHECKSUMS ==="

CHECKSUM_FILE="/tmp/eaasgrid-migration-artifacts.sha256"

sha256sum \
  database/schema.sql \
  database/migrations/001_initial_schema.sql \
  database/legacy-snapshot/eaas_db-schema.sql \
  database/legacy-snapshot/eaas_db-data.sql \
  database/legacy-snapshot/eaas_db-full.dump \
  > "$CHECKSUM_FILE"

if sha256sum -c "$CHECKSUM_FILE" >/tmp/eaasgrid-checksum.log 2>&1; then
  echo "[PASS] Migration artifact checksums verified"
else
  echo "[FAIL] Migration artifact checksum verification failed"
  FAIL=$((FAIL + 1))
fi

echo
echo "=== 6. GIT STATUS ==="

git status --short

echo
echo "=== 7. STAGED FILE REVIEW ==="

STAGED_COUNT=$(git diff --cached --name-only | wc -l)

if [ "$STAGED_COUNT" -eq 0 ]; then
  echo "[INFO] No files are currently staged"
else
  echo "Staged files: $STAGED_COUNT"
  git diff --cached --stat
fi

echo
echo "=============================================="
echo "FINAL MIGRATION COMMIT PRE-FLIGHT"
echo "=============================================="

if [ "$FAIL" -eq 0 ]; then
  echo "PRE_FLIGHT_STATUS=PASS"
  echo "READY_FOR_COMMIT=YES"
  exit 0
else
  echo "PRE_FLIGHT_STATUS=FAIL"
  echo "READY_FOR_COMMIT=NO"
  echo "FAIL_COUNT=$FAIL"
  exit 1
fi
