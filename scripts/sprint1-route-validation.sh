#!/bin/bash

echo "=========================================="
echo " XaaSGrid Sprint 1 Route Validation"
echo " Commercial API Smoke Test"
echo "=========================================="


API="http://localhost:4000"



echo ""
echo "[1] Customer Onboarding"

curl -s \
$API/api/v1/customer/profile


echo ""



echo ""
echo "[2] Subscription Engine"

curl -s \
$API/api/v1/subscription


echo ""



echo ""
echo "[3] Billing Engine"

curl -s \
$API/api/v1/billing/invoices


echo ""



echo ""
echo "[4] Partner Portal"

curl -s \
$API/api/v1/partner/dashboard


echo ""



echo ""
echo "[5] Investor Portal"

curl -s \
$API/api/v1/investor


echo ""



echo ""
echo "[6] Monitoring"

curl -s \
$API/api/v1/monitoring/health


echo ""


echo "=========================================="
echo " Sprint 1 Route Validation Complete"
echo "=========================================="
