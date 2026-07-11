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


  const totalCapacity = sites.reduce(

    (sum, site) => sum + site.system_size_kw,

    0

  );


  const totalStorage = sites.reduce(

    (sum, site) => sum + site.battery_capacity_kwh,

    0

  );


  return (

    <section
      id="sites"
      className="bg-white border-t"
    >

      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Deployment Portfolio

        </h2>


        <p className="mt-4 text-gray-600">

          Investor view of EaaSGrid renewable energy infrastructure rollout,
          deployed assets and expansion pipeline.

        </p>



        <div className="mt-8 grid gap-6 md:grid-cols-4">


          <MetricBox

            title="Pilot Sites"

            value={infrastructure.pilot_sites}

          />


          <MetricBox

            title="Installed Capacity"

            value={`${totalCapacity} kW`}

          />


          <MetricBox

            title="Energy Storage"

            value={`${totalStorage} kWh`}

          />


          <MetricBox

            title="Annual Expansion Target"

            value={infrastructure.planned_sites_per_year}

          />


        </div>



        <div className="mt-12">


          <h3 className="text-xl font-semibold text-gray-900">

            Current Deployment Pipeline

          </h3>



          <div className="mt-6 overflow-x-auto">


            <table className="w-full border-collapse">


              <thead>

                <tr className="border-b text-left text-sm text-gray-500">


                  <th className="py-3">
                    Site
                  </th>


                  <th className="py-3">
                    Market Segment
                  </th>


                  <th className="py-3">
                    Capacity
                  </th>


                  <th className="py-3">
                    Storage
                  </th>


                  <th className="py-3">
                    Location
                  </th>


                  <th className="py-3">
                    Deployment Status
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



        <div className="mt-10 grid gap-6 md:grid-cols-3">


          <InvestorCard

            title="Active Assets"

            value={infrastructure.active_sites}

            description="Currently operating energy assets"

          />


          <InvestorCard

            title="Monitored Infrastructure"

            value={infrastructure.monitored_sites}

            description="Connected digital energy assets"

          />


          <InvestorCard

            title="Growth Strategy"

            value="60 Sites / Year"

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

}:{

  title:string;

  value:number|string;

}) {


  return (

    <div className="rounded-xl border bg-gray-50 p-6">


      <p className="text-sm text-gray-500">

        {title}

      </p>


      <p className="mt-3 text-2xl font-bold text-gray-900">

        {value}

      </p>


    </div>

  );

}





function InvestorCard({

  title,

  value,

  description,

}:{

  title:string;

  value:number|string;

  description:string;

}) {


  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm">


      <h4 className="text-sm text-gray-500">

        {title}

      </h4>


      <p className="mt-3 text-3xl font-bold text-gray-900">

        {value}

      </p>


      <p className="mt-2 text-sm text-gray-600">

        {description}

      </p>


    </div>

  );

}
