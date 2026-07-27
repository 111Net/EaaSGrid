"use client";

import { useMemo } from "react";
import { getSession, clearSession } from "@/lib/session";
import { useRouter } from "next/navigation";


export default function Navbar(){

    const router = useRouter();

    const user = useMemo(()=>{

        const session = getSession();

        return session?.user || null;

    },[]);


    function logout(){

        clearSession();

        router.push("/login");

    }


    return (

        <nav
        style={{
            width:"100%",
            padding:"18px 30px",
            background:
            "linear-gradient(90deg,#071426,#123b63)",
            color:"#ffffff",
            display:"flex",
            justifyContent:"space-between",
            alignItems:"center",
            boxShadow:"0 4px 20px rgba(0,0,0,.3)"
        }}
        >

            <div>

                <h2>
                    ⚡ EaaSGrid
                </h2>

                <small>
                    Everything-as-a-Service Platform
                </small>

            </div>


            <div>

                {
                user &&
                <span style={{
                    marginRight:"20px"
                }}>
                    {user.email}
                </span>
                }


                <button
                onClick={logout}
                style={{
                    background:"#ff4757",
                    color:"white",
                    border:"none",
                    padding:"10px 18px",
                    borderRadius:"8px",
                    cursor:"pointer"
                }}
                >
                    Logout
                </button>


            </div>


        </nav>

    );

}
