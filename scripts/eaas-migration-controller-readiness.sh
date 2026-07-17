#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-controller-discovery-report.txt"
READINESS_REPORT="$PROJECT_ROOT/eaasgrid-migration-controller-readiness-report.txt"

PASS=0
WARN=0
FAIL=0

pass() {
  echo "[PASS] $1"
  PASS=$((PASS + 1))
}

warn() {
  echo "[WARN] $1"
  WARN=$((WARN + 1))
}

fail() {
  echo "[FAIL] $1"
  FAIL=$((FAIL + 1))
}

echo "=============================================="
echo " EaaSGrid Migration Controller Readiness"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

if [[ ! -f "$REPORT_FILE" ]]; then
  fail "Discovery report not found"
  exit 1
fi

ALEMBIC_INI_COUNT="$(
  grep -Ec \
    '(^|/)alembic\.(ini|toml)$' \
    "$REPORT_FILE" || true
)"

ENV_PY_COUNT="$(
  grep -Ec \
    '(^|/)env\.py$' \
    "$REPORT_FILE" || true
)"

VERSIONS_DIR_COUNT="$(
  grep -Ec \
    '(^|/)versions$' \
    "$REPORT_FILE" || true
)"

ALEMBIC_REFERENCE_COUNT="$(
  grep -Eic \
    '(alembic|sqlalchemy)' \
    "$REPORT_FILE" || true
)"

SQL_MIGRATION_COUNT="$(
  find "$PROJECT_ROOT/database/migrations" \
    -maxdepth 1 \
    -type f \
    -name "*.sql" \
    2>/dev/null \
    | wc -l
)"

if [[ "$ALEMBIC_INI_COUNT" -gt 0 ]]; then
  pass "Alembic configuration detected"
else
  warn "No Alembic configuration file detected"
fi

if [[ "$ENV_PY_COUNT" -gt 0 ]]; then
  pass "Alembic env.py detected"
else
  warn "No Alembic env.py detected"
fi

if [[ "$VERSIONS_DIR_COUNT" -gt 0 ]]; then
  pass "Alembic versions directory detected"
else
  warn "No Alembic versions directory detected"
fi

if [[ "$ALEMBIC_REFERENCE_COUNT" -gt 0 ]]; then
  pass "Alembic/SQLAlchemy references detected"
else
  warn "No Alembic/SQLAlchemy references detected"
fi

if [[ "$SQL_MIGRATION_COUNT" -gt 0 ]]; then
  pass "$SQL_MIGRATION_COUNT SQL migration file(s) detected"
else
  warn "No SQL migration files detected"
fi

echo
echo "=== CONTROLLER DECISION ==="

if [[ "$ALEMBIC_INI_COUNT" -gt 0 &&
      "$ENV_PY_COUNT" -gt 0 &&
      "$VERSIONS_DIR_COUNT" -gt 0 ]]; then

  echo "Migration framework: ALEMBIC"
  echo "Controller mode: ALEMBIC_AUTOMATION"
  pass "Full Alembic automation appears possible"

elif [[ "$SQL_MIGRATION_COUNT" -gt 0 ]]; then

  echo "Migration framework: VERSIONED_SQL"
  echo "Controller mode: SQL_MIGRATION_AUTOMATION"
  pass "Versioned SQL automation is available"

else

  echo "Migration framework: UNKNOWN"
  echo "Controller mode: SAFE_DISCOVERY_ONLY"
  warn "No executable migration framework detected"

fi

{
  echo "EaaSGrid Migration Controller Readiness Report"
  echo "=============================================="
  echo "Timestamp: $(date)"
  echo
  echo "Alembic config files: $ALEMBIC_INI_COUNT"
  echo "Alembic env.py files: $ENV_PY_COUNT"
  echo "Alembic versions directories: $VERSIONS_DIR_COUNT"
  echo "Alembic/SQLAlchemy references: $ALEMBIC_REFERENCE_COUNT"
  echo "SQL migrations: $SQL_MIGRATION_COUNT"
  echo
  echo "PASS: $PASS"
  echo "WARN: $WARN"
  echo "FAIL: $FAIL"
} > "$READINESS_REPORT"

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="
echo "PASS: $PASS"
echo "WARN: $WARN"
echo "FAIL: $FAIL"
echo "Report: $READINESS_REPORT"
echo
echo "No database changes were made."

if [[ "$FAIL" -eq 0 ]]; then
  echo
  echo "MIGRATION CONTROLLER READINESS: COMPLETE"
  exit 0
else
  echo
  echo "MIGRATION CONTROLLER READINESS: BLOCKED"
  exit 1
fi
