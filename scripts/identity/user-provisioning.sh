#!/usr/bin/env bash

set -e

echo "======================================"
echo "EaaSGrid Identity User Provisioning"
echo "======================================"

cd /data/eaasgrid-platform

export $(grep -v '^#' .env | xargs)

echo "[1/7] Checking bcrypt"

cd apps/api

npm install bcrypt >/dev/null 2>&1

ADMIN_HASH=$(node -e "const bcrypt=require('bcrypt'); bcrypt.hash('Admin@12345',12).then(console.log)")
OPERATIONS_HASH=$(node -e "const bcrypt=require('bcrypt'); bcrypt.hash('Operations@12345',12).then(console.log)")
PARTNER_HASH=$(node -e "const bcrypt=require('bcrypt'); bcrypt.hash('Partner@12345',12).then(console.log)")
INVESTOR_HASH=$(node -e "const bcrypt=require('bcrypt'); bcrypt.hash('Investor@12345',12).then(console.log)")

cd ../..

echo "[2/7] Creating users"


psql "$DATABASE_URL" <<SQL

INSERT INTO users
(email,password_hash,full_name,role_id)

SELECT
'admin@eaasgrid.com',
'$ADMIN_HASH',
'EaaSGrid Administrator',
id
FROM roles
WHERE name='ADMIN'

ON CONFLICT(email)
DO UPDATE SET password_hash=EXCLUDED.password_hash;



INSERT INTO users
(email,password_hash,full_name,role_id)

SELECT
'operations@eaasgrid.com',
'$OPERATIONS_HASH',
'EaaSGrid Operations',
id
FROM roles
WHERE name='OPERATIONS'

ON CONFLICT(email)
DO UPDATE SET password_hash=EXCLUDED.password_hash;



INSERT INTO users
(email,password_hash,full_name,role_id)

SELECT
'partner@eaasgrid.com',
'$PARTNER_HASH',
'EaaSGrid Partner',
id
FROM roles
WHERE name='PARTNER'

ON CONFLICT(email)
DO UPDATE SET password_hash=EXCLUDED.password_hash;



INSERT INTO users
(email,password_hash,full_name,role_id)

SELECT
'investor@eaasgrid.com',
'$INVESTOR_HASH',
'EaaSGrid Investor',
id
FROM roles
WHERE name='INVESTOR'

ON CONFLICT(email)
DO UPDATE SET password_hash=EXCLUDED.password_hash;


SQL


echo "[3/7] Validation"

psql "$DATABASE_URL" <<SQL

SELECT 
u.email,
r.name AS role
FROM users u
JOIN roles r
ON u.role_id=r.id;

SQL


echo "[4/7] Identity users created"

echo "
ADMIN:
admin@eaasgrid.com
Admin@12345

OPERATIONS:
operations@eaasgrid.com
Operations@12345

PARTNER:
partner@eaasgrid.com
Partner@12345

INVESTOR:
investor@eaasgrid.com
Investor@12345
"


echo "[5/7] Password hashing complete"

echo "[6/7] Database validation complete"

echo "[7/7] COMPLETE"
