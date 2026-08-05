"use client";

export default function LiveMetrics({data}){

return (

<div className="grid grid-cols-2 md:grid-cols-5 gap-4">

<div className="rounded-xl border p-4">
<p>Revenue</p>
<h2>₦{data?.revenue?.toLocaleString()}</h2>
</div>

<div className="rounded-xl border p-4">
<p>Customers</p>
<h2>{data?.customers}</h2>
</div>

<div className="rounded-xl border p-4">
<p>Services</p>
<h2>{data?.services}</h2>
</div>

<div className="rounded-xl border p-4">
<p>API Requests</p>
<h2>{data?.apiRequests}</h2>
</div>

<div className="rounded-xl border p-4">
<p>Uptime</p>
<h2>{data?.uptime}%</h2>
</div>

</div>

);

}
