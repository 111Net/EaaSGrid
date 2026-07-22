#!/usr/bin/env bash

set -e

cd /data/eaasgrid-platform

echo "Installing Sprint 8 Migration Release Gate"

chmod +x scripts/sprint-8-migration-release-gate.sh

bash -n scripts/sprint-8-migration-release-gate.sh

echo "SPRINT8_SCRIPT_VALID=PASS"
