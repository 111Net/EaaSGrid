#!/bin/bash

set -e

echo "======================================"
echo " XaaSGrid Dashboard Assets Fix"
echo "======================================"

BASE=/data/eaasgrid-platform/apps/dashboard

PAGE=$BASE/app/control-centre/page.jsx


echo "[1] Backup dashboard page"

cp $PAGE $PAGE.backup-assets-$(date +%F-%H%M)


echo "[2] Injecting deployment asset mapping"


python3 <<'PY'

from pathlib import Path

p=Path("/data/eaasgrid-platform/apps/dashboard/app/control-centre/page.jsx")

text=p.read_text()


# Add assets variable after data loading

old="""
  if(!data){
"""

new="""
  const assets =
    data?.sites ||
    data?.deploymentAssets ||
    data?.assets ||
    [];



  if(!data){
"""


if old in text:
    text=text.replace(old,new)


# Replace empty deployment section mapping

text=text.replace(
"""
{data.deploymentAssets?.map
""",
"""
{assets.map
"""
)


# Replace possible wrong references

text=text.replace(
"dashboard.deploymentAssets",
"assets"
)

text=text.replace(
"dashboard.assets",
"assets"
)


p.write_text(text)

PY


echo "[3] Restart dashboard"

cd $BASE

pkill -f "next" || true

sleep 2

nohup npm run dev > /tmp/eaasgrid-dashboard.log 2>&1 &


echo ""
echo "======================================"
echo " Deployment Assets Fixed"
echo "======================================"

echo "Open:"
echo "http://192.168.100.21:3000/control-centre"

