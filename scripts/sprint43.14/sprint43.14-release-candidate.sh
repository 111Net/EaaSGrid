#!/bin/bash

set -e

echo "========================================"
echo "XaaSGrid Sprint 43.14"
echo "Release Candidate Preparation"
echo "========================================"

ROOT="/data/eaasgrid-platform"

cd $ROOT


echo "[1] Creating release directories"

mkdir -p deployment/{nginx,systemd,backup,restore,env}


echo "[2] Creating production environment template"

cat > deployment/env/.env.production.example <<EOF
NODE_ENV=production

PORT=4000

POSTGRES_USER=xaasgrid_user
POSTGRES_PASSWORD=CHANGE_ME
POSTGRES_DB=xaasgrid

DATABASE_URL=postgresql://USER:PASSWORD@xaasgrid-postgres:5432/DATABASE

REDIS_URL=redis://xaasgrid-redis:6379

JWT_SECRET=CHANGE_ME

NEXT_PUBLIC_API_URL=/api
EOF


echo "[3] Creating production docker compose template"

cat > deployment/docker-compose.production.yml <<EOF
services:

  xaasgrid-postgres:
    image: postgres:15
    restart: unless-stopped

  xaasgrid-redis:
    image: redis:7
    restart: unless-stopped

  xaasgrid-api:
    restart: unless-stopped
    ports:
      - "4000:4000"

  xaasgrid-dashboard:
    restart: unless-stopped
    ports:
      - "3000:3000"
EOF


echo "[4] Creating nginx configuration"

cat > deployment/nginx/xaasgrid.conf <<EOF
server {

    listen 80;

    server_name xaasgrid.example.com;


    location /api {

        proxy_pass http://localhost:4000;

    }


    location / {

        proxy_pass http://localhost:3000;

    }

}
EOF


echo "[5] Creating systemd service template"

cat > deployment/systemd/xaasgrid.service <<EOF
[Unit]
Description=XaaSGrid Platform

After=docker.service


[Service]

Restart=always

ExecStart=/usr/bin/docker compose up

ExecStop=/usr/bin/docker compose down


[Install]

WantedBy=multi-user.target
EOF


echo "[6] Creating backup scripts"


cat > deployment/backup/postgres-backup.sh <<EOF
#!/bin/bash

docker exec xaasgrid-postgres \
pg_dump -U eaas_user eaas_db \
> xaasgrid-backup-\$(date +%F).sql
EOF


chmod +x deployment/backup/postgres-backup.sh


echo "[7] Creating collaborator documentation"


cat > DEPLOYMENT.md <<EOF
# XaaSGrid Deployment Guide

## Services

Dashboard:
3000

API:
4000

Database:
PostgreSQL 15

Cache:
Redis 7


## Deployment

docker compose up -d
EOF


cat > CONTRIBUTING.md <<EOF
# Contributing to XaaSGrid

1. Create branch

2. Test locally

3. Submit pull request

4. Maintain production standards
EOF


echo "[8] Creating release metadata"

cat > RELEASE-CANDIDATE.md <<EOF
# XaaSGrid Release Candidate

Version:
43.14.0-rc1

Status:
Production Candidate

Generated:
$(date)
EOF


echo "[9] Validation"

docker ps


echo ""
echo "========================================"
echo "SPRINT 43.14 COMPLETE"
echo "Release Candidate Ready"
echo "========================================"
