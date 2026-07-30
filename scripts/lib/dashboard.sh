#!/bin/bash

#########################################
# XaaSGrid Dashboard Module
#########################################

DASHBOARD_DIR="/data/eaasgrid-platform/apps/dashboard"


dashboard_validation() {

    echo "[DASHBOARD] Running dashboard validation"

    echo
    echo "Checking dashboard directory..."

    if [ -d "$DASHBOARD_DIR" ]
    then
        echo "Dashboard directory: OK"
    else
        echo "Dashboard directory missing: $DASHBOARD_DIR"
        return
    fi


    echo
    echo "Checking package configuration..."

    if [ -f "$DASHBOARD_DIR/package.json" ]
    then
        echo "package.json: OK"
    else
        echo "package.json: MISSING"
    fi


    echo
    echo "Checking Next.js process..."

    if pgrep -f "next" >/dev/null
    then
        echo "Next.js process: RUNNING"
    else
        echo "Next.js process: NOT RUNNING"
    fi


    echo
    echo "Checking dashboard ports..."

    for port in 3000 3002
    do

        if ss -tulpn 2>/dev/null | grep -q ":$port"
        then
            echo "Port $port: ACTIVE"
        else
            echo "Port $port: NOT ACTIVE"
        fi

    done


    echo
    echo "Dashboard validation complete"

}



dashboard_repair() {

    echo "[DASHBOARD] Running dashboard repair checks"


    if [ ! -d "$DASHBOARD_DIR" ]
    then
        echo "Dashboard directory missing"
        return
    fi


    if [ -d "$DASHBOARD_DIR/.next" ]
    then
        echo "Next.js build cache detected"
    else
        echo "No Next.js build cache found"
    fi


    if [ -f "$DASHBOARD_DIR/package.json" ]
    then
        echo "Checking npm configuration"

        cd "$DASHBOARD_DIR" || return

        npm --version 2>/dev/null

    fi


    echo "Dashboard repair checks complete"

}
#########################################
# Dashboard API Validation
#########################################

dashboard_api_validation() {

    echo "[DASHBOARD API] Running dashboard API validation"


    DASHBOARD_DIR="/data/eaasgrid-platform/apps/dashboard"


    if [ ! -d "$DASHBOARD_DIR" ]
    then
        echo "Dashboard directory missing"
        return
    fi


    echo
    echo "Checking dashboard environment"


    if [ -f "$DASHBOARD_DIR/.env.local" ]
    then

        echo ".env.local found"

        grep "NEXT_PUBLIC_API" \
        "$DASHBOARD_DIR/.env.local" || true

    else

        echo ".env.local not found"

    fi


    echo
    echo "Checking dashboard API references"


    if grep -R "NEXT_PUBLIC_API" "$DASHBOARD_DIR" >/dev/null 2>&1
    then

        echo "API environment reference detected"

    else

        echo "No API environment reference detected"

    fi


    echo
    echo "Checking auth/API client"


    if [ -d "$DASHBOARD_DIR/lib" ]
    then

        echo "Dashboard lib directory found"

    else

        echo "Dashboard lib directory missing"

    fi


    echo
    echo "Dashboard API validation complete"

}
