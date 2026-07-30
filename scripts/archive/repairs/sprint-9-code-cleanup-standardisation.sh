#!/usr/bin/env bash

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE"
EVIDENCE="$ROOT/docs/evidence/sprint-9/$DATE"

REPORT="$REPORT_DIR/sprint-9-code-cleanup-standardisation.md"

mkdir -p "$REPORT_DIR"
mkdir -p "$EVIDENCE"

PASS=0
WARN=0
FAIL=0


pass(){
echo "[PASS] $1"
echo "- PASS: $1" >> "$REPORT"
PASS=$((PASS+1))
}

warn(){
echo "[WARN] $1"
echo "- WARN: $1" >> "$REPORT"
WARN=$((WARN+1))
}

fail(){
echo "[FAIL] $1"
echo "- FAIL: $1" >> "$REPORT"
FAIL=$((FAIL+1))
}


cat > "$REPORT" <<EOF
# EaaSGrid Platform

## Sprint 9 Code Cleanup & Repository Standardisation

Date:
$DATE

Repository:
$ROOT

