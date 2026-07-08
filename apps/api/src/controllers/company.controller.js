const supabase = require("../config/supabase");

exports.getCompany = async (req, res) => {

    try {

        const { data, error } = await supabase
            .from("companies")
            .select("*")
            .order("created_at", { ascending: true })
            .limit(1)
            .single();


        if (error) {

            return res.status(500).json({
                success:false,
                error:error.message
            });

        }


        res.json(data);


    } catch(err){

        res.status(500).json({
            success:false,
            error:err.message
        });

    }

};
