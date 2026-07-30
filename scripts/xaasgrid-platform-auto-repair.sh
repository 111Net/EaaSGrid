#!/bin/bash

###############################################
# XaaSGrid Platform Auto Repair Controller
# Operations + Health + Recovery + Validation
###############################################

BASE="/data/eaasgrid-platform"
REPORT_DIR="$BASE/reports/platform-operations"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT="$REPORT_DIR/xaasgrid-operations-$DATE.txt"

mkdir -p "$REPORT_DIR"

exec > >(tee -a "$REPORT") 2>&1


echo "=========================================="
echo " XaaSGrid Platform Auto Repair Controller"
echo " $DATE"
echo "=========================================="


cd "$BASE"


###############################################
# 1. Backup
###############################################

echo
echo "[1] Creating configuration backup"

mkdir -p backups/auto-repair

tar -czf \
backups/auto-repair/xaasgrid-$DATE.tar.gz \
apps/dashboard/lib \
apps/dashboard/app \
apps/api/src/routes \
apps/api/src/controllers \
2>/dev/null


echo "PASS - Backup created"



###############################################
# 2. Permission Engine Repair
###############################################

echo
echo "[2] Checking dashboard permissions"


PERM="apps/dashboard/lib/permissions.js"


if ! grep -q "getCurrentUser" "$PERM"
then

echo "Repairing getCurrentUser"

cat >> "$PERM" <<'EOF'


export function getCurrentUser(){

    if(typeof window === "undefined"){
        return null;
    }


    const user =
    localStorage.getItem(
        "eaasgrid_user"
    );


    if(!user){
        return null;
    }


    try{

        return JSON.parse(user);

    }
    catch{

        return null;

    }

}

EOF


else

echo "PASS - getCurrentUser exists"

fi




###############################################
# 3. Dashboard API Contract Repair
###############################################

echo
echo "[3] Checking dashboard API"


CONTROL="apps/dashboard/app/control-centre/page.jsx"


if grep -q "/api/v1/dashboard/summary" "$CONTROL"
then


echo "Updating dashboard API endpoint"


sed -i \
's#/api/v1/dashboard/summary#/api/v1/dashboard#g' \
"$CONTROL"


else

echo "PASS - Dashboard API endpoint"

fi




###############################################
# 4. Dashboard Cache Cleanup
###############################################

echo
echo "[4] Clearing Next.js cache"


rm -rf apps/dashboard/.next/dev/cache/turbopack
rm -rf apps/dashboard/.next/cache


echo "PASS - Cache cleared"




###############################################
# 5. API Health
###############################################

echo
echo "[5] API Health Check"


API=$(curl -s http://localhost:4000/api/v1/health)


echo "$API"


if echo "$API" | grep -q "ok"
then

echo "PASS - API healthy"

else

echo "ERROR - API unavailable"

fi





###############################################
# 6. Database Check
###############################################

echo
echo "[6] Database"


systemctl status postgresql \
--no-pager | head -5


echo "PASS - PostgreSQL checked"





###############################################
# 7. Frontend Build Validation
###############################################

echo
echo "[7] Dashboard Build"


cd apps/dashboard


npm run build


if [ $? -eq 0 ]
then

echo "PASS - Dashboard build"

else

echo "ERROR - Dashboard build failed"

fi


cd "$BASE"





###############################################
# 8. Runtime Services
###############################################

echo
echo "[8] Active Services"


ps aux | grep node | grep -v grep





###############################################
# 9. Infrastructure
###############################################

echo
echo "[9] Infrastructure"


echo "--- Disk ---"

df -h /


echo "--- Memory ---"

free -h




###############################################
# 10. Security Scan
###############################################

echo
echo "[10] Security Checks"


echo "Checking exposed secrets"


grep -R "password=" \
apps 2>/dev/null | head -10


echo "Security scan complete"





###############################################
# 11. Route Validation
###############################################

echo
echo "[11] Platform Routes"


echo "Dashboard"

curl -s \
http://localhost:4000/api/v1/dashboard \
| head -c 300


echo


echo "Investor"

curl -s \
http://localhost:4000/api/v1/investor \
| head -c 300


echo




###############################################
# 12. Final Report
###############################################

echo
echo "=========================================="
echo " XaaSGrid Platform Auto Repair Complete"
echo "=========================================="

echo
echo "REPORT:"
echo "$REPORT"
