"use client";


import { useEffect,useState } from "react";


export default function Home(){


const [health,setHealth]=useState(null);

const [operations,setOperations]=useState(null);

const [analytics,setAnalytics]=useState(null);



useEffect(()=>{


async function loadData(){


try{


const h =
await fetch("/api/health");


const o =
await fetch("/api/operations/overview");


const a =
await fetch("/api/analytics/overview");



setHealth(await h.json());

setOperations(await o.json());

setAnalytics(await a.json());



}

catch(error){

console.error(
"Dashboard API error",
error
);

}



}


loadData();


},[]);




const modules=[

[
"Enterprise Administration",
"Organizations, tenants, RBAC and governance",
"/enterprise"
],

[
"Customer Portal",
"Customer onboarding and subscriptions",
"/customer"
],

[
"Operations Intelligence",
"Infrastructure monitoring and service health",
"/operations"
],

[
"Analytics Engine",
"Platform metrics and AI recommendations",
"/analytics"
],

[
"Marketplace",
"Services and XaaS catalog",
"/marketplace"
],

[
"Administration",
"Platform administration",
"/admin"
]

];



return (

<main style={{
padding:"40px",
fontFamily:"Arial"
}}>


<h1>
XaaSGrid Console
</h1>


<p>
Everything-as-a-Service Enterprise Platform
</p>



<hr/>


<h2>
Platform Status
</h2>


<p>
API:
{" "}
{health?.status ?? "Checking..."}
</p>


<p>
Operations:
{" "}
{operations?.status ?? "Checking..."}
</p>


<p>
Analytics:
{" "}
{analytics?.status ?? "Checking..."}
</p>



<hr/>


<h2>
Platform Modules
</h2>


<div style={{
display:"grid",
gridTemplateColumns:
"repeat(auto-fit,minmax(280px,1fr))",
gap:"20px"
}}>


{
modules.map(
(item)=>(

<div
key={item[0]}
style={{
border:"1px solid #ddd",
padding:"20px",
borderRadius:"10px"
}}
>


<h3>
{item[0]}
</h3>


<p>
{item[1]}
</p>


<a href={item[2]}>
Open Module →
</a>


</div>


)
)

}


</div>



<hr/>


<h2>
Analytics Snapshot
</h2>

<pre>
{
JSON.stringify(
analytics,
null,
2
)
}
</pre>



<h2>
Operations Snapshot
</h2>

<pre>
{
JSON.stringify(
operations,
null,
2
)
}
</pre>



</main>

);

}
