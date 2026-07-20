#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="/data/eaasgrid-platform"
REPORT_DIR="${PROJECT_ROOT}/reports"
REPORT_FILE="${REPORT_DIR}/nginx-test-report-$(date +%Y%m%d-%H%M%S).txt"

PASS=0
FAIL=0
WARN=0

mkdir -p "${REPORT_DIR}"

exec > >(tee -a "${REPORT_FILE}") 2>&1

echo "=========================================="
echo " EaaSGrid Nginx Automated Test"
echo "=========================================="
echo "Date: $(date)"
echo

pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
}

warn() {
    echo "WARN: $1"
    WARN=$((WARN + 1))
}

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        pass "$1 is installed"
    else
        fail "$1 is not installed"
    fi
}

check_port() {
    local service="$1"
    local port="$2"

    if ss -ltn | awk '{print $4}' | grep -qE "(:|\.)${port}$"; then
        pass "${service} is listening on port ${port}"
    else
        fail "${service} is not listening on port ${port}"
    fi
}

check_http() {
    local name="$1"
    local url="$2"
    local expected="${3:-}"

    local response
    local http_code

    response=$(curl -sS --max-time 10 "$url" 2>/dev/null || true)
    http_code=$(curl -sS -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || true)

    if [[ "$http_code" =~ ^2|^3 ]]; then
        if [[ -n "$expected" ]]; then
            if echo "$response" | grep -q "$expected"; then
                pass "${name}: ${url}"
            else
                fail "${name}: response did not contain expected value"
            fi
        else
            pass "${name}: ${url}"
        fi
    else
        fail "${name}: ${url} returned HTTP ${http_code}"
    fi
}

echo "[1] Checking required commands..."
check_command nginx
check_command curl
check_command ss

echo
echo "[2] Checking Nginx service..."

if systemctl is-active --quiet nginx; then
    pass "Nginx service is active"
else
    fail "Nginx service is not active"
fi

echo
echo "[3] Validating Nginx configuration..."

if nginx -t >/dev/null 2>&1; then
    pass "Nginx configuration is valid"
else
    fail "Nginx configuration is invalid"
fi

echo
echo "[4] Checking application ports..."

check_port "Dashboard" 3000
check_port "Investor Portal" 3001
check_port "Showcase" 3002
check_port "API" 4000

echo
echo "[5] Testing direct application services..."

check_http "Dashboard direct service" "http://127.0.0.1:3000"
check_http "Investor Portal direct service" "http://127.0.0.1:3001"
check_http "Showcase direct service" "http://127.0.0.1:3002"
check_http "API direct service" "http://127.0.0.1:4000/api/v1/health" "status"

echo
echo "[6] Testing Nginx proxy routes..."

check_http "Dashboard through Nginx" "http://localhost/"
check_http "Investor Portal through Nginx" "http://localhost/investor/"
check_http "Showcase through Nginx" "http://localhost/showcase/"
check_http "API through Nginx" "http://localhost/api/v1/health" "status"

echo
echo "[7] Checking Nginx configuration files..."

if [[ -f "/etc/nginx/sites-available/eaasgrid" ]]; then
    pass "EaaSGrid Nginx configuration exists"
else
    fail "EaaSGrid Nginx configuration is missing"
fi

if [[ -L "/etc/nginx/sites-enabled/eaasgrid" ]]; then
    pass "EaaSGrid Nginx configuration is enabled"
else
    fail "EaaSGrid Nginx configuration is not enabled"
fi

echo
echo "=========================================="
echo " TEST SUMMARY"
echo "=========================================="
echo "PASS: ${PASS}"
echo "FAIL: ${FAIL}"
echo "WARN: ${WARN}"
echo

if [[ "${FAIL}" -eq 0 ]]; then
    echo "=========================================="
    echo " OVERALL RESULT: PASS"
    echo "=========================================="
    echo
    echo "EaaSGrid Nginx routing is operational."
    exit 0
else
    echo "=========================================="
    echo " OVERALL RESULT: FAIL"
    echo "=========================================="
    echo
    echo "One or more checks failed."
    echo "Review the report:"
    echo "${REPORT_FILE}"
    exit 1
fi
