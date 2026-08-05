

const data=require("./knowledge.store");


function get(type){

return data[type] || [];

}


module.exports={get};


