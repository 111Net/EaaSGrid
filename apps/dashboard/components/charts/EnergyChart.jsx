"use client";

export default function EnergyChart(){

return (

<div
style={{
background:"#111827",
borderRadius:"16px",
padding:"25px",
color:"white",
marginTop:"20px"
}}
>

<h2>
⚡ Energy Performance
</h2>


<div
style={{
height:"180px",
display:"flex",
alignItems:"center",
justifyContent:"center",
background:"linear-gradient(135deg,#06b6d4,#2563eb)",
borderRadius:"12px",
marginTop:"20px"
}}
>

<p
style={{
fontSize:"24px",
fontWeight:"bold"
}}
>
Solar Grid Monitoring Active
</p>


</div>


<div
style={{
display:"grid",
gridTemplateColumns:"repeat(3,1fr)",
gap:"15px",
marginTop:"20px"
}}
>

<div>
<h3>
0 kWh
</h3>
<p>
Monthly Generation
</p>
</div>


<div>
<h3>
0%
</h3>
<p>
Battery Utilisation
</p>
</div>


<div>
<h3>
0
</h3>
<p>
Connected Assets
</p>
</div>


</div>


</div>

);


}
