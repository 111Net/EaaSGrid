#!/bin/bash

cd /data/eaasgrid-platform/apps/dashboard

echo "Repairing Module 14 pages..."

create_page(){

DIR=$1
TITLE=$2
ICON=$3
DESC=$4

mkdir -p app/$DIR

cat > app/$DIR/page.jsx <<EOF
"use client";

import DashboardLayout from "@/components/layout/DashboardLayout";

export default function Page(){

return (

<DashboardLayout>

<div
style={{
background:"linear-gradient(135deg,#001f3f,#0074D9)",
color:"white",
padding:"35px",
borderRadius:"20px",
marginBottom:"30px"
}}
>

<h1>
$ICON $TITLE
</h1>

<p>
$DESC
</p>

</div>


<div
style={{
display:"grid",
gridTemplateColumns:"repeat(auto-fit,minmax(250px,1fr))",
gap:"20px"
}}
>


<div className="card">
<h2>Status</h2>
<p>Operational</p>
</div>


<div className="card">
<h2>Platform Integration</h2>
<p>XaaSGrid Engine Connected</p>
</div>


<div className="card">
<h2>Monitoring</h2>
<p>Real-time Intelligence Active</p>
</div>


</div>


</DashboardLayout>

);

}
EOF

}


create_page analytics "Analytics Intelligence" "📊" "Business analytics and platform insights"

create_page users "User Administration" "👥" "Identity and access management"

create_page security "Security Operations" "🔐" "Cybersecurity monitoring and controls"

create_page monitoring "Monitoring Centre" "📡" "Infrastructure and energy monitoring"

create_page settings "Platform Settings" "⚙️" "System configuration management"

create_page billing "Revenue & Billing" "💰" "Financial intelligence and subscriptions"


echo "Pages repaired"
