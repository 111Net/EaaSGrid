"use client";

import { useEffect, useState } from "react";
import DashboardLayout from "@/components/layout/DashboardLayout";


const formatNGN = (value) =>
  new Intl.NumberFormat("en-NG").format(value || 0);


export default function ControlCentre() {

  const [dashboard,setDashboard] = useState(null);
  const [error,setError] = useState("");


  useEffect(()=>{

    async function load(){

      try {

        const token =
        localStorage.getItem("eaasgrid_token");


        const response =
        await fetch(
          `${process.env.NEXT_PUBLIC_API_URL}/api/v1/dashboard`,
          {
            cache:"no-store",
            headers:{
              Authorization:`Bearer ${token}`
            }
          }
        );


        const json =
        await response.json();


        setDashboard(json.data);


      } catch(err){

        console.error(err);

        setError(
          "Unable to load platform intelligence"
        );

      }

    }


    load();

  },[]);



  if(error){

    return (
      <DashboardLayout>
        <div style={{padding:"40px",color:"red"}}>
          {error}
        </div>
      </DashboardLayout>
    );

  }


  if(!dashboard){

    return (
      <DashboardLayout>
        <div style={{padding:"40px"}}>
          Loading XaaSGrid intelligence...
        </div>
      </DashboardLayout>
    );

  }



return (

<DashboardLayout>

<div style={{padding:"30px"}}>


<div
style={{
background:
"linear-gradient(135deg,#071426,#123b63,#1d6fa5)",
padding:"40px",
borderRadius:"20px",
color:"white"
}}
>

<h1>
⚡ XaaSGrid Command Centre
</h1>

<p>
Everything-as-a-Service Platform Intelligence
</p>

</div>



<div
style={{
display:"grid",
gridTemplateColumns:
"repeat(auto-fit,minmax(220px,1fr))",
gap:"20px",
marginTop:"30px"
}}
>


<Metric
title="Platform Status"
value={dashboard.dashboard?.status || "Operational"}
/>


<Metric
title="Deployment Sites"
value={dashboard.totalSites}
/>


<Metric
title="Pilot Sites"
value={dashboard.pilotSites}
/>


<Metric
title="Monthly Revenue"
value={`₦${formatNGN(dashboard.finance?.monthly_revenue)}`}
/>


<Metric
title="Portfolio Value"
value={`₦${formatNGN(dashboard.finance?.portfolio_value_ngn)}`}
/>


<Metric
title="Energy Generated"
value={`${dashboard.energy?.monthly_generation_mwh || 0} MWh`}
/>


<Metric
title="Connected Assets"
value={dashboard.energy?.connected_assets || 0}
/>


<Metric
title="Availability"
value={`${dashboard.performance?.availability_percent || 0}%`}
/>


</div>




<div
style={{
marginTop:"40px",
background:"#fff",
padding:"25px",
borderRadius:"15px"
}}
>


<h2>
Investor Overview
</h2>


<p>
Funding Stage:
{" "}
<b>
{dashboard.investment?.funding_stage}
</b>
</p>


<p>
Required Capital:
{" "}
<b>
₦{formatNGN(
dashboard.investment?.required_capital_ngn
)}
</b>
</p>


<p>
Expansion Target:
{" "}
<b>
{dashboard.infrastructure?.planned_sites_per_year}
sites/year
</b>
</p>


</div>




<div
style={{
marginTop:"40px"
}}
>


<h2>
Deployment Assets
</h2>


<table
style={{
width:"100%",
background:"#fff",
borderRadius:"15px",
padding:"20px"
}}
>


<thead>

<tr>

<th>Site</th>
<th>Type</th>
<th>Manufacturer</th>
<th>Status</th>

</tr>

</thead>


<tbody>


{
dashboard.sites?.map(site=>(

<tr key={site.id}>

<td>
{site.site_code}
</td>

<td>
{site.device_type}
</td>

<td>
{site.manufacturer}
</td>

<td>
{site.connectivity}
</td>


</tr>

))
}


</tbody>


</table>


</div>




<p style={{marginTop:"30px"}}>

Last synchronisation:

{" "}

{
new Date(
dashboard.dashboard?.last_updated
).toLocaleString()
}

</p>



</div>

</DashboardLayout>

);

}



function Metric({title,value}){

return (

<div
style={{
background:"#fff",
padding:"20px",
borderRadius:"15px",
boxShadow:"0 2px 8px rgba(0,0,0,.1)"
}}
>

<h3>
{title}
</h3>

<h2>
{value}
</h2>


</div>

);

}
