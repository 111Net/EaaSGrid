import DashboardLayout from "@/components/layout/DashboardLayout";
import IntelligenceCard from "@/components/intelligence/IntelligenceCard";
import IntelligenceGrid from "@/components/intelligence/IntelligenceGrid";


export default function Operations(){


return (

<DashboardLayout>


<h1
style={{
fontSize:"36px",
fontWeight:"800"
}}
>
⚙ Operations Intelligence
</h1>


<p>
Real-time infrastructure operations command centre
</p>



<IntelligenceGrid>


<IntelligenceCard
title="Platform Health"
icon="🟢"
color="#16a34a"
>

System Status:
<br/>

Operational

<br/><br/>

API:
Connected

<br/>

Database:
Healthy

</IntelligenceCard>



<IntelligenceCard
title="Energy Assets"
icon="⚡"
color="#f59e0b"
>

Connected Sites:
6

<br/>

Solar Monitoring:
Active

<br/>

Battery Systems:
Online

</IntelligenceCard>



<IntelligenceCard
title="Automation Engine"
icon="🤖"
color="#7c3aed"
>

Guardian:
Active

<br/>

Self Healing:
Enabled

<br/>

Lifecycle Engine:
Running

</IntelligenceCard>



</IntelligenceGrid>



</DashboardLayout>

);

}
