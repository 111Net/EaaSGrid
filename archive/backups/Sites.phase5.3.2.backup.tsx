interface SitesProps {
  infrastructure: {
    pilot_sites: number;
    planned_sites_per_year: number;
    active_sites: number;
    monitored_sites: number;
  };
}


export default function Sites({
  infrastructure,
}: SitesProps) {

  return (
    <section
      id="sites"
      className="bg-white border-t"
    >

      <div className="mx-auto max-w-7xl px-6 py-16">

        <h2 className="text-3xl font-bold text-gray-900">
          Pilot Deployment Overview
        </h2>


        <p className="mt-4 text-gray-600">
          Current Everything-as-a-Service deployment portfolio.
        </p>


        <div className="mt-8 overflow-x-auto">

          <table className="w-full border-collapse">

            <thead>

              <tr className="border-b text-left text-sm text-gray-500">

                <th className="py-3">
                  Site
                </th>

                <th className="py-3">
                  System Size
                </th>

                <th className="py-3">
                  Status
                </th>

              </tr>

            </thead>


            <tbody>

              <tr className="border-b">

                <td className="py-4">
                  Pilot Site A
                </td>

                <td>
                  5 kW + 10 kWh
                </td>

                <td className="text-green-700">
                  Active
                </td>

              </tr>


              <tr className="border-b">

                <td className="py-4">
                  Pilot Site B
                </td>

                <td>
                  10 kW + 20 kWh
                </td>

                <td className="text-green-700">
                  Active
                </td>

              </tr>


              <tr>

                <td className="py-4">
                  Pilot Site C
                </td>

                <td>
                  20 kW + 40 kWh
                </td>

                <td className="text-yellow-700">
                  Deployment Ready
                </td>

              </tr>

            </tbody>

          </table>

        </div>


        <div className="mt-6 grid gap-4 md:grid-cols-3">

          <div className="rounded-xl border bg-gray-50 p-4">

            <p className="text-sm text-gray-500">
              Total Pilot Sites
            </p>

            <p className="mt-2 text-2xl font-bold text-gray-900">
              {infrastructure.pilot_sites}
            </p>

          </div>


          <div className="rounded-xl border bg-gray-50 p-4">

            <p className="text-sm text-gray-500">
              Planned Annual Expansion
            </p>

            <p className="mt-2 text-2xl font-bold text-gray-900">
              {infrastructure.planned_sites_per_year}
            </p>

          </div>


          <div className="rounded-xl border bg-gray-50 p-4">

            <p className="text-sm text-gray-500">
              Connected Assets
            </p>

            <p className="mt-2 text-2xl font-bold text-gray-900">
              {infrastructure.monitored_sites}
            </p>

          </div>


        </div>


      </div>

    </section>
  );
}
