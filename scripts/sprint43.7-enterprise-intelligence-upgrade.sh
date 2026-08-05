#!/bin/bash

set -e

PROJECT="/data/eaasgrid-platform"
BACKUP="$PROJECT/backups/sprint43.7-pre-upgrade-$(date +%Y%m%d-%H%M)"

echo "=============================================="
echo " Sprint 43.7 Enterprise Intelligence Upgrade"
echo " XaaSGrid Lifecycle Management + Dashboard"
echo "=============================================="

cd $PROJECT


echo "[1/12] Creating safety backup..."

mkdir -p "$BACKUP"

cp -r apps/dashboard "$BACKUP/dashboard"
cp -r apps/api "$BACKUP/api"

echo "Backup created:"
echo "$BACKUP"


echo "[2/12] Creating dashboard module directories..."

mkdir -p apps/dashboard/app/lifecycle
mkdir -p apps/dashboard/app/website-factory
mkdir -p apps/dashboard/app/activity
mkdir -p apps/dashboard/components/widgets


echo "[3/12] Creating Lifecycle Management module..."


cat > apps/dashboard/app/lifecycle/page.jsx <<'EOF'
"use client";

export default function Lifecycle(){

const services=[
{
client:"GreenGrid Infrastructure Africa",
service:"Solar-as-a-Service Enterprise",
stage:"OPERATE"
},
{
client:"Lagos Energy Solutions Ltd",
service:"Smart Energy Monitoring",
stage:"MONITOR"
},
{
client:"NovaSecure Technologies",
service:"Managed Cybersecurity Platform",
stage:"OPTIMIZE"
}
];


return (

<main style={{padding:"35px"}}>

<h1>
Lifecycle Management as a Service
</h1>

<p>
Enterprise service lifecycle orchestration
</p>


{services.map((item)=>(

<div
key={item.client}
style={{
background:"white",
padding:"20px",
margin:"15px",
borderRadius:"10px"
}}
>

<h3>{item.client}</h3>

<p>
Service: {item.service}
</p>

<strong>
Lifecycle Stage: {item.stage}
</strong>


</div>

))}


</main>

);

}
EOF



echo "[4/12] Creating Website Factory module..."


cat > apps/dashboard/app/website-factory/page.jsx <<'EOF'
"use client";


export default function WebsiteFactory(){


const sites=[

"Lagos Energy Solutions Customer Portal",

"Afrex Cloud Services Marketplace",

"NovaSecure Enterprise Website"

];


return (

<main style={{padding:"35px"}}>

<h1>
Website Factory as a Service
</h1>


<p>
Enterprise website provisioning and management
</p>


{sites.map(site=>(

<div
key={site}
style={{
background:"#fff",
padding:"20px",
margin:"15px",
borderRadius:"10px"
}}
>

<h3>{site}</h3>

<p>
Status: Production Ready
</p>

</div>

))}


</main>

);

}
EOF



echo "[5/12] Creating Activity Stream module..."


cat > apps/dashboard/app/activity/page.jsx <<'EOF'
"use client";


export default function Activity(){


const events=[

"Lagos Energy Solutions Ltd activated Solar Monitoring",

"Afrex Cloud Services Plc upgraded Enterprise Support",

"GreenGrid Infrastructure Africa lifecycle moved to OPERATE",

"NovaSecure Technologies completed compliance review"

];


return (

<main style={{padding:"35px"}}>

<h1>
Enterprise Activity Stream
</h1>


{events.map(event=>(

<div
key={event}
style={{
background:"#fff",
padding:"15px",
margin:"10px",
borderRadius:"8px"
}}
>

{event}

</div>

))}


</main>

);

}
EOF



echo "[6/12] Creating dashboard widgets..."


cat > apps/dashboard/components/widgets/MetricWidget.jsx <<'EOF'
export default function MetricWidget({title,value}){

return (

<div
style={{
background:"white",
padding:"20px",
borderRadius:"10px"
}}
>

<h3>{title}</h3>

<strong>
{value}
</strong>

</div>

);

}
EOF



echo "[7/12] Adding API lifecycle route structure..."


mkdir -p apps/api/src/routes/lifecycle


cat > apps/api/src/routes/lifecycle/index.js <<'EOF'

const express=require("express");

const router=express.Router();


router.get("/",(req,res)=>{

res.json({

success:true,

services:[

{
client:"GreenGrid Infrastructure Africa",
service:"Solar-as-a-Service",
stage:"OPERATE"
},

{
client:"NovaSecure Technologies",
service:"Managed Security",
stage:"MONITOR"
}

]

});

});


module.exports=router;

EOF



echo "[8/12] Creating enterprise seed data..."

mkdir -p apps/api/prisma/seed


cat > apps/api/prisma/seed/enterprise-demo-data.js <<'EOF'

module.exports=[

{
organisation:
"Lagos Energy Solutions Ltd",

service:
"Solar-as-a-Service Enterprise",

status:
"ACTIVE"

},


{
organisation:
"GreenGrid Infrastructure Africa",

service:
"Energy Monitoring Platform",

status:
"ACTIVE"

},


{
organisation:
"NovaSecure Technologies",

service:
"Cybersecurity Operations",

status:
"ACTIVE"

}

];


EOF



echo "[9/12] Updating module registry..."

cat >> apps/dashboard/lib/moduleRegistry.js <<'EOF'


// Sprint 43.7 Enterprise Modules

EOF



echo "[10/12] Rebuilding containers..."


docker compose build xaasgrid-dashboard
docker compose build xaasgrid-api


docker compose up -d



echo "[11/12] Running validation..."


sleep 10


curl -f http://localhost:4000/api/health

curl -I http://localhost:3000



echo "[12/12] Creating Git checkpoint..."


git add .

git commit \
-m "Sprint 43.7 Enterprise Intelligence Lifecycle Management Upgrade" || true


echo ""
echo "=============================================="
echo " Sprint 43.7 COMPLETE"
echo "=============================================="

echo "Backup:"
echo "$BACKUP"

echo ""
echo "New modules:"
echo " - Lifecycle Management as a Service"
echo " - Website Factory"
echo " - Activity Stream"
echo " - Dashboard Widgets"
echo " - Enterprise Seed Data"
