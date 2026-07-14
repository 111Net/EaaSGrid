import MetricCard from "../components/MetricCard";

interface EnergyProps {
  energy: {
    monthly_generation: number;
    battery_utilisation: number;
    connected_assets: number;
  };
}

export default function Energy({ energy }: EnergyProps) {
  return (
    <section id="energy" className="bg-white border-t relative z-10">

      <div className="mx-auto max-w-7xl px-6 pt-20 pb-20 relative z-10">

        <div className="space-y-4 mb-12">
          <h2 className="text-2xl font-bold text-gray-900">
            Energy
          </h2>

          <p className="text-gray-600">
            Renewable generation, storage utilisation and connected energy assets.
          </p>
        </div>


        <div className="grid gap-8 md:grid-cols-3">

          <MetricCard
            title="Renewable Generation"
            value={`${energy.monthly_generation} MWh`}
            description="Monthly clean energy production"
          />

          <MetricCard
            title="Battery Utilisation"
            value={`${energy.battery_utilisation}%`}
            description="Average storage utilisation efficiency"
          />

          <MetricCard
            title="Connected Energy Assets"
            value={String(energy.connected_assets)}
            description="Assets monitored through EaaSGrid"
          />

        </div>

      </div>

    </section>
  );
}


function Card({
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

      <p className="text-sm leading-6 text-gray-500">
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
