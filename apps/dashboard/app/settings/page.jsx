import DashboardLayout from "@/components/layout/DashboardLayout";
import IntelligenceCard from "@/components/intelligence/IntelligenceCard";
import IntelligenceGrid from "@/components/intelligence/IntelligenceGrid";


export default function Settings(){


return (

<DashboardLayout>


<h1
style={{
fontSize:"36px",
fontWeight:"800",
marginBottom:"10px"
}}
>
⚙️ Platform Configuration Centre
</h1>


<p>
XaaSGrid environment management, infrastructure controls and system configuration
</p>



<IntelligenceGrid>



<IntelligenceCard
title="Platform Environment"
icon="🌐"
color="#2563eb"
>

Environment:

<br/>

Production Ready

<br/><br/>

Framework:

<br/>

Next.js 16.2.10

<br/><br/>

Deployment:

<br/>

Self Hosted

</IntelligenceCard>



<IntelligenceCard
title="Infrastructure Health"
icon="🖥️"
color="#16a34a"
>

API:

<br/>

Connected

<br/><br/>

Database:

<br/>

PostgreSQL Healthy

<br/><br/>

Cache:

<br/>

Redis Ready

</IntelligenceCard>



<IntelligenceCard
title="Automation Controls"
icon="🤖"
color="#7c3aed"
>

Guardian:

<br/>

Enabled

<br/><br/>

Self Healing:

<br/>

Active

<br/><br/>

Lifecycle Engine:

<br/>

Running

</IntelligenceCard>



<IntelligenceCard
title="System Configuration"
icon="🔧"
color="#f59e0b"
>

Authentication:

<br/>

RBAC Enabled

<br/><br/>

Monitoring:

<br/>

Active

<br/><br/>

Security:

<br/>

Protected

</IntelligenceCard>



</IntelligenceGrid>



</DashboardLayout>

);

}
