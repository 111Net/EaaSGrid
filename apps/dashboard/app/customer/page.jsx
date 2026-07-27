import RoleGuard from "@/components/RoleGuard";


export default function Customer(){

return (

<RoleGuard allowedRoles={["CUSTOMER","ADMIN"]}>


<div>

<h1>
Customer Energy Dashboard
</h1>


<p>
Consumption, billing and service information
</p>


</div>


</RoleGuard>

);

}
