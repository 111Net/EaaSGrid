#!/bin/bash

#########################################
# XaaSGrid Route Validation Module
#########################################

PROJECT_DIR="/data/eaasgrid-platform"


route_validation() {

    echo "[ROUTES] Running route validation"


    API_DIR="$PROJECT_DIR/apps/api"


    if [ ! -d "$API_DIR" ]
    then
        echo "API directory missing"
        return
    fi


    echo
    echo "Checking API route files..."


    if [ -d "$API_DIR/src/routes" ]
    then

        echo "Routes directory found"

        find "$API_DIR/src/routes" \
        -maxdepth 1 \
        -type f \
        -name "*.js" \
        -print

    else

        echo "Routes directory not found"

    fi


    echo
    echo "Checking Express route registration..."


    if grep -R "app.use" "$API_DIR/src" >/dev/null 2>&1
    then
        echo "Express route registration detected"
    else
        echo "No Express routes detected"
    fi


    echo
    echo "Route validation complete"

}



route_repair() {

    echo "[ROUTES] Running route repair"


    API_DIR="$PROJECT_DIR/apps/api"


    if [ -d "$API_DIR/src/routes" ]
    then
        echo "Route structure exists"
    else
        echo "Route directory missing"
    fi


    echo "Route repair complete"

}
