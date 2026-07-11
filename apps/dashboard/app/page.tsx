import ExecutiveSummary from "./sections/ExecutiveSummary";
import Overview from "./sections/Overview";
import Sites from "./sections/Sites";
import Energy from "./sections/Energy";
import Finance from "./sections/Finance";
import Performance from "./sections/Performance";

import { getDashboardData } from "./services/dashboardService";


export default async function Home() {


  const dashboard = await getDashboardData();


  const data = dashboard.data;



  return (

    <div className="bg-gray-50">


      <ExecutiveSummary

        investment={data.investment}

        finance={data.finance}

        energy={data.energy}

        performance={data.performance}

        infrastructure={data.infrastructure}

      />



      <Overview

        infrastructure={
          data.infrastructure
        }

      />



      <Sites

        infrastructure={
          data.infrastructure
        }

        sites={
          data.sites
        }

      />



      <Energy

        energy={
          data.energy
        }

      />



      <Finance

        investment={
          data.investment
        }

        finance={
          data.finance
        }

      />



      <Performance

        performance={
          data.performance
        }

      />


    </div>

  );

}
