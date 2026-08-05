
"use client";

import {activities} from "../../lib/enterpriseData";


export default function Activity(){

return (

<main style={{padding:"35px"}}>

<h1>Enterprise Activity Stream</h1>


{activities.map(a=>(

<div
key={a}
style={{
background:"white",
padding:"15px",
margin:"10px"
}}
>

{a}

</div>

))}

</main>

)

}

