#!/bin/bash

set -e

cd /data/eaasgrid-platform/apps/api

echo "======================================"
echo " XaaSGrid Final Schema Compatibility"
echo "======================================"


cp src/services/dashboard.service.js \
src/services/dashboard.service.schema-backup


python3 <<'PY'

from pathlib import Path

p=Path("src/services/dashboard.service.js")

text=p.read_text()


old='return {'


new='''
return {

investment:{
 required_capital_ngn:298000000,
 currency:"NGN",
 funding_stage:"Pilot Deployment"
},

investor:{
 company_name:"EaaSGrid Energy Services",
 project:"Everything-as-a-Service Platform",
 stage:"Pilot Deployment",
 funding_amount:298000000,
 funding_currency:"NGN",
 annual_expansion_sites:60,
 pilot_sites:6,
 headquarters:"Ibadan, Oyo State, Nigeria"
},

'''


if old in text and "investment:" not in text:
    text=text.replace(old,new,1)


p.write_text(text)

PY


echo "[1] Restarting API"

pkill -f "node src/server.js" || true

sleep 2

nohup npm start >/tmp/eaasgrid-api.log 2>&1 &


sleep 5


echo "[2] Testing compatibility"

curl -s \
http://192.168.100.21:4000/api/v1/dashboard \
| jq '.data.investment,.data.investor'


echo ""
echo "======================================"
echo " COMPLETE"
echo "======================================"

