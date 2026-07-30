const API_URL =
process.env.NEXT_PUBLIC_API_URL ||
"http://192.168.100.21:4000";


export async function getDashboard(token){

    const response =
    await fetch(

        `${API_URL}/api/v1/dashboard`,

        {

            cache:"no-store",

            headers:{

                Authorization:
                `Bearer ${token}`

            }

        }

    );


    if(!response.ok){

        throw new Error(
            "Dashboard API unavailable"
        );

    }


    const result =
    await response.json();


    return result.data;

}
