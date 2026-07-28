#!/bin/bash

set -e

ROOT="/data/eaasgrid-platform/apps/dashboard"

echo "======================================"
echo " XaaSGrid Module 14 Step 6 Hardening"
echo "======================================"

cd $ROOT


echo "[1] Backup layout files"

mkdir -p backups/module14

cp components/layout/Navbar.jsx backups/module14/Navbar.jsx.$(date +%s)
cp components/layout/DashboardLayout.jsx backups/module14/DashboardLayout.jsx.$(date +%s)


echo "[2] Repair Navbar hydration"


cat > components/layout/Navbar.jsx <<'EOF'
"use client";

import { useState } from "react";

export default function Navbar(){

const [user] = useState({
email:"admin@eaasgrid.com"
});


return (

<nav
style={{
height:"70px",
background:"linear-gradient(90deg,#001f3f,#0074D9,#00c853)",
color:"white",
display:"flex",
alignItems:"center",
justifyContent:"space-between",
padding:"0 30px",
fontWeight:"600"
}}
>

<div>
⚡ XaaSGrid Command Centre
</div>


<div>

<span>
{user.email}
</span>

</div>


</nav>

);

}
EOF



echo "[3] Upgrade Dashboard Layout"


cat > components/layout/DashboardLayout.jsx <<'EOF'
"use client";

import Sidebar from "./Sidebar";
import Navbar from "./Navbar";


export default function DashboardLayout({children}){


return (

<div
style={{
display:"flex",
minHeight:"100vh"
}}
>


<Sidebar />


<div
style={{
flex:1,
marginLeft:"260px"
}}
>


<Navbar />


<main
style={{
padding:"35px",
background:"#f4f7fb",
minHeight:"calc(100vh - 70px)"
}}
>

{children}

</main>


</div>


</div>

);

}
EOF



echo "[4] Upgrade Control Centre header"

python3 <<'PY'

from pathlib import Path

p=Path("app/control-centre/page.jsx")

text=p.read_text()

text=text.replace(
"Executive Platform Intelligence",
"""
<div
style={{
background:"linear-gradient(135deg,#001f3f,#0074D9,#00c853)",
color:"white",
padding:"35px",
borderRadius:"20px",
marginBottom:"30px",
boxShadow:"0 10px 30px rgba(0,0,0,.25)"
}}
>

<h1 style={{
fontSize:"38px",
marginBottom:"10px"
}}>
Executive Platform Intelligence
</h1>

<p style={{
fontSize:"18px"
}}>
Real-time XaaSGrid Command Centre
</p>

</div>
"""
)

p.write_text(text)

PY



echo "[5] Clear cache"

rm -rf .next
rm -rf node_modules/.cache


echo "[6] Test build"

npm run lint || true

npx next build


echo "======================================"
echo " MODULE 14 STEP 6 COMPLETE"
echo "======================================"
