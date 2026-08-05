# XaaSGrid Production Deployment

Requirements:

- Ubuntu 24+
- Docker
- Docker Compose
- PostgreSQL
- Redis


Deployment:

git clone repository

cd eaasgrid-platform

docker compose up -d


Validation:

curl http://localhost:4000/api/system/status


Expected:

API ONLINE
PostgreSQL ONLINE
Redis ONLINE

