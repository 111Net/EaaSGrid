#!/bin/bash

set -e

BASE_URL="http://localhost:4000"

REPORT="reports/production-certification-$(date +%Y%m%d-%H%M%S).txt"


echo "========================================" | tee $REPORT
echo "XaaSGrid Production Certification" | tee -a $REPORT
echo "========================================" | tee -a $REPORT


echo "" | tee -a $REPORT
echo "[1] Docker Containers" | tee -a $REPORT

docker ps \
--format "table {{.Names}}\t{{.Status}}" \
| tee -a $REPORT



echo "" | tee -a $REPORT
echo "[2] API Live Check" | tee -a $REPORT

curl -sf \
$BASE_URL/api/live \
| tee -a $REPORT



echo "" | tee -a $REPORT
echo "[3] API Ready Check" | tee -a $REPORT

curl -sf \
$BASE_URL/api/ready \
| tee -a $REPORT



echo "" | tee -a $REPORT
echo "[4] API Version" | tee -a $REPORT

curl -sf \
$BASE_URL/api/version \
| tee -a $REPORT



echo "" | tee -a $REPORT
echo "[5] Runtime Metrics" | tee -a $REPORT

curl -sf \
$BASE_URL/api/system/metrics \
| tee -a $REPORT



echo "" | tee -a $REPORT
echo "[6] Intelligence Engine" | tee -a $REPORT


curl -sf \
$BASE_URL/api/v1/intelligence/metrics \
| tee -a $REPORT


curl -sf \
$BASE_URL/api/v1/intelligence/activity \
| tee -a $REPORT


curl -sf \
$BASE_URL/api/v1/intelligence/lifecycle \
| tee -a $REPORT


curl -sf \
$BASE_URL/api/v1/intelligence/services \
| tee -a $REPORT



echo "" | tee -a $REPORT
echo "[7] Git State" | tee -a $REPORT

git status \
| tee -a $REPORT


echo "" | tee -a $REPORT
echo "========================================" | tee -a $REPORT
echo "CERTIFICATION COMPLETE" | tee -a $REPORT
echo "REPORT: $REPORT" | tee -a $REPORT
echo "========================================" | tee -a $REPORT
