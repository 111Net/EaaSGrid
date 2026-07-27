#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"
API="$ROOT/apps/api"

echo "======================================"
echo "EaaSGrid Identity User Provisioning"
echo "======================================"

cd "$API"


echo "[1/7] Loading environment"

if [ -f "$ROOT/.env" ]; then
    export $(grep -v '^#' "$ROOT/.env" | xargs)
fi


echo "[2/7] Applying identity schema"


psql "$DATABASE_URL" <<'EOF'

CREATE TABLE IF NOT EXISTS users (

id SERIAL PRIMARY KEY,

email VARCHAR(255)
UNIQUE NOT NULL,

password_hash TEXT NOT NULL,

full_name VARCHAR(255),

status VARCHAR(30)
DEFAULT 'ACTIVE',

created_at TIMESTAMP
DEFAULT CURRENT_TIMESTAMP

);


CREATE TABLE IF NOT EXISTS roles (

id SERIAL PRIMARY KEY,

name VARCHAR(50)
UNIQUE NOT NULL

);


CREATE TABLE IF NOT EXISTS user_roles (

user_id INTEGER
REFERENCES users(id)
ON DELETE CASCADE,

role_id INTEGER
REFERENCES roles(id)
ON DELETE CASCADE,

PRIMARY KEY(user_id,role_id)

);


INSERT INTO roles(name)
VALUES

('ADMIN'),
('OPERATIONS'),
('PARTNER'),
('CUSTOMER'),
('INVESTOR'),
('COLLABORATOR')

ON CONFLICT DO NOTHING;


EOF


echo "[3/7] Creating password hashes"


ADMIN_HASH=$(node - <<'EOF'

const bcrypt=require("bcrypt");

bcrypt.hash(
"Admin@12345",
12
)
.then(console.log);

EOF
)


OPS_HASH=$(node - <<'EOF'

const bcrypt=require("bcrypt");

bcrypt.hash(
"Operations@12345",
12
)
.then(console.log);

EOF
)


echo "[4/7] Creating users"


psql "$DATABASE_URL" <<EOF


INSERT INTO users
(
email,
password_hash,
full_name
)

VALUES

(
'admin@eaasgrid.com',
'$ADMIN_HASH',
'EaaSGrid Administrator'
),

(
'operations@eaasgrid.com',
'$OPS_HASH',
'EaaSGrid Operations'
)


ON CONFLICT(email)
DO UPDATE SET
password_hash=EXCLUDED.password_hash;


EOF



echo "[5/7] Assigning roles"


psql "$DATABASE_URL" <<'EOF'


INSERT INTO user_roles
(
user_id,
role_id
)

SELECT

u.id,
r.id

FROM users u,
roles r

WHERE

u.email='admin@eaasgrid.com'

AND r.name='ADMIN'


ON CONFLICT DO NOTHING;



INSERT INTO user_roles
(
user_id,
role_id
)

SELECT

u.id,
r.id

FROM users u,
roles r

WHERE

u.email='operations@eaasgrid.com'

AND r.name='OPERATIONS'


ON CONFLICT DO NOTHING;


EOF



echo "[6/7] Validation"


psql "$DATABASE_URL" <<'EOF'


SELECT

u.email,
r.name AS role,
u.status

FROM users u

JOIN user_roles ur
ON u.id=ur.user_id

JOIN roles r
ON r.id=ur.role_id

ORDER BY u.email;


EOF



echo "[7/7] Complete"

echo ""
echo "Created accounts:"
echo ""
echo "ADMIN"
echo "admin@eaasgrid.com"
echo "Password: Admin@12345"
echo ""
echo "OPERATIONS"
echo "operations@eaasgrid.com"
echo "Password: Operations@12345"
echo ""
