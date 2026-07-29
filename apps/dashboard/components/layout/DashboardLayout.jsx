"use client";


import {
    useEffect,
    useState
} from "react";


import {
    hasPermission,
    getCurrentUser
} from "@/lib/permissions";



export default function DashboardLayout({
    children
}) {


    const [mounted,setMounted] =
        useState(false);


    const [user,setUser] =
        useState(null);



    useEffect(()=>{


        setUser(
            getCurrentUser()
        );


        setMounted(true);


    },[]);



    const menu = [

        {
            name:"Control Centre",
            path:"/control-centre",
            icon:"🏢",
            permission:"VIEW_DASHBOARD"
        },


        {
            name:"Operations",
            path:"/operations",
            icon:"⚙️",
            permission:"VIEW_OPERATIONS"
        },


        {
            name:"Revenue & Billing",
            path:"/billing",
            icon:"💰",
            permission:"VIEW_BILLING"
        },


        {
            name:"Investor Intelligence",
            path:"/investor",
            icon:"📈",
            permission:"VIEW_INVESTOR"
        },


        {
            name:"User Management",
            path:"/users",
            icon:"👥",
            permission:"MANAGE_USERS"
        },


        {
            name:"Security Centre",
            path:"/security",
            icon:"🔐",
            permission:"MANAGE_SECURITY"
        }

    ];



return (

<div
style={{
display:"flex",
minHeight:"100vh",
background:"#eef4ff"
}}
>


<aside
style={{
width:"270px",
minHeight:"100vh",
background:
"linear-gradient(180deg,#071426,#123b63,#0077ff)",
color:"white",
padding:"25px",
position:"fixed",
left:0,
top:0
}}
>


<h2>
⚡ XaaSGrid
</h2>


{

mounted &&

menu

.filter(
item =>
hasPermission(
item.permission
)
)

.map(item=>(

<a
key={item.path}
href={item.path}

style={{
display:"block",
padding:"14px",
marginBottom:"12px",
borderRadius:"10px",
color:"white",
textDecoration:"none",
background:
"rgba(255,255,255,.12)"
}}

>

{item.icon} {item.name}

</a>

))

}


</aside>




<div
style={{
flex:1,
marginLeft:"270px"
}}
>


<nav

style={{
height:"75px",
position:"fixed",
top:0,
right:0,
left:"270px",
zIndex:1000,
background:
"linear-gradient(90deg,#061A40,#0077ff,#00c853)",
color:"white",
display:"flex",
alignItems:"center",
justifyContent:"space-between",
padding:"0 35px",
fontWeight:"700"
}}

>


<div>
⚡ XaaSGrid Command Centre
</div>


<div
style={{
background:"rgba(255,255,255,.15)",
padding:"10px 18px",
borderRadius:"20px"
}}
>


{
mounted
?
user?.email
:
""
}


<br/>


<span
style={{
fontSize:"12px"
}}
>

{
mounted
?
user?.role
:
""
}

</span>


</div>


</nav>



<main
style={{
padding:"40px",
paddingTop:"110px",
background:
"linear-gradient(135deg,#eef6ff,#ffffff)",
minHeight:"100vh"
}}
>

{children}

</main>



</div>


</div>

);


}
