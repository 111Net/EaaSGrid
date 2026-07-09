const supabase = require("../config/supabase");
const response = require("../utils/response");


exports.getCompany = async (req, res) => {

    try {

        const { data, error } = await supabase
            .from("companies")
            .select("*")
            .order("created_at", { ascending: false })
            .limit(1)
            .single();


        if (error) {

            return response.error(
                res,
                error.message,
                500
            );

        }


        return response.success(
            res,
            data,
            "Company retrieved successfully"
        );


    } catch(err){

        return response.error(
            res,
            err.message
        );

    }

};
