export default function MetricWidget({title,value}){

return (

<div
style={{
background:"white",
padding:"20px",
borderRadius:"10px"
}}
>

<h3>{title}</h3>

<strong>
{value}
</strong>

</div>

);

}
