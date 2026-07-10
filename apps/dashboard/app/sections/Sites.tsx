export default function Sites() {
  return (
    <section
      id="sites"
      className="border-t bg-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-16">

        <h2 className="text-3xl font-bold text-gray-900">
          Pilot Deployment Overview
        </h2>


        <p className="mt-3 text-gray-600">
          Current Energy-as-a-Service deployment portfolio.
        </p>


        <div className="mt-8 overflow-x-auto">

          <table className="w-full border-collapse">

            <thead>
              <tr className="border-b text-left text-sm text-gray-500">

                <th className="py-3">Site</th>
                <th className="py-3">System Size</th>
                <th className="py-3">Customer Type</th>
                <th className="py-3">Status</th>

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

                <td>
                  SME / Commercial
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

                <td>
                  Business Facility
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

                <td>
                  Institutional Facility
                </td>

                <td className="text-yellow-700">
                  Deployment Ready
                </td>

              </tr>


            </tbody>

          </table>

        </div>

      </div>

    </section>
  );
}
