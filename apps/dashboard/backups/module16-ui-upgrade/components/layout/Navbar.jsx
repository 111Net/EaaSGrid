"use client";

import { useState } from "react";

export default function Navbar(){

const [user] = useState({
email:"admin@eaasgrid.com"
});


return (

<nav
style={{
height:"70px",
background:"linear-gradient(90deg,#001f3f,#0074D9,#00c853)",
color:"white",
display:"flex",
alignItems:"center",
justifyContent:"space-between",
padding:"0 30px",
fontWeight:"600"
}}
>

<div>
⚡ XaaSGrid Command Centre
</div>


<div>

<span>
{user.email}
</span>

</div>


</nav>

);

}
