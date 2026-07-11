interface ExecutiveSummaryProps {

  investment: {

    required_capital_ngn: number;

    currency: string;

    funding_stage: string;

  };


  infrastructure: {

    pilot_sites: number;

    planned_sites_per_year: number;

    active_sites: number;

    monitored_sites: number;

  };


  platform: {

    name: string;

    version: string;

    environment: string;

  };


  dashboard: {

    status: string;

  };


  target_markets: string[];

}



export default function ExecutiveSummary({

  investment,

  infrastructure,

  platform,

  dashboard,

  target_markets,

}: ExecutiveSummaryProps) {


  return (

    <section className="bg-white">


      <div className="mx-auto max-w-7xl px-6 py-16">


        <h1 className="text-4xl font-bold text-gray-900">

          EaaSGrid Investor Dashboard

        </h1>


        <p className="mt-4 text-gray-600 max-w-3xl">

          Energy-as-a-Service infrastructure platform enabling
          distributed renewable energy deployment, financing,
          monitoring and recurring energy services.

        </p>



        <div className="mt-10 grid gap-6 md:grid-cols-4">


          <SummaryCard

            title="Capital Requirement"

            value={
              formatCurrency(
                investment.required_capital_ngn,
                investment.currency
              )
            }

            description={
              investment.funding_stage
            }

          />



          <SummaryCard

            title="Pilot Deployment"

            value={
              `${infrastructure.active_sites}/${infrastructure.pilot_sites}`
            }

            description="Active pilot sites"

          />



          <SummaryCard

            title="Platform"

            value={
              dashboard.status
            }

            description={
              `${platform.name} v${platform.version}`
            }

          />



          <SummaryCard

            title="Target Markets"

            value={
              String(target_markets.length)
            }

            description="Market segments"

          />


        </div>


      </div>


    </section>

  );

}



function formatCurrency(

  amount:number,

  currency:string

){

  return new Intl.NumberFormat(

    "en-NG",

    {

      style:"currency",

      currency,

      maximumFractionDigits:0

    }

  ).format(amount);

}



function SummaryCard({

  title,

  value,

  description,

}:{

  title:string;

  value:string;

  description:string;

}) {


  return (

    <div className="rounded-xl border bg-gray-50 p-6 shadow-sm">


      <p className="text-sm text-gray-500">

        {title}

      </p>


      <p className="mt-3 text-2xl font-bold text-gray-900">

        {value}

      </p>


      <p className="mt-2 text-sm text-gray-600">

        {description}

      </p>


    </div>

  );

}
