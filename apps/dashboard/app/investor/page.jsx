import RoleGuard from "@/components/RoleGuard";


export default function Investor(){

return (

<RoleGuard allowedRoles={["INVESTOR","ADMIN"]}>


<div>

<h1>
Investor Dashboard
</h1>

<p>
Portfolio performance and investment intelligence
</p>


</div>


</RoleGuard>

);

}
