
export default function Table({items}){

return (

<div>

{items.map((item,i)=>(

<div
key={i}
style={{
background:"white",
margin:"10px",
padding:"15px",
borderRadius:"8px"
}}
>

{Object.entries(item).map(([k,v])=>(

<p key={k}>
<strong>{k}:</strong> {v}
</p>

))}

</div>

))}

</div>

);

}

