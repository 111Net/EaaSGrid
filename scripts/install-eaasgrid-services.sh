#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="/data/eaasgrid-platform"
NODE_BIN="$(command -v node)"
NPM_BIN="$(command -v npm)"
USER_NAME="$(whoami)"

echo "=============================================="
echo " EaaSGrid SYSTEMD SERVICE INSTALLATION"
echo "=============================================="
echo

if [[ -z "$NODE_BIN" || -z "$NPM_BIN" ]]; then
    echo "FAIL: Node.js or npm not found"
    exit 1
fi

echo "Node: $NODE_BIN"
echo "NPM:  $NPM_BIN"
echo "User: $USER_NAME"
echo

create_service() {
    local service_name="$1"
    local app_name="$2"
    local app_dir="$3"
    local port="$4"
    local start_command="$5"

    echo "Creating $service_name..."

    cat > "/etc/systemd/system/${service_name}.service" <<SERVICE
[Unit]
Description=EaaSGrid ${app_name}
After=network.target postgresql.service
Wants=postgresql.service

[Service]
Type=simple
User=${USER_NAME}
WorkingDirectory=${app_dir}
Environment=NODE_ENV=production
Environment=PORT=${port}
ExecStart=${start_command}
Restart=always
RestartSec=5
StandardOutput=append:${ROOT_DIR}/logs/systemd/${service_name}.log
StandardError=append:${ROOT_DIR}/logs/systemd/${service_name}.error.log

[Install]
WantedBy=multi-user.target
SERVICE
}

mkdir -p "$ROOT_DIR/logs/systemd"

create_service \
    "eaasgrid-api" \
    "API" \
    "$ROOT_DIR/apps/api" \
    "4000" \
    "$NPM_BIN run start"

create_service \
    "eaasgrid-dashboard" \
    "Dashboard" \
    "$ROOT_DIR/apps/dashboard" \
    "3000" \
    "$NPM_BIN run start -- -p 3000"

create_service \
    "eaasgrid-investor" \
    "Investor Portal" \
    "$ROOT_DIR/apps/investor-portal" \
    "3001" \
    "$NPM_BIN run start -- -p 3001"

create_service \
    "eaasgrid-showcase" \
    "Showcase" \
    "$ROOT_DIR/apps/showcase" \
    "3002" \
    "$NPM_BIN run start -- -p 3002"

echo
echo "Reloading systemd..."
systemctl daemon-reload

echo "Enabling services for automatic startup..."
systemctl enable eaasgrid-api.service
systemctl enable eaasgrid-dashboard.service
systemctl enable eaasgrid-investor.service
systemctl enable eaasgrid-showcase.service

echo
echo "Stopping existing manually-started application processes..."

for port in 3000 3001 3002 4000; do
    pids="$(lsof -ti :"$port" 2>/dev/null || true)"

    if [[ -n "$pids" ]]; then
        kill $pids 2>/dev/null || true
    fi
done

sleep 3

echo
echo "Starting EaaSGrid services..."

systemctl restart eaasgrid-api.service
systemctl restart eaasgrid-dashboard.service
systemctl restart eaasgrid-investor.service
systemctl restart eaasgrid-showcase.service

sleep 10

echo
echo "=============================================="
echo " SERVICE STATUS"
echo "=============================================="

FAILURES=0

for service in \
    eaasgrid-api.service \
    eaasgrid-dashboard.service \
    eaasgrid-investor.service \
    eaasgrid-showcase.service
do
    if systemctl is-active --quiet "$service"; then
        echo "PASS: $service is active"
    else
        echo "FAIL: $service is not active"
        FAILURES=$((FAILURES + 1))
    fi
done

echo
echo "=============================================="

if [[ "$FAILURES" -eq 0 ]]; then
    echo "SYSTEMD_INSTALL_STATUS=PASS"
    echo
    echo "EaaSGrid applications are now:"
    echo "  - Automatically started at boot"
    echo "  - Automatically restarted if they crash"
    echo "  - Managed by systemd"
    echo "  - Routed through Nginx"
    exit 0
else
    echo "SYSTEMD_INSTALL_STATUS=FAIL"
    exit 1
fi
