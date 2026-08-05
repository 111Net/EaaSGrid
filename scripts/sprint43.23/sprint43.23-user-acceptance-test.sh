#!/bin/bash

set -e


echo "=========================================="
echo "XaaSGrid Sprint 43.23"
echo "Enterprise User Acceptance Testing"
echo "Deployment Documentation"
echo "=========================================="


ROOT="/data/eaasgrid-platform"

cd $ROOT


DATE=$(date +"%Y%m%d-%H%M%S")

REPORT="reports/sprint43.23-uat-$DATE.txt"


mkdir -p docs
mkdir -p demo
mkdir -p reports



echo "[1] Creating documentation"



cat > docs/GETTING_STARTED.md <<EOF

# XaaSGrid Getting Started


## Requirements

- Ubuntu 22/24
- Docker
- Docker Compose
- Git


## Deployment


git clone repository

cd XaaSGrid

cp .env.production.example .env

docker compose up -d


## Access


Dashboard:

http://SERVER-IP:3000


API:

http://SERVER-IP:4000


EOF





cat > docs/INSTALLATION.md <<EOF

# Installation Guide


## VM/VPS/Cloud Deployment


1. Install Docker

2. Clone repository

3. Configure environment

4. Start containers


docker compose up -d



Verify:


docker ps


EOF





cat > docs/USER_GUIDE.md <<EOF

# User Guide


Users can:


- Login

- View dashboard

- Manage services

- View analytics

- Monitor operations


EOF





cat > docs/ADMIN_GUIDE.md <<EOF

# Administrator Guide


Administrators manage:


- Users

- Roles

- Services

- Billing

- Platform configuration


EOF





cat > docs/PARTNER_GUIDE.md <<EOF

# Partner Guide


Partners access:


- APIs

- Integrations

- Service lifecycle

- Partner workflows


EOF





cat > docs/INVESTOR_GUIDE.md <<EOF

# Investor Demonstration Guide


Demo workflow:


1. Platform overview

2. Enterprise dashboard

3. Intelligence engine

4. Growth metrics


EOF





cat > docs/API_GUIDE.md <<EOF

# API Guide


Base URL:


/api


Health:


/api/health


System:


/api/system/status


EOF





cat > docs/TROUBLESHOOTING.md <<EOF

# Troubleshooting


Common checks:


docker ps


docker logs xaasgrid-api


docker logs xaasgrid-dashboard


EOF





cat > docs/SECURITY.md <<EOF

# Security Controls


Implemented:


- Security headers

- JWT authentication

- Container isolation

- Database separation

- Redis service isolation


EOF




echo "[2] Creating demo users"



cat > demo/DEMO_USERS.md <<EOF

# XaaSGrid Demo Users


## Super Admin

Username:

admin@xaasgrid.demo


Password:

ChangeMe-Admin-2026!


Role:

Super Admin



---


## Operations

Username:

operations@xaasgrid.demo


Password:

ChangeMe-Operations-2026!


Role:

Operations Manager



---


## Partner

Username:

partner@xaasgrid.demo


Password:

ChangeMe-Partner-2026!


Role:

Partner



---


## Investor

Username:

investor@xaasgrid.demo


Password:

ChangeMe-Investor-2026!


Role:

Investor Viewer


EOF





cat > demo/demo-roles.json <<EOF
[
 {
  "role":"SUPER_ADMIN",
  "permissions":["all"]
 },
 {
  "role":"OPERATIONS",
  "permissions":["monitor","manage"]
 },
 {
  "role":"PARTNER",
  "permissions":["integration","view"]
 },
 {
  "role":"INVESTOR",
  "permissions":["readonly"]
 }
]
EOF




echo "[3] Running platform usability checks"


{

echo "XaaSGrid Sprint 43.23 UAT"

date


echo

echo "Docker Status"

docker ps


echo

echo "API Status"

curl -s http://localhost:4000/api/system/status


echo

echo "Health"

curl -s http://localhost:4000/api/health


echo

echo "Dashboard"

curl -I http://localhost:3000


echo

echo "Database"

docker exec xaasgrid-postgres \
psql -U eaas_user -d eaas_db \
-c "\dt"


} > $REPORT




echo "[4] Git preparation"



git add \
docs \
demo \
scripts/sprint43.23




echo

echo "=========================================="

echo "Sprint 43.23 COMPLETE"

echo "=========================================="


echo

echo "Report:"

echo $REPORT


echo

echo "Commit:"

echo 'git commit -m "Sprint 43.23 enterprise UAT and deployment documentation"'


echo

echo "Push:"

echo "git push origin main"

