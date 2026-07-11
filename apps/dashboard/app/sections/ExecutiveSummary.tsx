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


      <div className="mx-auto max-w-7xl px-6 py-20">


        <div className="max-w-4xl">


          <p className="text-sm font-semibold uppercase tracking-wide text-gray-500">

            Energy-as-a-Service Infrastructure Platform

          </p>



          <h1 className="mt-4 text-5xl font-bold leading-tight text-gray-900">

            Building scalable renewable energy infrastructure through digital energy services.

          </h1>



          <p className="mt-6 text-lg text-gray-600">

            EaaSGrid enables organisations to access reliable renewable energy
            through financed solar infrastructure, intelligent monitoring and
            recurring Energy-as-a-Service delivery.

          </p>


        </div>



        <div className="mt-12 grid gap-6 md:grid-cols-4">



          <Card

            title="Investment Requirement"

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



          <Card

            title="Pilot Deployment"

            value={
              `${infrastructure.active_sites}/${infrastructure.pilot_sites}`
            }

            description="Operational pilot assets"

          />



          <Card

            title="Expansion Capacity"

            value={
              String(
                infrastructure.planned_sites_per_year
              )
            }

            description="Annual planned deployments"

          />



          <Card

            title="Platform Status"

            value={
              dashboard.status
            }

            description={
              `${platform.name} v${platform.version}`
            }

          />


        </div>



        <div className="mt-10 rounded-xl border bg-gray-50 p-6">


          <h3 className="text-lg font-semibold text-gray-900">

            Target Markets

          </h3>


          <div className="mt-4 flex flex-wrap gap-3">


            {target_markets.map((market)=>(

              <span

                key={market}

                className="rounded-full bg-white border px-4 py-2 text-sm text-gray-700"

              >

                {market}

              </span>

            ))}


          </div>


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
