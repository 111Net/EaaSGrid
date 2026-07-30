"use client";

import Sidebar from "./Sidebar";
import Navbar from "./Navbar";


export default function DashboardLayout({children}){


return (

<div
style={{
display:"flex",
minHeight:"100vh"
}}
>


<Sidebar />


<div
style={{
flex:1,
marginLeft:"260px"
}}
>


<Navbar />


<main
style={{
padding:"35px",
background:"#f4f7fb",
minHeight:"calc(100vh - 70px)"
}}
>

{children}

</main>


</div>


</div>

);

}
