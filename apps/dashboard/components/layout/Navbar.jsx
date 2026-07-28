"use client";


export default function Navbar(){


return (

<nav
style={{
height:"75px",
position:"fixed",
top:0,
right:0,
left:"260px",
zIndex:1000,

background:
"linear-gradient(90deg,#061A40,#0077ff,#00c853)",

color:"white",

display:"flex",
alignItems:"center",
justifyContent:"space-between",

padding:"0 35px",

fontWeight:"700",

boxShadow:
"0 4px 20px rgba(0,0,0,.25)"
}}
>


<div
style={{
fontSize:"24px",
letterSpacing:"0.5px"
}}
>
⚡ XaaSGrid Command Centre
</div>


<div
style={{
background:"rgba(255,255,255,.15)",
padding:"10px 18px",
borderRadius:"20px"
}}
>
admin@eaasgrid.com
</div>


</nav>


);

}
