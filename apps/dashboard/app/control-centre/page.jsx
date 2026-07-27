import DashboardLayout from "@/components/layout/DashboardLayout";

"use client";

import DashboardLayout from "@/components/layout/DashboardLayout";
import MetricCard from "@/components/dashboard/MetricCard";
import EnergyChart from "@/components/charts/EnergyChart";
import RevenueChart from "@/components/charts/RevenueChart";

import { useEffect, useState } from "react";


export default function ControlCentre(){

    const [dashboard, setDashboard] = useState(null);
    const [error, setError] = useState(null);


    useEffect(()=>{


        async function loadDashboard(){

            try {

                const response = await fetch(
                    process.env.NEXT_PUBLIC_API_URL +
                    "/api/v1/dashboard",
                    {
                        cache:"no-store"
                    }
                );


                const result = await response.json();


                if(result.success){

                    setDashboard(result.data);

                }
                else {

                    setError(
                        "Unable to load dashboard data"
                    );

                }


            }
            catch(err){

                console.error(err);

                setError(
                    "API connection failed"
                );

            }

        }


        loadDashboard();


    },[]);



    if(error){

        return (

            <DashboardLayout>

                <div
                style={{
                    padding:"40px"
                }}
                >

                    <h2>
                    Control Centre Error
                    </h2>

                    <p>
                    {error}
                    </p>

                </div>

            </DashboardLayout>

        );

    }



    if(!dashboard){

        return (

            <DashboardLayout>

                <div
                style={{
                    padding:"40px"
                }}
                >

                    <h2>
                    Loading EaaSGrid Control Centre...
                    </h2>

                </div>

            </DashboardLayout>

        );

    }



    return (

        <DashboardLayout>


            <main
            style={{
                padding:"30px"
            }}
            >


                <h1
                style={{
                    fontSize:"32px",
                    marginBottom:"10px"
                }}
                >
                    Executive Platform Intelligence
                </h1>


                <p
                style={{
                    color:"#555",
                    marginBottom:"30px"
                }}
                >
                    Real-time visibility into EaaSGrid infrastructure,
                    energy, finance and operations.
                </p>



                <section

                style={{

                    display:"grid",

                    gridTemplateColumns:
                    "repeat(auto-fit,minmax(220px,1fr))",

                    gap:"20px"

                }}

                >


                    <MetricCard

                    title="Platform Status"

                    value={
                        dashboard.dashboard.status
                    }

                    />


                    <MetricCard

                    title="Pilot Sites"

                    value={
                        dashboard.infrastructure.pilot_sites
                    }

                    />


                    <MetricCard

                    title="Annual Target"

                    value={
                        dashboard.infrastructure.planned_sites_per_year
                    }

                    />


                    <MetricCard

                    title="Capital Requirement"

                    value={
                        "₦" +
                        dashboard.investment.required_capital_ngn
                        .toLocaleString()
                    }

                    />


                    <MetricCard

                    title="Monthly Revenue"

                    value={
                        "₦" +
                        dashboard.finance.monthly_revenue
                        .toLocaleString()
                    }

                    />


                    <MetricCard

                    title="Availability"

                    value={
                        dashboard.performance.availability +
                        "%"
                    }

                    />


                </section>





                <section

                style={{

                    marginTop:"40px",

                    display:"grid",

                    gridTemplateColumns:
                    "repeat(auto-fit,minmax(400px,1fr))",

                    gap:"25px"

                }}

                >


                    <div

                    style={{

                        background:"white",

                        padding:"25px",

                        borderRadius:"15px",

                        boxShadow:
                        "0 4px 15px rgba(0,0,0,0.08)"

                    }}

                    >

                        <h2>
                        ⚡ Energy Performance
                        </h2>


                        <p>
                        Solar Grid Monitoring Active
                        </p>


                        <EnergyChart />


                    </div>





                    <div

                    style={{

                        background:"white",

                        padding:"25px",

                        borderRadius:"15px",

                        boxShadow:
                        "0 4px 15px rgba(0,0,0,0.08)"

                    }}

                    >

                        <h2>
                        💰 Revenue Intelligence
                        </h2>


                        <p>
                        Financial Engine Connected
                        </p>


                        <RevenueChart />


                    </div>



                </section>





                <section

                style={{

                    marginTop:"40px",

                    background:"white",

                    padding:"25px",

                    borderRadius:"15px"

                }}

                >

                    <h2>
                    Business Model
                    </h2>


                    <p>
                    {dashboard.business_model}
                    </p>



                    <h3>
                    Target Markets
                    </h3>


                    <ul>

                    {
                        dashboard.target_markets.map(
                            (market,index)=>(

                            <li key={index}>
                                {market}
                            </li>

                            )
                        )
                    }

                    </ul>


                </section>



            </main>


        </DashboardLayout>

    );

}
