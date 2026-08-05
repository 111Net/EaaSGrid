#!/bin/bash

set -e


PROJECT="/data/eaasgrid-platform"

REPORT="reports/sprint43.13-production-readiness-$(date +%Y%m%d-%H%M%S).txt"


echo "========================================"
echo "XaaSGrid Sprint 43.13"
echo "Production Readiness Automation"
echo "========================================"


cd $PROJECT


mkdir -p reports
mkdir -p backups/sprint43.13



echo "[1] Creating middleware backups"


cp apps/api/src/middleware/security.js \
backups/sprint43.13/security.js.$(date +%s).bak


cp apps/api/src/middleware/cors.js \
backups/sprint43.13/cors.js.$(date +%s).bak



echo "[2] Checking Node dependencies"


cd apps/api


npm list cors >/dev/null 2>&1 || npm install cors


cd $PROJECT



echo "[3] Updating production CORS"


cat > apps/api/src/middleware/cors.js <<'EOF'
const cors = require("cors");


const allowedOrigins = (
process.env.CORS_ORIGINS ||
"http://localhost:3000,http://localhost:3001"
)
.split(",");



module.exports = cors({

origin(origin, callback){


if(!origin)
{
return callback(null,true);
}


if(
allowedOrigins.includes(origin)
)
{
return callback(null,true);
}


return callback(
new Error("CORS policy blocked request")
);

},


methods:[
"GET",
"POST",
"PUT",
"PATCH",
"DELETE"
],


allowedHeaders:[
"Content-Type",
"Authorization"
],


credentials:true

});
EOF



echo "[4] Updating security headers"


cat > apps/api/src/middleware/security.js <<'EOF'
const securityHeaders = (req,res,next)=>{


res.setHeader(
"X-Content-Type-Options",
"nosniff"
);


res.setHeader(
"X-Frame-Options",
"DENY"
);


res.setHeader(
"Referrer-Policy",
"no-referrer"
);


res.setHeader(
"Permissions-Policy",
"camera=(), microphone=(), geolocation=()"
);


next();

};


module.exports = securityHeaders;
EOF




echo "[5] Docker validation"


docker compose config > /tmp/xaasgrid-compose-validation.txt



echo "[6] Rebuilding API"


docker compose build xaasgrid-api



echo "[7] Restarting production stack"


docker compose up -d



echo "[8] Waiting for health"


sleep 30



echo "[9] Running production checks"


{

echo "======== Sprint 43.13 Certification ========"

date


echo ""

echo "Docker"

docker ps


echo ""

echo "API LIVE"

curl -s http://localhost:4000/api/live


echo ""

echo "API READY"

curl -s http://localhost:4000/api/ready


echo ""

echo "SYSTEM STATUS"

curl -s http://localhost:4000/api/system/status


echo ""

echo "DATABASE"

docker exec xaasgrid-postgres \
psql -U eaas_user -d eaas_db -c "\dt"


} | tee $REPORT




echo "[10] Git checkpoint"


git add \
apps/api/src/middleware \
scripts/sprint43.13 \
reports



git commit \
-m "Sprint 43.13 production security and deployment readiness"


git push origin main



echo "========================================"
echo "SPRINT 43.13 COMPLETE"
echo "REPORT:"
echo "$REPORT"
echo "========================================"
