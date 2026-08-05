"use client";

import Link from "next/link";

const links=[
["Dashboard","/dashboard"],
["Enterprise","/enterprise"],
["Customers","/customer"],
["Operations","/operations"],
["Analytics","/analytics"],
["Marketplace","/marketplace"],
["Administration","/admin"]
];


export default function Sidebar(){

return (

<aside style={{
width:"260px",
background:"#111827",
color:"white",
minHeight:"100vh",
padding:"25px"
}}>

<h2>
XaaSGrid
</h2>

<p>
Enterprise Console
</p>

<hr/>


{
links.map(x=>

<div key={x[1]} style={{
margin:"18px 0"
}}>

<Link
href={x[1]}
style={{
color:"white",
textDecoration:"none",
fontSize:"16px"
}}
>

{x[0]}

</Link>

</div>

)

}


</aside>

)

}
