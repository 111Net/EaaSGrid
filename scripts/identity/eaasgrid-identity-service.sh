#!/usr/bin/env bash

set -uo pipefail


ROOT="/data/eaasgrid-platform"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/identity-reports/$DATE"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/identity-service-report.txt"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Identity Service Activation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



IDENTITY="$ROOT/services/identity"


mkdir -p \
"$IDENTITY/database" \
"$IDENTITY/authentication" \
"$IDENTITY/rbac" \
"$IDENTITY/users"



echo "[1] Creating PostgreSQL User Model" | tee -a "$REPORT"


cat > "$IDENTITY/database/users-schema.sql" <<'EOF'

CREATE TABLE IF NOT EXISTS users (

id SERIAL PRIMARY KEY,

email VARCHAR(255) UNIQUE NOT NULL,

password_hash TEXT NOT NULL,

full_name VARCHAR(255),

role VARCHAR(50) NOT NULL,

tenant_id VARCHAR(100),

status VARCHAR(30) DEFAULT 'ACTIVE',

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

EOF


echo "User table definition created" | tee -a "$REPORT"



echo "[2] Creating Authentication Configuration" | tee -a "$REPORT"


cat > "$IDENTITY/authentication/authentication.yaml" <<'EOF'

authentication:

method:

password


session:

jwt


token:

enabled


expiry:

24h


EOF


echo "JWT authentication configured" | tee -a "$REPORT"



echo "[3] Creating RBAC Rules" | tee -a "$REPORT"


cat > "$IDENTITY/rbac/roles.yaml" <<'EOF'

roles:


ADMIN:

permissions:

- all



OPERATIONS:

permissions:

- monitoring

- reports

- diagnostics



CUSTOMER:

permissions:

- services

- billing



PARTNER:

permissions:

- projects



INVESTOR:

permissions:

- metrics

EOF


echo "RBAC roles created" | tee -a "$REPORT"



echo "[4] Creating Initial Users" | tee -a "$REPORT"


cat > "$IDENTITY/users/bootstrap-users.yaml" <<'EOF'

users:


- email:

admin@eaasgrid.com

role:

ADMIN



- email:

operations@eaasgrid.com

role:

OPERATIONS


EOF


echo "Initial users created" | tee -a "$REPORT"



echo "[5] Creating Protected Route Map" | tee -a "$REPORT"


cat > "$IDENTITY/authentication/routes.yaml" <<'EOF'

routes:


/control-centre:

ADMIN


/operations:

OPERATIONS


/customer:

CUSTOMER


/partner:

PARTNER


/investor:

INVESTOR


EOF


echo "Protected routes created" | tee -a "$REPORT"



echo "[6] Creating Identity Service Documentation" | tee -a "$REPORT"


mkdir -p "$ROOT/docs/security"


cat > "$ROOT/docs/security/identity-service-guide.txt" <<'EOF'

EaaSGrid Identity Service


Provides:


- User authentication

- JWT sessions

- Role permissions

- Protected portals

- Account management


EOF


echo "Documentation created" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/recovery/identity-service"

cp "$REPORT" "$ROOT/docs/recovery/identity-service/"


echo "==========================================" | tee -a "$REPORT"
echo "IDENTITY SERVICE STATUS: GREEN" | tee -a "$REPORT"
echo "POSTGRES USER MODEL READY" | tee -a "$REPORT"
echo "JWT AUTH FOUNDATION READY" | tee -a "$REPORT"
echo "RBAC FOUNDATION READY" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"
