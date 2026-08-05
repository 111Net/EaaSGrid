#!/bin/bash

set -e

ROOT=/data/eaasgrid-platform/apps/dashboard

echo "=== XaaSGrid Dashboard Stabilization ==="


mkdir -p $ROOT/components
mkdir -p $ROOT/app/dashboard
mkdir -p $ROOT/app/analytics
mkdir -p $ROOT/app/operations
mkdir -p $ROOT/app/admin


cat > $ROOT/components/KPICard.jsx <<'EOF'
export default function KPICard({title,value,status}) {

return (
<div style={{
background:"#ffffff",
padding:"25px",
borderRadius:"14px",
boxShadow:"0 4px 15px rgba(0,0,0,.08)"
}}>

<h3>{title}</h3>

<h1>
{value}
</h1>

<p>
{status}
</p>

</div>
)

}
EOF


cat > $ROOT/components/Sidebar.jsx <<'EOF'
"use client";

import Link from "next/link";

const links=[
["Dashboard","/dashboard"],
["Enterprise","/enterprise"],
["Customers","/customer"],
["Operations","/operations"],
["Analytics","/analytics"],
["Marketplace","/marketplace"],
["Administration","/admin"]
];


export default function Sidebar(){

return (

<aside style={{
width:"260px",
background:"#111827",
color:"white",
minHeight:"100vh",
padding:"25px"
}}>

<h2>
XaaSGrid
</h2>

<p>
Enterprise Console
</p>

<hr/>


{
links.map(x=>

<div key={x[1]} style={{
margin:"18px 0"
}}>

<Link
href={x[1]}
style={{
color:"white",
textDecoration:"none",
fontSize:"16px"
}}
>

{x[0]}

</Link>

</div>

)

}


</aside>

)

}
EOF



cat > $ROOT/app/page.js <<'EOF'
import Link from "next/link";

export default function Home(){

return (

<div style={{
padding:"50px",
fontFamily:"Arial"
}}>

<h1>
XaaSGrid Enterprise Platform
</h1>

<p>
Everything-as-a-Service Operating System
</p>


<Link href="/dashboard">
Open Enterprise Dashboard →
</Link>


</div>

)

}
EOF



cat > $ROOT/app/dashboard/page.jsx <<'EOF'
"use client";

import Sidebar from "../../components/Sidebar";
import KPICard from "../../components/KPICard";


export default function Dashboard(){

const metrics=[
["Organizations","25","Healthy"],
["Tenants","142","Active"],
["Customers","1840","Online"],
["Availability","99.95%","Operational"]
];


return (

<div style={{
display:"flex",
background:"#f3f4f6",
minHeight:"100vh"
}}>


<Sidebar/>


<main style={{
padding:"40px",
flex:1
}}>


<h1>
XaaSGrid Enterprise Dashboard
</h1>


<p>
Platform overview and operational intelligence
</p>


<div style={{
display:"grid",
gridTemplateColumns:"repeat(4,1fr)",
gap:"20px"
}}>


{
metrics.map(m=>

<KPICard
key={m[0]}
title={m[0]}
value={m[1]}
status={m[2]}
/>

)

}


</div>


<h2 style={{
marginTop:"40px"
}}>
Platform Modules
</h2>


<ul>

<li><Link href="/enterprise">Enterprise Management</Link></li>
<li><Link href="/operations">Operations Intelligence</Link></li>
<li><Link href="/analytics">Analytics Engine</Link></li>
<li><Link href="/admin">Administration</Link></li>

</ul>


</main>


</div>

)

}
EOF



cat > $ROOT/app/analytics/page.jsx <<'EOF'
export default function Analytics(){

return (
<div style={{padding:"40px"}}>

<h1>
Analytics Engine
</h1>

<p>
Platform analytics, AI recommendations and reporting will appear here.
</p>

</div>
)

}
EOF



cat > $ROOT/app/operations/page.js <<'EOF'
export default function Operations(){

return (
<div style={{padding:"40px"}}>

<h1>
Operations Intelligence
</h1>

<p>
Infrastructure monitoring and service health.
</p>

</div>
)

}
EOF



cat > $ROOT/app/admin/page.jsx <<'EOF'
export default function Admin(){

return (
<div style={{padding:"40px"}}>

<h1>
Administration
</h1>

<p>
System administration and governance controls.
</p>

</div>
)

}
EOF



echo "Rebuilding dashboard..."

docker compose build xaasgrid-dashboard

docker compose up -d xaasgrid-dashboard


echo "=== Dashboard Stabilization Complete ==="
