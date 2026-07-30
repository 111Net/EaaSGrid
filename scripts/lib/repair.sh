#!/bin/bash

#########################################
# XaaSGrid Repair Module
#########################################

PROJECT_DIR="/data/eaasgrid-platform"


route_repair() {

    echo "[ROUTE] Running route repair"


    API_DIR="$PROJECT_DIR/apps/api"


    if [ -d "$API_DIR" ]
    then

        echo "Checking API route structure..."

        if [ -d "$API_DIR/src/routes" ]
        then
            echo "Routes directory found"
        else
            echo "Routes directory missing"
        fi

    else

        echo "API directory missing"

    fi


    echo "Route repair complete"

}



dashboard_api_repair() {

    echo "[DASHBOARD API] Running dashboard API repair"


    DASHBOARD_DIR="$PROJECT_DIR/apps/dashboard"


    if [ -d "$DASHBOARD_DIR" ]
    then

        echo "Checking dashboard environment..."

        if [ -f "$DASHBOARD_DIR/.env.local" ]
        then
            echo ".env.local found"

            grep "NEXT_PUBLIC_API" "$DASHBOARD_DIR/.env.local" || true

        else
            echo ".env.local missing"
        fi

    else

        echo "Dashboard directory missing"

    fi


    echo "Dashboard API repair complete"

}



nextjs_cache_repair() {

    echo "[NEXTJS] Running Next.js cache repair"


    for APP in dashboard investor-portal
    do

        APP_DIR="$PROJECT_DIR/apps/$APP"


        if [ -d "$APP_DIR/.next" ]
        then

            echo "Cleaning $APP Next.js cache"

            rm -rf "$APP_DIR/.next"

            echo "$APP cache cleared"

        else

            echo "$APP cache not found"

        fi

    done


    echo "Next.js cache repair complete"

}
