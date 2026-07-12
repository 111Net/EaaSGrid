export default function Hero() {
  return (
    <section
      id="home"
      className="bg-gradient-to-b from-white via-gray-50 to-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-24">

        <div className="grid gap-12 lg:grid-cols-2 lg:items-center">


          <div>

            <p className="text-sm font-semibold uppercase tracking-wider text-green-700">
              Energy-as-a-Service Infrastructure Platform
            </p>


            <h1 className="mt-4 text-5xl font-bold tracking-tight text-gray-900 md:text-6xl">

              Powering Africa&apos;s Energy Future Through
              <span className="text-green-700">
                {" "}
                Renewable Infrastructure
              </span>

            </h1>


            <p className="mt-6 max-w-2xl text-xl leading-8 text-gray-600">

              EaaSGrid develops distributed renewable energy infrastructure
              that enables businesses, institutions and communities to access
              reliable clean power without the burden of upfront capital
              investment.

            </p>


            <div className="mt-8 flex flex-wrap gap-4">


              <a
                href="#investment"
                className="rounded-lg bg-green-700 px-6 py-3 font-semibold text-white hover:bg-green-800"
              >
                Investment Opportunity
              </a>


              <a
                href="#pilot"
                className="rounded-lg border border-gray-300 px-6 py-3 font-semibold text-gray-700 hover:bg-gray-100"
              >
                View Pilot Programme
              </a>


            </div>


          </div>



          <div className="rounded-2xl border bg-white p-8 shadow-sm">


            <h2 className="text-xl font-bold text-gray-900">
              Investor Proposition
            </h2>


            <p className="mt-4 text-gray-600">
              A scalable infrastructure model combining renewable energy,
              digital monitoring and recurring service revenue.
            </p>


            <div className="mt-8 space-y-5">


              <div>
                <p className="text-sm text-gray-500">
                  Business Model
                </p>

                <p className="font-semibold text-gray-900">
                  Energy-as-a-Service Subscription Infrastructure
                </p>
              </div>



              <div>
                <p className="text-sm text-gray-500">
                  Target Markets
                </p>

                <p className="font-semibold text-gray-900">
                  Commercial • Industrial • Healthcare • Education
                </p>
              </div>



              <div>
                <p className="text-sm text-gray-500">
                  Platform Capability
                </p>

                <p className="font-semibold text-gray-900">
                  Renewable Assets + Digital Energy Management
                </p>
              </div>


            </div>


          </div>


        </div>



        <div className="mt-20 grid gap-6 md:grid-cols-4">


          <Metric
            value="₦298M"
            label="Initial 6-Site Pilot Capital Requirement"
          />


          <Metric
            value="6"
            label="Initial Pilot Deployment Sites"
          />


          <Metric
            value="60+"
            label="Annual Deployment Target"
          />


          <Metric
            value="≈₦3B"
            label="Estimated Annual Deployment Capital"
          />


        </div>


      </div>

    </section>
  );
}



function Metric({
  value,
  label,
}: {
  value: string;
  label: string;
}) {

  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm">

      <p className="text-3xl font-bold text-green-700">
        {value}
      </p>


      <p className="mt-2 text-sm text-gray-600">
        {label}
      </p>

    </div>

  );

}
