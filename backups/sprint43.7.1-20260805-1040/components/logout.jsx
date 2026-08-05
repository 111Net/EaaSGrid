"use client";


import {logout} from "../lib/auth";


export default function Logout(){


return (

<button
onClick={logout}
>

Logout

</button>

);


}
