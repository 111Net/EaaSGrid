#!/bin/bash

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/sprint02-git-baseline.md"

echo "======================================"
echo " XaaSGrid Sprint 2"
echo " Git Version Control Foundation"
echo "======================================"

echo "# XaaSGrid Sprint 2 Git Baseline" > "$REPORT"

echo "" >> "$REPORT"
echo "Date: $(date)" >> "$REPORT"


echo "" >> "$REPORT"
echo "## Git Version" >> "$REPORT"

if command -v git >/dev/null 2>&1
then
    git --version >> "$REPORT"
    echo "Git: PASS" >> "$REPORT"
else
    echo "Git: FAIL" >> "$REPORT"
    exit 1
fi


echo "" >> "$REPORT"
echo "## Repository Initialisation" >> "$REPORT"

cd "$ROOT"


if [ ! -d ".git" ]
then
    git init >> "$REPORT" 2>&1
    echo "Repository created: PASS" >> "$REPORT"
else
    echo "Repository already exists: PASS" >> "$REPORT"
fi


echo "" >> "$REPORT"
echo "## Git Ignore" >> "$REPORT"


cat > "$ROOT/.gitignore" <<EOF
node_modules/
.next/
dist/
build/
.env
.env.*
*.log
logs/
tmp/
coverage/
.DS_Store
reports/*.tmp
EOF


echo ".gitignore created: PASS" >> "$REPORT"



echo "" >> "$REPORT"
echo "## Secret Check" >> "$REPORT"


SECRET_CHECK=$(grep -R -n \
-E "password=|PASSWORD=|secret=|SECRET=|api_key=|API_KEY=" \
--exclude-dir=node_modules \
--exclude-dir=.git \
"$ROOT" 2>/dev/null | head -20)


if [ -z "$SECRET_CHECK" ]
then
    echo "Secrets scan: PASS" >> "$REPORT"
else
    echo "Secrets scan: REVIEW REQUIRED" >> "$REPORT"
    echo "$SECRET_CHECK" >> "$REPORT"
fi



echo "" >> "$REPORT"
echo "## Git Status Before Commit" >> "$REPORT"

git status --short >> "$REPORT"



echo "" >> "$REPORT"
echo "## Baseline Commit" >> "$REPORT"


git add . >> "$REPORT" 2>&1


git commit \
-m "XaaSGrid Platform Baseline v1.0.0 - Sprint 1 Foundation Complete" \
>> "$REPORT" 2>&1


if [ $? -eq 0 ]
then
    echo "Initial commit: PASS" >> "$REPORT"
else
    echo "Initial commit: REVIEW" >> "$REPORT"
fi



echo "" >> "$REPORT"
echo "## Commit History" >> "$REPORT"

git log --oneline -5 >> "$REPORT"



echo "" >> "$REPORT"
echo "## Final Status" >> "$REPORT"

echo "Sprint 2 Git Foundation Completed" >> "$REPORT"


echo ""


mkdir -p "$ROOT/state"


cat > "$ROOT/state/platform-state.json" <<EOF
{
"platform":"XaaSGrid",
"baseline":"created",
"current_sprint":2,
"status":"git-controlled"
}
EOF


echo "======================================"
echo " Sprint 2 Complete"
echo " Report:"
echo "$REPORT"
echo "======================================"
