"use client";

import { useEffect, useState } from "react";
import DashboardLayout from "@/components/layout/DashboardLayout";

export default function ControlCentre() {

  const [data, setData] = useState(null);
  const [error, setError] = useState("");


  useEffect(() => {

    async function loadDashboard(){

      try {

        const token =
localStorage.getItem(
"eaasgrid_token"
);


const response = await fetch(

`${process.env.NEXT_PUBLIC_API_URL}/api/v1/dashboard/summary`,

{

cache:"no-store",

headers:{

Authorization:
`Bearer ${token}`

}

}

);


        if(!response.ok){
          throw new Error(
            "Dashboard API unavailable"
          );
        }


        const result =
          await response.json();


        setData(result);


      } catch(err){

        console.error(err);

        setError(
          "Unable to load platform intelligence"
        );

      }

    }


    loadDashboard();


  }, []);



  if(error){

    return (

      <DashboardLayout>

        <div style={{
          padding:"40px",
          color:"red"
        }}>

          {error}

        </div>

      </DashboardLayout>

    );

  }



  if(!data){

    return (

      <DashboardLayout>

        <div style={{
          padding:"40px"
        }}>

          Loading XaaSGrid intelligence...

        </div>

      </DashboardLayout>

    );

  }



  return (

    <DashboardLayout>

      <div
        style={{
          padding:"30px"
        }}
      >


        <div
          style={{
            background:
            "linear-gradient(135deg,#071426,#123b63,#1d6fa5)",

            padding:"40px",

            borderRadius:"20px",

            color:"white",

            marginBottom:"30px"
          }}
        >

          <h1
            style={{
              fontSize:"42px",
              fontWeight:"800"
            }}
          >

            XaaSGrid Executive Platform Intelligence

          </h1>


          <p>

            Everything-as-a-Service Command Centre

          </p>


        </div>



        <div
          style={{
            display:"grid",
            gridTemplateColumns:
            "repeat(auto-fit,minmax(250px,1fr))",
            gap:"20px"
          }}
        >


          <Metric
            title="Platform Status"
            value={data.platformStatus}
          />


          <Metric
            title="Deployment Sites"
            value={data.totalSites}
          />


          <Metric
            title="Customers"
            value={data.activeCustomers}
          />


          <Metric
            title="Monthly Revenue"
            value={`₦${data.monthlyRevenue}`}
          />


          <Metric
            title="Energy Generated"
            value={data.energyGenerated}
          />


          <Metric
            title="Availability"
            value={data.uptime}
          />


        </div>



        <div
          style={{
            marginTop:"40px",
            background:"#f5f7fb",
            padding:"30px",
            borderRadius:"15px"
          }}
        >

          <h2>
            Platform Status
          </h2>


          <p>

            Last synchronisation:

            {" "}

            {data.timestamp}

          </p>


        </div>


      </div>


    </DashboardLayout>

  );

}



function Metric({title,value}){

  return (

    <div
      style={{
        background:"white",
        padding:"25px",
        borderRadius:"15px",
        boxShadow:
        "0 5px 20px rgba(0,0,0,.08)"
      }}
    >

      <h3>
        {title}
      </h3>


      <h1
        style={{
          marginTop:"15px"
        }}
      >

        {value}

      </h1>


    </div>

  );

}
