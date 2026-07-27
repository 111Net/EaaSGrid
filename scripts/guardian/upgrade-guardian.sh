#!/bin/bash

set -e

BASE="/data/eaasgrid-platform"
GUARDIAN="$BASE/scripts/guardian/eaasgrid-platform-auto-repair.sh"
LOGDIR="$BASE/logs/guardian"

echo "======================================"
echo "EAASGrid Guardian Upgrade"
echo "======================================"

mkdir -p "$LOGDIR"

DATE=$(date +%F-%H%M%S)


echo "[1] Backing up existing guardian..."

if [ -f "$GUARDIAN" ]; then
    cp "$GUARDIAN" \
    "$GUARDIAN.backup.$DATE"

    echo "Backup created"
fi


echo "[2] Writing new self-healing controller..."


cat > "$GUARDIAN" <<'EOF'
#!/bin/bash

set -e

BASE="/data/eaasgrid-platform"
API="$BASE/apps/api"
LOGDIR="$BASE/logs/guardian"

mkdir -p "$LOGDIR"

LOG="$LOGDIR/guardian-$(date +%F-%H%M%S).log"


exec > >(tee -a "$LOG") 2>&1


echo "======================================"
echo "EAASGrid Automatic Repair v2"
echo "$(date)"
echo "======================================"


echo ""
echo "[1] Directory checks"

if [ -d "$API" ]; then
    echo "API directory OK"
else
    echo "API directory missing"
    exit 1
fi



echo ""
echo "[2] Checking auth route"


APPFILE="$API/src/app.js"


if grep -q 'app.use("/api/auth"' "$APPFILE"; then

    echo "Old auth mount detected"

    sed -i \
    's#app.use("/api/auth"#app.use("/api/v1/auth"#' \
    "$APPFILE"

    echo "Auth route repaired"

else

    if grep -q 'app.use("/api/v1/auth"' "$APPFILE"; then
        echo "Auth route OK"
    else
        echo "Auth route missing"
    fi

fi



echo ""
echo "[3] Cleaning stale API processes"


PIDS=$(lsof -ti:4000 || true)


if [ ! -z "$PIDS" ]; then

    echo "Stopping processes:"
    echo "$PIDS"

    kill -9 $PIDS

    sleep 3

else

    echo "No stale API process"

fi



echo ""
echo "[4] Starting API"


cd "$API"


nohup node src/server.js \
> "$LOGDIR/api.log" 2>&1 &


sleep 5


echo "API started"



echo ""
echo "[5] API health check"


HEALTH=$(curl -s \
http://192.168.100.21:4000/api/v1/health)


echo "$HEALTH"


if echo "$HEALTH" | grep -q "ok"; then

    echo "HEALTH STATUS: GREEN"

else

    echo "HEALTH STATUS: RED"

fi



echo ""
echo "[6] Authentication check"


LOGIN=$(curl -s \
-X POST \
http://192.168.100.21:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}')


echo "$LOGIN"


if echo "$LOGIN" | grep -q "token"; then

    echo "AUTH STATUS: GREEN"

else

    echo "AUTH STATUS: RED"

fi



echo ""
echo "[7] Dashboard processes"


ps aux | grep next | grep -v grep || true



echo ""
echo "[8] Port status"


ss -tulpn | grep -E ':3000|:3001|:4000' || true



echo ""
echo "======================================"
echo "EAASGrid Repair Completed"
echo "======================================"

EOF


chmod +x "$GUARDIAN"


echo ""
echo "[3] Guardian upgraded successfully"

echo ""
echo "Run:"
echo "$GUARDIAN"
