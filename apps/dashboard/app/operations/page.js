
"use client";

import {operations} from "../../lib/enterpriseData";


export default function Operations(){

return (

<main style={{padding:"35px"}}>

<h1>Operations Command Centre</h1>


{operations.map(o=>(

<div
key={o.service}
style={{
background:"white",
padding:"20px",
margin:"15px",
borderRadius:"10px"
}}
>

<h3>{o.service}</h3>

<p>Status: {o.status}</p>

<p>Uptime: {o.uptime}</p>


</div>

))}


</main>

)

}

