#!/bin/bash

#########################################
# XaaSGrid Backup Module
# Sprint 14 Production Launch
#########################################

PROJECT_DIR="/data/eaasgrid-platform"
BACKUP_DIR="$PROJECT_DIR/backups"


platform_backup() {

    echo "======================================"
    echo "[BACKUP] Running XaaSGrid backup"
    echo "======================================"


    mkdir -p "$BACKUP_DIR"


    BACKUP_FILE="$BACKUP_DIR/eaasgrid-backup-$(date +%Y%m%d-%H%M%S).tar.gz"


    echo "Creating backup:"
    echo "$BACKUP_FILE"


    tar \
    --exclude="$PROJECT_DIR/node_modules" \
    --exclude="$PROJECT_DIR/.next" \
    --exclude="$PROJECT_DIR/backups" \
    -czf "$BACKUP_FILE" \
    "$PROJECT_DIR/apps" \
    "$PROJECT_DIR/packages" \
    "$PROJECT_DIR/scripts" \
    2>/dev/null


    if [ $? -eq 0 ]
    then
        echo
        echo "Backup completed successfully"

        ls -lh "$BACKUP_FILE"

    else

        echo
        echo "Backup failed"

        return 1

    fi

}
