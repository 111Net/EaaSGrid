"use client";

import RoleGuard from "@/components/RoleGuard";
import MetricCard from "@/components/dashboard/MetricCard";


export default function Operations(){


return (

<RoleGuard allowedRoles={["OPERATIONS","ADMIN"]}>


<div style={{padding:"30px"}}>


<h1>
Operations Dashboard
</h1>


<div style={{
display:"flex",
gap:"20px",
flexWrap:"wrap"
}}>


<MetricCard
title="Active Sites"
value="0"
description="Sites online"
/>


<MetricCard
title="Alerts"
value="0"
description="Maintenance alerts"
/>


<MetricCard
title="Assets"
value="0"
description="Connected devices"
/>


</div>


</div>


</RoleGuard>

);


}
