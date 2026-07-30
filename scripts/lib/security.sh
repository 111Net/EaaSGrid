#!/bin/bash

#########################################
# XaaSGrid Security Module
#########################################

PROJECT_DIR="/data/eaasgrid-platform"


security_validation() {

    echo "[SECURITY] Running security validation"


    echo
    echo "Checking project permissions..."


    if [ -d "$PROJECT_DIR" ]
    then
        echo "Project directory: OK"
    else
        echo "Project directory missing"
        return
    fi


    echo
    echo "Checking exposed sensitive files..."


    SENSITIVE_FILES=(
        ".env"
        ".env.local"
        "docker-compose.yml"
    )


    for file in "${SENSITIVE_FILES[@]}"
    do

        if [ -f "$PROJECT_DIR/$file" ]
        then
            echo "$file : PRESENT"
        fi

    done


    echo
    echo "Checking running services..."

    ps aux | grep -E "node|python|postgres" | grep -v grep || true


    echo
    echo "Security validation complete"

}



permission_validation() {

    echo "[PERMISSIONS] Running permission validation"


    echo
    echo "Checking script permissions..."

    find "$PROJECT_DIR/scripts" -type f -name "*.sh" \
    -exec ls -l {} \;


    echo
    echo "Checking ownership..."

    ls -ld "$PROJECT_DIR"


    echo
    echo "Permission validation complete"

}



permission_repair() {

    echo "[PERMISSIONS] Running permission repair"


    echo
    echo "Applying script executable permissions..."

    find "$PROJECT_DIR/scripts" -type f -name "*.sh" \
    -exec chmod +x {} \;


    echo
    echo "Permission repair complete"

}
