interface PerformanceProps {

  performance: {

    availability: number;

    maintenance_alerts: number;

  };

}



export default function Performance({

  performance,

}: PerformanceProps) {


  return (

    <section

      id="performance"

      className="bg-gray-50 border-t"

    >


      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Operational Performance

        </h2>



        <p className="mt-4 max-w-3xl text-gray-600">

          Digital monitoring and operational intelligence
          supporting reliable renewable energy infrastructure
          deployment at scale.

        </p>




        <div className="mt-10 grid gap-6 md:grid-cols-3">


          <PerformanceCard

            title="Asset Availability"

            value={`${performance.availability}%`}

            description="Infrastructure uptime performance"

          />



          <PerformanceCard

            title="Remote Monitoring"

            value="Online"

            description="Continuous digital asset visibility"

          />



          <PerformanceCard

            title="Maintenance Alerts"

            value={String(performance.maintenance_alerts)}

            description="Current operational issues"

          />


        </div>




        <div className="mt-10 rounded-xl border bg-white p-6 shadow-sm">


          <h3 className="text-xl font-semibold text-gray-900">

            Scalable Asset Management

          </h3>



          <p className="mt-3 text-gray-600">

            EaaSGrid's software platform provides monitoring,
            performance tracking and operational control across
            distributed renewable energy assets.

          </p>


        </div>



      </div>


    </section>

  );

}





function PerformanceCard({

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


      <p className="text-sm text-gray-500">

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
