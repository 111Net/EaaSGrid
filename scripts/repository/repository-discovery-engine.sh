#!/bin/bash

#############################################################
# EaaSGrid Repository Discovery Engine
#
# Sprint 0.1 - Repository Rationalization
#
# Purpose:
#   Non-destructive repository intelligence gathering.
#
# This script DOES NOT:
#   - delete files
#   - move files
#   - modify services
#   - modify code
#
# Output:
#   reports/repository/
#
#############################################################

set -e

PROJECT_ROOT="/data/eaasgrid-platform"

REPORT_DIR="$PROJECT_ROOT/reports/repository"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

REPORT="$REPORT_DIR/discovery-summary-$TIMESTAMP.txt"

INVENTORY="$REPORT_DIR/repository-inventory-$TIMESTAMP.txt"
PACKAGES="$REPORT_DIR/package-inventory-$TIMESTAMP.txt"
SERVICES="$REPORT_DIR/service-inventory-$TIMESTAMP.txt"
SCRIPTS="$REPORT_DIR/script-inventory-$TIMESTAMP.txt"
DOCKER="$REPORT_DIR/docker-inventory-$TIMESTAMP.txt"
GIT="$REPORT_DIR/git-inventory-$TIMESTAMP.txt"


#############################################################
# Prepare directories
#############################################################

mkdir -p "$REPORT_DIR"


#############################################################
# Header
#############################################################

echo "
==================================================
 EaaSGrid Repository Discovery Engine
 Sprint 0.1
 Repository Intelligence Scan

 Date:
 $(date)

 Repository:
 $PROJECT_ROOT

==================================================
" | tee "$REPORT"


#############################################################
# Filesystem Discovery
#############################################################

echo "
[1] Repository File Inventory
" | tee -a "$REPORT"


find "$PROJECT_ROOT" \
-type f \
-not -path "*/node_modules/*" \
-not -path "*/.git/*" \
> "$INVENTORY"


FILE_COUNT=$(wc -l < "$INVENTORY")


echo "
Files discovered: $FILE_COUNT

Inventory:
$INVENTORY
" | tee -a "$REPORT"



#############################################################
# Package Discovery
#############################################################

echo "
[2] Node Package Discovery
" | tee -a "$REPORT"


find "$PROJECT_ROOT" \
-name package.json \
-not -path "*/node_modules/*" \
-print \
> "$PACKAGES"


echo "
Package files:

$(cat "$PACKAGES")

" | tee -a "$REPORT"



#############################################################
# Script Discovery
#############################################################

echo "
[3] Script Discovery
" | tee -a "$REPORT"


find "$PROJECT_ROOT/scripts" \
-type f \
-name "*.sh" \
-print \
> "$SCRIPTS"


SCRIPT_COUNT=$(wc -l < "$SCRIPTS")


echo "
Shell scripts discovered:
$SCRIPT_COUNT

$(cat "$SCRIPTS")

" | tee -a "$REPORT"



#############################################################
# Systemd Discovery
#############################################################

echo "
[4] Systemd Service Discovery
" | tee -a "$REPORT"


systemctl list-unit-files \
| grep -Ei "eaas|xaas" \
> "$SERVICES" || true


echo "
Registered EAAS/XAAS services:

$(cat "$SERVICES")

" | tee -a "$REPORT"



#############################################################
# Running Services
#############################################################

echo "
[5] Active EAAS/XAAS Services
" | tee -a "$REPORT"


systemctl list-units \
--type=service \
| grep -Ei "eaas|xaas" \
>> "$SERVICES" || true



#############################################################
# Docker Discovery
#############################################################

echo "
[6] Docker Inventory
" | tee -a "$REPORT"


docker ps -a \
> "$DOCKER" 2>&1 || echo "Docker unavailable" > "$DOCKER"


echo "
Docker:

$(cat "$DOCKER")

" | tee -a "$REPORT"



#############################################################
# Git Discovery
#############################################################

echo "
[7] Git Repository State
" | tee -a "$REPORT"


{

echo "Current Branch:"
git branch --show-current

echo ""

echo "Recent Commits:"
git log --oneline -10

echo ""

echo "Tags:"
git tag

echo ""

echo "Status:"
git status

} > "$GIT"



cat "$GIT" | tee -a "$REPORT"



#############################################################
# Application Discovery
#############################################################

echo "
[8] Applications Found
" | tee -a "$REPORT"


find "$PROJECT_ROOT/apps" \
-maxdepth 2 \
-type d \
-print \
| tee -a "$REPORT"



#############################################################
# Package Discovery
#############################################################

echo "
[9] Workspace Packages
" | tee -a "$REPORT"


find "$PROJECT_ROOT/packages" \
-maxdepth 2 \
-type d \
-print \
| tee -a "$REPORT"



#############################################################
# Duplicate Candidates
#############################################################

echo "
[10] Potential Duplicate Files

Review Required:

" | tee -a "$REPORT"


find "$PROJECT_ROOT" \
-type f \
-name "*.backup" \
-o -name "*.bak" \
-o -name "*.old" \
-o -name "*backup*" \
-o -name "*.disabled" \
| tee -a "$REPORT"



#############################################################
# Final Summary
#############################################################

echo "

==================================================
 Discovery Completed

Generated Reports:

$REPORT_DIR


Inventory:
$INVENTORY

Packages:
$PACKAGES

Services:
$SERVICES

Scripts:
$SCRIPTS

Docker:
$DOCKER

Git:
$GIT


NEXT STEP:
Sprint 0.2 Dependency Analysis

==================================================

" | tee -a "$REPORT"


exit 0
