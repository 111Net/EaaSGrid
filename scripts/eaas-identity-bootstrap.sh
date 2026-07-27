#!/usr/bin/env bash

set -euo pipefail

DB="eaas_db"

REPORT="docs/identity-bootstrap-report.txt"

mkdir -p docs


echo "EaaSGrid Identity Bootstrap"
echo "===========================" > "$REPORT"
date >> "$REPORT"


create_user(){

EMAIL=$1
NAME=$2
ROLE=$3
PASSWORD=$4


HASH=$(node -e "
const bcrypt=require('bcrypt');
bcrypt.hash('$PASSWORD',10)
.then(console.log)
")


sudo -u postgres psql "$DB" <<SQL

INSERT INTO users
(
email,
password_hash,
full_name,
role_id
)

SELECT
'$EMAIL',
'$HASH',
'$NAME',
id

FROM roles

WHERE name='$ROLE'

ON CONFLICT(email)
DO NOTHING;


SQL


echo "$EMAIL | $ROLE" >> "$REPORT"

}


create_user \
"admin@eaasgrid.com" \
"EaaSGrid Administrator" \
"ADMIN" \
"Admin@123"


create_user \
"operations@eaasgrid.com" \
"EaaSGrid Operations" \
"OPERATIONS" \
"Operations@123"


create_user \
"partner@eaasgrid.com" \
"EaaSGrid Partner" \
"PARTNER" \
"Partner@123"


create_user \
"investor@eaasgrid.com" \
"EaaSGrid Investor" \
"INVESTOR" \
"Investor@123"


create_user \
"customer@eaasgrid.com" \
"EaaSGrid Customer" \
"CUSTOMER" \
"Customer@123"


echo ""
echo "Identity bootstrap completed"
echo "Report: $REPORT"
