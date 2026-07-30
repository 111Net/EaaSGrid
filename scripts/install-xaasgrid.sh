#!/bin/bash

set -e

echo "======================================"
echo " XaaSGrid Platform Installer"
echo "======================================"

echo "[1] Checking operating system"

if ! grep -q "Ubuntu" /etc/os-release; then
    echo "Unsupported OS"
    exit 1
fi


echo "[2] Checking dependencies"


for cmd in git node npm psql; do

 if command -v $cmd >/dev/null 2>&1
 then
    echo "$cmd OK"
 else
    echo "$cmd missing"
 fi

done


echo "[3] Repository location"

echo "Platform:"
pwd


echo "[4] Environment"

if [ ! -f .env.example ]
then

cat > .env.example <<ENV

NODE_ENV=production

DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=eaas_db
DATABASE_USER=eaas_user

API_PORT=4000
DASHBOARD_PORT=3000

ENV

fi


if [ ! -f .env ]
then

cp .env.example .env

fi


echo "[5] Installing API"

cd apps/api

npm install

cd ../..


echo "[6] Installing Dashboard"

cd apps/dashboard

npm install

cd ../..


echo "[7] Validation"


if [ -d apps/api ]
then
echo "API PRESENT"
else
echo "API MISSING"
fi


if [ -d apps/dashboard ]
then
echo "DASHBOARD PRESENT"
else
echo "DASHBOARD MISSING"
fi


echo "======================================"
echo " XaaSGrid Installation Complete"
echo "======================================"

