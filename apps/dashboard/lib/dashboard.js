const API_URL =
process.env.NEXT_PUBLIC_API_URL ||
"http://192.168.100.21:4000";


export async function getDashboard(){

    const response =
    await fetch(
        `${API_URL}/api/v1/dashboard/summary`,
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
