import MetricCard from "../components/MetricCard";


interface FinanceProps {
  investment: {
    required_capital_ngn: number;
    currency: string;
    funding_stage: string;
  };
}


export default function Finance({
  investment,
}: FinanceProps) {


  const formattedCapital =
    new Intl.NumberFormat("en-NG", {
      style: "currency",
      currency: "NGN",
      maximumFractionDigits: 0,
    }).format(
      investment.required_capital_ngn
    );


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
          Investor view of recurring Everything-as-a-Service economics.
        </p>



        <div className="mt-8 grid gap-6 md:grid-cols-3">


          <MetricCard

            title="Funding Requirement"

            value={formattedCapital}

            description={
              investment.funding_stage
            }

          />



          <MetricCard

            title="Currency"

            value={
              investment.currency
            }

            description="Investment denomination"

          />



          <MetricCard

            title="Asset Portfolio"

            value={formattedCapital}

            description="Pilot infrastructure value"

          />


        </div>


      </div>

    </section>
  );
}
