#!/bin/bash

set -e

cd /data/eaasgrid-platform/apps/dashboard


echo "======================================"
echo " XaaSGrid Module 14 Step 7"
echo " Dashboard Page Population"
echo "======================================"


create_page(){

PATHNAME=$1
ICON=$2
TITLE=$3
DESC=$4
CARD1=$5
VALUE1=$6
CARD2=$7
VALUE2=$8
CARD3=$9
VALUE3=${10}


mkdir -p app/$PATHNAME


cat > app/$PATHNAME/page.jsx <<EOF
"use client";

import DashboardLayout from "@/components/layout/DashboardLayout";


export default function Page(){

return (

<DashboardLayout>


<div
style={{
background:"linear-gradient(135deg,#001f3f,#0074D9,#00c853)",
color:"white",
padding:"40px",
borderRadius:"22px",
marginBottom:"30px"
}}
>

<h1 style={{fontSize:"38px"}}>
$ICON $TITLE
</h1>

<p style={{fontSize:"18px"}}>
$DESC
</p>


</div>



<div
style={{
display:"grid",
gridTemplateColumns:"repeat(auto-fit,minmax(250px,1fr))",
gap:"25px"
}}
>


<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>$CARD1</h2>
<h3>$VALUE1</h3>

</div>



<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>$CARD2</h2>
<h3>$VALUE2</h3>

</div>



<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>$CARD3</h2>
<h3>$VALUE3</h3>

</div>


</div>


</DashboardLayout>

);

}
EOF

}


create_page \
operations \
"⚙️" \
"Operations Command Centre" \
"Operational workflows, field activities and service management" \
"Active Sites" \
"6" \
"System Health" \
"99.2%" \
"Incidents" \
"0"



create_page \
analytics \
"📊" \
"Analytics Intelligence" \
"Executive analytics, performance trends and business insights" \
"Energy Generated" \
"18.6 kWh" \
"Revenue Trend" \
"Growing" \
"Reports" \
"Available"



create_page \
users \
"👥" \
"User Administration" \
"Identity management and role governance" \
"Active Users" \
"Admin + Roles" \
"RBAC Status" \
"Enabled" \
"Sessions" \
"Protected"



create_page \
security \
"🔐" \
"Security Operations" \
"Cybersecurity monitoring and platform protection" \
"Threat Status" \
"Secure" \
"Firewall" \
"Active" \
"Audit Logs" \
"Enabled"



create_page \
settings \
"⚙️" \
"Platform Settings" \
"System configuration and environment management" \
"Platform" \
"XaaSGrid" \
"Version" \
"1.0" \
"Environment" \
"Production Ready"



create_page \
monitoring \
"📡" \
"Energy Monitoring Centre" \
"Real-time infrastructure and energy visibility" \
"Connected Assets" \
"6" \
"Battery Usage" \
"82%" \
"Availability" \
"99.2%"



create_page \
billing \
"💰" \
"Revenue & Billing Intelligence" \
"Financial engine and subscription management" \
"Monthly Revenue" \
"₦2.4M" \
"Portfolio Value" \
"₦298M" \
"Billing Status" \
"Active"



echo ""
echo "======================================"
echo " Module 14 Step 7 Completed"
echo "======================================"
