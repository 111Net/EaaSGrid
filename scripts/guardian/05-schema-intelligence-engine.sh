#!/bin/bash

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports/schema-intelligence-$(date +%Y-%m-%d_%H-%M-%S).log"

mkdir -p "$ROOT/reports"

exec > >(tee -a "$REPORT") 2>&1


echo "============================================"
echo " EaaSGrid Schema Intelligence Engine"
echo " Module 05"
echo "$(date)"
echo "============================================"


PASS=0
FAIL=0


echo
echo "DATABASE DISCOVERY"
echo "=================="


DB="eaas_db"


sudo -u postgres psql "$DB" <<EOF


\echo 'TABLE INVENTORY'

SELECT table_name
FROM information_schema.tables
WHERE table_schema='public'
ORDER BY table_name;



\echo 'USER TABLE SCHEMA'

SELECT 
column_name,
data_type
FROM information_schema.columns
WHERE table_name='users'
ORDER BY ordinal_position;



\echo 'ROLE TABLE SCHEMA'

SELECT
column_name,
data_type
FROM information_schema.columns
WHERE table_name='roles'
ORDER BY ordinal_position;



\echo 'PERMISSION TABLE SCHEMA'

SELECT
column_name,
data_type
FROM information_schema.columns
WHERE table_name='permissions'
ORDER BY ordinal_position;



EOF


echo
echo "APPLICATION SCHEMA REFERENCES"
echo "============================="


grep -R "role_id" \
"$ROOT/apps/api/src" \
--include="*.js" \
| head -20



grep -R "password_hash" \
"$ROOT/apps/api/src" \
--include="*.js" \
| head -20



echo
echo "GENERATING GUARDIAN SCHEMA MAP"


cat > "$ROOT/scripts/guardian/schema-map.json" <<EOF
{
 "database":"eaas_db",
 "identity":{
   "users_table":"users",
   "email_column":"email",
   "password_column":"password_hash",
   "role_reference":"role_id"
 },
 "rbac":{
   "roles_table":"roles",
   "permissions_table":"permissions",
   "mapping_table":"role_permissions"
 },
 "generated":"$(date)"
}
EOF


if [ -f "$ROOT/scripts/guardian/schema-map.json" ]
then

echo "[PASS] Schema map generated"
PASS=$((PASS+1))

else

echo "[FAIL] Schema map missing"
FAIL=$((FAIL+1))

fi



echo
echo "VALIDATING REQUIRED SECURITY COLUMNS"


sudo -u postgres psql "$DB" <<EOF

SELECT
CASE
WHEN EXISTS(
SELECT 1 FROM information_schema.columns
WHERE table_name='users'
AND column_name='password_hash'
)
THEN 'PASSWORD HASH OK'
ELSE 'PASSWORD HASH MISSING'
END;


SELECT
CASE
WHEN EXISTS(
SELECT 1 FROM information_schema.columns
WHERE table_name='users'
AND column_name='role_id'
)
THEN 'ROLE LINK OK'
ELSE 'ROLE LINK MISSING'
END;


EOF



echo
echo "============================================"
echo "SUMMARY"
echo "PASS:$PASS"
echo "FAIL:$FAIL"


if [ "$FAIL" -eq 0 ]
then
echo "STATUS: SCHEMA INTELLIGENCE READY"
else
echo "STATUS: REVIEW REQUIRED"
fi


echo
echo "REPORT:"
echo "$REPORT"

echo "============================================"
