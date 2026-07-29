export function getSession(){

    if(typeof window==="undefined"){
        return null;
    }


    const token =
        localStorage.getItem(
            "eaasgrid_token"
        );


    const user =
        localStorage.getItem(
            "eaasgrid_user"
        );


    if(!token || !user){
        return null;
    }


    return {

        token,

        user:
        JSON.parse(user)

    };

}
