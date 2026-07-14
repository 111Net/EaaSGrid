import MetricCard from "../components/MetricCard";

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

    <section
      id="top"
      className="scroll-mt-24 bg-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-20">


        <div className="flex flex-col gap-6 md:flex-row md:items-start md:justify-between">


          <div className="max-w-4xl">


            <p className="text-sm font-semibold uppercase tracking-wide text-gray-500">

              EaaSGrid Operations Dashboard

            </p>


            <h1 className="mt-4 text-5xl font-bold leading-tight text-gray-900">

              Energy-as-a-Service Infrastructure Monitoring Platform

            </h1>


            <p className="mt-6 text-lg text-gray-600">

              Building scalable renewable energy infrastructure through
              digital energy services, intelligent monitoring and recurring
              infrastructure revenue.

            </p>


          </div>



          <div className="rounded-xl border bg-gray-50 px-6 py-5 shadow-sm">


            <p className="block text-sm leading-6 text-gray-500">

              Platform Status

            </p>


            <p className="mt-2 text-xl font-bold text-gray-900">

              ● {dashboard.status}

            </p>


            <p className="mt-2 text-sm text-gray-600">

              {platform.name} v{platform.version}

            </p>


            <p className="block text-sm leading-6 text-gray-500">

              {platform.environment}

            </p>


          </div>


        </div>




        <div className="mt-12 grid gap-6 md:grid-cols-4">


          <MetricCard

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



          <MetricCard

            title="Pilot Deployment"

            value={
              `${infrastructure.active_sites}/${infrastructure.pilot_sites}`
            }

            description="Operational pilot assets"

          />



          <MetricCard

            title="Expansion Capacity"

            value={
              String(
                infrastructure.planned_sites_per_year
              )
            }

            description="Annual planned deployments"

          />



          <MetricCard

            title="Connected Assets"

            value={
              String(
                infrastructure.monitored_sites
              )
            }

            description="Digitally monitored infrastructure"

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

                className="rounded-full border bg-white px-4 py-2 text-sm text-gray-700"

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


      <p className="block text-sm leading-6 text-gray-500">

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




function formatCurrency(

  amount:number,

  currency:string

) {


  return new Intl.NumberFormat(

    "en-NG",

    {

      style:"currency",

      currency,

      maximumFractionDigits:0

    }

  ).format(amount);

}
