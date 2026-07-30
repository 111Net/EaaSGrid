#!/bin/bash

set -e

BACKUP_DIR="./backup/database"

mkdir -p "$BACKUP_DIR"


echo "Creating PostgreSQL backup"


pg_dumpall > "$BACKUP_DIR/postgres-backup.sql"


echo "Database backup complete"

