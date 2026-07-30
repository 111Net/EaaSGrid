#!/bin/bash

############################################
# XaaSGrid Dashboard API Validation Engine
############################################


dashboard_api_validation() {


echo "[DASHBOARD API] Running dashboard API validation"


ROOT="/data/eaasgrid-platform/apps/dashboard"


echo
echo "Checking dashboard directory"


if [ -d "$ROOT" ]
then
echo "Dashboard directory OK"
else
echo "Dashboard directory missing"
fi


echo
echo "Checking package configuration"


if [ -f "$ROOT/package.json" ]
then
echo "package.json detected"
else
echo "package.json missing"
fi


echo
echo "Checking environment"


if [ -f "$ROOT/.env.local" ]
then

echo ".env.local detected"

cat "$ROOT/.env.local"

else

echo ".env.local missing"

fi



echo
echo "Checking authentication API references"


AUTH=$(grep -R "/auth/login" "$ROOT/lib" 2>/dev/null)


if [ -n "$AUTH" ]
then

echo "Authentication API detected"
echo "$AUTH"

else

echo "Authentication API reference missing"

fi



echo
echo "Checking dashboard API URL"


grep -R "NEXT_PUBLIC_API_URL" "$ROOT" \
--exclude-dir=node_modules \
2>/dev/null



echo
echo "Dashboard API validation complete"

}
