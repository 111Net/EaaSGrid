#!/bin/bash

#############################################
# EaaSGrid Repository Dependency Analyzer
# Sprint 0.2
#
# Purpose:
# Build dependency intelligence report
# No destructive operations
#############################################

set -e

ROOT="/data/eaasgrid-platform"
REPORT_DIR="$ROOT/reports/repository"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

MAIN_REPORT="$REPORT_DIR/dependency-analysis-$DATE.txt"
PACKAGE_REPORT="$REPORT_DIR/package-analysis-$DATE.txt"
SERVICE_REPORT="$REPORT_DIR/service-dependency-map-$DATE.txt"
SCRIPT_REPORT="$REPORT_DIR/script-dependency-map-$DATE.txt"
DOCKER_REPORT="$REPORT_DIR/docker-dependency-map-$DATE.txt"
APP_REPORT="$REPORT_DIR/application-dependency-map-$DATE.txt"

mkdir -p "$REPORT_DIR"


echo "=====================================" > "$MAIN_REPORT"
echo " EaaSGrid Dependency Analyzer" >> "$MAIN_REPORT"
echo " Sprint 0.2" >> "$MAIN_REPORT"
echo " Date: $(date)" >> "$MAIN_REPORT"
echo " Repository: $ROOT" >> "$MAIN_REPORT"
echo "=====================================" >> "$MAIN_REPORT"


#############################################
# Package Dependency Analysis
#############################################

echo "" >> "$MAIN_REPORT"
echo "[1] PACKAGE DEPENDENCY ANALYSIS" >> "$MAIN_REPORT"


echo "Package inventory" > "$PACKAGE_REPORT"
echo "=================" >> "$PACKAGE_REPORT"


find "$ROOT" \
-name package.json \
-not -path "*/node_modules/*" \
-not -path "*/.next/*" \
-print >> "$PACKAGE_REPORT"


echo "" >> "$PACKAGE_REPORT"

while read pkg
do

echo "--------------------------------" >> "$PACKAGE_REPORT"
echo "PACKAGE: $pkg" >> "$PACKAGE_REPORT"

echo "Dependencies:" >> "$PACKAGE_REPORT"

grep -A20 '"dependencies"' "$pkg" 2>/dev/null \
>> "$PACKAGE_REPORT" || true


echo "Dev Dependencies:" >> "$PACKAGE_REPORT"

grep -A20 '"devDependencies"' "$pkg" 2>/dev/null \
>> "$PACKAGE_REPORT" || true


done < <(
find "$ROOT" \
-name package.json \
-not -path "*/node_modules/*" \
-not -path "*/.next/*"
)


#############################################
# Script Dependency Analysis
#############################################

echo "" >> "$MAIN_REPORT"
echo "[2] SCRIPT DEPENDENCY ANALYSIS" >> "$MAIN_REPORT"


echo "Shell scripts discovered" > "$SCRIPT_REPORT"
echo "========================" >> "$SCRIPT_REPORT"


find "$ROOT/scripts" \
-name "*.sh" \
-print >> "$SCRIPT_REPORT"


echo "" >> "$SCRIPT_REPORT"
echo "Command references:" >> "$SCRIPT_REPORT"


grep -RhoE \
"(systemctl|docker|npm|node|python|psql|nginx)[^ ]*" \
"$ROOT/scripts" \
2>/dev/null \
| sort \
| uniq \
>> "$SCRIPT_REPORT"



#############################################
# Systemd Dependency Analysis
#############################################

echo "" >> "$MAIN_REPORT"
echo "[3] SYSTEMD DEPENDENCY ANALYSIS" >> "$MAIN_REPORT"


echo "Systemd services" > "$SERVICE_REPORT"
echo "=================" >> "$SERVICE_REPORT"


systemctl list-unit-files \
| grep -Ei "eaas|xaas" \
>> "$SERVICE_REPORT"


echo "" >> "$SERVICE_REPORT"
echo "Service definitions:" >> "$SERVICE_REPORT"


for svc in /etc/systemd/system/*eaas*.service
do

if [ -f "$svc" ]
then

echo "--------------------------------" >> "$SERVICE_REPORT"
echo "$svc" >> "$SERVICE_REPORT"

cat "$svc" >> "$SERVICE_REPORT"

fi

done



#############################################
# Docker Dependency Analysis
#############################################

echo "" >> "$MAIN_REPORT"
echo "[4] DOCKER ANALYSIS" >> "$MAIN_REPORT"


echo "Docker containers" > "$DOCKER_REPORT"
echo "==================" >> "$DOCKER_REPORT"

docker ps -a >> "$DOCKER_REPORT" 2>/dev/null || true


echo "" >> "$DOCKER_REPORT"

docker images >> "$DOCKER_REPORT" 2>/dev/null || true



#############################################
# Application Mapping
#############################################

echo "" >> "$MAIN_REPORT"
echo "[5] APPLICATION DEPENDENCY MAP" >> "$MAIN_REPORT"


echo "Applications" > "$APP_REPORT"
echo "=============" >> "$APP_REPORT"


find "$ROOT/apps" \
-maxdepth 2 \
-type d \
-print \
>> "$APP_REPORT"


echo "" >> "$APP_REPORT"

echo "Workspace packages:" >> "$APP_REPORT"


find "$ROOT/packages" \
-maxdepth 2 \
-type d \
-print \
>> "$APP_REPORT"



#############################################
# Risk Analysis
#############################################

echo "" >> "$MAIN_REPORT"
echo "[6] RISK SUMMARY" >> "$MAIN_REPORT"


echo "Potential cleanup risks:" >> "$MAIN_REPORT"

echo "" >> "$MAIN_REPORT"

echo "Generated reports:" >> "$MAIN_REPORT"

echo "$PACKAGE_REPORT" >> "$MAIN_REPORT"
echo "$SCRIPT_REPORT" >> "$MAIN_REPORT"
echo "$SERVICE_REPORT" >> "$MAIN_REPORT"
echo "$DOCKER_REPORT" >> "$MAIN_REPORT"
echo "$APP_REPORT" >> "$MAIN_REPORT"


echo "" >> "$MAIN_REPORT"
echo "=====================================" >> "$MAIN_REPORT"
echo " Dependency Analysis Completed" >> "$MAIN_REPORT"
echo "=====================================" >> "$MAIN_REPORT"


echo ""
echo "======================================"
echo " EaaSGrid Dependency Analyzer Complete"
echo "======================================"
echo ""
echo "Reports:"
echo "$MAIN_REPORT"
echo "$PACKAGE_REPORT"
echo "$SCRIPT_REPORT"
echo "$SERVICE_REPORT"
echo "$DOCKER_REPORT"
echo "$APP_REPORT"
