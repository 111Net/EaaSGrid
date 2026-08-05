#!/bin/bash

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"


FRAMEWORK="$ROOT/scripts/framework"


echo "=========================================="
echo "XaaSGrid Automation Framework v2.0"
echo "Root:"
echo "$ROOT"
echo "=========================================="


case "$1" in


validate)

echo "[VALIDATE] Starting platform validation"


source "$FRAMEWORK/environment-check.sh"
source "$FRAMEWORK/docker-manager.sh"
source "$FRAMEWORK/prisma-manager.sh"
source "$FRAMEWORK/code-safety.sh"
source "$FRAMEWORK/certification-manager.sh"


environment_check

docker_check

prisma_check

code_safety_check

generate_certification


echo "Validation completed"


;;


deploy)

echo "[DEPLOY] Production deployment"


source "$FRAMEWORK/docker-manager.sh"


docker_safe_deploy


;;


backup)

echo "[BACKUP] Creating checkpoint"


source "$FRAMEWORK/backup-manager.sh"


create_backup


;;


sprint*)

SPRINT="$1"


echo "Executing:"
echo "$SPRINT"


if [ -f "scripts/sprints/$SPRINT.sh" ]

then

bash "scripts/sprints/$SPRINT.sh"

else

echo "ERROR:"
echo "Sprint module not found"

exit 1

fi


;;


*)

echo ""
echo "XaaSGrid Automation Framework v2.0"
echo ""
echo "Commands:"
echo ""
echo "./scripts/xaasgrid.sh validate"
echo "./scripts/xaasgrid.sh deploy"
echo "./scripts/xaasgrid.sh backup"
echo "./scripts/xaasgrid.sh sprint43"
echo ""

;;


esac
