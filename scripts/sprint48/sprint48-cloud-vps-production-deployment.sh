#!/bin/bash

set -e


echo "================================================="
echo "XaaSGrid Sprint 48"
echo "Cloud/VPS Production Deployment & External Access"
echo "================================================="


ROOT="/data/eaasgrid-platform"

cd $ROOT


DATE=$(date +"%Y-%m-%d")

REPORT="reports/sprint48-cloud-deployment-$DATE.txt"



mkdir -p reports

mkdir -p deployment/nginx

mkdir -p deployment/system

mkdir -p deployment/backup



echo "[1] Checking Production Infrastructure"



docker ps



echo "[2] Creating Deployment Documentation"



cat > deployment/cloud-vps-deployment-guide.md <<EOF

# XaaSGrid Cloud/VPS Deployment Guide


## Supported Platforms


- Ubuntu 24.04 VPS

- AWS EC2

- Google Cloud VM

- Azure VM

- DigitalOcean

- Hetzner


## Requirements


CPU:

4 cores recommended


RAM:

8GB recommended


Storage:

100GB+


Software:

Docker

Docker Compose

Nginx

Certbot


EOF



echo "[3] Creating Nginx Production Configuration"



cat > deployment/nginx/xaasgrid.conf <<EOF

server {

    listen 80;


    server_name xaasgrid.example.com;



    location /api/ {

        proxy_pass http://localhost:4000/api/;


        proxy_http_version 1.1;


        proxy_set_header Host \$host;


        proxy_set_header X-Real-IP \$remote_addr;


    }



    location / {


        proxy_pass http://localhost:3000;


        proxy_http_version 1.1;


        proxy_set_header Host \$host;


    }


}

EOF



echo "[4] Creating SSL Deployment Instructions"



cat > deployment/nginx/ssl-install.sh <<EOF

#!/bin/bash


apt update


apt install -y nginx certbot python3-certbot-nginx


certbot --nginx \\
-d xaasgrid.example.com


EOF



chmod +x deployment/nginx/ssl-install.sh



echo "[5] Creating Backup Automation"



cat > deployment/backup/postgres-backup.sh <<EOF

#!/bin/bash


DATE=\$(date +"%Y%m%d")


mkdir -p backups/database



docker exec xaasgrid-postgres \\
pg_dump -U eaas_user eaas_db \\
> backups/database/xaasgrid-\$DATE.sql



EOF


chmod +x deployment/backup/postgres-backup.sh



echo "[6] Creating Production Environment Template"



mkdir -p deployment/environment



cat > deployment/environment/.env.production.template <<EOF


NODE_ENV=production


PORT=4000


DATABASE_URL=postgresql://USER:PASSWORD@HOST:5432/DATABASE


REDIS_URL=redis://HOST:6379


JWT_SECRET=CHANGE_THIS_SECRET


NEXT_PUBLIC_API_URL=/api


DOMAIN=xaasgrid.example.com


EOF



echo "[7] External Access Validation"



{

echo "XaaSGrid Sprint 48 Certification"

date


echo

echo "Containers"

docker ps


echo

echo "API"

curl -s http://localhost:4000/api/system/status


echo

echo "Network Ports"


ss -tulpn | grep -E "3000|4000|5432|6379"



echo

echo "Deployment Files"


find deployment -type f



} > $REPORT



echo "[8] Git Deployment Package"



git add deployment scripts/sprint48


git commit \
-m "Sprint 48 Cloud VPS production deployment automation" \
|| true



git tag \
-a v48.0-cloud-ready \
-m "XaaSGrid Sprint 48 Cloud Deployment Ready" \
|| true



echo

echo "================================================="

echo "SPRINT 48 COMPLETE"

echo "================================================="


echo

echo "Release Tag"

echo "v48.0-cloud-ready"


echo

echo "Report"

echo $REPORT


echo

echo "Push command"

echo "git push origin main --tags"

