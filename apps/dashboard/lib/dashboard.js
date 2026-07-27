const API_URL =
process.env.NEXT_PUBLIC_API_URL ||
"http://192.168.100.21:4000";


export async function getDashboardData(){


const response =
await fetch(
`${API_URL}/api/v1/dashboard`,
{
cache:"no-store"
}
);


if(!response.ok){

throw new Error(
"Dashboard API failed"
);

}


const result =
await response.json();


return result.data;


}
