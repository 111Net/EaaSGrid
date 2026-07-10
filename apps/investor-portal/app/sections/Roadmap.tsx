export default function Roadmap() {
  return (
    <section
      id="roadmap"
      className="bg-white"
    >

      <div className="mx-auto max-w-6xl px-6 py-20">

        <div className="max-w-3xl">

          <h2 className="text-4xl font-bold tracking-tight text-gray-900">
            Deployment Roadmap
          </h2>

          <p className="mt-6 text-lg leading-8 text-gray-600">
            EaaSGrid follows a phased deployment strategy from pilot
            validation to scalable distributed energy infrastructure
            expansion.
          </p>

        </div>


        <div className="mt-12 grid gap-6 md:grid-cols-3">


          <div className="rounded-xl border bg-gray-50 p-6 shadow-sm">

            <h3 className="text-xl font-semibold text-gray-900">
              Phase 1 — Pilot Deployment
            </h3>

            <p className="mt-3 text-gray-600">
              Deploy initial Energy-as-a-Service sites to validate
              technology performance, customer adoption and operational
              processes.
            </p>

          </div>


          <div className="rounded-xl border bg-white p-6 shadow-sm">

            <h3 className="text-xl font-semibold text-gray-900">
              Phase 2 — Market Expansion
            </h3>

            <p className="mt-3 text-gray-600">
              Expand deployments across commercial, institutional and
              SME customers through strategic partnerships.
            </p>

          </div>


          <div className="rounded-xl border bg-gray-50 p-6 shadow-sm">

            <h3 className="text-xl font-semibold text-gray-900">
              Phase 3 — Regional Infrastructure Network
            </h3>

            <p className="mt-3 text-gray-600">
              Scale distributed energy infrastructure into a regional
              Energy-as-a-Service platform.
            </p>

          </div>


        </div>

      </div>

    </section>
  );
}
