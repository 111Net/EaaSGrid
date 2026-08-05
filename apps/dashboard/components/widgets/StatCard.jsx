
export default function StatCard({title,value}){

return (

<div
style={{
background:"white",
padding:"20px",
borderRadius:"12px",
boxShadow:"0 2px 8px #ddd"
}}
>

<h3>{title}</h3>

<h2>{value}</h2>

</div>

);

}

