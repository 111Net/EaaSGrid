const supabase = require("../config/database");


async function getDashboardData() {


    const [
        investorResult,
        sitesResult,
        energyResult,
        performanceResult,
        financeResult
    ] = await Promise.all([


        supabase
            .from("investors")
            .select("*")
            .single(),


        supabase
            .from("pilot_sites")
            .select("*")
            .order("created_at"),


        supabase
            .from("energy_metrics")
            .select("*")
            .order("recorded_at", {
                ascending:false
            })
            .limit(1)
            .single(),


        supabase
            .from("performance_metrics")
            .select("*")
            .order("recorded_at", {
                ascending:false
            })
            .limit(1)
            .single(),


        supabase
            .from("financial_metrics")
            .select("*")
            .order("recorded_at", {
                ascending:false
            })
            .limit(1)
            .single()

    ]);



    const errors = [
        investorResult.error,
        sitesResult.error,
        energyResult.error,
        performanceResult.error,
        financeResult.error
    ]
    .filter(Boolean);



    if(errors.length){

        throw new Error(
            errors[0].message
        );

    }



    return {


        investor:
            investorResult.data,


        sites:
            sitesResult.data,


        energy:
            energyResult.data,


        performance:
            performanceResult.data,


        finance:
            financeResult.data

    };


}


module.exports = {
    getDashboardData
};
