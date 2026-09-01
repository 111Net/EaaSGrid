"use client";

import {useEffect,useState} from "react";

import LiveMetrics from "@/components/widgets/intelligence/LiveMetrics";
import ActivityStream from "@/components/widgets/intelligence/ActivityStream";
import LifecycleStatus from "@/components/widgets/intelligence/LifecycleStatus";


export default function IntelligencePage(){

const [metrics,setMetrics]=useState({});
const [activity,setActivity]=useState([]);
const [lifecycle,setLifecycle]=useState([]);


useEffect(()=>{

fetch("/api/intelligence/metrics")
.then(r=>r.json())
.then(x=>setMetrics(x.data));


fetch("/api/intelligence/activity")
.then(r=>r.json())
.then(x=>setActivity(x.data));


fetch("/api/intelligence/lifecycle")
.then(r=>r.json())
.then(x=>setLifecycle(x.data));


},[]);


return (

<div className="p-8 space-y-8">


<h1 className="text-3xl font-bold">
XaaSGrid Enterprise Intelligence
</h1>


<LiveMetrics data={metrics}/>


<div className="grid md:grid-cols-2 gap-6">

<ActivityStream events={activity}/>

<LifecycleStatus items={lifecycle}/>

</div>


</div>

);

}
