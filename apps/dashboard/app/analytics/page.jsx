
"use client";

import {customers,services} from "../../lib/enterpriseData";
import StatCard from "../../components/widgets/StatCard";


export default function Analytics(){

return (

<main style={{padding:"35px"}}>

<h1>Analytics Intelligence</h1>


<div style={{
display:"grid",
gridTemplateColumns:"repeat(3,1fr)",
gap:"20px"
}}>

<StatCard title="Monthly Revenue" value="₦84.6M"/>

<StatCard title="Active Subscriptions" value="326"/>

<StatCard title="Customer Growth" value="+18.4%"/>

</div>


<h2>Top Customers</h2>

{customers.map(c=>(

<p key={c.name}>
{c.name} - {c.revenue}
</p>

))}


<h2>Services</h2>

{services.map(s=>(

<p key={s.name}>
{s.name} ({s.customers} customers)
</p>

))}


</main>

)

}

