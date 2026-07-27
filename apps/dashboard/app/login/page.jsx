"use client";

import { useState } from "react";
import { login, saveSession } from "@/lib/auth";

export default function LoginPage() {

    const [email,setEmail] = useState("");
    const [password,setPassword] = useState("");
    const [message,setMessage] = useState("");
    const [loading,setLoading] = useState(false);


    async function submit(e){

        e.preventDefault();

        setLoading(true);
        setMessage("Authenticating...");


        try {

            const result = await login(
                email,
                password
            );


            console.log(
                "LOGIN RESULT:",
                result
            );


            if(result && result.token){

                saveSession(result);


                const role =
                    result.user?.role;


                console.log(
                    "ROLE:",
                    role
                );


                switch(role){

                    case "ADMIN":
                        window.location.href =
                        "/control-centre";
                        break;


                    case "OPERATIONS":
                        window.location.href =
                        "/operations";
                        break;


                    case "PARTNER":
                        window.location.href =
                        "/partner";
                        break;


                    case "INVESTOR":
                        window.location.href =
                        "/investor";
                        break;


                    case "CUSTOMER":
                        window.location.href =
                        "/customer";
                        break;


                    case "COLLABORATOR":
                        window.location.href =
                        "/collaborator";
                        break;


                    default:
                        window.location.href =
                        "/unauthorized";

                }


            }
            else {

                setMessage(
                    result?.message ||
                    "Invalid credentials"
                );

            }


        }
        catch(error){

            console.error(
                error
            );

            setMessage(
                "Authentication error"
            );

        }


        setLoading(false);

    }



return (

<div
style={{
minHeight:"100vh",
display:"flex",
alignItems:"center",
justifyContent:"center",
background:"#08111f",
color:"white"
}}
>


<form
onSubmit={submit}
style={{
width:"380px",
padding:"40px",
background:"#132238",
borderRadius:"15px"
}}
>


<h1>
EaaSGrid Login
</h1>


<input
style={{
width:"100%",
padding:"12px",
margin:"10px 0"
}}
placeholder="Email"
value={email}
onChange={
e=>setEmail(e.target.value)
}
/>



<input
style={{
width:"100%",
padding:"12px",
margin:"10px 0"
}}
type="password"
placeholder="Password"
value={password}
onChange={
e=>setPassword(e.target.value)
}
/>



<button
style={{
width:"100%",
padding:"12px",
background:"#00c853",
border:"none",
cursor:"pointer"
}}
disabled={loading}
>


{
loading ?
"Authenticating..." :
"Login"
}


</button>


<p>
{message}
</p>


</form>


</div>


);


}
