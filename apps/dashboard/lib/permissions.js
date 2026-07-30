export function hasPermission(permission, permissions=[]){

    return permissions.includes(permission);

}


export function canAccess(route, permissions=[]){

    const rules = {

        "/operations":[
            "VIEW_OPERATIONS"
        ],

        "/investor":[
            "VIEW_INVESTOR"
        ],

        "/billing":[
            "VIEW_BILLING"
        ],

        "/users":[
            "MANAGE_USERS"
        ],

        "/security":[
            "MANAGE_SECURITY"
        ]

    };


    const required = rules[route];


    if(!required){
        return true;
    }


    return required.some(
        p=>permissions.includes(p)
    );

}


export function getCurrentUser(){

    if(typeof window === "undefined"){
        return null;
    }


    try {

        const user =
            localStorage.getItem("user");


        if(!user){
            return null;
        }


        return JSON.parse(user);


    } catch(error){

        console.error(
            "Unable to load current user",
            error
        );

        return null;

    }

}

