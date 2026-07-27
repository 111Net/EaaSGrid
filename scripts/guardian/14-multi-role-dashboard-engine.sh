#!/bin/bash


BASE="/data/eaasgrid-platform/apps/dashboard/app"


echo "============================================"
echo " EaaSGrid Multi Role Dashboard Engine"
echo " Module 14"
date
echo "============================================"


echo ""
echo "Creating role dashboard components"
echo "--------------------------------"


mkdir -p \
$BASE/operations \
$BASE/partner \
$BASE/investor \
$BASE/customer \
$BASE/collaborator


echo "[PASS] Dashboard routes created"



echo ""
echo "Creating role dashboard pages"
echo "--------------------------------"



cat > $BASE/operations/page.jsx <<'EOF'
import RoleGuard from "@/components/RoleGuard";


export default function Operations(){

return (

<RoleGuard allowedRoles={["OPERATIONS","ADMIN"]}>


<div>

<h1>
Operations Dashboard
</h1>

<p>
Site monitoring, assets, maintenance and alerts
</p>


</div>


</RoleGuard>

);

}
EOF



cat > $BASE/partner/page.jsx <<'EOF'
import RoleGuard from "@/components/RoleGuard";


export default function Partner(){

return (

<RoleGuard allowedRoles={["PARTNER","ADMIN"]}>


<div>

<h1>
Partner Portal
</h1>

<p>
Providers, installations and service partners
</p>


</div>


</RoleGuard>

);

}
EOF



cat > $BASE/investor/page.jsx <<'EOF'
import RoleGuard from "@/components/RoleGuard";


export default function Investor(){

return (

<RoleGuard allowedRoles={["INVESTOR","ADMIN"]}>


<div>

<h1>
Investor Dashboard
</h1>

<p>
Portfolio performance and investment intelligence
</p>


</div>


</RoleGuard>

);

}
EOF



cat > $BASE/customer/page.jsx <<'EOF'
import RoleGuard from "@/components/RoleGuard";


export default function Customer(){

return (

<RoleGuard allowedRoles={["CUSTOMER","ADMIN"]}>


<div>

<h1>
Customer Energy Dashboard
</h1>


<p>
Consumption, billing and service information
</p>


</div>


</RoleGuard>

);

}
EOF



cat > $BASE/collaborator/page.jsx <<'EOF'
import RoleGuard from "@/components/RoleGuard";


export default function Collaborator(){

return (

<RoleGuard allowedRoles={["COLLABORATOR","ADMIN"]}>


<div>

<h1>
Collaborator Workspace
</h1>


<p>
Projects, tasks and shared activities
</p>


</div>


</RoleGuard>

);

}
EOF



echo "[PASS] Role dashboards generated"



echo ""
echo "Creating dashboard registry"


cat > /data/eaasgrid-platform/scripts/guardian/dashboard-role-map.json <<EOF
{
"ADMIN":"/control-centre",
"OPERATIONS":"/operations",
"PARTNER":"/partner",
"INVESTOR":"/investor",
"CUSTOMER":"/customer",
"COLLABORATOR":"/collaborator"
}
EOF


echo "[PASS] Dashboard role map created"



echo ""
echo "============================================"
echo " MODULE 14 COMPLETE"
echo "============================================"
