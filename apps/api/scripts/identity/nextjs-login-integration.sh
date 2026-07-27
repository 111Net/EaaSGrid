#!/usr/bin/env bash

set -euo pipefail

ROOT="/data/eaasgrid-platform"

DASHBOARD="$ROOT/apps/dashboard"

DATE=$(date +%Y-%m-%d)

REPORT_DIR="$ROOT/docs/sprint-reports/$DATE/identity-login"

mkdir -p "$REPORT_DIR"


REPORT="$REPORT_DIR/nextjs-login-report.txt"


echo "==================================" > "$REPORT"
echo "EaaSGrid Next.js Login Integration" >> "$REPORT"
echo "Date: $DATE" >> "$REPORT"
echo "==================================" >> "$REPORT"


cd "$DASHBOARD"


echo "[1] Creating auth directories"

mkdir -p app/login
mkdir -p lib
mkdir -p components


echo "[2] Creating API authentication client"


cat > lib/auth.js <<'EOF'

const API_URL =
process.env.NEXT_PUBLIC_API_URL ||
"http://192.168.100.21:4000";


export async function login(
email,
password
){

const response =
await fetch(
`${API_URL}/api/auth/login`,
{
method:"POST",
headers:
{
"Content-Type":"application/json"
},
body:
JSON.stringify(
{
email,
password
}
)
}
);


return response.json();

}


export function saveSession(data)
{
localStorage.setItem(
"eaasgrid_token",
data.token
);

localStorage.setItem(
"eaasgrid_user",
JSON.stringify(data.user)
);

}


export function logout()
{
localStorage.removeItem(
"eaasgrid_token"
);

localStorage.removeItem(
"eaasgrid_user"
);

}

EOF



echo "[3] Creating login page"


cat > app/login/page.jsx <<'EOF'

"use client";


import {useState} from "react";

import {
login,
saveSession
}
from "@/lib/auth";


export default function LoginPage()
{


const [email,setEmail]=useState("");

const [password,setPassword]=useState("");

const [message,setMessage]=useState("");


async function submit(e)
{

e.preventDefault();


const result =
await login(
email,
password
);


if(result.token)
{

saveSession(result);


if(result.user.role==="ADMIN")
{
window.location="/control-centre";
}
else
{
window.location="/operations";
}

}
else
{

setMessage(
result.message || "Login failed"
);

}


}


return (

<div>

<h1>
EaaSGrid Login
</h1>


<form onSubmit={submit}>


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


<button>
Login
</button>


</form>


<p>{message}</p>


</div>

);


}

EOF



echo "[4] Creating route protection helper"


cat > lib/session.js <<'EOF'


export function getUser()
{

if(typeof window==="undefined")
return null;


const user =
localStorage.getItem(
"eaasgrid_user"
);


return user ?
JSON.parse(user)
:
null;

}


export function isLoggedIn()
{

return Boolean(
localStorage.getItem(
"eaasgrid_token"
)
);

}

EOF



echo "[5] Validation"


npm run build


echo "STATUS: PASS" > "$REPORT"


echo "Next.js Login Integration COMPLETE"
