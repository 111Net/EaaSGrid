import DashboardLayout from "@/components/layout/DashboardLayout";
import IntelligenceCard from "@/components/intelligence/IntelligenceCard";
import IntelligenceGrid from "@/components/intelligence/IntelligenceGrid";


export default function Security(){


return (

<DashboardLayout>


<h1
style={{
fontSize:"36px",
fontWeight:"800",
marginBottom:"10px"
}}
>
🔐 Security Operations Centre
</h1>


<p>
Cybersecurity posture, compliance monitoring and platform protection
</p>



<IntelligenceGrid>



<IntelligenceCard
title="Security Posture"
icon="🛡️"
color="#16a34a"
>

Overall Status:

<br/>

Protected

<br/><br/>

Threat Level:

<br/>

Low

<br/><br/>

Security Monitoring:

<br/>

Active

</IntelligenceCard>




<IntelligenceCard
title="Access Control"
icon="🔑"
color="#2563eb"
>

RBAC:

<br/>

Enabled

<br/><br/>

Authentication:

<br/>

Secure

<br/><br/>

Session Management:

<br/>

Active

</IntelligenceCard>




<IntelligenceCard
title="Audit Intelligence"
icon="📋"
color="#7c3aed"
>

Audit Logs:

<br/>

Enabled

<br/><br/>

User Activities:

<br/>

Tracked

<br/><br/>

Compliance:

<br/>

Monitoring

</IntelligenceCard>




<IntelligenceCard
title="Guardian Protection"
icon="🤖"
color="#f59e0b"
>

Self Healing:

<br/>

Enabled

<br/><br/>

Infrastructure Checks:

<br/>

Running

<br/><br/>

Lifecycle Monitoring:

<br/>

Active

</IntelligenceCard>



</IntelligenceGrid>


</DashboardLayout>

);

}
