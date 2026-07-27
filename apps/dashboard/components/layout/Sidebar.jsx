"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";


export default function Sidebar(){

const pathname = usePathname();


const menu = [

{
name:"Overview",
path:"/control-centre",
icon:"📊"
},

{
name:"Operations",
path:"/operations",
icon:"⚙️"
},

{
name:"Energy",
path:"/energy",
icon:"⚡"
},

{
name:"Finance",
path:"/finance",
icon:"💰"
},

{
name:"Customers",
path:"/customer",
icon:"👥"
},

{
name:"Partners",
path:"/partner",
icon:"🤝"
},

{
name:"Settings",
path:"/settings",
icon:"🔧"
}

];


return (

<aside

style={{
width:"250px",
minHeight:"calc(100vh - 70px)",
background:
"linear-gradient(180deg,#081b3a,#123d7a)",
color:"white",
padding:"25px 15px"
}}

>


<h3
style={{
marginBottom:"30px",
textAlign:"center"
}}
>
XaaSGrid
</h3>


<nav>

{
menu.map((item)=>(


<Link

key={item.path}

href={item.path}

style={{

display:"flex",

alignItems:"center",

gap:"12px",

padding:"12px",

marginBottom:"8px",

borderRadius:"8px",

textDecoration:"none",

color:"white",

background:

pathname===item.path

?

"rgba(255,255,255,0.20)"

:

"transparent"

}}

>


<span>
{item.icon}
</span>


<span>
{item.name}
</span>


</Link>


))

}


</nav>


</aside>

);


}
