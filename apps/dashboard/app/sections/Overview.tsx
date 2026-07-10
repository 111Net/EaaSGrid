import MetricCard from "../components/MetricCard";


export default function Overview() {
  return (
    <section
      id="overview"
      className="mx-auto max-w-7xl px-6 py-16"
    >

      <div className="max-w-3xl">

        <h1 className="text-4xl font-bold tracking-tight text-gray-900">
          EaaSGrid Operational Dashboard
        </h1>


        <p className="mt-4 text-lg text-gray-600">
          Monitoring distributed energy infrastructure,
          pilot deployments and Energy-as-a-Service performance.
        </p>

      </div>


      <div className="mt-12 grid gap-6 md:grid-cols-4">

        <MetricCard
          title="Active Sites"
          value="6"
          description="Pilot deployment locations"
        />


        <MetricCard
          title="Installed Capacity"
          value="70 kW"
          description="Solar + storage infrastructure"
        />


        <MetricCard
          title="Energy Delivered"
          value="12.4 MWh"
          description="Cumulative pilot output"
        />


        <MetricCard
          title="System Availability"
          value="99.2%"
          description="Infrastructure uptime"
        />

      </div>

    </section>
  );
}
