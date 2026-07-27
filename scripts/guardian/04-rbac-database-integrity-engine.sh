#!/bin/bash

#############################################
# EaaSGrid RBAC Database Integrity Engine
# Module 04
#############################################

ROOT="/data/eaasgrid-platform"
REPORT="$ROOT/reports"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$REPORT"

LOG="$REPORT/rbac-integrity-$DATE.log"

exec > >(tee -a "$LOG") 2>&1


echo "============================================"
echo " EaaSGrid RBAC Database Integrity Engine"
echo " Module 04"
echo "$DATE"
echo "============================================"


FAIL=0


check()
{
TITLE=$1
CMD=$2

echo ""
echo "--------------------------------"
echo "$TITLE"
echo "--------------------------------"

eval "$CMD"

if [ $? -eq 0 ]
then
    echo "[PASS]"
else
    echo "[FAIL]"
    FAIL=$((FAIL+1))
fi

}



#############################################
# Database connection
#############################################

check \
"PostgreSQL available" \
"systemctl is-active --quiet postgresql"



#############################################
# Database existence
#############################################

check \
"eaas_db exists" \
"sudo -u postgres psql -lqt | grep eaas_db"



#############################################
# Tables
#############################################

echo ""
echo "RBAC TABLE INVENTORY"

sudo -u postgres psql \
-d eaas_db \
-c "\dt"



#############################################
# Users table
#############################################

echo ""
echo "USERS"

sudo -u postgres psql \
-d eaas_db \
-c "
SELECT id,email,role
FROM users;
"



#############################################
# User count
#############################################

USER_COUNT=$(sudo -u postgres psql \
-d eaas_db \
-tAc "SELECT count(*) FROM users;")


echo ""
echo "USER COUNT:"
echo "$USER_COUNT"


if [ "$USER_COUNT" -gt 0 ]
then
echo "[PASS] Users exist"
else
echo "[FAIL] No users found"
FAIL=$((FAIL+1))
fi



#############################################
# Roles table
#############################################

echo ""
echo "ROLES"

sudo -u postgres psql \
-d eaas_db \
-c "
SELECT * FROM roles;
"



ROLE_COUNT=$(sudo -u postgres psql \
-d eaas_db \
-tAc "SELECT count(*) FROM roles;")


if [ "$ROLE_COUNT" -gt 0 ]
then
echo "[PASS] Roles exist"
else
echo "[FAIL] Roles missing"
FAIL=$((FAIL+1))
fi



#############################################
# Permissions
#############################################

echo ""
echo "PERMISSIONS"


sudo -u postgres psql \
-d eaas_db \
-c "
SELECT * FROM permissions;
"



#############################################
# Role Permission Mapping
#############################################

echo ""
echo "ROLE PERMISSION MAP"


sudo -u postgres psql \
-d eaas_db \
-c "
SELECT *
FROM role_permissions;
"



#############################################
# Duplicate emails
#############################################

echo ""
echo "CHECKING DUPLICATE USERS"


sudo -u postgres psql \
-d eaas_db \
-c "
SELECT email,count(*)
FROM users
GROUP BY email
HAVING count(*) > 1;
"



#############################################
# Sessions
#############################################

echo ""
echo "ACTIVE SESSIONS"


sudo -u postgres psql \
-d eaas_db \
-c "
SELECT *
FROM sessions;
"



#############################################
# Password field check
#############################################

echo ""
echo "PASSWORD HASH CHECK"


sudo -u postgres psql \
-d eaas_db \
-c "
SELECT email,
CASE
WHEN password IS NULL THEN 'MISSING'
WHEN length(password)<20 THEN 'INVALID'
ELSE 'OK'
END
FROM users;
"



#############################################
# ADMIN validation
#############################################

echo ""
echo "ADMIN ACCOUNT CHECK"


sudo -u postgres psql \
-d eaas_db \
-c "
SELECT email,role
FROM users
WHERE email='admin@eaasgrid.com';
"



#############################################
# Summary
#############################################

echo ""

echo "============================================"
echo "RBAC DATABASE VALIDATION COMPLETE"
echo "FAILURES:"
echo "$FAIL"
echo ""
echo "REPORT:"
echo "$LOG"
echo "============================================"


exit $FAIL
