import RoleGuard from "@/components/RoleGuard";


export default function Collaborator(){

return (

<RoleGuard allowedRoles={["COLLABORATOR","ADMIN"]}>


<div>

<h1 className="page-title">Collaborator Workspace
</h1>


<p>
Projects, tasks and shared activities
</p>


</div>


</RoleGuard>

);

}
