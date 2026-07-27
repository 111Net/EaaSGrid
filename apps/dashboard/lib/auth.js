const API_URL =
process.env.NEXT_PUBLIC_API_URL ||
"http://192.168.100.21:4000";



export async function login(email,password){

    const response = await fetch(
        `${API_URL}/api/v1/auth/login`,
        {
            method:"POST",
            headers:{
                "Content-Type":
                "application/json"
            },
            body:JSON.stringify({
                email,
                password
            })
        }
    );


    const data =
    await response.json();


    console.log(
        "API LOGIN:",
        data
    );


    return data;

}



export function saveSession(data){

    if(typeof window !== "undefined"){


        localStorage.setItem(
            "eaasgrid_token",
            data.token
        );


        localStorage.setItem(
            "eaasgrid_user",
            JSON.stringify(data.user)
        );


        document.cookie =
        `eaasgrid_token=${data.token}; path=/; SameSite=Lax`;

    }

}
