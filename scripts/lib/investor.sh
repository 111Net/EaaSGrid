#!/bin/bash

#########################################
# XaaSGrid Investor Portal Module
#########################################

INVESTOR_DIR="/data/eaasgrid-platform/apps/investor-portal"


investor_validation() {

    echo "[INVESTOR] Running investor portal validation"

    echo
    echo "Checking investor portal directory..."

    if [ -d "$INVESTOR_DIR" ]
    then
        echo "Investor portal directory: OK"
    else
        echo "Investor portal directory missing: $INVESTOR_DIR"
        return
    fi


    echo
    echo "Checking package configuration..."

    if [ -f "$INVESTOR_DIR/package.json" ]
    then
        echo "package.json: OK"
    else
        echo "package.json: MISSING"
    fi


    echo
    echo "Checking Next.js investor process..."

    if pgrep -f "next" >/dev/null
    then
        echo "Next.js process detected"
    else
        echo "Next.js process not detected"
    fi


    echo
    echo "Checking investor portal port..."

    for port in 3001 3003
    do

        if ss -tulpn 2>/dev/null | grep -q ":$port"
        then
            echo "Port $port: ACTIVE"
        else
            echo "Port $port: NOT ACTIVE"
        fi

    done


    echo
    echo "Investor validation complete"

}



investor_repair() {

    echo "[INVESTOR] Running investor repair checks"


    if [ ! -d "$INVESTOR_DIR" ]
    then
        echo "Investor portal directory missing"
        return
    fi


    if [ -f "$INVESTOR_DIR/package.json" ]
    then

        echo "Checking npm configuration"

        cd "$INVESTOR_DIR" || return

        npm --version 2>/dev/null

    else

        echo "package.json missing"

    fi


    if [ -d "$INVESTOR_DIR/.next" ]
    then
        echo "Next.js build cache detected"
    else
        echo "No build cache detected"
    fi


    echo "Investor repair checks complete"

}
