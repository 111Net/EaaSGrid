#!/bin/bash

set -e

PROJECT="/data/eaasgrid-platform"
DASHBOARD="$PROJECT/apps/dashboard"

echo "=========================================="
echo " Sprint 43.6 Enterprise UI Stabilization"
echo "=========================================="

cd "$PROJECT"


echo "[1/8] Creating backup..."

mkdir -p backups/sprint43.6-before

tar -czf backups/sprint43.6-before/dashboard-$(date +%Y%m%d-%H%M).tar.gz \
apps/dashboard


echo "[2/8] Creating component structure..."

mkdir -p $DASHBOARD/components/layout
mkdir -p $DASHBOARD/components/ui


cat > $DASHBOARD/components/layout/Sidebar.jsx <<'EOF'
"use client";

import Link from "next/link";
import {usePathname} from "next/navigation";


const menu=[
{
section:"MAIN",
items:[
["Dashboard","/dashboard"]
]
},
{
section:"PLATFORM",
items:[
["Enterprise","/enterprise"],
["Customers","/customer"],
["Operations","/operations"],
["Analytics","/analytics"],
["Marketplace","/marketplace"]
]
},
{
section:"SYSTEM",
items:[
["Administration","/admin"]
]
}
];


export default function Sidebar(){

const path=usePathname();


return (

<aside className="sidebar">

<h2>
XaaSGrid
</h2>

<p className="sidebar-sub">
Enterprise Console
</p>


{
menu.map(group=>

<div key={group.section}>

<h5>
{group.section}
</h5>


{
group.items.map(item=>

<Link
key={item[1]}
href={item[1]}
className={
path===item[1]
?"active-link"
:"menu-link"
}
>

{item[0]}

</Link>

)

}

</div>

)

}


</aside>

)

}
EOF



cat > $DASHBOARD/components/layout/Header.jsx <<'EOF'
export default function Header(){

return (

<header className="header">

<h3>
XaaSGrid Enterprise Console
</h3>


<div>

SUPER_ADMIN

</div>

</header>

)

}
EOF



cat > $DASHBOARD/components/layout/AppShell.jsx <<'EOF'
import Sidebar from "./Sidebar";
import Header from "./Header";


export default function AppShell({children}){

return (

<div className="app-shell">

<Sidebar/>


<div className="workspace">

<Header/>


<main className="content">

{children}

</main>


</div>


</div>

)

}
EOF



echo "[3/8] Creating global layout..."


cat > $DASHBOARD/app/layout.tsx <<'EOF'
import "./globals.css";
import AppShell from "../components/layout/AppShell";


export const metadata={
title:"XaaSGrid Enterprise Console",
description:"Everything-as-a-Service Platform"
};


export default function RootLayout({
children
}:{
children:React.ReactNode
}){


return (

<html lang="en">

<body>

<AppShell>

{children}

</AppShell>

</body>

</html>

)

}
EOF



echo "[4/8] Replacing styling..."


cat > $DASHBOARD/app/globals.css <<'EOF'
*{
box-sizing:border-box;
}


html,
body{
margin:0;
padding:0;
font-family:
Inter,
Arial,
sans-serif;

background:#f8fafc;

color:#111827;
}


a{
text-decoration:none;
}


.app-shell{

display:flex;
min-height:100vh;

}


.sidebar{

width:260px;

background:#111827;

color:white;

padding:25px;

}


.sidebar h2{

font-size:28px;

margin-bottom:5px;

}


.sidebar-sub{

opacity:.7;

}


.sidebar h5{

margin-top:30px;

font-size:12px;

opacity:.5;

}


.menu-link,
.active-link{

display:block;

padding:12px;

margin:6px 0;

border-radius:8px;

color:white;

}


.active-link{

background:#2563eb;

}


.menu-link:hover{

background:#1f2937;

}


.workspace{

flex:1;

}


.header{

height:70px;

background:white;

border-bottom:1px solid #e5e7eb;

display:flex;

justify-content:space-between;

align-items:center;

padding:0 35px;

}


.content{

padding:35px;

}


.card-grid{

display:grid;

grid-template-columns:
repeat(auto-fit,minmax(220px,1fr));

gap:20px;

}


.card{

background:white;

padding:25px;

border-radius:15px;

box-shadow:
0 5px 20px
rgba(0,0,0,.06);

}
EOF



echo "[5/8] Creating dashboard..."

cat > $DASHBOARD/app/dashboard/page.jsx <<'EOF'
const metrics=[

["Organizations","25"],
["Tenants","142"],
["Customers","1840"],
["Availability","99.95%"]

];


export default function Dashboard(){


return (

<>

<h1>
Platform Overview
</h1>


<p>
Everything-as-a-Service operating environment.
</p>


<div className="card-grid">


{
metrics.map(m=>

<div className="card" key={m[0]}>

<h3>
{m[0]}
</h3>

<h1>
{m[1]}
</h1>

<p>
Operational
</p>

</div>

)

}


</div>


<h2 style={{marginTop:40}}>
Platform Health
</h2>


<div className="card-grid">

<div className="card">
API
<br/>
ONLINE
</div>

<div className="card">
Database
<br/>
ONLINE
</div>


<div className="card">
Redis
<br/>
ONLINE
</div>


<div className="card">
Workers
<br/>
ONLINE
</div>


</div>


</>

)

}
EOF



echo "[6/8] Updating module pages..."


for MODULE in enterprise customer operations analytics marketplace admin
do

mkdir -p $DASHBOARD/app/$MODULE


cat > $DASHBOARD/app/$MODULE/page.jsx <<EOF

export default function Page(){

return (

<>

<h1>
${MODULE^}
</h1>

<div className="card">

<h3>
${MODULE^} Module
</h3>

<p>
XaaSGrid ${MODULE} services and intelligence layer.
</p>

</div>

</>

)

}

EOF

done



echo "[7/8] Building dashboard..."

docker compose build xaasgrid-dashboard

docker compose up -d xaasgrid-dashboard


echo "[8/8] Validation..."

curl -I http://localhost:3000


echo "=========================================="
echo " Sprint 43.6 Complete"
echo "=========================================="
