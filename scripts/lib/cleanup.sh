#!/bin/bash

#########################################
# XaaSGrid Cleanup Module
# Sprint 14 Production Launch
#########################################

PROJECT_DIR="/data/eaasgrid-platform"


automatic_cleanup() {

    echo "======================================"
    echo "[CLEANUP] Running XaaSGrid cleanup"
    echo "======================================"

    echo


    ####################################
    # Temporary directories
    ####################################

    echo "[1] Checking temporary files"

    TEMP_DIRS=(
        "$PROJECT_DIR/tmp"
        "$PROJECT_DIR/cache"
    )


    for DIR in "${TEMP_DIRS[@]}"
    do

        if [ -d "$DIR" ]
        then

            echo "Cleaning user-owned files: $DIR"

            find "$DIR" \
            -type f \
            -user "$(whoami)" \
            -mtime +7 \
            -print \
            -delete

        else

            echo "Not found: $DIR"

        fi

    done


    echo


    ####################################
    # Application cache cleanup
    ####################################

    echo "[2] Checking application caches"


    APPS=(
        "dashboard"
        "investor-portal"
        "showcase"
        "api"
    )


    for APP in "${APPS[@]}"
    do

        APP_DIR="$PROJECT_DIR/apps/$APP"


        if [ -d "$APP_DIR/node_modules/.cache" ]
        then

            echo "Cleaning cache:"
            echo "$APP_DIR/node_modules/.cache"

            rm -rf "$APP_DIR/node_modules/.cache"

        else

            echo "$APP cache not found"

        fi

    done


    echo


    ####################################
    # Log cleanup (safe mode)
    ####################################

    echo "[3] Checking application logs"


    LOG_DIR="$PROJECT_DIR/logs"


    if [ -d "$LOG_DIR" ]
    then

        echo "Scanning logs owned by $(whoami)"

        find "$LOG_DIR" \
        -type f \
        -user "$(whoami)" \
        -mtime +30 \
        -print \
        -delete

        echo "Protected root/system logs skipped"

    else

        echo "Log directory not found"

    fi


    echo


    ####################################
    # Docker cleanup
    ####################################

    echo "[4] Docker cleanup"


    if command -v docker >/dev/null 2>&1
    then

        echo "Removing unused Docker objects"

        docker system prune -f

        echo "Docker cleanup complete"

    else

        echo "Docker not installed"

    fi


    echo


    ####################################
    # Final status
    ####################################

    echo "======================================"
    echo "Cleanup completed successfully"
    echo "======================================"

}
