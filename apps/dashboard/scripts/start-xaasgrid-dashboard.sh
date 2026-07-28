#!/bin/bash


echo "======================================"
echo " XaaSGrid Dashboard Clean Launcher"
echo "======================================"


cd /data/eaasgrid-platform/apps/dashboard || exit 1



echo "[1] Stop old servers"

pkill -9 -f "next-server" 2>/dev/null
pkill -9 -f "next dev" 2>/dev/null
pkill -9 -f "next start" 2>/dev/null



sleep 3



echo "[2] Check ports"



for PORT in 3000 3001 3002 3003 3004
do

PID=$(lsof -ti:$PORT)

if [ ! -z "$PID" ]; then

echo "Cleaning port $PORT"

kill -9 $PID

fi

done



echo "[3] Remove stale Next cache"

rm -rf .next



echo "[4] Validate dashboard"

npm run lint


if [ $? -ne 0 ]; then

echo "Lint failed"

exit 1

fi



echo "[5] Start XaaSGrid Dashboard"


npm run dev
