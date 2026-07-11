const dashboardService = require("../services/dashboard.service");


exports.getDashboard = async (req, res, next) => {

    try {


        const dashboard =
            await dashboardService.getDashboardData();



        res.json({

            success:true,

            message:
                "Dashboard data retrieved successfully",


            data:{


                platform:{

                    name:
                        "EaaSGrid",

                    version:
                        "1.0.0",

                    environment:
                        process.env.NODE_ENV || "development",

                    server_time:
                        new Date().toISOString()

                },



                company:{

                    name:
                        dashboard.investor.company_name,

                    headquarters:
                        dashboard.investor.headquarters,

                    project:
                        dashboard.investor.project

                },



                dashboard:{

                    status:
                        "Operational",

                    last_updated:
                        new Date().toISOString()

                },



                infrastructure:{


                    pilot_sites:
                        dashboard.sites.length,


                    planned_sites_per_year:
                        dashboard.investor.annual_expansion_sites,


                    active_sites:
                        dashboard.sites.filter(
                            site =>
                            site.status === "Active"
                        ).length,


                    monitored_sites:
                        dashboard.energy.connected_assets

                },



                investment:{


                    required_capital_ngn:
                        dashboard.finance.portfolio_value_ngn,


                    currency:
                        dashboard.investor.funding_currency,


                    funding_stage:
                        dashboard.investor.stage

                },



                energy:{

                    monthly_generation:
                        dashboard.energy.monthly_generation_mwh,


                    battery_utilisation:
                        dashboard.energy.battery_utilisation_percent,


                    connected_assets:
                        dashboard.energy.connected_assets

                },



                finance:{


                    monthly_revenue:
                        dashboard.finance.monthly_revenue_ngn,


                    portfolio_value:
                        dashboard.finance.portfolio_value_ngn

                },



                performance:{


                    availability:
                        dashboard.performance.availability_percent,


                    maintenance_alerts:
                        dashboard.performance.maintenance_alerts

                },



                sites:
                    dashboard.sites,


                business_model:
                    dashboard.investor.business_model,


                target_markets:
                    dashboard.investor.target_markets


            }

        });


    } catch(error){

        next(error);

    }

};
