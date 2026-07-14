export default function Hero() {
  return (
    <section className="bg-gradient-to-b from-white to-gray-50">

      <div className="mx-auto max-w-6xl px-6 py-20">


        <div className="max-w-3xl">


          <h1 className="text-5xl font-bold tracking-tight text-gray-900">

            Powering Africa&apos;s Energy Future
            Through Energy-as-a-Service Infrastructure

          </h1>



          <p className="mt-6 text-xl leading-8 text-gray-600">

            EaaSGrid enables businesses, institutions and communities
            to access reliable renewable energy infrastructure without
            the burden of upfront capital investment.

          </p>



          <div className="mt-8 flex flex-wrap gap-4">


            <a
              href="#investment"
              className="rounded-lg bg-green-700 px-6 py-3 font-semibold text-white hover:bg-green-800"
            >

              Investment Opportunity

            </a>



            <a
              href={process.env.NEXT_PUBLIC_DASHBOARD_URL}
              target="_blank"
              rel="noopener noreferrer"
              className="rounded-lg border border-gray-300 px-6 py-3 font-semibold text-gray-700 hover:bg-gray-50"
            >

              View Live Dashboard

            </a>


          </div>


        </div>




        <div className="mt-16 grid gap-6 md:grid-cols-4">


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
            value="₦3B"
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
  value:string;
  label:string;
}) {

  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm">


      <h2 className="text-3xl font-bold text-green-700">

        {value}

      </h2>



      <p className="mt-2 text-sm text-gray-600">

        {label}

      </p>


    </div>

  );

}
