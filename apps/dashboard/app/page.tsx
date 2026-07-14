import ExecutiveSummary from "./sections/ExecutiveSummary";
import Overview from "./sections/Overview";
import Sites from "./sections/Sites";
import Energy from "./sections/Energy";
import Finance from "./sections/Finance";
import Performance from "./sections/Performance";
import PlatformHealth from "./sections/PlatformHealth";

import { getDashboardData } from "./services/dashboardService";


export default async function Home() {


  const dashboard =
    await getDashboardData();


  const data =
    dashboard.data;



  return (

    <div className="bg-white">


      <ExecutiveSummary

        investment={
          data.investment
        }

        infrastructure={
          data.infrastructure
        }

        platform={
          data.platform
        }

        dashboard={
          data.dashboard
        }

        target_markets={
          data.target_markets
        }

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



      <PlatformHealth

        platform={
          data.platform
        }

        dashboard={
          data.dashboard
        }

      />


    </div>

  );

}
