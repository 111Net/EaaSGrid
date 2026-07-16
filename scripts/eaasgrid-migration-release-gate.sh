#!/usr/bin/env bash
set -u

REPO_ROOT="/data/eaasgrid-platform"
REPORT="$REPO_ROOT/eaasgrid-migration-release-gate-report.txt"

cd "$REPO_ROOT"

{
  echo "=============================================="
  echo "EAASGRID MIGRATION RELEASE GATE"
  echo "=============================================="
  echo "Date: $(date -Is)"
  echo "Repository: $REPO_ROOT"
  echo

  run_check() {
    local name="$1"
    local script="$2"

    echo "=============================================="
    echo "$name"
    echo "=============================================="

    if [ ! -x "$script" ]; then
      echo "[FAIL] Missing executable: $script"
      return 1
    fi

    if "$script"; then
      echo "[PASS] $name"
      return 0
    else
      echo "[FAIL] $name"
      return 1
    fi
  }

  PASS_COUNT=0
  FAIL_COUNT=0

  if run_check "AUTOMATED QA" \
    "$REPO_ROOT/scripts/eaasgrid-qa.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  if run_check "SCHEMA COMPARISON" \
    "$REPO_ROOT/scripts/schema-compare.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  if run_check "MIGRATION EXECUTION VALIDATION" \
    "$REPO_ROOT/scripts/validate-migration.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  if run_check "DEEP SCHEMA PARITY" \
    "$REPO_ROOT/scripts/deep-schema-parity.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  if run_check "INDEX PARITY" \
    "$REPO_ROOT/scripts/index-parity.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  if run_check "DATA PARITY" \
    "$REPO_ROOT/scripts/data-parity.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  if run_check "ADVANCED SCHEMA PARITY" \
    "$REPO_ROOT/scripts/advanced-schema-parity.sh"; then
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi

  echo
  echo "=============================================="
  echo "FINAL MIGRATION RELEASE GATE"
  echo "=============================================="
  echo "PASS_COUNT=$PASS_COUNT"
  echo "FAIL_COUNT=$FAIL_COUNT"

  if [ "$FAIL_COUNT" -eq 0 ]; then
    echo "MIGRATION_RELEASE_STATUS=PASS"
    echo
    echo "=============================================="
    echo "FINAL STATUS: PASS"
    echo "=============================================="
  else
    echo "MIGRATION_RELEASE_STATUS=FAIL"
    echo
    echo "=============================================="
    echo "FINAL STATUS: FAIL"
    echo "=============================================="
    exit 1
  fi

} 2>&1 | tee "$REPORT"
