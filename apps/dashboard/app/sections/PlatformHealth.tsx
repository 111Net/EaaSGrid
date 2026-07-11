interface PlatformHealthProps {

  platform: {

    name: string;

    version: string;

    environment: string;

    server_time: string;

  };


  dashboard: {

    status: string;

    last_updated: string;

  };

}



export default function PlatformHealth({

  platform,

  dashboard,

}: PlatformHealthProps) {


  return (

    <section
      id="health"
      className="bg-gray-900 text-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-12">


        <h2 className="text-3xl font-bold">

          Platform Health

        </h2>


        <p className="mt-3 text-gray-300">

          Real-time operational status of the EaaSGrid digital infrastructure.

        </p>



        <div className="mt-8 grid gap-6 md:grid-cols-4">



          <HealthCard

            title="Platform Status"

            value={dashboard.status}

          />


          <HealthCard

            title="API Environment"

            value={platform.environment}

          />


          <HealthCard

            title="Version"

            value={platform.version}

          />


          <HealthCard

            title="Last Update"

            value={
              new Date(
                dashboard.last_updated
              ).toLocaleTimeString()
            }

          />


        </div>


      </div>


    </section>

  );

}



function HealthCard({

  title,

  value,

}:{

  title:string;

  value:string;

}) {


  return (

    <div className="rounded-xl bg-white/10 p-5">


      <p className="text-sm text-gray-300">

        {title}

      </p>


      <p className="mt-3 text-xl font-bold">

        {value}

      </p>


    </div>

  );

}
