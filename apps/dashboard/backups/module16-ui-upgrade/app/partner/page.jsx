import RoleGuard from "@/components/RoleGuard";


export default function Partner(){

return (

<RoleGuard allowedRoles={["PARTNER","ADMIN"]}>


<div>

<h1 className="page-title">Partner Portal
</h1>

<p>
Providers, installations and service partners
</p>


</div>


</RoleGuard>

);

}
