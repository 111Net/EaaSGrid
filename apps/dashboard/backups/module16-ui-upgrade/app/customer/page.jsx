import RoleGuard from "@/components/RoleGuard";


export default function Customer(){

return (

<RoleGuard allowedRoles={["CUSTOMER","ADMIN"]}>


<div>

<h1 className="page-title">Customer Energy Dashboard
</h1>


<p>
Consumption, billing and service information
</p>


</div>


</RoleGuard>

);

}
