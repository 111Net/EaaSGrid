const supabase = require("../config/database");


async function getDashboardData(){

    const { data, error } = await supabase
        .from("investors")
        .select("*")
        .single();


    if(error){
        throw new Error(error.message);
    }


    return data;

}


module.exports = {
    getDashboardData
};
