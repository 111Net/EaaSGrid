import MetricCard from "../components/MetricCard";


export default function Finance() {
  return (
    <section
      id="finance"
      className="border-t bg-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">
          Financial Performance
        </h2>


        <p className="mt-4 text-gray-600">
          Investor view of recurring Energy-as-a-Service economics.
        </p>


        <div className="mt-8 grid gap-6 md:grid-cols-3">


          <MetricCard
            title="Monthly Revenue"
            value="₦2.4M"
            description="Subscription energy payments"
          />


          <MetricCard
            title="Contracted Sites"
            value="6"
            description="Pilot customers"
          />


          <MetricCard
            title="Asset Portfolio"
            value="₦298M"
            description="Pilot infrastructure value"
          />


        </div>


      </div>

    </section>
  );
}
