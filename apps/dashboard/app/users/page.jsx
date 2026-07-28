import DashboardLayout from "@/components/layout/DashboardLayout";
import IntelligenceCard from "@/components/intelligence/IntelligenceCard";
import IntelligenceGrid from "@/components/intelligence/IntelligenceGrid";


export default function Users(){


return (

<DashboardLayout>


<h1
style={{
fontSize:"36px",
fontWeight:"800",
marginBottom:"10px"
}}
>
👥 Identity & Access Intelligence
</h1>


<p>
Enterprise user management, roles and permission governance
</p>



<IntelligenceGrid>


<IntelligenceCard
title="Active Users"
icon="👤"
color="#2563eb"
>

Total Users:

<br/>

5

<br/><br/>

Active Sessions:

<br/>

3

<br/><br/>

Status:

<br/>

Healthy

</IntelligenceCard>



<IntelligenceCard
title="Role Management"
icon="🔑"
color="#7c3aed"
>

ADMIN

<br/>

Full Platform Access


<br/><br/>

OPERATIONS

<br/>

Infrastructure Control


<br/><br/>

PARTNER

<br/>

Service Access

</IntelligenceCard>



<IntelligenceCard
title="Access Security"
icon="🛡️"
color="#16a34a"
>

Authentication:

<br/>

Enabled

<br/><br/>

RBAC:

<br/>

Active

<br/><br/>

Session Monitoring:

<br/>

Enabled

</IntelligenceCard>



<IntelligenceCard
title="User Activity"
icon="📊"
color="#f59e0b"
>

Login Events:

<br/>

Tracked

<br/><br/>

Audit Trail:

<br/>

Enabled

<br/><br/>

Compliance:

<br/>

Monitoring

</IntelligenceCard>



</IntelligenceGrid>



</DashboardLayout>

);

}
