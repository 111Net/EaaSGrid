#!/bin/bash

BASE=/data/eaasgrid-platform

echo "=========================================="
echo " XaaSGrid Dashboard API Compatibility Repair"
echo "=========================================="


cd $BASE


FILE="apps/api/src/routes/dashboard.routes.js"


echo "[1] Backup dashboard routes"

cp $FILE \
$FILE.backup.$(date +%s)



echo "[2] Checking summary route"


if grep -q "/summary" $FILE
then

echo "PASS - summary route exists"

else


cat >> $FILE <<'EOF'


// XaaSGrid Control Centre compatibility route

router.get("/summary", async (req,res)=>{

    try {

        const dashboard =
        await dashboardService.getDashboardData();


        res.json({

            success:true,

            data:dashboard

        });


    } catch(error){

        console.error(error);


        res.status(500).json({

            success:false,

            message:"Dashboard summary unavailable"

        });

    }

});


EOF


echo "Added /summary route"

fi



echo "[3] Restarting API"


pkill -f "node src/server.js" || true

sleep 3


cd apps/api

nohup npm run dev \
> api-runtime.log 2>&1 &


sleep 8



echo "[4] Testing API"


curl http://localhost:4000/api/v1/dashboard/summary



echo


echo "=========================================="
echo " Dashboard API Repair Complete"
echo "=========================================="
