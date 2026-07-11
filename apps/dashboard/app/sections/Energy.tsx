interface EnergyProps {

  energy: {

    monthly_generation: number;

    battery_utilisation: number;

    connected_assets: number;

  };

}



export default function Energy({

  energy,

}: EnergyProps) {


  return (

    <section

      id="energy"

      className="bg-gray-50 border-t"

    >


      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Energy Infrastructure Performance

        </h2>



        <p className="mt-4 max-w-3xl text-gray-600">

          Operational view of renewable energy generation,
          battery storage utilisation and digitally connected
          distributed energy assets.

        </p>




        <div className="mt-10 grid gap-6 md:grid-cols-3">


          <EnergyCard

            title="Renewable Generation"

            value={`${energy.monthly_generation} MWh`}

            description="Monthly clean energy production"

          />



          <EnergyCard

            title="Battery Utilisation"

            value={`${energy.battery_utilisation}%`}

            description="Average storage utilisation efficiency"

          />



          <EnergyCard

            title="Connected Energy Assets"

            value={String(energy.connected_assets)}

            description="Assets monitored through the EaaSGrid platform"

          />


        </div>




        <div className="mt-10 rounded-xl border bg-white p-6 shadow-sm">


          <h3 className="text-xl font-semibold text-gray-900">

            Digital Energy Platform Advantage

          </h3>



          <p className="mt-3 text-gray-600">

            EaaSGrid combines renewable generation,
            battery storage and software-based monitoring
            to deliver scalable Energy-as-a-Service infrastructure
            with recurring revenue potential.

          </p>


        </div>



      </div>


    </section>

  );

}





function EnergyCard({

  title,

  value,

  description,

}:{

  title:string;

  value:string;

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
