export default function MetricCard({
title,
value,
description
}){


return (

<div
style={{
background:"#102542",
color:"white",
padding:"20px",
borderRadius:"15px",
minWidth:"220px",
boxShadow:"0 5px 20px rgba(0,0,0,.25)"
}}
>

<h3>
{title}
</h3>


<h1>
{value}
</h1>


<p>
{description}
</p>


</div>

);


}
