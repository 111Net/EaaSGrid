"use client";

import {
LineChart,
Line,
XAxis,
YAxis,
Tooltip,
ResponsiveContainer
} from "recharts";


export default function EnergyChart(){


const data=[

{
month:"Jan",
generation:12
},

{
month:"Feb",
generation:18
},

{
month:"Mar",
generation:25
},

{
month:"Apr",
generation:30
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
Energy Generation
</h2>


<ResponsiveContainer width="100%" height="90%">


<LineChart data={data}>


<XAxis dataKey="month"/>

<YAxis/>

<Tooltip/>


<Line
type="monotone"
dataKey="generation"
/>


</LineChart>


</ResponsiveContainer>


</div>

);


}
