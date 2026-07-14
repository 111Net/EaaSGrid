import MetricCard from "../components/MetricCard";

interface FinanceProps {

  investment:{
    required_capital_ngn:number;
    currency:string;
    funding_stage:string;
  };

  finance:{
    monthly_revenue:number;
    portfolio_value:number;
  };

}


export default function Finance({
  investment,
  finance,
}:FinanceProps){

return (

<section id="finance" className="bg-white border-t relative z-10">

<div className="mx-auto max-w-7xl px-6 pt-20 pb-20 relative z-10">


<div className="space-y-4 mb-12">

<h2 className="text-2xl font-bold text-gray-900">
Finance
</h2>

<p className="text-gray-600">
Investment requirements, recurring revenue and infrastructure value.
</p>

</div>


<div className="grid gap-8 md:grid-cols-3">


<MetricCard
title="Capital Requirement"
value={formatCurrency(
investment.required_capital_ngn,
investment.currency
)}
description={investment.funding_stage}
/>


<MetricCard
title="Recurring Monthly Revenue"
value={formatCurrency(
finance.monthly_revenue,
investment.currency
)}
description="Energy service subscriptions"
/>


<MetricCard
title="Infrastructure Portfolio Value"
value={formatCurrency(
finance.portfolio_value,
investment.currency
)}
description="Distributed energy assets"
/>


</div>


</div>

</section>

);

}


function formatCurrency(amount:number,currency:string){

return new Intl.NumberFormat(
"en-NG",
{
style:"currency",
currency,
maximumFractionDigits:0
}
).format(amount);

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
