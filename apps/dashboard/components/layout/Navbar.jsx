"use client";

import { useRouter } from "next/navigation";
import { getSession, clearSession } from "@/lib/session";
import { useEffect, useState } from "react";

export default function Navbar() {

    const router = useRouter();

    const [user, setUser] = useState(null);

    useEffect(() => {

        const session = getSession();

        if(session?.user){
            setUser(session.user);
        }

    }, []);


    function logout(){

        clearSession();

        router.push("/login");

    }


    return (

        <header
        style={{
            height:"70px",
            display:"flex",
            justifyContent:"space-between",
            alignItems:"center",
            padding:"0 30px",
            background:"linear-gradient(90deg,#06142e,#123d7a)",
            color:"white"
        }}
        >

            <div>

                <h2>
                    ⚡ EaaSGrid Control Centre
                </h2>

            </div>


            <div
            style={{
                display:"flex",
                alignItems:"center",
                gap:"20px"
            }}
            >

                <div>

                    <div>
                    {user?.email || "Administrator"}
                    </div>

                    <small>
                    Role: {user?.role || "ADMIN"}
                    </small>

                </div>


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


        </header>

    );

}
