
"use client";

import {lifecycle} from "../../lib/enterpriseData";


export default function Lifecycle(){

return (

<main style={{padding:"35px"}}>

<h1>Lifecycle Management as a Service</h1>


{lifecycle.map(x=>(

<div
key={x.client}
style={{
background:"white",
padding:"20px",
margin:"15px"
}}
>

<h3>{x.client}</h3>

<p>{x.service}</p>

<p>
Lifecycle Stage: {x.stage}
</p>

<p>
Health: {x.health}
</p>


</div>

))}


</main>

)

}

