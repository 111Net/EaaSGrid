interface PerformanceProps {
  performance: {
    asset_availability: string;
    remote_monitoring: string;
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
        Operational monitoring of deployed renewable energy assets.
      </p>


      <div className="mt-8 grid gap-6 md:grid-cols-3">


        <div className="rounded-xl border bg-white p-6 shadow-sm">

          <h3 className="text-sm text-gray-500">
            Asset Availability
          </h3>


          <p className="mt-3 text-3xl font-bold">
            {performance.asset_availability}
          </p>


          <p className="mt-2 text-sm text-gray-600">
            System uptime
          </p>

        </div>



        <div className="rounded-xl border bg-white p-6 shadow-sm">

          <h3 className="text-sm text-gray-500">
            Remote Monitoring
          </h3>


          <p className="mt-3 text-3xl font-bold">
            {performance.remote_monitoring}
          </p>


          <p className="mt-2 text-sm text-gray-600">
            Digital platform connectivity
          </p>

        </div>



        <div className="rounded-xl border bg-white p-6 shadow-sm">

          <h3 className="text-sm text-gray-500">
            Maintenance Alerts
          </h3>


          <p className="mt-3 text-3xl font-bold">
            {performance.maintenance_alerts}
          </p>


          <p className="mt-2 text-sm text-gray-600">
            Current active issues
          </p>

        </div>


      </div>


    </section>
  );
}
