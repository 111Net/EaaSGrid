#!/bin/bash

set -e

echo "======================================"
echo " XaaSGrid Control Centre JSX Repair"
echo "======================================"

PAGE="/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx"


echo "[1] Finding backup"

BACKUP=$(ls -t ${PAGE}.backup-table-fix-* 2>/dev/null | head -1)


if [ -z "$BACKUP" ]; then
    echo "No table backup found."
    echo "Searching general backups..."

    BACKUP=$(ls -t ${PAGE}.backup-* 2>/dev/null | head -1)
fi


if [ -z "$BACKUP" ]; then
    echo "No backup available."
    exit 1
fi


echo "Restoring:"
echo "$BACKUP"


cp "$BACKUP" "$PAGE"


echo "[2] Checking JSX"

cd /data/eaasgrid-platform/apps/dashboard

npm run build


echo "[3] Restarting dashboard"

pkill -f "next" || true

sleep 2

nohup npm run dev > /tmp/eaasgrid-dashboard.log 2>&1 &


echo ""
echo "======================================"
echo " JSX REPAIR COMPLETE"
echo "======================================"

echo "Open:"
echo "http://192.168.100.21:3000/control-centre"


