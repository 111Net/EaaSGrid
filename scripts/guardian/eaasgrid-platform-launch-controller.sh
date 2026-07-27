#!/bin/bash

#############################################
# EaaSGrid Platform Launch Controller
# Quick Repair Version 2.0
#
# Starts:
# - API
# - Dashboard
# - Investor Portal
#
# Checks:
# - PostgreSQL
# - Redis/Docker Redis
# - Ports
# - Health endpoints
#############################################

set -u

ROOT="/data/eaasgrid-platform"
LOGDIR="/tmp/eaasgrid"

mkdir -p $LOGDIR


echo "================================"
echo " EaaSGrid Platform Launcher"
echo " Quick Repair v2.0"
echo "================================"


#############################################
# DATABASE
#############################################

echo ""
echo "[1] Checking PostgreSQL"

if systemctl is-active --quiet postgresql
then
    echo "PostgreSQL OK"
else
    echo "Starting PostgreSQL"
    sudo systemctl start postgresql
fi



#############################################
# REDIS CHECK
#############################################

echo ""
echo "[2] Checking Redis"


if systemctl list-unit-files | grep -q redis
then

    sudo systemctl start redis || true
    echo "Redis service checked"

else

    echo "System Redis not installed"

    if command -v docker >/dev/null
    then

        if docker ps | grep -q redis
        then
            echo "Docker Redis running"
        else
            echo "Docker Redis not running"
        fi

    fi

fi



#############################################
# CLEAN OLD DEVELOPMENT PROCESSES
#############################################

echo ""
echo "[3] Checking old processes"


for PORT in 3000 3001 4000
do

PID=$(lsof -ti:$PORT || true)

if [ ! -z "$PID" ]
then

echo "Port $PORT occupied by PID $PID"

fi

done



#############################################
# FUNCTION TO START APP
#############################################

start_app()
{

APP=$1
PORT=$2

APP_PATH="$ROOT/$APP"


echo ""
echo "Starting $APP"


if [ ! -d "$APP_PATH" ]
then

echo "Missing directory $APP_PATH"

return

fi


cd $APP_PATH


if [ ! -d node_modules ]
then

echo "Installing dependencies"

npm install

fi



LOGFILE="$LOGDIR/$(echo $APP | tr '/' '-').log"


echo "Log:"
echo $LOGFILE


nohup npm run dev > "$LOGFILE" 2>&1 &


sleep 8



if lsof -i:$PORT >/dev/null
then

echo "$APP RUNNING on port $PORT"

else

echo "$APP FAILED"

echo "Check:"
echo "cat $LOGFILE"

fi


}



#############################################
# START SERVICES
#############################################

echo ""
echo "[4] Starting API"

start_app apps/api 4000



echo ""
echo "[5] Starting Dashboard"

start_app apps/dashboard 3000



echo ""
echo "[6] Starting Investor Portal"

start_app apps/investor-portal 3001



#############################################
# HEALTH CHECK
#############################################

echo ""
echo "================================"
echo " Health Check"
echo "================================"


echo ""
echo "API"

curl -s http://localhost:4000/api/v1/health || echo "API FAILED"



echo ""
echo ""
echo "Dashboard"

curl -I -s http://localhost:3000 | head -1 || echo "Dashboard FAILED"



echo ""
echo ""
echo "Investor Portal"

curl -I -s http://localhost:3001 | head -1 || echo "Investor Portal FAILED"



#############################################
# FINAL OUTPUT
#############################################

echo ""
echo "================================"
echo " EaaSGrid Platform Status"
echo "================================"


echo ""
echo "Dashboard:"
echo "http://192.168.100.21:3000"


echo ""
echo "Investor Portal:"
echo "http://192.168.100.21:3001"


echo ""
echo "API:"
echo "http://192.168.100.21:4000"



echo ""
echo "Logs:"
echo "$LOGDIR"


echo ""
echo "Launch Complete"
