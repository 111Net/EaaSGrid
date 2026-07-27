#!/usr/bin/env bash

set -e

DB="eaas_db"
USER="eaas_user"

REPORT="docs/db-rbac-audit-report.txt"

mkdir -p docs


echo "EaaSGrid RBAC Database Audit"
echo "============================" > "$REPORT"
date >> "$REPORT"


echo "" >> "$REPORT"
echo "DATABASES" >> "$REPORT"
echo "----------" >> "$REPORT"

sudo -u postgres psql -c "\l" >> "$REPORT"


echo "" >> "$REPORT"
echo "TABLES" >> "$REPORT"
echo "------" >> "$REPORT"

sudo -u postgres psql -d "$DB" -c "\dt" >> "$REPORT"


echo "" >> "$REPORT"
echo "USERS STRUCTURE" >> "$REPORT"
echo "---------------" >> "$REPORT"

sudo -u postgres psql -d "$DB" -c "\d users" >> "$REPORT"


echo "" >> "$REPORT"
echo "ROLES STRUCTURE" >> "$REPORT"
echo "---------------" >> "$REPORT"

sudo -u postgres psql -d "$DB" -c "\d roles" >> "$REPORT"


echo "" >> "$REPORT"
echo "USER DATA" >> "$REPORT"
echo "---------" >> "$REPORT"

sudo -u postgres psql -d "$DB" \
-c "SELECT email,full_name,active,role_id FROM users;" \
>> "$REPORT"


echo "" >> "$REPORT"
echo "ROLE DATA" >> "$REPORT"
echo "---------" >> "$REPORT"

sudo -u postgres psql -d "$DB" \
-c "SELECT * FROM roles;" \
>> "$REPORT"


echo ""
echo "AUDIT COMPLETE"
echo "REPORT: $REPORT"
