"use client";

import Sidebar from "./Sidebar";
import Navbar from "./Navbar";


export default function DashboardLayout({children}){


return (

<div
style={{
display:"flex",
minHeight:"100vh",
background:"#eef4ff"
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
padding:"40px",
paddingTop:"100px",
background:
"linear-gradient(135deg,#eef6ff,#ffffff)",
minHeight:"100vh"
}}
>

{children}

</main>


</div>


</div>

);

}
