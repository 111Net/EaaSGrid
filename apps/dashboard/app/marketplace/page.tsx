
"use client";

import {services} from "../../lib/enterpriseData";


export default function Marketplace(){

return (

<main style={{padding:"35px"}}>

<h1>XaaS Marketplace</h1>


{services.map(s=>(

<div
key={s.name}
style={{
background:"white",
padding:"20px",
margin:"15px"
}}
>

<h3>{s.name}</h3>

<p>
Provider: {s.provider}
</p>

<p>
Customers: {s.customers}
</p>

</div>

))}


</main>

)

}

