#!/bin/bash

echo "============================================"
echo " EaaSGrid Role Authorization Intelligence Engine"
echo " Module 11"
date
echo "============================================"


BASE="/data/eaasgrid-platform/apps/dashboard"

REPORT="/data/eaasgrid-platform/reports/role-authorization-$(date +%F_%H-%M-%S).log"

MAP="/data/eaasgrid-platform/scripts/guardian/role-authorization-map.json"


echo ""
echo "1. Checking middleware authorization layer"
echo "--------------------------------------------"

if [ -f "$BASE/middleware.js" ]; then

echo "[PASS] middleware.js found"

grep -n "protectedRoutes" \
"$BASE/middleware.js"

else

echo "[FAIL] middleware.js missing"

fi



echo ""
echo "2. Checking dashboard role routes"
echo "--------------------------------------------"


ROUTES=(
"control-centre"
"operations"
"partner"
"investor"
"customer"
"collaborator"
)


for route in "${ROUTES[@]}"
do

echo ""

echo "Testing route: /$route"


if [ -d "$BASE/app/$route" ]; then

echo "[PASS] app/$route exists"

elif [ -d "$BASE/pages/$route" ]; then

echo "[PASS] pages/$route exists"

else

echo "[WARN] route folder missing"

fi

done



echo ""
echo "3. Checking authentication storage"
echo "--------------------------------------------"


grep -R "eaasgrid_token" \
"$BASE/lib" \
"$BASE/middleware.js" \
2>/dev/null



echo ""
echo "4. Checking role references"
echo "--------------------------------------------"


grep -R "\"ADMIN\"" \
"$BASE" \
--exclude-dir=.next \
2>/dev/null


grep -R "\"OPERATIONS\"" \
"$BASE" \
--exclude-dir=.next \
2>/dev/null


grep -R "\"INVESTOR\"" \
"$BASE" \
--exclude-dir=.next \
2>/dev/null



echo ""
echo "5. Creating role authorization map"
echo "--------------------------------------------"


cat > "$MAP" <<EOF

{
  "roles": {

    "ADMIN": {
      "landing": "/control-centre",
      "permissions": [
        "platform",
        "users",
        "finance",
        "operations"
      ]
    },

    "OPERATIONS": {
      "landing": "/operations",
      "permissions": [
        "sites",
        "devices",
        "monitoring"
      ]
    },

    "PARTNER": {
      "landing": "/partner",
      "permissions": [
        "projects",
        "services"
      ]
    },

    "INVESTOR": {
      "landing": "/investor",
      "permissions": [
        "portfolio",
        "finance",
        "reports"
      ]
    },

    "CUSTOMER": {
      "landing": "/customer",
      "permissions": [
        "usage",
        "billing",
        "support"
      ]
    },

    "COLLABORATOR": {
      "landing": "/collaborator",
      "permissions": [
        "shared-projects",
        "communication"
      ]
    }

  }
}

EOF


echo "[PASS] Role authorization map created"



echo ""
echo "6. Saving report"
echo "--------------------------------------------"


{
echo "EaaSGrid Role Authorization Intelligence Report"
echo ""
echo "Date:"
date
echo ""
echo "Role Map:"
cat "$MAP"

} > "$REPORT"



echo ""
echo "============================================"
echo " COMPLETE"
echo ""
echo "REPORT:"
echo "$REPORT"
echo ""
echo "MAP:"
echo "$MAP"
echo "============================================"
