#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform

echo "======================================"
echo " XaaSGrid Sprint 3 Repository Cleanup"
echo "======================================"

cd $ROOT


echo "[1] Creating required repository structure"

mkdir -p \
docs \
database \
scripts/sprints \
reports \
state



echo "[2] Scanning for secrets"

find . \
\( -name ".env" \
-o -name ".env.local" \
-o -name "*.pem" \
-o -name "*.key" \) \
-not -path "./node_modules/*" \
-not -path "./.git/*" \
> reports/sprint03-secret-scan.txt || true



echo "[3] Creating environment template"


if [ -f .env ]; then

    cp .env .env.example

    sed -i \
    -E 's/(=.*)/=CHANGE_ME/g' \
    .env.example

else

    cat > .env.example <<EOF
NODE_ENV=development

DATABASE_URL=CHANGE_ME

POSTGRES_USER=CHANGE_ME
POSTGRES_PASSWORD=CHANGE_ME
POSTGRES_DB=CHANGE_ME

API_PORT=4000

NEXT_PUBLIC_API_URL=http://localhost:4000

EOF

fi



echo "[4] Updating .gitignore"


touch .gitignore


cat >> .gitignore <<EOF

# ======================
# XaaSGrid Runtime
# ======================

.env
.env.*
!.env.example

node_modules/

.next/

dist/

coverage/

*.log

*.pid


# Database

*.sql.backup


# OS

.DS_Store

EOF



echo "[5] Repository inventory"


cat > reports/sprint03-cleanup-report.md <<EOF
# XaaSGrid Sprint 3 Repository Cleanup

Date:
$(date)


## Repository

Path:
$ROOT


## Applications

$(ls apps)


## Packages

$(ls packages 2>/dev/null || echo "No packages folder")


## Scripts

$(find scripts -maxdepth 2 -type f | sort)


## Secret Scan

$(cat reports/sprint03-secret-scan.txt)


## Status

Repository cleanup completed.

EOF



echo "[6] Updating platform state"


cat > state/platform-state.json <<EOF
{
 "platform":"XaaSGrid",
 "baseline":"created",
 "current_sprint":3,
 "status":"repository-cleanup-complete",
 "git_version_control":true,
 "portable_ready":false
}
EOF



echo
echo "======================================"
echo " Sprint 3 Repository Cleanup Complete"
echo "======================================"

echo
echo "Report:"
echo "reports/sprint03-cleanup-report.md"

