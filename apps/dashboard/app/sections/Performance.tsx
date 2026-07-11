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

      className="mx-auto max-w-7xl px-6 py-16"

    >


      <h2 className="text-3xl font-bold text-gray-900">

        Infrastructure Performance

      </h2>



      <p className="mt-4 text-gray-600">

        Operational monitoring of deployed renewable
        energy assets.

      </p>



      <div className="mt-8 grid gap-6 md:grid-cols-3">



        <Metric

          title="Asset Availability"

          value={`${performance.availability}%`}

          description="System uptime"

        />



        <Metric

          title="Remote Monitoring"

          value="Online"

          description="Digital platform connectivity"

        />



        <Metric

          title="Maintenance Alerts"

          value={String(performance.maintenance_alerts)}

          description="Current active issues"

        />


      </div>


    </section>

  );

}





function Metric({

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


      <h3 className="text-sm text-gray-500">

        {title}

      </h3>



      <p className="mt-3 text-3xl font-bold">

        {value}

      </p>



      <p className="mt-2 text-sm text-gray-600">

        {description}

      </p>


    </div>

  );

}
