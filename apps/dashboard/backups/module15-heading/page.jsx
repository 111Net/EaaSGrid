import DashboardLayout from "@/components/layout/DashboardLayout";
import IntelligenceCard from "@/components/intelligence/IntelligenceCard";
import IntelligenceGrid from "@/components/intelligence/IntelligenceGrid";


export default function Analytics(){


return (

<DashboardLayout>


<h1
style={{
fontSize:"36px",
fontWeight:"800",
marginBottom:"10px"
}}
>
📊 Analytics Intelligence Centre
</h1>


<p>
Enterprise analytics, performance intelligence and business forecasting engine
</p>



<IntelligenceGrid>


<IntelligenceCard
title="Energy Analytics"
icon="⚡"
color="#f59e0b"
>

Monthly Generation:

<br/>

18.6 MWh

<br/><br/>

Battery Utilisation:

<br/>

82%

<br/><br/>

Availability:

<br/>

99.2%

</IntelligenceCard>



<IntelligenceCard
title="Revenue Intelligence"
icon="💰"
color="#16a34a"
>

Monthly Revenue:

<br/>

₦2,400,000

<br/><br/>

Portfolio Value:

<br/>

₦298,000,000

<br/><br/>

Growth Model:

<br/>

Subscription XaaS

</IntelligenceCard>



<IntelligenceCard
title="Investor Analytics"
icon="📈"
color="#2563eb"
>

Pilot Sites:

<br/>

6

<br/><br/>

Annual Deployment Target:

<br/>

60 Sites

<br/><br/>

Funding Stage:

<br/>

Pilot Deployment

</IntelligenceCard>



<IntelligenceCard
title="AI Forecast Engine"
icon="🤖"
color="#7c3aed"
>

Prediction:

<br/>

Operational Expansion

<br/><br/>

Risk Monitoring:

<br/>

Active

<br/><br/>

Lifecycle Engine:

<br/>

Enabled

</IntelligenceCard>



</IntelligenceGrid>


</DashboardLayout>

);

}
