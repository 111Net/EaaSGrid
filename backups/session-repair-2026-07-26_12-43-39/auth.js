const API_URL =
process.env.NEXT_PUBLIC_API_URL ||
"http://192.168.100.21:4000";


export async function login(email,password){

    try {

        const response = await fetch(
            `${API_URL}/api/v1/auth/login`,
            {
                method:"POST",
                headers:{
                    "Content-Type":"application/json"
                },
                body:JSON.stringify({
                    email,
                    password
                })
            }
        );


        const data = await response.json();

console.log("LOGIN RESPONSE:", data);

return data;


    } catch(error){

        return {
            message:
            "API connection failed: " + error.message
        };

    }

}



export function saveSession(data){

    localStorage.setItem(
        "eaasgrid_token",
        data.token
    );


    localStorage.setItem(
        "eaasgrid_user",
        JSON.stringify(data.user)
    );


}



export function getSession(){

    if(typeof window === "undefined")
        return null;


    const token =
    localStorage.getItem(
        "eaasgrid_token"
    );


    const user =
    localStorage.getItem(
        "eaasgrid_user"
    );


    return {
        token,
        user:user ? JSON.parse(user):null
    };

}



export function logout(){

    localStorage.removeItem(
        "eaasgrid_token"
    );


    localStorage.removeItem(
        "eaasgrid_user"
    );

}
