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
