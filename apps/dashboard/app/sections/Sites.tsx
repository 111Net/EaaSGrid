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
      className="bg-gray-50 border-t"
    >


      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Deployment Portfolio

        </h2>



        <p className="mt-4 max-w-3xl text-gray-600">

          EaaSGrid deploys distributed renewable energy infrastructure
          through an Energy-as-a-Service model, combining solar generation,
          battery storage and digital monitoring across commercial,
          institutional and industrial customers.

        </p>



        <div className="mt-10 grid gap-6 md:grid-cols-4">


          <MetricBox

            title="Pilot Projects"

            value={infrastructure.pilot_sites}

            description="Initial deployment portfolio"

          />


          <MetricBox

            title="Annual Growth Target"

            value={infrastructure.planned_sites_per_year}

            description="Sites planned per year"

          />


          <MetricBox

            title="Active Sites"

            value={infrastructure.active_sites}

            description="Currently operating"

          />


          <MetricBox

            title="Connected Assets"

            value={infrastructure.monitored_sites}

            description="Digitally monitored"

          />


        </div>




        <div className="mt-12 rounded-xl border bg-white shadow-sm">


          <div className="border-b px-6 py-5">


            <h3 className="text-xl font-semibold text-gray-900">

              Pilot Deployment Pipeline

            </h3>


            <p className="mt-2 text-sm text-gray-600">

              Investor view of deployed and planned renewable energy assets.

            </p>


          </div>





          <div className="overflow-x-auto">


            <table className="w-full">


              <thead>


                <tr className="border-b text-left text-sm text-gray-500">


                  <th className="px-6 py-4">
                    Site
                  </th>


                  <th className="px-6 py-4">
                    Market Segment
                  </th>


                  <th className="px-6 py-4">
                    Solar Capacity
                  </th>


                  <th className="px-6 py-4">
                    Storage
                  </th>


                  <th className="px-6 py-4">
                    Location
                  </th>


                  <th className="px-6 py-4">
                    Status
                  </th>


                </tr>


              </thead>




              <tbody>


              {sites.map((site)=>(


                <tr
                  key={site.id}
                  className="border-b last:border-0"
                >


                  <td className="px-6 py-4 font-medium text-gray-900">

                    {site.site_name}

                  </td>




                  <td className="px-6 py-4 text-gray-700">

                    {site.customer_type}

                  </td>




                  <td className="px-6 py-4 text-gray-700">

                    {site.system_size_kw} kW

                  </td>




                  <td className="px-6 py-4 text-gray-700">

                    {site.battery_capacity_kwh} kWh

                  </td>




                  <td className="px-6 py-4 text-gray-700">

                    {site.location}

                  </td>




                  <td className="px-6 py-4">


                    <span

                      className={

                        site.status === "Active"

                        ? "rounded-full bg-green-100 px-3 py-1 text-sm text-green-700"

                        : "rounded-full bg-yellow-100 px-3 py-1 text-sm text-yellow-700"

                      }

                    >

                      {site.status}

                    </span>


                  </td>



                </tr>


              ))}


              </tbody>


            </table>


          </div>


        </div>



      </div>


    </section>

  );

}





function MetricBox({

  title,

  value,

  description,

}:{

  title:string;

  value:number;

  description:string;

}) {


  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm">


      <p className="text-sm text-gray-500">

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
