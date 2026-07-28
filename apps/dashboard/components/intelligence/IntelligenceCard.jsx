"use client";

export default function IntelligenceCard({
 title,
 children,
 icon
}) {

return (

<section
style={{
background:"linear-gradient(135deg,#ffffff,#eef5ff)",
borderRadius:"20px",
padding:"28px",
marginBottom:"25px",
boxShadow:"0 12px 35px rgba(0,0,0,0.12)",
border:"1px solid rgba(20,80,220,0.18)"
}}
>

<h2
style={{
display:"flex",
alignItems:"center",
gap:"12px",
fontSize:"25px",
fontWeight:"900",
color:"#071A3D",
letterSpacing:"0.2px",
marginBottom:"20px",
textShadow:"0 1px 2px rgba(0,0,0,.15)"
}}
>

{icon}

{title}

</h2>


<div
style={{
fontSize:"16px",
fontWeight:"600",
color:"#243b63",
lineHeight:"1.8"
}}
>

{children}

</div>


</section>

);

}
