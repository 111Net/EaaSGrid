"use client";


const USER_KEY="xaasgrid_user";

const TOKEN_KEY="xaasgrid_token";



export function saveSession(data){


if(typeof window==="undefined"){

return;

}


localStorage.setItem(
TOKEN_KEY,
data.token
);


localStorage.setItem(
USER_KEY,
JSON.stringify(data.user)
);


}



export function getSession(){


if(typeof window==="undefined"){

return null;

}


const user =
localStorage.getItem(USER_KEY);



if(!user){

return null;

}



return {

token:
localStorage.getItem(TOKEN_KEY),

user:
JSON.parse(user)

};


}



export function logout(){


if(typeof window==="undefined"){

return;

}


localStorage.removeItem(
TOKEN_KEY
);


localStorage.removeItem(
USER_KEY
);


window.location.href="/login";


}
