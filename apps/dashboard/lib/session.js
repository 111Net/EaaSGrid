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



export function getSession(){


if(typeof window==="undefined")
return null;



const token =
localStorage.getItem(
"eaasgrid_token"
);



const user =
JSON.parse(
localStorage.getItem(
"eaasgrid_user"
)||"null"
);



return {

token,

user

};



}




export function clearSession(){


if(typeof window!=="undefined"){


localStorage.removeItem(
"eaasgrid_token"
);



localStorage.removeItem(
"eaasgrid_user"
);



document.cookie =
"eaasgrid_token=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT";



}



}
