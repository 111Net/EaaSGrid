"use client";

import Link from "next/link";
import {usePathname} from "next/navigation";


const menu=[
{
section:"MAIN",
items:[
["Dashboard","/dashboard"]
]
},
{
section:"PLATFORM",
items:[
["Enterprise","/enterprise"],
["Customers","/customer"],
["Operations","/operations"],
["Analytics","/analytics"],
["Marketplace","/marketplace"]
]
},
{
section:"SYSTEM",
items:[
["Administration","/admin"]
]
}
];


export default function Sidebar(){

const path=usePathname();


return (

<aside className="sidebar">

<h2>
XaaSGrid
</h2>

<p className="sidebar-sub">
Enterprise Console
</p>


{
menu.map(group=>

<div key={group.section}>

<h5>
{group.section}
</h5>


{
group.items.map(item=>

<Link
key={item[1]}
href={item[1]}
className={
path===item[1]
?"active-link"
:"menu-link"
}
>

{item[0]}

</Link>

)

}

</div>

)

}


</aside>

)

}
