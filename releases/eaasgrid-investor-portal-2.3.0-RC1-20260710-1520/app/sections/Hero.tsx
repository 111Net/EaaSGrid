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


          <div className="mt-8 flex gap-4">

            <button
              className="rounded-lg bg-green-700 px-6 py-3
              font-semibold text-white hover:bg-green-800"
            >
              Investment Opportunity
            </button>


            <button
              className="rounded-lg border border-gray-300
              px-6 py-3 font-semibold text-gray-700"
            >
              View Pilot Programme
            </button>

          </div>

        </div>


        <div className="mt-16 grid gap-6 md:grid-cols-4">


          <div className="rounded-xl border bg-white p-6 shadow-sm">

            <h2 className="text-3xl font-bold text-green-700">
              ₦298M
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              Initial 6-Site Pilot Capital Requirement
            </p>

          </div>



          <div className="rounded-xl border bg-white p-6 shadow-sm">

            <h2 className="text-3xl font-bold text-green-700">
              6
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              Initial Pilot Deployment Sites
            </p>

          </div>



          <div className="rounded-xl border bg-white p-6 shadow-sm">

            <h2 className="text-3xl font-bold text-green-700">
              &gt;60
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              Annual Deployment Target
            </p>

          </div>



          <div className="rounded-xl border bg-white p-6 shadow-sm">

            <h2 className="text-3xl font-bold text-green-700">
              ≈₦3B
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              Estimated Annual Deployment Capital
            </p>

          </div>


        </div>

      </div>

    </section>
  );
}
