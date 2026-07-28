"use client";


export default function IntelligenceGrid({children}){


return (

<div
style={{
display:"grid",
gridTemplateColumns:"repeat(auto-fit,minmax(300px,1fr))",
gap:"25px",
marginTop:"25px"
}}
>

{children}

</div>

);


}
