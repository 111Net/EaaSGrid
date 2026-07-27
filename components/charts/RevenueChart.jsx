"use client";

import {
BarChart,
Bar,
XAxis,
YAxis,
Tooltip,
ResponsiveContainer
} from "recharts";


export default function RevenueChart(){


const data=[

{
month:"Jan",
revenue:500000
},

{
month:"Feb",
revenue:900000
},

{
month:"Mar",
revenue:1400000
}

];


return (

<div
style={{
height:"300px",
background:"#ffffff",
padding:"20px",
borderRadius:"15px"
}}
>


<h2>
Revenue Growth
</h2>


<ResponsiveContainer width="100%" height="90%">


<BarChart data={data}>


<XAxis dataKey="month"/>

<YAxis/>

<Tooltip/>


<Bar
dataKey="revenue"
/>


</BarChart>


</ResponsiveContainer>


</div>

);


}
