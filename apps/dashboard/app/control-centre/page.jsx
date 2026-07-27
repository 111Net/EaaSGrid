"use client";

import Navbar from "@/components/layout/Navbar";
import MetricCard from "@/components/dashboard/MetricCard";
import EnergyChart from "@/components/charts/EnergyChart";
import RevenueChart from "@/components/charts/RevenueChart";

import { useEffect, useState } from "react";


export default function ControlCentre(){

const [dashboard,setDashboard] = useState(null);


useEffect(()=>{


async function load(){

const response =
await fetch(
process.env.NEXT_PUBLIC_API_URL +
"/api/v1/dashboard"
);


const data =
await response.json();


setDashboard(data.data);


}


load();


},[]);



if(!dashboard)
return <p>Loading Control Centre...</p>;



return (

<div>

<Navbar />


<main
style={{
padding:"30px",
background:"#f4f7fb",
minHeight:"calc(100vh - 70px)"
}}
>


<h1>
Executive Platform Intelligence
</h1>



<div
style={{
display:"grid",
gridTemplateColumns:"repeat(4,1fr)",
gap:"20px"
}}
>


<MetricCard
title="Platform Status"
value={dashboard.dashboard.status}
/>


<MetricCard
title="Pilot Sites"
value={dashboard.infrastructure.pilot_sites}
/>


<MetricCard
title="Capital Requirement"
value={"₦"+dashboard.investment.required_capital_ngn.toLocaleString()}
/>


<MetricCard
title="Monthly Revenue"
value={"₦"+dashboard.finance.monthly_revenue.toLocaleString()}
/>


</div>



<section
style={{
marginTop:"40px"
}}
>

<EnergyChart />

<RevenueChart />

</section>


</main>


</div>

);


}
