#!/bin/bash


create_backup(){


STAMP=$(date +"%Y%m%d-%H%M")


DEST="backups/framework/$STAMP"


mkdir -p "$DEST"


cp docker-compose.yml "$DEST/"


cp -r apps/api/src "$DEST/api-src"


cp -r apps/dashboard/app "$DEST/dashboard-app"


echo "Backup created:"
echo "$DEST"


}
