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
          title="Pilot Sites"
          value={String(infrastructure.pilot_sites)}
          description="Deployment locations"
        />


        <MetricCard
          title="Planned Expansion"
          value={String(infrastructure.planned_sites_per_year)}
          description="Annual deployment target"
        />


        <MetricCard
          title="Active Sites"
          value={String(infrastructure.active_sites)}
          description="Currently operational"
        />


        <MetricCard
          title="Monitored Sites"
          value={String(infrastructure.monitored_sites)}
          description="Connected assets"
        />


      </div>


    </section>
  );
}
