#!/usr/bin/env bash


echo "EaaSGrid GUI Health Check"


curl -I http://localhost:3000


echo "API Check"


curl http://localhost:4000/api/v1/health

