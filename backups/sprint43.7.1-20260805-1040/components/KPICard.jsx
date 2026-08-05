export default function KPICard({title,value,status}) {

return (
<div style={{
background:"#ffffff",
padding:"25px",
borderRadius:"14px",
boxShadow:"0 4px 15px rgba(0,0,0,.08)"
}}>

<h3>{title}</h3>

<h1>
{value}
</h1>

<p>
{status}
</p>

</div>
)

}
