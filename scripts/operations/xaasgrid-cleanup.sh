#!/bin/bash

BASE=/data/eaasgrid-platform

echo "=========================================="
echo " XaaSGrid Production Cleanup"
echo "=========================================="


cd $BASE


echo "[1] Cleaning Next.js cache"

rm -rf apps/dashboard/.next/dev/cache
rm -rf apps/investor-portal/.next/dev/cache


echo "[2] Compressing old logs"

find apps \
-name "*.log" \
-mtime +7 \
-exec gzip {} \;


echo "[3] Removing temporary files"

find . \
-name "*.tmp" \
-delete


find . \
-name "*.bak" \
-mtime +30 \
-delete


echo "[4] Checking disk"

df -h


echo "[5] Generating cleanup report"


mkdir -p reports/operations


REPORT="reports/operations/cleanup-$(date +%F).txt"


{
echo "XaaSGrid Cleanup Report"
echo
date
echo
du -sh .
echo
df -h
} > $REPORT


echo
echo "Cleanup Complete"
echo "Report:"
echo $REPORT
