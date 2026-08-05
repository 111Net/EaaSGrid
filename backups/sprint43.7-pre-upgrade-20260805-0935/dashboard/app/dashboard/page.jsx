const metrics=[

["Organizations","25"],
["Tenants","142"],
["Customers","1840"],
["Availability","99.95%"]

];


export default function Dashboard(){


return (

<>

<h1>
Platform Overview
</h1>


<p>
Everything-as-a-Service operating environment.
</p>


<div className="card-grid">


{
metrics.map(m=>

<div className="card" key={m[0]}>

<h3>
{m[0]}
</h3>

<h1>
{m[1]}
</h1>

<p>
Operational
</p>

</div>

)

}


</div>


<h2 style={{marginTop:40}}>
Platform Health
</h2>


<div className="card-grid">

<div className="card">
API
<br/>
ONLINE
</div>

<div className="card">
Database
<br/>
ONLINE
</div>


<div className="card">
Redis
<br/>
ONLINE
</div>


<div className="card">
Workers
<br/>
ONLINE
</div>


</div>


</>

)

}
