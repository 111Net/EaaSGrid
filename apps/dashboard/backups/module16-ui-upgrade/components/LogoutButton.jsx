"use client";


import {clearSession} from "@/lib/session";
import {useRouter} from "next/navigation";


export default function LogoutButton(){


const router = useRouter();



function logout(){


    clearSession();


    router.push("/login");


}



return (

<button

onClick={logout}

style={{

background:"#dc2626",

color:"white",

padding:"10px 20px",

borderRadius:"8px",

border:"none",

cursor:"pointer",

fontWeight:"bold"

}}

>

Logout

</button>


);


}
