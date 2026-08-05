#!/bin/bash


cd /opt/xaasgrid


docker compose pull


docker compose build


docker compose up -d


docker ps

