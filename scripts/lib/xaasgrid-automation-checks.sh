#!/bin/bash


validate_environment(){

echo "Checking XaaSGrid environment"


ROOT=$(pwd)


if [ ! -f docker-compose.yml ]; then

echo "ERROR: docker-compose.yml missing"

exit 1

fi



docker compose config >/dev/null


echo "Compose configuration OK"


}



cleanup_orphans(){

echo "Removing orphan containers"


docker compose down --remove-orphans


}



check_services(){

echo "Current services"

docker compose ps


}
