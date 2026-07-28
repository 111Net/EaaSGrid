#!/bin/bash

###############################################
# EaaSGrid Repository Rationalization Engine
# Sprint 0.4
#
# Purpose:
# Prepare controlled repository cleanup plan
# without deleting files.
###############################################

ROOT="/data/eaasgrid-platform"
REPORT_DIR="$ROOT/reports/repository"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT="$REPORT_DIR/rationalization-plan-$DATE.txt"

mkdir -p "$REPORT_DIR"

echo "======================================" > "$REPORT"
echo " EaaSGrid Repository Rationalization Engine" >> "$REPORT"
echo " Sprint 0.4" >> "$REPORT"
echo " Date: $(date)" >> "$REPORT"
echo " Repository: $ROOT" >> "$REPORT"
echo "======================================" >> "$REPORT"

echo "" >> "$REPORT"
echo "[1] Archive Structure Proposal" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

cat <<EOF >> "$REPORT"

Recommended archive:

archive/
|
├── backups/
|
├── releases/
|
├── deprecated-scripts/
|
└── artifacts/

Purpose:
- Preserve history
- Reduce active repository noise
- Improve CI/CD reliability

EOF


echo "" >> "$REPORT"
echo "[2] Backup Files Identified" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-type f \
\( \
-name "*.backup*" \
-o -name "*.broken-backup*" \
-o -name "*.old" \
-o -name "*.disabled" \
\) \
! -path "*/node_modules/*" \
! -path "*/.next/*" \
>> "$REPORT"


echo "" >> "$REPORT"
echo "[3] Release Snapshots" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT/releases" \
-maxdepth 2 \
-type d \
2>/dev/null \
>> "$REPORT"


echo "" >> "$REPORT"
echo "[4] Generated Artifacts" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-type d \
\( \
-name ".next" \
-o -name "node_modules" \
-o -name "__pycache__" \
\) \
>> "$REPORT"


echo "" >> "$REPORT"
echo "[5] Deprecated Script Candidates" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT/scripts" \
-type f \
-name "*.sh" \
| grep -Ei \
"fix|backup|old|test|migration|phase" \
>> "$REPORT"


echo "" >> "$REPORT"
echo "[6] Large Files (>50MB)" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

find "$ROOT" \
-type f \
-size +50M \
! -path "*/node_modules/*" \
! -path "*/.next/*" \
-exec ls -lh {} \; \
>> "$REPORT"


echo "" >> "$REPORT"
echo "[7] Recommended Actions" >> "$REPORT"
echo "--------------------------------------" >> "$REPORT"

cat <<EOF >> "$REPORT"

ACTION PLAN:

Phase 1:
Create archive folders.

Phase 2:
Move backup artifacts.

Phase 3:
Remove generated build artifacts from Git tracking.

Phase 4:
Consolidate duplicate lifecycle scripts.

Phase 5:
Create clean Sprint 0 baseline commit.

NO FILES WERE MODIFIED.

======================================
 Rationalization Analysis Complete
 Report:
 $REPORT
======================================

EOF


echo "$REPORT"
