#!/bin/bash

#############################################
# XaaSGrid Platform Ltd
# Guardian Self-Healing Controller
# Sprint 0.4 Repository Cleanup Baseline
#############################################

set -u

PROJECT="/data/eaasgrid-platform"
LOG_DIR="$PROJECT/archive/logs"

mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/guardian-$(date +%F).log"

exec > >(tee -a "$LOG_FILE") 2>&1


echo "======================================"
echo " XaaSGrid Platform Ltd"
echo " Guardian Self-Healing Controller"
echo " $(date '+%Y-%m-%d_%H-%M-%S')"
echo "======================================"



#############################################
# 1 SYSTEM CHECK
#############################################

echo "[1] Checking system"

df -h

echo ""

free -h

echo ""

uptime



#############################################
# 2 NETWORK CHECK
#############################################

echo "[2] Network"

SERVER_IP=$(hostname -I | awk '{print $1}')

echo "Server IP: $SERVER_IP"

ping -c 2 8.8.8.8 || echo "WARNING: Internet connectivity issue"



#############################################
# 3 PORT CHECK
#############################################

echo "[3] Checking ports"


check_port()
{
PORT=$1

if lsof -i :"$PORT" >/dev/null 2>&1
then
    PID=$(lsof -ti :"$PORT")
    echo "Port $PORT used by $PID"
else
    echo "Port $PORT available"
fi

}


check_port 4000
check_port 3000
check_port 3001
check_port 3002



#############################################
# 4 POSTGRESQL CHECK
#############################################

echo "[4] PostgreSQL"


if systemctl is-active --quiet postgresql
then
    echo "Postgres OK"
else
    echo "Postgres inactive - attempting restart"

    sudo systemctl restart postgresql

fi



#############################################
# 5 DATABASE CHECK
#############################################

echo "[5] Database"


sudo -u postgres psql \
-P pager=off \
-c "\l" \
|| echo "Database check failed"



#############################################
# 6 REDIS CHECK
#############################################

echo "[6] Redis"


if systemctl list-unit-files | grep -qi redis
then

    if systemctl is-active --quiet redis
    then
        echo "Redis running"
    else
        echo "Redis installed but stopped"
        sudo systemctl restart redis
    fi

else

    echo "Redis not installed - optional component skipped"

fi



#############################################
# 7 API HEALTH CHECK
#############################################

echo "[7] XaaSGrid API Health"


if curl -fs http://127.0.0.1:4000/api/v1/health >/dev/null
then

echo "XaaSGrid API healthy"

else

echo "WARNING: API health check failed"

fi



#############################################
# 8 STORAGE CHECK
#############################################

echo "[8] Storage Monitoring"


ROOT_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')


if [ "$ROOT_USAGE" -gt 90 ]
then

echo "WARNING: Root filesystem above 90%"

else

echo "Root filesystem healthy: ${ROOT_USAGE}%"

fi



#############################################
# 9 RUNNING SERVICES
#############################################

echo "[9] Service Status"


echo ""

echo "Node Processes"

ps aux | grep node | grep -v grep || echo "No node processes"


echo ""

echo "Python Processes"

ps aux | grep python | grep -v grep || echo "No python processes"



#############################################
# COMPLETE
#############################################

echo ""
echo "======================================"
echo " XaaSGrid Guardian Completed"
echo " Log:"
echo " $LOG_FILE"
echo "======================================"
