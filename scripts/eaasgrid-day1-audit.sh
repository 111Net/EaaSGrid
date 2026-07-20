#!/usr/bin/env bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATE="$(date '+%Y-%m-%d')"
TIMESTAMP="$(date '+%Y-%m-%dT%H:%M:%S%z')"
REPORT_DIR="$ROOT_DIR/docs/audits/$DATE"
REPORT="$REPORT_DIR/day1-final-report-$TIMESTAMP.md"

mkdir -p "$REPORT_DIR"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

run_stage() {
    local number="$1"
    local name="$2"
    local command="$3"

    echo
    echo "[$number] $name"
    echo "----------------------------------------------"

    local output
    output="$(mktemp)"

    if bash -c "$command" >"$output" 2>&1; then
        echo "STATUS: PASS"
        PASS_COUNT=$((PASS_COUNT + 1))
        STAGE_STATUS="PASS"
    else
        local rc=$?
        echo "STATUS: FAIL (exit code $rc)"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        STAGE_STATUS="FAIL"
    fi

    cat "$output" >> "$REPORT"
    rm -f "$output"
}

{
    echo "# EaaSGrid Day 1 Automated Audit"
    echo
    echo "- **Date:** $DATE"
    echo "- **Timestamp:** $TIMESTAMP"
    echo "- **Repository:** $ROOT_DIR"
    echo
    echo "## Stage Results"
    echo
} > "$REPORT"

echo "=============================================="
echo " EaaSGrid DAY 1 AUTOMATED AUDIT"
echo "=============================================="
echo "Repository: $ROOT_DIR"

run_stage "1/7" "Opening State Audit" \
    "$ROOT_DIR/scripts/eaasgrid-audit.sh opening-state"

run_stage "2/7" "Automated QA" \
    "$ROOT_DIR/scripts/eaasgrid-qa.sh"

run_stage "3/7" "Migration Validation" \
    "$ROOT_DIR/scripts/validate-migration.sh"

run_stage "4/7" "Deep Schema Parity" \
    "$ROOT_DIR/scripts/deep-schema-parity.sh"

run_stage "5/7" "Data Parity" \
    "$ROOT_DIR/scripts/data-parity.sh"

run_stage "6/7" "Index Parity" \
    "$ROOT_DIR/scripts/index-parity.sh"

run_stage "7/7" "Migration Release Gate" \
    "$ROOT_DIR/scripts/eaasgrid-migration-release-gate.sh"

echo
echo "=============================================="
echo " FINAL RESULT"
echo "=============================================="

if [ "$FAIL_COUNT" -gt 0 ]; then
    OVERALL_STATUS="FAIL"
elif [ "$WARN_COUNT" -gt 0 ]; then
    OVERALL_STATUS="WARN"
else
    OVERALL_STATUS="PASS"
fi

echo "PASS: $PASS_COUNT"
echo "WARN: $WARN_COUNT"
echo "FAIL: $FAIL_COUNT"
echo
echo "OVERALL STATUS: $OVERALL_STATUS"
echo
echo "REPORT:"
echo "$REPORT"

cat >> "$REPORT" <<REPORT_EOF

## Final Summary

| Status | Count |
|---|---:|
| PASS | $PASS_COUNT |
| WARN | $WARN_COUNT |
| FAIL | $FAIL_COUNT |

**OVERALL STATUS:** $OVERALL_STATUS
REPORT_EOF

if [ "$OVERALL_STATUS" = "FAIL" ]; then
    exit 1
fi

exit 0
