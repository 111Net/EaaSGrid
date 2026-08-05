#!/bin/bash


docker_check(){

echo "[DOCKER] Checking compose"


docker compose config >/dev/null


echo "Docker compose OK"

}



docker_safe_deploy(){


echo "[DOCKER] Stopping old services"


docker compose down --remove-orphans



echo "[DOCKER] Building"


docker compose build



echo "[DOCKER] Starting"


docker compose up -d



echo "[DOCKER] Running containers"


docker compose ps


}
