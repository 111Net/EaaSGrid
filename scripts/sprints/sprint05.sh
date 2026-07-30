#!/bin/bash

set -e

ROOT="/data/eaasgrid-platform"

REPORT="$ROOT/reports/sprint05-docker-foundation.md"

echo "======================================"
echo " XaaSGrid Sprint 5 Docker Foundation"
echo "======================================"

mkdir -p "$ROOT/docker/api"
mkdir -p "$ROOT/docker/dashboard"
mkdir -p "$ROOT/docker/postgres/init"
mkdir -p "$ROOT/reports"


echo "[1] Checking Docker"

docker --version
docker compose version


echo "[2] Creating API Dockerfile"

cat > "$ROOT/docker/api/Dockerfile" <<EOF
FROM node:20-alpine

WORKDIR /app

COPY apps/api/package*.json ./

RUN npm install

COPY apps/api .

EXPOSE 4000

CMD ["node","src/server.js"]
EOF



echo "[3] Creating Dashboard Dockerfile"

cat > "$ROOT/docker/dashboard/Dockerfile" <<EOF
FROM node:20-alpine

WORKDIR /app

COPY apps/dashboard/package*.json ./

RUN npm install

COPY apps/dashboard .

RUN npm run build

EXPOSE 3000

CMD ["npm","start"]
EOF



echo "[4] Creating environment template"


cat > "$ROOT/.env.example" <<EOF

# XaaSGrid Environment Template

NODE_ENV=production

API_PORT=4000

DASHBOARD_PORT=3000

POSTGRES_DB=eaas_db

POSTGRES_USER=eaas_user

POSTGRES_PASSWORD=CHANGE_ME

DATABASE_URL=postgresql://eaas_user:CHANGE_ME@postgres:5432/eaas_db

NEXT_PUBLIC_API_URL=http://localhost:4000

EOF



echo "[5] Creating docker compose"


cat > "$ROOT/docker-compose.yml" <<EOF

services:

  postgres:

    image: postgres:16

    container_name: xaasgrid-postgres

    environment:

      POSTGRES_DB: eaas_db

      POSTGRES_USER: eaas_user

      POSTGRES_PASSWORD: CHANGE_ME

    volumes:

      - postgres_data:/var/lib/postgresql/data

    ports:

      - "5432:5432"



  api:

    build:

      context: .

      dockerfile: docker/api/Dockerfile

    container_name: xaasgrid-api

    depends_on:

      - postgres

    ports:

      - "4000:4000"



  dashboard:

    build:

      context: .

      dockerfile: docker/dashboard/Dockerfile

    container_name: xaasgrid-dashboard

    depends_on:

      - api

    ports:

      - "3000:3000"



volumes:

  postgres_data:

EOF



echo "[6] Validating Docker Compose"


docker compose config > /tmp/xaasgrid-compose-check.txt



echo "[7] Creating report"


cat > "$REPORT" <<EOF

# XaaSGrid Sprint 5 Docker Foundation

Date:

$(date)


## Docker

Status: PASS


## Containers

API:
Prepared


Dashboard:
Prepared


PostgreSQL:
Prepared


## Compose Validation

PASS


## Portable Deployment

READY


EOF



echo "[8] Updating platform state"


python3 <<EOF

import json

path="$ROOT/state/platform-state.json"

with open(path) as f:
    data=json.load(f)

data["current_sprint"]="5"
data["status"]="docker-foundation-complete"

with open(path,"w") as f:
    json.dump(data,f,indent=2)

EOF



echo "======================================"
echo " Sprint 5 Docker Foundation Complete"
echo "======================================"

echo "Report:"
echo "$REPORT"
	o
