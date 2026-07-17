import MetricCard from "../components/MetricCard";


interface Site {

  id: number;

  site_code: string;

  site_name: string;

  status: string;

  device_type: string;

  manufacturer: string;

  connectivity: string;

}


interface SitesProps {

  infrastructure: {

    pilot_sites: number;

    planned_sites_per_year: number;

    active_sites: number;

    monitored_sites: number;

  };

  sites: Site[];

}


export default function Sites({

  infrastructure,

  sites,

}: SitesProps) {


  return (

    <section

      id="sites"

      className="scroll-mt-24 bg-white"

    >

      <div className="mx-auto max-w-7xl px-6 pt-12 pb-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Deployment Portfolio

        </h2>


        <p className="mt-4 text-gray-600">

          Investor view of EaaSGrid connected energy infrastructure,

          monitored assets and deployment expansion.

        </p>


        <div className="mt-8 grid gap-6 md:grid-cols-4">


          <MetricBox

            title="Pilot Sites"

            value={infrastructure.pilot_sites}

          />


          <MetricBox

            title="Connected Assets"

            value={sites.length}

          />


          <MetricBox

            title="Active Assets"

            value={infrastructure.active_sites}

          />


          <MetricBox

            title="Annual Expansion Target"

            value={infrastructure.planned_sites_per_year}

          />


        </div>


        <div className="mt-12">


          <h3 className="text-xl font-semibold text-gray-900">

            Connected Infrastructure

          </h3>


          <div className="mt-6 overflow-x-auto">


            <table className="w-full border-collapse">


              <thead>


                <tr className="border-b text-left text-sm text-gray-500">


                  <th className="py-3">Asset</th>

                  <th className="py-3">Device Type</th>

                  <th className="py-3">Manufacturer</th>

                  <th className="py-3">Connectivity</th>

                  <th className="py-3">Status</th>


                </tr>


              </thead>


              <tbody>


                {sites.map((site) => (


                  <tr

                    key={site.id}

                    className="border-b"

                  >


                    <td className="py-4 font-medium">

                      {site.site_name}

                    </td>


                    <td>

                      {site.device_type}

                    </td>


                    <td>

                      {site.manufacturer}

                    </td>


                    <td>

                      {site.connectivity}

                    </td>


                    <td

                      className={

                        site.status === "Active"

                          ? "font-medium text-green-700"

                          : "font-medium text-yellow-700"

                      }

                    >

                      {site.status}

                    </td>


                  </tr>


                ))}


              </tbody>


            </table>


          </div>


        </div>


        <div className="mt-10 grid gap-6 md:grid-cols-3">


          <MetricCard

            title="Active Assets"

            value={String(infrastructure.active_sites)}

            description="Currently operating energy assets"

          />


          <MetricCard

            title="Monitored Infrastructure"

            value={String(infrastructure.monitored_sites)}

            description="Connected digital energy assets"

          />


          <MetricCard

            title="Growth Strategy"

            value={`${infrastructure.planned_sites_per_year} Sites / Year`}

            description="Planned distributed energy expansion"

          />


        </div>


      </div>


    </section>

  );

}


function MetricBox({

  title,

  value,

}: {

  title: string;

  value: number | string;

}) {


  return (

    <div className="rounded-xl border bg-gray-50 p-6">


      <p className="block text-sm leading-6 text-gray-500">

        {title}

      </p>


      <p className="mt-3 text-2xl font-bold text-gray-900">

        {value}

      </p>


    </div>

  );

}
