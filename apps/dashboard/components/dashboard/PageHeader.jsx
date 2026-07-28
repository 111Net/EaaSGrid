"use client";

export default function PageHeader({
title,
subtitle,
icon
}){

return (

<div
style={{
marginBottom:"35px",
padding:"35px",
borderRadius:"22px",
background:
"linear-gradient(135deg,#061A40,#0074D9,#00C853)",
boxShadow:
"0 15px 40px rgba(0,0,0,.25)"
}}
>

<h1
style={{
fontSize:"38px",
fontWeight:"900",
letterSpacing:"-1px",
color:"#ffffff",
margin:"0 0 12px 0",
textShadow:"none"
}}
>

{icon} {title}

</h1>


<p
style={{
fontSize:"18px",
fontWeight:"500",
color:"#EAF4FF",
margin:0
}}
>

{subtitle}

</p>


</div>

);

}
