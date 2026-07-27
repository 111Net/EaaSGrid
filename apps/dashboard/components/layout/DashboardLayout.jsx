"use client";


import Sidebar from "./Sidebar";
import Navbar from "./Navbar";


export default function DashboardLayout({children}){


return (

<div>


<Navbar />


<div
style={{
display:"flex"
}}
>


<Sidebar />


<div

style={{

flex:1,

background:"#f4f7fb",

minHeight:"calc(100vh - 70px)"

}}

>

{children}


</div>


</div>


</div>

);


}
