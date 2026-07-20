#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_ROOT="/data/eaasgrid-platform"
NGINX_SITE_NAME="eaasgrid"
NGINX_AVAILABLE="/etc/nginx/sites-available/${NGINX_SITE_NAME}"
NGINX_ENABLED="/etc/nginx/sites-enabled/${NGINX_SITE_NAME}"

echo "=========================================="
echo " EaaSGrid Automated Nginx Setup"
echo "=========================================="

if [[ "${EUID}" -ne 0 ]]; then
    echo "ERROR: Run this script with sudo."
    echo "Usage: sudo ./scripts/setup-nginx.sh"
    exit 1
fi

if [[ ! -d "${PROJECT_ROOT}" ]]; then
    echo "ERROR: Project directory not found:"
    echo "${PROJECT_ROOT}"
    exit 1
fi

echo "[1/8] Installing Nginx..."
apt-get update -qq
apt-get install -y nginx >/dev/null

echo "[2/8] Creating Nginx configuration..."

cat > "${NGINX_AVAILABLE}" <<'NGINX_CONFIG'
server {
    listen 80;
    listen [::]:80;

    server_name localhost;

    # EaaSGrid Dashboard
    location / {
        proxy_pass http://127.0.0.1:3000;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # EaaSGrid Investor Portal
    location /investor/ {
        proxy_pass http://127.0.0.1:3001/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # EaaSGrid Showcase
    location /showcase/ {
        proxy_pass http://127.0.0.1:3002/;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # EaaSGrid API
    location /api/ {
        proxy_pass http://127.0.0.1:4000;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINX_CONFIG

echo "[3/8] Removing default Nginx site..."
rm -f /etc/nginx/sites-enabled/default

echo "[4/8] Activating EaaSGrid site..."

ln -sfn "${NGINX_AVAILABLE}" "${NGINX_ENABLED}"

echo "[5/8] Validating Nginx configuration..."

nginx -t

echo "[6/8] Enabling Nginx at system startup..."

systemctl enable nginx >/dev/null

echo "[7/8] Restarting Nginx..."

systemctl restart nginx

echo "[8/8] Verifying Nginx service..."

if systemctl is-active --quiet nginx; then
    echo
    echo "=========================================="
    echo " SUCCESS: Nginx is running"
    echo "=========================================="
    echo
    echo "Routes configured:"
    echo
    echo "Dashboard:       http://localhost/"
    echo "Investor Portal: http://localhost/investor/"
    echo "Showcase:        http://localhost/showcase/"
    echo "API:             http://localhost/api/"
    echo
    echo "Configuration:"
    echo "${NGINX_AVAILABLE}"
    echo
else
    echo "ERROR: Nginx failed to start."
    systemctl status nginx --no-pager
    exit 1
fi
