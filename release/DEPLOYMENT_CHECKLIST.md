
# Deployment Checklist


## Server


Ubuntu 22/24


## Required


Docker

Docker Compose

Git


## Deploy


git clone repository

cp .env.production.example .env

docker compose up -d


## Verify


docker ps

curl API health


