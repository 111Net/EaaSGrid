"use client";


export default function RoleGuard({
role,
allowed,
children
}){


if(!allowed.includes(role)){

return (

<div>

<h2>
Access Restricted
</h2>

<p>
Your role does not have permission.
</p>

</div>

);

}


return children;

}
