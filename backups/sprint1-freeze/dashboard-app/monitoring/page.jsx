"use client";

import DashboardLayout from "@/components/layout/DashboardLayout";


export default function Page(){

return (

<DashboardLayout>


<div
style={{
background:"linear-gradient(135deg,#001f3f,#0074D9,#00c853)",
color:"white",
padding:"40px",
borderRadius:"22px",
marginBottom:"30px"
}}
>

<h1 style={{fontSize:"38px"}}>
📡 Energy Monitoring Centre
</h1>

<p style={{fontSize:"21px"}}>
Real-time infrastructure and energy visibility
</p>


</div>



<div
style={{
display:"grid",
gridTemplateColumns:"repeat(auto-fit,minmax(250px,1fr))",
gap:"25px"
}}
>


<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>Connected Assets</h2>
<h3>6</h3>

</div>



<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>Battery Usage</h2>
<h3>82%</h3>

</div>



<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>Availability</h2>
<h3>99.2%</h3>

</div>


</div>


</DashboardLayout>

);

}
