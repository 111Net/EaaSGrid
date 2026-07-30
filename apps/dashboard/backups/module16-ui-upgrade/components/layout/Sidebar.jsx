"use client";

import Link from "next/link";


export default function Sidebar(){


const menu=[

{
name:"Control Centre",
icon:"🏢",
path:"/control-centre"
},

{
name:"Operations",
icon:"⚙️",
path:"/operations"
},

{
name:"Energy Monitoring",
icon:"⚡",
path:"/monitoring"
},

{
name:"Revenue & Billing",
icon:"💰",
path:"/billing"
},

{
name:"Analytics",
icon:"📊",
path:"/analytics"
},

{
name:"Users",
icon:"👥",
path:"/users"
},

{
name:"Security",
icon:"🔐",
path:"/security"
},

{
name:"Settings",
icon:"⚙",
path:"/settings"
}

];


return (

<aside

style={{

width:"260px",

minHeight:"100vh",

background:
"linear-gradient(180deg,#071426,#123b63)",

color:"white",

padding:"25px",

position:"fixed",

left:0,

top:0

}}

>


<h2
style={{
fontSize:"26px",
marginBottom:"30px"
}}
>
⚡ XaaSGrid
</h2>



{
menu.map((item)=>(

<Link

key={item.path}

href={item.path}

style={{

display:"block",

padding:"14px",

marginBottom:"10px",

borderRadius:"10px",

color:"white",

textDecoration:"none",

background:
"rgba(255,255,255,.08)"

}}

>

{item.icon}

&nbsp;

{item.name}

</Link>

))

}


</aside>


);


}
