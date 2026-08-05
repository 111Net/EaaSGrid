
const API_URL =
process.env.INTERNAL_API_URL ||
"http://xaasgrid-api:4000";


export async function getPlatformMetrics(){

    const response = await fetch(
        `${API_URL}/api/platform/metrics`,
        {
            cache:"no-store"
        }
    );


    if(!response.ok){

        throw new Error(
            "Platform metrics API failed"
        );

    }


    return response.json();

}

