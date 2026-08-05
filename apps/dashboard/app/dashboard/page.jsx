"use client";


import {useEffect,useState} from "react";

import {useRouter} from "next/navigation";

import {getSession} from "../../lib/auth";

import Logout from "../../components/logout";



export default function Dashboard(){


const router=useRouter();

const [session,setSession]=useState(null);



useEffect(()=>{


const data=getSession();


if(!data){

router.push("/login");

return;

}


setSession(data);


},[]);



if(!session){

return (

<div>
Loading XaaSGrid Console...
</div>

);

}



return (

<div>


<h1>
XaaSGrid Console
</h1>


<h2>
User
</h2>


<p>
{session.user.email}
</p>


<h2>
Role
</h2>


<p>
{session.user.role}
</p>



<Logout />


<hr/>


<h3>
Available Modules
</h3>


<ul>

<li>
Enterprise Administration
</li>

<li>
Operations Intelligence
</li>

<li>
Analytics Engine
</li>

<li>
Customer Platform
</li>

<li>
Marketplace
</li>


</ul>


</div>

);

}
