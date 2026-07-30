#!/bin/bash

#########################################
# XaaSGrid API Module
#########################################

API_DIR="/data/eaasgrid-platform/apps/api"


api_validation() {

    echo "[API] Running API validation"

    echo "Checking API directory..."

    if [ -d "$API_DIR" ]
    then
        echo "API directory: OK"
    else
        echo "API directory missing: $API_DIR"
    fi


    echo
    echo "Checking running processes..."

    if pgrep -f "node" >/dev/null
    then
        echo "Node process detected"
    else
        echo "No Node process detected"
    fi


    echo
    echo "Checking common API ports..."

    for port in 8000 3000 3001
    do
        if ss -tulpn 2>/dev/null | grep -q ":$port"
        then
            echo "Port $port: ACTIVE"
        else
            echo "Port $port: NOT ACTIVE"
        fi
    done


    echo
    echo "API validation complete"

}


api_repair() {

    echo "[API] Running API repair"


    if [ -d "$API_DIR" ]
    then

        echo "API directory found"

        if [ -f "$API_DIR/package.json" ]
        then
            echo "package.json detected"
        else
            echo "package.json missing"
        fi

    else

        echo "Cannot repair - API directory missing"

    fi


    echo "API repair checks complete"

}
