import MetricCard from "../components/MetricCard";

interface PerformanceProps {

performance:{
availability:number;
maintenance_alerts:number;
};

}


export default function Performance({
performance,
}:PerformanceProps){

return (

<section id="performance" className="bg-white border-t relative z-10">

<div className="mx-auto max-w-7xl px-6 pt-20 pb-20 relative z-10">


<div className="space-y-4 mb-12">

<h2 className="text-2xl font-bold text-gray-900">
Performance
</h2>

<p className="text-gray-600">
Operational reliability, monitoring and maintenance intelligence.
</p>

</div>


<div className="grid gap-8 md:grid-cols-3">


<MetricCard
title="Asset Availability"
value={`${performance.availability}%`}
description="Infrastructure uptime performance"
/>


<MetricCard
title="Remote Monitoring"
value="Online"
description="Continuous digital asset visibility"
/>


<MetricCard
title="Maintenance Alerts"
value={String(performance.maintenance_alerts)}
description="Current operational issues"
/>


</div>


</div>

</section>

);

}



function Card({
title,
value,
description,
}:{
title:string;
value:string;
description:string;
}){

return (

<div className="rounded-xl border bg-white p-6 shadow-sm">

<p className="text-sm leading-6 text-gray-500">
{title}
</p>

<p className="mt-3 text-3xl font-bold text-gray-900">
{value}
</p>

<p className="mt-2 text-sm text-gray-600">
{description}
</p>

</div>

);

}
