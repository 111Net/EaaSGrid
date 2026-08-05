"use client";


import {useState} from "react";

import {useRouter} from "next/navigation";

import {postApi} from "../../lib/api";

import {saveSession} from "../../lib/auth";



export default function Login(){


const router =
useRouter();


const [email,setEmail]=useState("");

const [password,setPassword]=useState("");

const [error,setError]=useState("");

const [loading,setLoading]=useState(false);



async function login(){


setLoading(true);

setError("");



try{


const response =
await postApi(
"/api/auth/login",
{
email,
password
}
);



const data =
await response.json();



if(!data.success){

setError(
data.message ||
"Login failed"
);

setLoading(false);

return;

}



saveSession(data);



router.push(
"/dashboard"
);



}

catch(error){


setError(
"Unable to connect to XaaSGrid API"
);


}


setLoading(false);


}



return (

<div>


<h1>
XaaSGrid Login
</h1>


<input

placeholder="Email"

value={email}

onChange={
e=>setEmail(e.target.value)
}

/>



<input

type="password"

placeholder="Password"

value={password}

onChange={
e=>setPassword(e.target.value)
}

/>



<button

disabled={loading}

onClick={login}

>


{
loading
?
"Signing in..."
:
"Login"
}


</button>



<p>

{error}

</p>


</div>

);


}
