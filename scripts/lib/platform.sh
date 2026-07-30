#!/bin/bash

#############################################
# XaaSGrid Platform Module
# Hybrid Architecture Controller
#
# Node Express  = Core Platform API :4000
# FastAPI       = AI Operations Engine :8000
# Next.js       = Dashboard :3000
# Investor      = Portal :3001
#############################################


ROOT_DIR="/data/eaasgrid-platform"


platform_backup() {

    echo "[BACKUP] Platform backup check"

    mkdir -p "$ROOT_DIR/reports/backups"

    echo "Backup directory:"
    ls -ld "$ROOT_DIR/reports/backups"

}



platform_environment_validation() {

    echo "[ENVIRONMENT] Validating environment"

    echo "Working directory:"
    pwd

    echo "User:"
    whoami

    echo "Date:"
    date

    echo "Root directory:"
    echo "$ROOT_DIR"

}



platform_build_validation() {

    echo "[PLATFORM BUILD] Running platform build validation"


    echo ""
    echo "Checking Dashboard..."

    if [ -f "$ROOT_DIR/apps/dashboard/package.json" ]; then
        echo "Dashboard package.json detected"
    else
        echo "Dashboard package.json missing"
    fi


    echo ""
    echo "Checking Investor Portal..."

    if [ -f "$ROOT_DIR/apps/investor-portal/package.json" ]; then
        echo "Investor portal package.json detected"
    else
        echo "Investor portal package.json missing"
    fi


    echo ""
    echo "Checking Node API..."

    if [ -f "$ROOT_DIR/apps/api/package.json" ]; then
        echo "Node API package.json detected"
    else
        echo "Node API package.json missing"
    fi


    echo ""
    echo "Checking FastAPI AI Engine..."

    if [ -d "$ROOT_DIR/services" ]; then
        echo "Services directory detected"
    else
        echo "Services directory not detected (optional)"
    fi


    echo ""
    echo "Platform build validation complete"

}



platform_service_detection() {

    echo "[SERVICES] Detecting XaaSGrid services"


    echo ""
    echo "Node API"

    if pgrep -f "node.*server.js" >/dev/null; then
        echo "Node Express API RUNNING"
    else
        echo "Node Express API NOT RUNNING"
    fi


    echo ""
    echo "FastAPI AI Engine"

    if pgrep -f "uvicorn" >/dev/null; then
        echo "FastAPI AI Engine RUNNING"
    else
        echo "FastAPI AI Engine NOT RUNNING"
    fi


    echo ""
    echo "Docker Services"

    docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || \
    echo "Docker unavailable"

}



platform_restart() {

    echo "[RESTART] Restart validation"

    echo "Checking systemd..."

    if systemctl list-unit-files | grep -q eaas-platform.service; then

        echo "eaas-platform.service detected"

        sudo systemctl restart eaas-platform.service

    else

        echo "eaas-platform.service not installed"

    fi


    echo "Runtime restart validation complete"

}



platform_health_check() {

    echo "[HEALTH] Platform health check"


    uptime


    echo ""
    echo "Filesystem"

    df -h /



    echo ""
    echo "Memory"

    free -h


}



platform_runtime_validation() {

    echo "[RUNTIME] Runtime validation"


    echo ""
    echo "Docker containers"

    docker ps


    echo ""
    echo "Node processes"

    ps aux | grep node | grep -v grep || true


    echo ""
    echo "Python/FastAPI processes"

    ps aux | grep uvicorn | grep -v grep || true

}



platform_port_validation() {

    echo "[PORTS] Checking platform ports"


    PORTS=(3000 3001 4000 8000 5432 6379)


    for PORT in "${PORTS[@]}"
    do

        if ss -tulnp | grep -q ":$PORT"; then

            echo "Port $PORT ACTIVE"

        else

            echo "Port $PORT NOT ACTIVE"

        fi

    done

}



disk_validation() {

    echo "[DISK] Checking storage"

    df -h

}



memory_validation() {

    echo "[MEMORY] Checking memory"

    free -h

}



cpu_validation() {

    echo "[CPU] Checking processor"

    uptime

}



platform_log_scan() {

    echo "[LOGS] Scanning errors"


    journalctl \
    -p err \
    -n 20 \
    --no-pager

}



platform_systemd_validation() {

    echo "[SYSTEMD] Checking platform service"


    if systemctl list-unit-files | grep -q eaas-platform.service
    then

        echo "eaas-platform.service installed"

        systemctl status eaas-platform.service \
        --no-pager \
        -l

    else

        echo "eaas-platform.service missing"

    fi

}



platform_security_validation() {

    echo "[SECURITY] Platform security validation"


    if [ -f "$ROOT_DIR/.env" ]; then

        echo ".env detected"

    else

        echo ".env missing"

    fi


    echo ""
    echo "Checking permissions"

    ls -ld "$ROOT_DIR"

}



#############################################
# End XaaSGrid Platform Module
#############################################
