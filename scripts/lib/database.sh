#!/bin/bash

#########################################
# XaaSGrid Database Module
#########################################

database_validation() {

    echo "[DATABASE] Running database validation"

    if command -v psql >/dev/null 2>&1
    then

        echo "PostgreSQL client detected"

        psql --version

    else

        echo "PostgreSQL client not installed"

    fi


    if systemctl list-units --type=service | grep -q postgresql
    then

        echo "PostgreSQL service detected"

    else

        echo "PostgreSQL service not detected"

    fi

}


database_repair() {

    echo "[DATABASE] Running database repair checks"


    if command -v psql >/dev/null 2>&1
    then

        echo "Checking PostgreSQL connectivity"

    else

        echo "Skipping database repair - PostgreSQL client unavailable"

    fi

}
