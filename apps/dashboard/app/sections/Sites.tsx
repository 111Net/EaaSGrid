interface Site {

  id: string;

  site_name: string;

  customer_type: string;

  system_size_kw: number;

  battery_capacity_kwh: number;

  status: string;

  location: string;

  created_at: string;

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
      className="bg-white border-t"
    >

      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Deployment Portfolio

        </h2>


        <p className="mt-4 text-gray-600 max-w-3xl">

          EaaSGrid is building a scalable distributed renewable
          energy infrastructure portfolio through Energy-as-a-Service
          deployments across commercial, industrial, education and
          institutional customers.

        </p>



        <div className="mt-8 grid gap-6 md:grid-cols-4">


          <MetricBox

            title="Current Pilot Sites"

            value={infrastructure.pilot_sites}

          />


          <MetricBox

            title="Active Deployments"

            value={infrastructure.active_sites}

          />


          <MetricBox

            title="Annual Expansion Target"

            value={infrastructure.planned_sites_per_year}

          />


          <MetricBox

            title="Connected Assets"

            value={infrastructure.monitored_sites}

          />


        </div>



        <div className="mt-12">


          <h3 className="text-xl font-semibold text-gray-900">

            Pilot Deployment Pipeline

          </h3>


          <p className="mt-2 text-gray-600">

            Representative customer deployments demonstrating
            platform scalability and recurring energy service delivery.

          </p>



          <div className="mt-6 overflow-x-auto">


            <table className="w-full border-collapse">


              <thead>

                <tr className="border-b text-left text-sm text-gray-500">


                  <th className="py-3">
                    Deployment
                  </th>


                  <th className="py-3">
                    Market Segment
                  </th>


                  <th className="py-3">
                    Energy Capacity
                  </th>


                  <th className="py-3">
                    Storage
                  </th>


                  <th className="py-3">
                    Location
                  </th>


                  <th className="py-3">
                    Status
                  </th>


                </tr>

              </thead>



              <tbody>


                {sites.map((site)=>(


                  <tr
                    key={site.id}
                    className="border-b"
                  >


                    <td className="py-4 font-medium">

                      {site.site_name}

                    </td>



                    <td>

                      {site.customer_type}

                    </td>



                    <td>

                      {site.system_size_kw} kW

                    </td>



                    <td>

                      {site.battery_capacity_kwh} kWh

                    </td>



                    <td>

                      {site.location}

                    </td>



                    <td
                      className={
                        site.status === "Active"
                        ? "text-green-700 font-medium"
                        : "text-yellow-700 font-medium"
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



        <div className="mt-10 rounded-xl border bg-gray-50 p-6">


          <h3 className="text-lg font-semibold text-gray-900">

            Investment Perspective

          </h3>


          <p className="mt-3 text-gray-600">

            Each deployment represents a long-term infrastructure
            asset generating recurring Energy-as-a-Service revenue.
            The platform model allows expansion from pilot projects
            into a multi-site distributed energy portfolio.

          </p>


        </div>


      </div>


    </section>

  );

}





function MetricBox({

  title,

  value,

}:{

  title:string;

  value:number;

}) {


  return (

    <div className="rounded-xl border bg-gray-50 p-5">


      <p className="text-sm text-gray-500">

        {title}

      </p>


      <p className="mt-2 text-3xl font-bold text-gray-900">

        {value}

      </p>


    </div>

  );

}
