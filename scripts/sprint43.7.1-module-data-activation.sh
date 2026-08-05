#!/bin/bash

set -e

PROJECT="/data/eaasgrid-platform"
BACKUP="$PROJECT/backups/sprint43.7.1-$(date +%Y%m%d-%H%M)"

echo "=============================================="
echo " Sprint 43.7.1 Enterprise Module Data Activation"
echo "=============================================="

cd $PROJECT


echo "[1/10] Creating backup..."

mkdir -p $BACKUP

cp -r apps/dashboard/app $BACKUP/dashboard-app
cp -r apps/dashboard/components $BACKUP/components


echo "[2/10] Creating enterprise data layer..."

mkdir -p apps/dashboard/lib


cat > apps/dashboard/lib/enterpriseData.js <<'EOF'

export const customers=[

{
name:"Lagos Energy Solutions Ltd",
sector:"Energy",
services:3,
revenue:"₦18.4M",
status:"ACTIVE"
},

{
name:"GreenGrid Infrastructure Africa",
sector:"Renewable Energy",
services:5,
revenue:"₦26.8M",
status:"ACTIVE"
},

{
name:"NovaSecure Technologies",
sector:"Cybersecurity",
services:4,
revenue:"₦14.2M",
status:"ACTIVE"
},

{
name:"Afrex Cloud Services Plc",
sector:"Cloud Infrastructure",
services:6,
revenue:"₦32.5M",
status:"ACTIVE"
}

];


export const operations=[

{
service:"XaaSGrid API",
status:"ONLINE",
uptime:"99.98%"
},

{
service:"PostgreSQL Cluster",
status:"ONLINE",
uptime:"99.99%"
},

{
service:"Redis Cache",
status:"ONLINE",
uptime:"99.97%"
},

{
service:"Worker Services",
status:"ONLINE",
uptime:"99.95%"
}

];


export const services=[

{
name:"Solar-as-a-Service",
provider:"GreenGrid Infrastructure Africa",
customers:142
},

{
name:"Managed Cybersecurity",
provider:"NovaSecure Technologies",
customers:76
},

{
name:"Cloud Infrastructure",
provider:"Afrex Cloud Services Plc",
customers:58
},

{
name:"AI Automation Platform",
provider:"XaaSGrid AI Services",
customers:50
}

];


export const lifecycle=[

{
client:"GreenGrid Infrastructure Africa",
service:"Solar Monitoring Platform",
stage:"OPERATE",
health:"99.97%"
},

{
client:"Lagos Energy Solutions Ltd",
service:"Energy Analytics",
stage:"MONITOR",
health:"99.92%"
},

{
client:"NovaSecure Technologies",
service:"Security Operations",
stage:"OPTIMIZE",
health:"99.95%"
}

];


export const activities=[

"GreenGrid Infrastructure Africa deployed 250 new monitoring nodes",

"Lagos Energy Solutions Ltd renewed enterprise subscription",

"NovaSecure Technologies completed security audit",

"Afrex Cloud Services Plc expanded cloud capacity"

];

EOF



echo "[3/10] Creating reusable components..."


mkdir -p apps/dashboard/components/widgets


cat > apps/dashboard/components/widgets/StatCard.jsx <<'EOF'

export default function StatCard({title,value}){

return (

<div
style={{
background:"white",
padding:"20px",
borderRadius:"12px",
boxShadow:"0 2px 8px #ddd"
}}
>

<h3>{title}</h3>

<h2>{value}</h2>

</div>

);

}

EOF



cat > apps/dashboard/components/widgets/Table.jsx <<'EOF'

export default function Table({items}){

return (

<div>

{items.map((item,i)=>(

<div
key={i}
style={{
background:"white",
margin:"10px",
padding:"15px",
borderRadius:"8px"
}}
>

{Object.entries(item).map(([k,v])=>(

<p key={k}>
<strong>{k}:</strong> {v}
</p>

))}

</div>

))}

</div>

);

}

EOF



echo "[4/10] Replacing Analytics..."


cat > apps/dashboard/app/analytics/page.jsx <<'EOF'

"use client";

import {customers,services} from "../../lib/enterpriseData";
import StatCard from "../../components/widgets/StatCard";


export default function Analytics(){

return (

<main style={{padding:"35px"}}>

<h1>Analytics Intelligence</h1>


<div style={{
display:"grid",
gridTemplateColumns:"repeat(3,1fr)",
gap:"20px"
}}>

<StatCard title="Monthly Revenue" value="₦84.6M"/>

<StatCard title="Active Subscriptions" value="326"/>

<StatCard title="Customer Growth" value="+18.4%"/>

</div>


<h2>Top Customers</h2>

{customers.map(c=>(

<p key={c.name}>
{c.name} - {c.revenue}
</p>

))}


<h2>Services</h2>

{services.map(s=>(

<p key={s.name}>
{s.name} ({s.customers} customers)
</p>

))}


</main>

)

}

EOF



echo "[5/10] Replacing Operations..."


cat > apps/dashboard/app/operations/page.js <<'EOF'

"use client";

import {operations} from "../../lib/enterpriseData";


export default function Operations(){

return (

<main style={{padding:"35px"}}>

<h1>Operations Command Centre</h1>


{operations.map(o=>(

<div
key={o.service}
style={{
background:"white",
padding:"20px",
margin:"15px",
borderRadius:"10px"
}}
>

<h3>{o.service}</h3>

<p>Status: {o.status}</p>

<p>Uptime: {o.uptime}</p>


</div>

))}


</main>

)

}

EOF



echo "[6/10] Replacing Marketplace..."


cat > apps/dashboard/app/marketplace/page.tsx <<'EOF'

"use client";

import {services} from "../../lib/enterpriseData";


export default function Marketplace(){

return (

<main style={{padding:"35px"}}>

<h1>XaaS Marketplace</h1>


{services.map(s=>(

<div
key={s.name}
style={{
background:"white",
padding:"20px",
margin:"15px"
}}
>

<h3>{s.name}</h3>

<p>
Provider: {s.provider}
</p>

<p>
Customers: {s.customers}
</p>

</div>

))}


</main>

)

}

EOF



echo "[7/10] Replacing Lifecycle..."


cat > apps/dashboard/app/lifecycle/page.jsx <<'EOF'

"use client";

import {lifecycle} from "../../lib/enterpriseData";


export default function Lifecycle(){

return (

<main style={{padding:"35px"}}>

<h1>Lifecycle Management as a Service</h1>


{lifecycle.map(x=>(

<div
key={x.client}
style={{
background:"white",
padding:"20px",
margin:"15px"
}}
>

<h3>{x.client}</h3>

<p>{x.service}</p>

<p>
Lifecycle Stage: {x.stage}
</p>

<p>
Health: {x.health}
</p>


</div>

))}


</main>

)

}

EOF



echo "[8/10] Replacing Activity..."


cat > apps/dashboard/app/activity/page.jsx <<'EOF'

"use client";

import {activities} from "../../lib/enterpriseData";


export default function Activity(){

return (

<main style={{padding:"35px"}}>

<h1>Enterprise Activity Stream</h1>


{activities.map(a=>(

<div
key={a}
style={{
background:"white",
padding:"15px",
margin:"10px"
}}
>

{a}

</div>

))}

</main>

)

}

EOF



echo "[9/10] Rebuilding Dashboard..."


docker compose build xaasgrid-dashboard

docker compose up -d xaasgrid-dashboard



echo "[10/10] Validation..."

sleep 10

curl -f http://localhost:4000/api/health

curl -I http://localhost:3000


git add .

git commit -m "Sprint 43.7.1 enterprise module data activation" || true


echo ""
echo "=============================================="
echo " Sprint 43.7.1 COMPLETE"
echo "=============================================="
echo "Backup:"
echo $BACKUP
