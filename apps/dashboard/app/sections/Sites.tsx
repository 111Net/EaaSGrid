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

          Pilot Deployment Overview

        </h2>



        <p className="mt-4 text-gray-600">

          Current Energy-as-a-Service deployment portfolio.

        </p>



        <div className="mt-8 overflow-x-auto">


          <table className="w-full border-collapse">


            <thead>

              <tr className="border-b text-left text-sm text-gray-500">


                <th className="py-3">
                  Site
                </th>


                <th className="py-3">
                  Customer Type
                </th>


                <th className="py-3">
                  System Size
                </th>


                <th className="py-3">
                  Battery
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


                  <td className="py-4">

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
                      ? "text-green-700"
                      : "text-yellow-700"
                    }
                  >

                    {site.status}

                  </td>


                </tr>


              ))}


            </tbody>


          </table>


        </div>




        <div className="mt-6 grid gap-4 md:grid-cols-3">


          <MetricBox

            title="Total Pilot Sites"

            value={infrastructure.pilot_sites}

          />



          <MetricBox

            title="Annual Expansion"

            value={infrastructure.planned_sites_per_year}

          />



          <MetricBox

            title="Connected Assets"

            value={infrastructure.monitored_sites}

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

  value:number;

}) {


  return (

    <div className="rounded-xl border bg-gray-50 p-4">


      <p className="text-sm text-gray-500">

        {title}

      </p>


      <p className="mt-2 text-2xl font-bold text-gray-900">

        {value}

      </p>


    </div>

  );

}
