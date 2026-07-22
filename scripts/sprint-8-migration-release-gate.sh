#!/usr/bin/env bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H%M%S)

REPORT_DIR="$ROOT_DIR/docs/sprint-reports/$DATE"
EVIDENCE_DIR="$ROOT_DIR/docs/evidence/sprint-8/$DATE"

REPORT="$REPORT_DIR/sprint-8-migration-release-gate.md"

mkdir -p "$REPORT_DIR"
mkdir -p "$EVIDENCE_DIR"

PASS=0
FAIL=0
WARN=0


pass()
{
echo "[PASS] $1"
echo "- PASS: $1" >> "$REPORT"
PASS=$((PASS+1))
}


fail()
{
echo "[FAIL] $1"
echo "- FAIL: $1" >> "$REPORT"
FAIL=$((FAIL+1))
}


warn()
{
echo "[WARN] $1"
echo "- WARN: $1" >> "$REPORT"
WARN=$((WARN+1))
}


echo "=========================================="
echo "EaaSGrid Platform Sprint 8"
echo "Migration Release Gate"
echo "=========================================="


cat > "$REPORT" <<REPORT
# EaaSGrid Platform

## Sprint 8 Migration Release Gate

Date:
$DATE

Repository:
$ROOT_DIR


REPORT


echo
echo "1. Repository Validation"


if [ -d "$ROOT_DIR/.git" ]; then
    pass "Git repository exists"
else
    fail "Git repository missing"
fi


if [ -f "$ROOT_DIR/scripts/eaasgrid-migration-release-gate.sh" ]; then
    pass "Migration release gate script exists"
else
    fail "Migration release gate missing"
fi


if [ -f "$ROOT_DIR/scripts/migration-commit-preflight.sh" ]; then
    pass "Migration commit preflight exists"
else
    fail "Migration commit preflight missing"
fi



echo
echo "2. Script Permission Validation"


chmod +x \
"$ROOT_DIR/scripts/eaasgrid-migration-release-gate.sh" \
"$ROOT_DIR/scripts/migration-commit-preflight.sh" \
2>/dev/null


if [ -x "$ROOT_DIR/scripts/eaasgrid-migration-release-gate.sh" ]; then
    pass "Migration gate executable"
else
    fail "Migration gate permission failed"
fi


if [ -x "$ROOT_DIR/scripts/migration-commit-preflight.sh" ]; then
    pass "Commit preflight executable"
else
    fail "Commit preflight permission failed"
fi



echo
echo "3. Bash Syntax Validation"


for SCRIPT in \
scripts/eaasgrid-migration-release-gate.sh \
scripts/migration-commit-preflight.sh
do

if bash -n "$ROOT_DIR/$SCRIPT"; then
    pass "$SCRIPT syntax valid"
else
    fail "$SCRIPT syntax error"
fi

done



echo
echo "4. PostgreSQL Validation"


if pg_isready >/dev/null 2>&1; then

    pass "PostgreSQL available"

else

    fail "PostgreSQL unavailable"

fi



echo
echo "5. Database Migration Verification"


if sudo -u postgres psql -d eaas_db \
-c "\dt eaasgrid_migration*" \
> "$EVIDENCE_DIR/database-tables.txt" 2>&1
then

pass "Migration tables verified"

else

fail "Migration table verification failed"

fi



echo
echo "6. Execute Migration Release Gate"


if "$ROOT_DIR/scripts/eaasgrid-migration-release-gate.sh" \
> "$EVIDENCE_DIR/migration-release-gate.log" 2>&1

then

pass "Migration release gate executed"

else

fail "Migration release gate failed"

fi



echo
echo "7. Execute Migration Commit Preflight"


if "$ROOT_DIR/scripts/migration-commit-preflight.sh" \
> "$EVIDENCE_DIR/migration-commit-preflight.log" 2>&1

then

pass "Migration commit preflight passed"

else

fail "Migration commit preflight failed"

fi



echo
echo "8. Git Validation"


git status --short \
> "$EVIDENCE_DIR/git-status.txt"


if git diff --quiet; then

warn "No tracked changes detected"

else

pass "Changes detected for commit"

fi



echo
echo "9. Commit Migration State"


git add .

if git commit \
-m "Sprint 8 migration release gate completion" \
2>&1 | tee "$EVIDENCE_DIR/git-commit.log"

then

pass "Migration state committed"

else

warn "Nothing new to commit"

fi



echo
echo "10. Final Sprint Gate"


cat >> "$REPORT" <<EOF

---

## Sprint 8 Final Result

PASS:
$PASS

WARN:
$WARN

FAIL:
$FAIL

