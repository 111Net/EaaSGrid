"use client";


export default function Activity(){


const events=[

"Lagos Energy Solutions Ltd activated Solar Monitoring",

"Afrex Cloud Services Plc upgraded Enterprise Support",

"GreenGrid Infrastructure Africa lifecycle moved to OPERATE",

"NovaSecure Technologies completed compliance review"

];


return (

<main style={{padding:"35px"}}>

<h1>
Enterprise Activity Stream
</h1>


{events.map(event=>(

<div
key={event}
style={{
background:"#fff",
padding:"15px",
margin:"10px",
borderRadius:"8px"
}}
>

{event}

</div>

))}


</main>

);

}
