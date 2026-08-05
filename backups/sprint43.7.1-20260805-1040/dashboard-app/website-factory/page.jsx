"use client";


export default function WebsiteFactory(){


const sites=[

"Lagos Energy Solutions Customer Portal",

"Afrex Cloud Services Marketplace",

"NovaSecure Enterprise Website"

];


return (

<main style={{padding:"35px"}}>

<h1>
Website Factory as a Service
</h1>


<p>
Enterprise website provisioning and management
</p>


{sites.map(site=>(

<div
key={site}
style={{
background:"#fff",
padding:"20px",
margin:"15px",
borderRadius:"10px"
}}
>

<h3>{site}</h3>

<p>
Status: Production Ready
</p>

</div>

))}


</main>

);

}
