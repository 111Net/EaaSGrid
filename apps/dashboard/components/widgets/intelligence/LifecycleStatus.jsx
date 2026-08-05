"use client";

export default function LifecycleStatus({items=[]}){

return (

<div className="rounded-xl border p-5">

<h2 className="font-semibold mb-4">
Lifecycle Management
</h2>


{items.map((x,i)=>(

<div key={i}
className="py-2 border-b">

<strong>{x.customer}</strong>

<p>
{x.service} -
{x.stage}
</p>

<p>
Health: {x.health}
</p>

</div>

))}

</div>

);

}
