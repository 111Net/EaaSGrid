#!/bin/bash

set -e

ROOT="/data/eaasgrid-platform"

REPORT="$ROOT/reports/sprint05-preclean-report.md"

echo "======================================"
echo " XaaSGrid Sprint 5A Repository Pre-Clean"
echo "======================================"

mkdir -p "$ROOT/reports"


echo "[1] Repository inventory"

FILES=$(find "$ROOT" -type f | wc -l)


echo "[2] Secret scan"

SECRET_SCAN=$(grep -RIl \
-E "password=|secret=|api_key=|private_key|DATABASE_URL=" \
"$ROOT" \
--exclude-dir=node_modules \
--exclude-dir=.git \
2>/dev/null || true)



echo "[3] Runtime artifact scan"

ARTIFACTS=$(find "$ROOT" \
-name "node_modules" \
-o -name ".next" \
-o -name "*.log" \
-o -name "*.tmp" \
2>/dev/null || true)



echo "[4] Backup archive scan"

BACKUPS=$(find "$ROOT" \
-name "backups" \
-o -name "*.backup*" \
-o -name "*.before*" \
2>/dev/null || true)



echo "[5] Large file scan"

LARGE_FILES=$(find "$ROOT" \
-type f -size +50M \
2>/dev/null || true)



echo "[6] Creating report"


cat > "$REPORT" <<EOF

# XaaSGrid Sprint 5A Repository Pre-Clean Report

Date:
$(date)


## Repository

Path:

$ROOT


Total Files:

$FILES


## Secrets Found

$SECRET_SCAN


## Runtime Artifacts

$ARTIFACTS


## Backup Files

$BACKUPS


## Large Files (>50MB)

$LARGE_FILES


## Recommendation

Repository requires professional cleanup review before public release.

No automatic deletion performed.


EOF



echo "[7] Updating state"


python3 <<EOF
import json

p="$ROOT/state/platform-state.json"

with open(p) as f:
    data=json.load(f)

data["current_sprint"]="5A"
data["status"]="repository-preclean-complete"

with open(p,"w") as f:
    json.dump(data,f,indent=2)

EOF



echo "======================================"
echo " Sprint 5A Pre-Clean Complete"
echo "======================================"

echo "Report:"
echo "$REPORT"
