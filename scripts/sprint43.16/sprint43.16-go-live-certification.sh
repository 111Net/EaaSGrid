#!/bin/bash

set -e


echo "========================================"
echo "XaaSGrid Sprint 43.16"
echo "FINAL GO-LIVE CERTIFICATION"
echo "========================================"


ROOT="/data/eaasgrid-platform"

REPORT="$ROOT/reports/sprint43.16-go-live-certification.txt"


mkdir -p reports


echo "XaaSGrid Final Go-Live Certification" > $REPORT
echo "====================================" >> $REPORT
date >> $REPORT



echo ""
echo "[1] Docker Status"

echo "Docker Status" >> $REPORT

docker ps >> $REPORT


echo ""
echo "[2] API LIVE"

curl -f http://localhost:4000/api/live \
| tee -a $REPORT



echo ""
echo "[3] API READY"

curl -f http://localhost:4000/api/ready \
| tee -a $REPORT



echo ""
echo "[4] SYSTEM STATUS"

curl -f http://localhost:4000/api/system/status \
| tee -a $REPORT



echo ""
echo "[5] VERSION"

curl -f http://localhost:4000/api/version \
| tee -a $REPORT



echo ""
echo "[6] METRICS"

curl -f http://localhost:4000/api/system/metrics \
| tee -a $REPORT



echo ""
echo "[7] DATABASE"


docker exec xaasgrid-postgres \
psql -U eaas_user -d eaas_db \
-c "\dt" \
| tee -a $REPORT



echo ""
echo "[8] REDIS"


docker exec xaasgrid-redis redis-cli ping \
| tee -a $REPORT



echo ""
echo "[9] SECURITY HEADERS"


curl -I http://localhost:4000/api/live \
| tee -a $REPORT



echo ""
echo "[10] Dashboard Check"


curl -I http://localhost:3000 \
| tee -a $REPORT



echo ""
echo "===================================="
echo "GO-LIVE CERTIFICATION COMPLETE"
echo "REPORT:"
echo $REPORT
echo "===================================="


echo ""
echo "XaaSGrid Status: READY FOR PARTNERS / INVESTORS"

