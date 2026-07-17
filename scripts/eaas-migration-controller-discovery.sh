#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPORT_FILE="$PROJECT_ROOT/eaasgrid-migration-controller-discovery-report.txt"

echo "=============================================="
echo " EaaSGrid Migration Controller Discovery"
echo "=============================================="
echo "Project: $PROJECT_ROOT"
echo "Started: $(date)"
echo

{
  echo "EaaSGrid Migration Controller Discovery Report"
  echo "=============================================="
  echo "Generated: $(date)"
  echo

  echo "=== ALEMBIC CONFIGURATION FILES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f \
    \( -name "alembic.ini" \
       -o -name "alembic.toml" \
       -o -name "env.py" \
       -o -name "script.py.mako" \) \
    -print | sort

  echo
  echo "=== ALEMBIC DIRECTORIES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type d \
    \( -name "alembic" -o -name "versions" \) \
    -print | sort

  echo
  echo "=== PYTHON DEPENDENCY REFERENCES ==="
  find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/.venv" -prune -o \
    -path "$PROJECT_ROOT/venv" -prune -o \
    -path "$PROJECT_ROOT/node_modules" -prune -o \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type f \
    \( -name "requirements*.txt" \
       -o -name "pyproject.toml" \
       -o -name "Pipfile" \
       -o -name "setup.py" \) \
    -exec grep -HnEi \
      '(alembic|sqlalchemy)' \
      {} \; 2>/dev/null || true

  echo
  echo "=== MIGRATION COMMAND REFERENCES ==="
  grep -RInEi \
    --exclude-dir=node_modules \
    --exclude-dir=.git \
    --exclude-dir=venv \
    --exclude-dir=.venv \
    '(alembic upgrade|alembic downgrade|alembic current|alembic history|migration)' \
    "$PROJECT_ROOT" 2>/dev/null || true

  echo
  echo "=== MIGRATION FILES ==="
  find "$PROJECT_ROOT/database/migrations" \
    -maxdepth 1 \
    -type f \
    -printf '%f\n' \
    2>/dev/null | sort

} > "$REPORT_FILE"

echo "[PASS] Migration controller discovery report generated"
echo "Report: $REPORT_FILE"
echo
echo "No database changes were made."
