import MetricCard from "../components/MetricCard";


export default function Performance() {
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


        <MetricCard
          title="Asset Availability"
          value="99.2%"
          description="System uptime"
        />


        <MetricCard
          title="Remote Monitoring"
          value="Online"
          description="Digital platform connectivity"
        />


        <MetricCard
          title="Maintenance Alerts"
          value="0"
          description="Current active issues"
        />


      </div>


    </section>
  );
}
