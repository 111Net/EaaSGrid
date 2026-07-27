"use client";

import RoleGuard from "@/components/RoleGuard";
import LogoutButton from "@/components/LogoutButton";

import MetricCard from "@/components/dashboard/MetricCard";
import EnergyChart from "@/components/charts/EnergyChart";
import RevenueChart from "@/components/charts/RevenueChart";

import { useEffect, useState } from "react";


export default function ControlCentre(){

    const [data,setData] = useState(null);
    const [error,setError] = useState("");


    useEffect(()=>{

        fetch(
            process.env.NEXT_PUBLIC_API_URL +
            "/api/v1/dashboard"
        )
        .then(response=>response.json())
        .then(result=>{
            setData(result);
        })
        .catch(err=>{
            setError(
                "Unable to load dashboard data"
            );
        });


    },[]);



    return (

        <RoleGuard allowedRoles={["ADMIN"]}>


        <div
        style={{
            padding:"30px",
            background:"#f8fafc",
            minHeight:"100vh"
        }}
        >


            <div
            style={{
                display:"flex",
                justifyContent:"space-between",
                alignItems:"center",
                marginBottom:"30px"
            }}
            >


                <div>

                    <h1>
                        EaaSGrid Control Centre
                    </h1>

                    <p>
                        Executive Platform Intelligence
                    </p>

                </div>


                <LogoutButton/>


            </div>



            {
                error &&
                <p>
                    {error}
                </p>
            }



            {
            data &&

            <>


            <div
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
                    data.data.dashboard.status
                }
                />


                <MetricCard
                title="Pilot Sites"
                value={
                    data.data.infrastructure.pilot_sites
                }
                />


                <MetricCard
                title="Annual Target"
                value={
                    data.data.infrastructure.planned_sites_per_year
                }
                />


                <MetricCard
                title="Capital Requirement"
                value="₦298,000,000"
                />


                <MetricCard
                title="Monthly Revenue"
                value={
                    "₦" +
                    data.data.finance.monthly_revenue
                }
                />


                <MetricCard
                title="Availability"
                value={
                    data.data.performance.availability +
                    "%"
                }
                />


            </div>



            <br/>


            <section>

                <h2>
                    ⚡ Energy Performance
                </h2>


                <EnergyChart/>


            </section>




            <br/>


            <section>

                <h2>
                    💰 Revenue Intelligence
                </h2>


                <RevenueChart/>


            </section>



            <br/>


            <section>

                <h2>
                    Business Model
                </h2>


                <p>
                    {
                    data.data.business_model
                    }
                </p>


            </section>



            <section>

                <h2>
                    Target Markets
                </h2>


                <ul>

                {
                data.data.target_markets.map(
                    (item,index)=>(

                    <li key={index}>
                        {item}
                    </li>

                    )
                )
                }

                </ul>


            </section>



            </>

            }


        </div>


        </RoleGuard>


    );

}
