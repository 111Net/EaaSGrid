import KPICard from "../components/cards/KPICard";


interface ExecutiveSummaryProps {

  investment: {

    required_capital_ngn: number;

    currency: string;

    funding_stage: string;

  };


  finance: {

    monthly_revenue: number;

    portfolio_value: number;

  };


  energy: {

    monthly_generation: number;

    connected_assets: number;

  };


  performance: {

    availability: number;

  };


  infrastructure: {

    active_sites: number;

    planned_sites_per_year: number;

  };

}



export default function ExecutiveSummary({

  investment,

  finance,

  energy,

  performance,

  infrastructure,

}: ExecutiveSummaryProps) {


return (

<section

className="mx-auto max-w-7xl px-6 py-12"

>


<h1 className="text-4xl font-bold text-gray-900">

EaaSGrid Executive Dashboard

</h1>


<p className="mt-3 text-gray-600">

Energy-as-a-Service infrastructure performance and investment overview.

</p>



<div className="mt-8 grid gap-6 md:grid-cols-4">


<KPICard

title="Portfolio Value"

value={formatCurrency(

finance.portfolio_value,

investment.currency

)}

description="Energy infrastructure portfolio"

/>



<KPICard

title="Monthly Revenue"

value={formatCurrency(

finance.monthly_revenue,

investment.currency

)}

description="Recurring subscription revenue"

/>



<KPICard

title="Energy Generated"

value={`${energy.monthly_generation} MWh`}

description="Monthly renewable generation"

/>



<KPICard

title="Asset Availability"

value={`${performance.availability}%`}

description="System uptime"

/>



<KPICard

title="Active Sites"

value={String(infrastructure.active_sites)}

description="Currently deployed sites"

/>



<KPICard

title="Expansion Plan"

value={String(infrastructure.planned_sites_per_year)}

description="Sites planned annually"

/>



<KPICard

title="Connected Assets"

value={String(energy.connected_assets)}

description="Monitored energy assets"

/>



<KPICard

title="Funding Stage"

value={investment.funding_stage}

description="Investment programme"

 />


</div>


</section>

);

}



function formatCurrency(

amount:number,

currency:string

){

return new Intl.NumberFormat(

"en-NG",

{

style:"currency",

currency,

maximumFractionDigits:0

}

).format(amount);

}
