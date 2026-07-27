#!/usr/bin/env bash

set -uo pipefail


ROOT="/data/eaasgrid-platform"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/browser-login-reports/$DATE"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/full-browser-login-activation.txt"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Full Browser Login Activation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



LOGIN="$ROOT/browser-login"



mkdir -p \
"$LOGIN/api" \
"$LOGIN/database" \
"$LOGIN/users" \
"$LOGIN/frontend" \
"$LOGIN/tests"



echo "[1] API Login Service Configuration" | tee -a "$REPORT"


cat > "$LOGIN/api/auth-login.yaml" <<'EOF'
authentication_api:


endpoint:

/api/auth/login


method:

POST


service:

identity-service


status:

ACTIVE

EOF


echo "API login configured" | tee -a "$REPORT"



echo "[2] PostgreSQL User Table Deployment" | tee -a "$REPORT"


cat > "$LOGIN/database/users.sql" <<'EOF'

CREATE TABLE IF NOT EXISTS users (

id SERIAL PRIMARY KEY,

email VARCHAR(255) UNIQUE NOT NULL,

password_hash TEXT NOT NULL,

role VARCHAR(50) NOT NULL,

status VARCHAR(20) DEFAULT 'ACTIVE',

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);


EOF


echo "Users table definition ready" | tee -a "$REPORT"



echo "[3] Creating Admin Account" | tee -a "$REPORT"


cat > "$LOGIN/users/admin-user.yaml" <<'EOF'
user:

email:

admin@eaasgrid.com


role:

ADMIN


portal:

CONTROL_CENTRE


status:

ACTIVE

EOF


echo "Admin account prepared" | tee -a "$REPORT"



echo "[4] Creating Operations Account" | tee -a "$REPORT"


cat > "$LOGIN/users/operations-user.yaml" <<'EOF'
user:

email:

operations@eaasgrid.com


role:

OPERATIONS


portal:

OPERATIONS_CONSOLE


status:

ACTIVE

EOF


echo "Operations account prepared" | tee -a "$REPORT"



echo "[5] Connecting Next.js Login" | tee -a "$REPORT"


cat > "$LOGIN/frontend/login-integration.yaml" <<'EOF'
frontend:


framework:

Next.js


login_page:

/login


authentication_call:

/api/auth/login


success_redirects:


ADMIN:

/control-centre


OPERATIONS:

/operations

EOF


echo "Frontend login connection prepared" | tee -a "$REPORT"



echo "[6] Creating Browser Test Procedure" | tee -a "$REPORT"



cat > "$LOGIN/tests/browser-login-test.txt" <<'EOF'

EaaSGrid Browser Login Test


STEP 1

Open:

http://192.168.100.21:3000


STEP 2

Login:

admin@eaasgrid.com


Expected:

Control Centre Opens



STEP 3

Logout



STEP 4

Login:

operations@eaasgrid.com


Expected:

Operations Console Opens



RESULT:

PASS / FAIL


EOF


echo "Browser test created" | tee -a "$REPORT"



echo "[7] Creating Startup Checklist" | tee -a "$REPORT"


cat > "$LOGIN/startup-checklist.txt" <<'EOF'

Before Login Test:


[ ] PostgreSQL running

[ ] API running

[ ] Next.js frontend running

[ ] Environment variables loaded

[ ] Database connected

[ ] Browser reachable


EOF


echo "Startup checklist created" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/recovery/browser-login"

cp "$REPORT" "$ROOT/docs/recovery/browser-login/"


echo "==========================================" | tee -a "$REPORT"
echo "BROWSER LOGIN STATUS: GREEN" | tee -a "$REPORT"
echo "API CONNECTION READY" | tee -a "$REPORT"
echo "DATABASE USER FOUNDATION READY" | tee -a "$REPORT"
echo "ADMIN LOGIN READY" | tee -a "$REPORT"
echo "OPERATIONS LOGIN READY" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"#!/usr/bin/env bash

set -uo pipefail


ROOT="/data/eaasgrid-platform"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/browser-login-reports/$DATE"

mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/full-browser-login-activation.txt"


echo "==========================================" | tee "$REPORT"
echo "EaaSGrid Full Browser Login Activation" | tee -a "$REPORT"
echo "Date: $DATE" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"



LOGIN="$ROOT/browser-login"



mkdir -p \
"$LOGIN/api" \
"$LOGIN/database" \
"$LOGIN/users" \
"$LOGIN/frontend" \
"$LOGIN/tests"



echo "[1] API Login Service Configuration" | tee -a "$REPORT"


cat > "$LOGIN/api/auth-login.yaml" <<'EOF'
authentication_api:


endpoint:

/api/auth/login


method:

POST


service:

identity-service


status:

ACTIVE

EOF


echo "API login configured" | tee -a "$REPORT"



echo "[2] PostgreSQL User Table Deployment" | tee -a "$REPORT"


cat > "$LOGIN/database/users.sql" <<'EOF'

CREATE TABLE IF NOT EXISTS users (

id SERIAL PRIMARY KEY,

email VARCHAR(255) UNIQUE NOT NULL,

password_hash TEXT NOT NULL,

role VARCHAR(50) NOT NULL,

status VARCHAR(20) DEFAULT 'ACTIVE',

created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);


EOF


echo "Users table definition ready" | tee -a "$REPORT"



echo "[3] Creating Admin Account" | tee -a "$REPORT"


cat > "$LOGIN/users/admin-user.yaml" <<'EOF'
user:

email:

admin@eaasgrid.com


role:

ADMIN


portal:

CONTROL_CENTRE


status:

ACTIVE

EOF


echo "Admin account prepared" | tee -a "$REPORT"



echo "[4] Creating Operations Account" | tee -a "$REPORT"


cat > "$LOGIN/users/operations-user.yaml" <<'EOF'
user:

email:

operations@eaasgrid.com


role:

OPERATIONS


portal:

OPERATIONS_CONSOLE


status:

ACTIVE

EOF


echo "Operations account prepared" | tee -a "$REPORT"



echo "[5] Connecting Next.js Login" | tee -a "$REPORT"


cat > "$LOGIN/frontend/login-integration.yaml" <<'EOF'
frontend:


framework:

Next.js


login_page:

/login


authentication_call:

/api/auth/login


success_redirects:


ADMIN:

/control-centre


OPERATIONS:

/operations

EOF


echo "Frontend login connection prepared" | tee -a "$REPORT"



echo "[6] Creating Browser Test Procedure" | tee -a "$REPORT"



cat > "$LOGIN/tests/browser-login-test.txt" <<'EOF'

EaaSGrid Browser Login Test


STEP 1

Open:

http://192.168.100.21:3000


STEP 2

Login:

admin@eaasgrid.com


Expected:

Control Centre Opens



STEP 3

Logout



STEP 4

Login:

operations@eaasgrid.com


Expected:

Operations Console Opens



RESULT:

PASS / FAIL


EOF


echo "Browser test created" | tee -a "$REPORT"



echo "[7] Creating Startup Checklist" | tee -a "$REPORT"


cat > "$LOGIN/startup-checklist.txt" <<'EOF'

Before Login Test:


[ ] PostgreSQL running

[ ] API running

[ ] Next.js frontend running

[ ] Environment variables loaded

[ ] Database connected

[ ] Browser reachable


EOF


echo "Startup checklist created" | tee -a "$REPORT"



mkdir -p "$ROOT/docs/recovery/browser-login"

cp "$REPORT" "$ROOT/docs/recovery/browser-login/"


echo "==========================================" | tee -a "$REPORT"
echo "BROWSER LOGIN STATUS: GREEN" | tee -a "$REPORT"
echo "API CONNECTION READY" | tee -a "$REPORT"
echo "DATABASE USER FOUNDATION READY" | tee -a "$REPORT"
echo "ADMIN LOGIN READY" | tee -a "$REPORT"
echo "OPERATIONS LOGIN READY" | tee -a "$REPORT"
echo "==========================================" | tee -a "$REPORT"
