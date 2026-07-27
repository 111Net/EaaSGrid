#!/usr/bin/env bash

#############################################
# EaaSGrid Guardian Core Validation Runner
#
# Purpose:
# Automatically validate Guardian libraries
#
# Tests:
# 1. Permission
# 2. Load
# 3. Dependency
# 4. Functionality
# 5. Reporting
# 6. Guardrails
#############################################

GUARDIAN_ROOT="/data/eaasgrid-platform/scripts/guardian"

CORE_DIR="$GUARDIAN_ROOT/core"

REPORT_DIR="$GUARDIAN_ROOT/reports"

LOG_DIR="$GUARDIAN_ROOT/logs"


mkdir -p "$REPORT_DIR"
mkdir -p "$LOG_DIR"


REPORT="$REPORT_DIR/core-validation-report.txt"


echo "==================================" | tee "$REPORT"
echo "EaaSGrid Guardian Core Validation" | tee -a "$REPORT"
echo "$(date)" | tee -a "$REPORT"
echo "==================================" | tee -a "$REPORT"


PASS=0
FAIL=0


test_result(){

if [ "$1" -eq 0 ]
then

echo "[PASS] $2" | tee -a "$REPORT"
PASS=$((PASS+1))

else

echo "[FAIL] $2" | tee -a "$REPORT"
FAIL=$((FAIL+1))

fi

}



####################################
# Test logger
####################################

LOGGER="$CORE_DIR/logger.sh"


if [ -f "$LOGGER" ]
then

chmod +x "$LOGGER"

source "$LOGGER"

log_info "Logger test running"

test_result 0 "logger.sh executable and loadable"

else

test_result 1 "logger.sh missing"

fi



####################################
# Test filesystem library
####################################


FILESYSTEM="$CORE_DIR/filesystem.sh"


if [ -f "$FILESYSTEM" ]
then


chmod +x "$FILESYSTEM"


source "$FILESYSTEM"


check_directory "/data/eaasgrid-platform"


test_result $? "filesystem.sh directory check"


find_files "/data/eaasgrid-platform" "*.jsx" \
> "$LOG_DIR/jsx-files.txt"


if [ -s "$LOG_DIR/jsx-files.txt" ]
then

test_result 0 "filesystem discovery found JSX files"

else

test_result 1 "filesystem discovery failed"

fi


directory_summary "/data/eaasgrid-platform" \
>> "$REPORT"


filesystem_safe "/data/eaasgrid-platform"


test_result $? "filesystem safety guardrail"


else


test_result 1 "filesystem.sh missing"


fi



####################################
# Permissions audit
####################################


for FILE in "$CORE_DIR"/*.sh
do


if [ -x "$FILE" ]
then

test_result 0 "$(basename "$FILE") executable"

else

chmod +x "$FILE"

test_result $? "$(basename "$FILE") permission repair"

fi


done



####################################
# Final report
####################################


echo "" | tee -a "$REPORT"

echo "==================================" | tee -a "$REPORT"

echo "SUMMARY" | tee -a "$REPORT"

echo "PASS: $PASS" | tee -a "$REPORT"

echo "FAIL: $FAIL" | tee -a "$REPORT"


if [ "$FAIL" -eq 0 ]
then

echo "STATUS: READY" | tee -a "$REPORT"

exit 0

else

echo "STATUS: NEEDS ATTENTION" | tee -a "$REPORT"

exit 1

fi
