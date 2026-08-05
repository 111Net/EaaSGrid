

const store=require("./user.store");


function list(){

return store.users;

}


function create(data){


const user={

id:Date.now(),

name:data.name,

email:data.email,

role:data.role || "CUSTOMER",

status:"ACTIVE"

};


store.users.push(user);


return user;


}


function find(id){

return store.users.find(

u=>u.id==id

);

}


function update(id,data){


const user=find(id);


if(!user)return null;


Object.assign(user,data);


return user;


}



function remove(id){


store.users =
store.users.filter(
u=>u.id!=id
);


return true;


}



module.exports={

list,

create,

find,

update,

remove

};


