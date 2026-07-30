#!/bin/bash

############################################
# XaaSGrid Authentication Validation Engine
############################################


auth_validation() {

echo "[AUTH] Running authentication validation"

ROOT_DIR="/data/eaasgrid-platform"
API_DIR="$ROOT_DIR/apps/api"


echo
echo "Checking API directory..."

if [ -d "$API_DIR" ]; then
    echo "API directory OK"
else
    echo "API directory missing"
fi


echo
echo "Searching authentication routes..."

AUTH_FILES=$(find "$API_DIR" \
-path "*/node_modules" -prune \
-o -name "auth.routes.js" -print)


if [ -n "$AUTH_FILES" ]; then

    echo "$AUTH_FILES"

else

    echo "Authentication route missing"

fi


echo
echo "Checking environment configuration"


if [ -f "$API_DIR/.env" ]; then

    echo "API .env detected"

else

    echo "API .env missing"

fi


echo
echo "Checking Express authentication registration"


if grep -R "auth.routes" "$API_DIR/src" >/dev/null 2>&1
then

echo "Auth router import detected"

else

echo "Auth router import missing"

fi


if grep -R "api/v1" "$API_DIR/src" >/dev/null 2>&1
then

echo "API version routing detected"

fi


echo
echo "Checking Node API process"

if pgrep -f "node src/server.js" >/dev/null
then

echo "Node API process detected"

else

echo "Node API process missing"

fi


echo
echo "Authentication validation complete"

}
