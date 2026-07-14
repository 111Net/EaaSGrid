import MetricCard from "../components/MetricCard";

interface OverviewProps {

  infrastructure: {

    pilot_sites: number;

    planned_sites_per_year: number;

    active_sites: number;

    monitored_sites: number;

  };

}



export default function Overview({

  infrastructure,

}: OverviewProps) {


  return (

    <section

      id="overview"

      className="scroll-mt-24 mx-auto max-w-7xl px-6 py-16"

    >


      <div>


        <h2 className="text-3xl font-bold text-gray-900">

          Platform Deployment Overview

        </h2>


        <p className="mt-4 max-w-3xl text-gray-600">

          EaaSGrid provides a scalable renewable energy
          infrastructure platform combining financed energy assets,
          digital monitoring and recurring Energy-as-a-Service delivery.

        </p>



        <div className="mt-10 grid gap-6 md:grid-cols-4">


          <MetricCard

            title="Pilot Portfolio"

            value={
              String(
                infrastructure.pilot_sites
              )
            }

            description="Initial deployment sites"

          />



          <MetricCard

            title="Operational Assets"

            value={
              String(
                infrastructure.active_sites
              )
            }

            description="Currently active installations"

          />



          <MetricCard

            title="Digital Monitoring"

            value={
              String(
                infrastructure.monitored_sites
              )
            }

            description="Connected energy assets"

          />



          <MetricCard

            title="Annual Expansion"

            value={
              String(
                infrastructure.planned_sites_per_year
              )
            }

            description="Planned yearly rollout capacity"

          />


        </div>



      </div>


    </section>

  );

}



function OverviewCard_DISABLED({

  title,

  value,

  description,

}:{

  title:string;

  value:string;

  description:string;

}) {


  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm">


      <p className="block text-sm leading-6 text-gray-500">

        {title}

      </p>



      <p className="mt-3 text-3xl font-bold text-gray-900">

        {value}

      </p>



      <p className="mt-2 text-sm text-gray-600">

        {description}

      </p>


    </div>

  );

}
