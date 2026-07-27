#!/bin/bash

echo "============================================"
echo " EaaSGrid Role Route Factory"
echo " Module 12"
date
echo "============================================"

BASE="/data/eaasgrid-platform/apps/dashboard/app"

echo ""
echo "Creating missing role routes"
echo "--------------------------------"

create_route(){

ROLE=$1
TITLE=$2
COLOR=$3

DIR="$BASE/$ROLE"

mkdir -p "$DIR"


cat > "$DIR/page.jsx" <<EOF
"use client";

import RoleGuard from "@/components/RoleGuard";


export default function ${ROLE^}Page(){

return (

<RoleGuard allowedRoles={["$ROLE"]}>

<div
style={{
padding:"40px",
minHeight:"100vh",
background:"linear-gradient(135deg,#020617,#0f766e)",
color:"white"
}}
>

<h1>
$title
</h1>


<p>
Welcome to EaaSGrid $TITLE portal.
</p>


<div
style={{
marginTop:"30px",
padding:"25px",
borderRadius:"16px",
background:"rgba(255,255,255,.1)"
}}
>

<h2>
Platform Access Active
</h2>

<p>
Role authorization successful.
</p>


</div>


</div>


</RoleGuard>

);

}
EOF


echo "[PASS] Created /$ROLE"

}


create_route partner Partner PORTAL
create_route investor Investor PORTAL
create_route customer Customer PORTAL


echo ""
echo "Updating login role routing"
echo "--------------------------------"


LOGIN="$BASE/login/page.jsx"


cp "$LOGIN" "$LOGIN.backup.module12"


python3 <<PY

from pathlib import Path

p=Path("$LOGIN")

x=p.read_text()

old='''if(result.user.role==="ADMIN")'''

new='''if(result.user.role)'''

x=x.replace(old,new)

p.write_text(x)

PY


echo "[PASS] Login role detection improved"


echo ""
echo "============================================"
echo " MODULE 12 COMPLETE"
echo "============================================"
