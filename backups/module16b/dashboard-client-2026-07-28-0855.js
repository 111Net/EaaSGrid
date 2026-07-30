
export async function getDashboard(){

const API =
process.env.NEXT_PUBLIC_API_URL ||
"http://localhost:4000";


const response =
await fetch(
`${API}/api/v1/dashboard`,
{
cache:"no-store"
}
);


if(!response.ok){

throw new Error(
"Dashboard API unavailable"
);

}


return response.json();

}

