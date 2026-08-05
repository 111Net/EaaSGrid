#!/bin/bash


environment_check(){

echo "[ENVIRONMENT] Checking"


if [ ! -f ".env" ]
then
echo "ERROR: .env missing"
exit 1
fi


if [ ! -f "docker-compose.yml" ]
then
echo "ERROR: docker-compose.yml missing"
exit 1
fi


if [ ! -d "apps/api" ]
then
echo "ERROR: API directory missing"
exit 1
fi


if [ ! -d "apps/dashboard" ]
then
echo "ERROR: Dashboard directory missing"
exit 1
fi


echo "Environment OK"

}
