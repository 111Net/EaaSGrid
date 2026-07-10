import MetricCard from "../components/MetricCard";


export default function Energy() {
  return (
    <section
      id="energy"
      className="mx-auto max-w-7xl px-6 py-16"
    >

      <h2 className="text-3xl font-bold text-gray-900">
        Energy Performance
      </h2>


      <p className="mt-4 text-gray-600">
        Monitoring renewable generation,
        battery storage utilisation and customer energy delivery.
      </p>


      <div className="mt-8 grid gap-6 md:grid-cols-3">

        <MetricCard
          title="Solar Generation"
          value="18.6 MWh"
          description="Monthly renewable generation"
        />


        <MetricCard
          title="Battery Utilisation"
          value="82%"
          description="Average storage utilisation"
        />


        <MetricCard
          title="CO₂ Reduction"
          value="9.4 tonnes"
          description="Estimated emissions avoided"
        />

      </div>


    </section>
  );
}
