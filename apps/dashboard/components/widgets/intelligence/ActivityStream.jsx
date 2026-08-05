"use client";

export default function ActivityStream({events=[]}){

return (

<div className="rounded-xl border p-5">

<h2 className="text-lg font-semibold mb-4">
Enterprise Activity Stream
</h2>


{events.map((item,index)=>(

<div key={index}
className="border-b py-3">

<p className="font-medium">
{item.company}
</p>

<p>
{item.event}
</p>

<span>
{item.status}
</span>

</div>

))}

</div>

);

}
