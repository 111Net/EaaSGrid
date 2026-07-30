"use client";


import {useEffect} from "react";
import {useRouter} from "next/navigation";
import {getSession} from "@/lib/session";


export default function RoleGuard({
    children,
    allowedRoles=[]
}){


const router = useRouter();



useEffect(()=>{


const session = getSession();



if(!session || !session.user){

    router.push("/login");

    return;

}



if(
!allowedRoles.includes(
session.user.role
)

){

    router.push("/unauthorized");

}



},[
allowedRoles,
router
]);



return children;


}
