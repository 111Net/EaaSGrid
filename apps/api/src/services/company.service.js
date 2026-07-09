const supabase = require("../config/supabase");


async function getCompany(){

    const { data, error } = await supabase
        .from("companies")
        .select("*")
        .order("created_at", { ascending:false })
        .limit(1)
        .single();


    if(error){
        throw new Error(error.message);
    }


    return data;

}


module.exports = {
    getCompany
};
