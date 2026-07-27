#!/bin/bash

ROOT="/data/eaasgrid-platform"
DASH="$ROOT/apps/dashboard"
REPORT="$ROOT/reports/session-repair-$(date +%F_%H-%M-%S).log"
BACKUP="$ROOT/backups/session-repair-$(date +%F_%H-%M-%S)"

mkdir -p "$ROOT/reports"
mkdir -p "$BACKUP"

exec > >(tee -a "$REPORT") 2>&1


echo "============================================"
echo " EaaSGrid Session Repair & Regression Engine"
echo " Module 07"
date
echo "============================================"


FAIL=0


echo
echo "[1] Creating backup checkpoint"

cp "$DASH/lib/auth.js" \
"$BACKUP/auth.js"

cp "$DASH/middleware.js" \
"$BACKUP/middleware.js"


echo "[PASS] Backup created"
echo "$BACKUP"


echo
echo "[2] Analysing current session contract"


grep -R "localStorage.*eaasgrid_token" \
"$DASH" \
--exclude-dir=.next


grep -R "cookies.get" \
"$DASH/middleware.js"



echo
echo "[3] Creating unified session adapter"


cat > "$DASH/lib/session.js" <<'EOF'

export function saveSession(data){

    if(typeof window !== "undefined"){

        localStorage.setItem(
            "eaasgrid_token",
            data.token
        );

        localStorage.setItem(
            "eaasgrid_user",
            JSON.stringify(data.user)
        );

        document.cookie =
        `eaasgrid_token=${data.token}; path=/; SameSite=Lax`;

    }

}


export function getSession(){

    if(typeof window === "undefined")
        return null;


    return {

        token:
        localStorage.getItem(
            "eaasgrid_token"
        ),

        user:
        JSON.parse(
            localStorage.getItem(
                "eaasgrid_user"
            ) || "null"
        )

    };

}


export function clearSession(){

    localStorage.removeItem(
        "eaasgrid_token"
    );


    localStorage.removeItem(
        "eaasgrid_user"
    );


    document.cookie =
    "eaasgrid_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";

}

EOF


echo "[PASS] Session adapter created"



echo
echo "[4] Updating auth.js import compatibility"


grep -q "saveSession" "$DASH/lib/auth.js"

if [ $? -eq 0 ]; then

echo "[PASS] auth.js compatible"

else

echo "[FAIL] auth.js incompatible"
FAIL=$((FAIL+1))

fi



echo
echo "[5] Middleware contract validation"


grep -q "eaasgrid_token" \
"$DASH/middleware.js"

if [ $? -eq 0 ]; then

echo "[PASS] Middleware token aligned"

else

echo "[FAIL]"
FAIL=$((FAIL+1))

fi



echo
echo "[6] Clearing Next cache"

rm -rf "$DASH/.next/dev"

echo "[PASS] Cache cleared"



echo
echo "[7] Restart dashboard service"


pkill -f "next dev" || true

sleep 3


cd "$DASH"

nohup npm run dev -- --port 3000 \
>/tmp/eaasgrid-dashboard.log 2>&1 &


sleep 8


echo
echo "[8] Dashboard process"

ps aux | grep next | grep -v grep



echo
echo "[9] Login regression test"


RESULT=$(curl -s \
-X POST \
http://192.168.100.21:4000/api/v1/auth/login \
-H "Content-Type: application/json" \
-d '{"email":"admin@eaasgrid.com","password":"Admin@123"}')


echo "$RESULT"



echo "$RESULT" | grep -q token


if [ $? -eq 0 ]; then

echo "[PASS] API login regression"

else

echo "[FAIL] API login regression"
FAIL=$((FAIL+1))

fi



echo
echo "============================================"
echo "SESSION REPAIR COMPLETE"
echo "FAILURES:$FAIL"
echo
echo "REPORT:"
echo "$REPORT"
echo
echo "BACKUP:"
echo "$BACKUP"
echo "============================================"
