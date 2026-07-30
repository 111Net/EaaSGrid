#!/bin/bash

BASE=/data/eaasgrid-platform

echo "=========================================="
echo " XaaSGrid Dashboard Permission Repair"
echo "=========================================="


FILE=$BASE/apps/dashboard/lib/permissions.js


echo "[1] Backup permissions.js"

cp $FILE \
$FILE.backup.$(date +%s)



echo "[2] Adding getCurrentUser export"


cat >> $FILE <<'EOF'


export function getCurrentUser(){

    if(typeof window === "undefined"){
        return null;
    }


    try {

        const user =
            localStorage.getItem("user");


        if(!user){
            return null;
        }


        return JSON.parse(user);


    } catch(error){

        console.error(
            "Unable to load current user",
            error
        );

        return null;

    }

}

EOF



echo "[3] Clearing Next cache"


cd $BASE/apps/dashboard

rm -rf .next



echo "[4] Testing dashboard build"


npm run build



echo "=========================================="
echo " Dashboard Permission Repair Complete"
echo "=========================================="
