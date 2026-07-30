#!/bin/bash

############################################################
# XaaSGrid Platform Operating System (XPOS)
#
# FINAL PLATFORM INTEGRATION
#
# Version 1.0
############################################################

set -e

ROOT=/data/eaasgrid-platform

REPORT_DIR=$ROOT/reports/platform

LOG_DIR=$ROOT/logs/platform

BACKUP_DIR=$ROOT/backups/platform

mkdir -p "$REPORT_DIR"

mkdir -p "$LOG_DIR"

mkdir -p "$BACKUP_DIR"

REPORT=$REPORT_DIR/platform-$(date +%F_%H-%M-%S).txt

exec > >(tee "$REPORT") 2>&1

echo "================================================"

echo " XaaSGrid Platform Operating System"

echo " FINAL PLATFORM INTEGRATION"

echo "================================================"

echo
LIB=$ROOT/scripts/lib

source $LIB/platform.sh

source $LIB/api.sh

source $LIB/dashboard.sh

source $LIB/investor.sh

source $LIB/dashboard-api.sh

source $LIB/database.sh

source $LIB/auth.sh


source $LIB/security.sh
source $LIB/routes.sh
source $LIB/repair.sh

source $LIB/backup.sh

source $LIB/reports.sh

source $LIB/cleanup.sh
echo

echo "STEP 1"

platform_backup

echo

echo "STEP 2"

platform_environment_validation

echo

echo "STEP 3"

database_validation

echo

echo "STEP 4"

database_repair

echo

echo "STEP 5"

api_validation

echo

echo "STEP 6"

api_repair

echo

echo "STEP 7"

dashboard_validation

echo

echo "STEP 8"

dashboard_repair

echo

echo "STEP 9"

investor_validation

echo

echo "STEP 10"

investor_repair

echo

echo "STEP 11"

authentication_validation

echo

echo "STEP 12"

authentication_repair

echo

echo "STEP 13"

permission_validation

echo

echo "STEP 14"

permission_repair

echo

echo "STEP 15"

route_validation

echo

echo "STEP 16"

route_repair

echo

echo "STEP 17"

dashboard_api_validation

echo

echo "STEP 18"

dashboard_api_repair

echo

echo "STEP 19"

nextjs_cache_repair

echo

echo "STEP 20"

platform_build_validation

echo

echo "STEP 21"

platform_restart

echo

echo "STEP 22"

platform_health_check

echo

echo "STEP 23"

platform_runtime_validation

echo

echo "STEP 24"

platform_log_scan

echo

echo "STEP 25"

disk_validation

memory_validation

cpu_validation

echo

echo "STEP 26"

security_validation

echo

echo "STEP 27"

automatic_cleanup

echo

echo "STEP 28"

generate_platform_report

echo

echo "================================================"

echo " XaaSGrid Platform Ready"

echo "================================================"
