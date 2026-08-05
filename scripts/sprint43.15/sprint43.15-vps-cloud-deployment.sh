#!/bin/bash

set -e

echo "========================================"
echo "XaaSGrid Sprint 43.15"
echo "VPS / Cloud Production Deployment Candidate"
echo "========================================"


ROOT="/data/eaasgrid-platform"

cd $ROOT


echo "[1] Creating deployment package"


mkdir -p deployment/vps
mkdir -p deployment/cloud
mkdir -p deployment/security
mkdir -p deployment/scripts



echo "[2] Creating VPS bootstrap script"


cat > deployment/vps/bootstrap-ubuntu.sh <<'EOF'
#!/bin/bash

set -e

echo "XaaSGrid Ubuntu Production Bootstrap"


apt update

apt install -y \
curl \
git \
ufw \
nginx \
certbot \
docker.io \
docker-compose-plugin


systemctl enable docker

systemctl start docker


echo "Docker ready"

EOF


chmod +x deployment/vps/bootstrap-ubuntu.sh



echo "[3] Creating cloud deployment checklist"


cat > deployment/cloud/CLOUD-DEPLOYMENT-CHECKLIST.md <<EOF

# XaaSGrid Cloud Deployment Checklist


## Infrastructure

Minimum:

CPU:
4 cores

RAM:
8GB

Storage:
100GB SSD


## Required Ports

3000 Dashboard

4000 API

80 HTTP

443 HTTPS


## Required Services

Docker

PostgreSQL

Redis

Nginx


## Validation

curl /api/live

curl /api/ready

EOF



echo "[4] Creating firewall configuration"


cat > deployment/security/firewall-setup.sh <<EOF
#!/bin/bash


ufw allow ssh

ufw allow 80

ufw allow 443


ufw --force enable


ufw status

EOF


chmod +x deployment/security/firewall-setup.sh



echo "[5] Creating production deployment runner"


cat > deployment/scripts/deploy-production.sh <<EOF
#!/bin/bash


cd /opt/xaasgrid


docker compose pull


docker compose build


docker compose up -d


docker ps

EOF


chmod +x deployment/scripts/deploy-production.sh



echo "[6] Creating Nginx production configuration"


cat > deployment/nginx/xaasgrid-production.conf <<EOF

server {

listen 80;


location /api {

proxy_pass http://127.0.0.1:4000;

proxy_set_header Host \$host;

}


location / {

proxy_pass http://127.0.0.1:3000;

proxy_set_header Host \$host;

}


}

EOF



echo "[7] Creating SSL readiness"


cat > deployment/security/ssl-setup.sh <<EOF

#!/bin/bash


DOMAIN=\$1


certbot --nginx \
-d \$DOMAIN


EOF


chmod +x deployment/security/ssl-setup.sh



echo "[8] Production validation"


docker ps


curl -f http://localhost:4000/api/live

curl -f http://localhost:4000/api/ready



echo ""

echo "========================================"
echo "SPRINT 43.15 COMPLETE"
echo "VPS/CLOUD DEPLOYMENT CANDIDATE READY"
echo "========================================"
