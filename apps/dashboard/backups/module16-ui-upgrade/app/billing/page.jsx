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
💰 Revenue & Billing Intelligence
</h1>

<p style={{fontSize:"18px"}}>
Financial engine and subscription management
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

<h2>Monthly Revenue</h2>
<h3>₦2.4M</h3>

</div>



<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>Portfolio Value</h2>
<h3>₦298M</h3>

</div>



<div
style={{
background:"white",
padding:"25px",
borderRadius:"15px",
boxShadow:"0 5px 20px #ddd"
}}
>

<h2>Billing Status</h2>
<h3>Active</h3>

</div>


</div>


</DashboardLayout>

);

}
