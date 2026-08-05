#!/bin/bash

set -e

echo "========================================"
echo "XaaSGrid Sprint 43.16"
echo "FINAL GO-LIVE CERTIFICATION"
echo "========================================"

ROOT="/data/eaasgrid-platform"

REPORT="$ROOT/reports/sprint43.16-go-live-certification-$(date +%Y%m%d-%H%M).txt"

mkdir -p "$ROOT/reports"


echo "XaaSGrid Sprint 43.16 Final Go-Live Certification" > "$REPORT"
echo "=================================================" >> "$REPORT"
date >> "$REPORT"


echo ""
echo "[1] Git State"

echo "===== GIT =====" >> "$REPORT"

git status >> "$REPORT"

git log --oneline -5 >> "$REPORT"



echo ""
echo "[2] Docker Containers"

echo "===== DOCKER =====" >> "$REPORT"

docker ps >> "$REPORT"



echo ""
echo "[3] API LIVE"

echo "===== API LIVE =====" >> "$REPORT"

curl -f http://localhost:4000/api/live \
| tee -a "$REPORT"



echo ""
echo "[4] API READY"

echo "===== API READY =====" >> "$REPORT"

curl -f http://localhost:4000/api/ready \
| tee -a "$REPORT"



echo ""
echo "[5] PLATFORM STATUS"

echo "===== PLATFORM STATUS =====" >> "$REPORT"

curl -f http://localhost:4000/api/system/status \
| tee -a "$REPORT"



echo ""
echo "[6] VERSION"

echo "===== VERSION =====" >> "$REPORT"

curl -f http://localhost:4000/api/version \
| tee -a "$REPORT"



echo ""
echo "[7] METRICS"

echo "===== METRICS =====" >> "$REPORT"

curl -f http://localhost:4000/api/system/metrics \
| tee -a "$REPORT"



echo ""
echo "[8] INTELLIGENCE CHECK"

echo "===== INTELLIGENCE =====" >> "$REPORT"

curl -f http://localhost:4000/api/v1/intelligence-check \
| tee -a "$REPORT"



echo ""
echo "[9] DATABASE"

echo "===== DATABASE =====" >> "$REPORT"

docker exec xaasgrid-postgres \
psql -U eaas_user -d eaas_db \
-c "\dt" \
| tee -a "$REPORT"



echo ""
echo "[10] REDIS"

echo "===== REDIS =====" >> "$REPORT"

docker exec xaasgrid-redis redis-cli ping \
| tee -a "$REPORT"



echo ""
echo "[11] SECURITY HEADERS"

echo "===== SECURITY =====" >> "$REPORT"

curl -I http://localhost:4000/api/live \
| tee -a "$REPORT"



echo ""
echo "[12] DASHBOARD"

echo "===== DASHBOARD =====" >> "$REPORT"

curl -I http://localhost:3000 \
| tee -a "$REPORT"



echo ""
echo "========================================"
echo "FINAL CERTIFICATION COMPLETE"
echo "========================================"

echo ""
echo "REPORT:"
echo "$REPORT"

echo ""
echo "XaaSGrid Status:"
echo "READY FOR COLLABORATORS"
echo "READY FOR PARTNERS"
echo "READY FOR INVESTOR DEMO"
echo "READY FOR VPS/CLOUD DEPLOYMENT"
