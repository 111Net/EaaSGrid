"use client";

import { MODULES } from "../../lib/moduleRegistry";
import ModuleCard from "../../components/ModuleCard";
import Sidebar from "../../components/Sidebar";

export default function DashboardPage(){

const role = "SUPER_ADMIN";


const modules =
MODULES[role] || [];


return (

<div
style={{
display:"flex",
minHeight:"100vh"
}}
>


<Sidebar role={role}/>


<div
style={{
padding:"30px",
flex:1
}}
>


<h1>
XaaSGrid Enterprise Console
</h1>


<p>
Role:
<strong>
{" "}{role}
</strong>
</p>


<hr/>


<h2>
Platform Modules
</h2>


{
modules.map(
(module)=>(

<ModuleCard
key={module.route}
module={module}
/>

)

)
}


</div>


</div>

);

}
