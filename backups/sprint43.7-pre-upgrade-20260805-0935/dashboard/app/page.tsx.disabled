
import { getPlatformMetrics } from "../lib/api";


export default async function Home(){

let metrics:any = {
    platform:"XaaSGrid",
    users:0,
    companies:0,
    customers:0,
    auditEvents:0,
    availability:"unknown"
};


try {

metrics = await getPlatformMetrics();

}
catch(error){

console.error(
"Metrics unavailable",
error
);

}


return (

<main style={{padding:"40px"}}>

<h1>
XaaSGrid Platform
</h1>


<h2>
Everything-as-a-Service Infrastructure Platform
</h2>


<section>

<h3>
Platform Overview
</h3>


<p>
Users: {metrics.users}
</p>

<p>
Companies: {metrics.companies}
</p>

<p>
Customers: {metrics.customers}
</p>


<p>
Audit Events: {metrics.auditEvents || 0}
</p>


<p>
Availability: {metrics.availability}
</p>


</section>


</main>

);

}

