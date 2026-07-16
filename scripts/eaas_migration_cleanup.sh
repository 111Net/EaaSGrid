#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/eaas-migration-cleanup-report.txt"

MODE="${1:-audit}"

echo "==============================================" | tee "$REPORT"
echo " EaaSGrid Migration Cleanup Audit" | tee -a "$REPORT"
echo " Root: $ROOT" | tee -a "$REPORT"
echo " Mode: $MODE" | tee -a "$REPORT"
echo " Date: $(date)" | tee -a "$REPORT"
echo "==============================================" | tee -a "$REPORT"

cd "$ROOT"

echo "" | tee -a "$REPORT"
echo "===== GENERATED / REBUILDABLE DIRECTORIES =====" | tee -a "$REPORT"

find . \
  -type d \
  \( \
    -name node_modules \
    -o -name .next \
    -o -name dist \
    -o -name build \
    -o -name coverage \
    -o -name .turbo \
    -o -name .cache \
  \) \
  -not -path "./.git/*" \
  -print | tee -a "$REPORT"

echo "" | tee -a "$REPORT"
echo "===== TEMPORARY / LOG FILES =====" | tee -a "$REPORT"

find . \
  -type f \
  \( \
    -name "*.log" \
    -o -name "*.tmp" \
    -o -name "*.temp" \
    -o -name "*.bak" \
    -o -name "*~" \
  \) \
  -not -path "./.git/*" \
  -print | tee -a "$REPORT"

echo "" | tee -a "$REPORT"
echo "===== RENDER DEPLOYMENT FILES =====" | tee -a "$REPORT"

find infrastructure/render \
  -type f \
  -print 2>/dev/null | tee -a "$REPORT" || true

echo "" | tee -a "$REPORT"
echo "===== SUPABASE REFERENCES =====" | tee -a "$REPORT"

grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.next \
  --exclude-dir=.git \
  --exclude="*.log" \
  -E "supabase|SUPABASE_URL|SUPABASE_SERVICE_ROLE_KEY|SUPABASE_ANON_KEY" \
  . 2>/dev/null | tee -a "$REPORT" || true

echo "" | tee -a "$REPORT"
echo "===== RENDER REFERENCES =====" | tee -a "$REPORT"

grep -RIl \
  --exclude-dir=node_modules \
  --exclude-dir=.next \
  --exclude-dir=.git \
  --exclude="*.log" \
  -E "render\.com|render\.yaml|render\.yml" \
  . 2>/dev/null | tee -a "$REPORT" || true

echo "" | tee -a "$REPORT"
echo "===== DOCKER FILES =====" | tee -a "$REPORT"

find . \
  -type f \
  \( \
    -name "Dockerfile" \
    -o -name "docker-compose.yml" \
    -o -name "docker-compose.yaml" \
    -o -name "compose.yml" \
    -o -name "compose.yaml" \
  \) \
  -not -path "./.git/*" \
  -print | tee -a "$REPORT"

echo "" | tee -a "$REPORT"
echo "===== ENVIRONMENT FILES =====" | tee -a "$REPORT"

find . \
  -type f \
  -name ".env*" \
  -not -path "./.git/*" \
  -print | tee -a "$REPORT"

echo "" | tee -a "$REPORT"
echo "===== GIT STATUS =====" | tee -a "$REPORT"

git status --short | tee -a "$REPORT"

echo "" | tee -a "$REPORT"
echo "==============================================" | tee -a "$REPORT"

if [ "$MODE" = "audit" ]; then

  echo "AUDIT ONLY." | tee -a "$REPORT"
  echo "Nothing has been deleted." | tee -a "$REPORT"
  echo "" | tee -a "$REPORT"
  echo "Review the report:" | tee -a "$REPORT"
  echo "$REPORT" | tee -a "$REPORT"

  exit 0

fi

if [ "$MODE" = "apply" ]; then

  echo "" | tee -a "$REPORT"
  echo "APPLY MODE ENABLED." | tee -a "$REPORT"
  echo "Deleting only rebuildable generated directories..." | tee -a "$REPORT"

  find . \
    -type d \
    \( \
      -name node_modules \
      -o -name .next \
      -o -name dist \
      -o -name build \
      -o -name coverage \
      -o -name .turbo \
      -o -name .cache \
    \) \
    -not -path "./.git/*" \
    -prune \
    -exec rm -rf {} +

  find . \
    -type f \
    \( \
      -name "*.log" \
      -o -name "*.tmp" \
      -o -name "*.temp" \
      -o -name "*.bak" \
      -o -name "*~" \
    \) \
    -not -path "./.git/*" \
    -delete

  echo "Generated and temporary files removed." | tee -a "$REPORT"
  echo "Source code and configuration were preserved." | tee -a "$REPORT"

  exit 0

fi

echo "Invalid mode: $MODE"
echo "Use:"
echo "  ./scripts/eaas_migration_cleanup.sh audit"
echo "  ./scripts/eaas_migration_cleanup.sh apply"

exit 1
