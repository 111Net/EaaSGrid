"use client";

export default function Lifecycle(){

const services=[
{
client:"GreenGrid Infrastructure Africa",
service:"Solar-as-a-Service Enterprise",
stage:"OPERATE"
},
{
client:"Lagos Energy Solutions Ltd",
service:"Smart Energy Monitoring",
stage:"MONITOR"
},
{
client:"NovaSecure Technologies",
service:"Managed Cybersecurity Platform",
stage:"OPTIMIZE"
}
];


return (

<main style={{padding:"35px"}}>

<h1>
Lifecycle Management as a Service
</h1>

<p>
Enterprise service lifecycle orchestration
</p>


{services.map((item)=>(

<div
key={item.client}
style={{
background:"white",
padding:"20px",
margin:"15px",
borderRadius:"10px"
}}
>

<h3>{item.client}</h3>

<p>
Service: {item.service}
</p>

<strong>
Lifecycle Stage: {item.stage}
</strong>


</div>

))}


</main>

);

}
