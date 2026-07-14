export default function Roadmap() {

  return (

    <section
      id="roadmap"
      className="bg-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-20">


        <div className="max-w-3xl">

          <p className="text-sm font-semibold uppercase tracking-wider text-green-700">
            Deployment Roadmap
          </p>


          <h2 className="mt-4 text-4xl font-bold text-gray-900">

            From Pilot Infrastructure to Scalable Energy Platform

          </h2>


          <p className="mt-6 text-lg leading-8 text-gray-600">

            EaaSGrid follows a structured deployment strategy designed
            to validate operations, establish recurring revenue and scale
            renewable energy infrastructure across multiple markets.

          </p>

        </div>



        <div className="mt-12 grid gap-6 md:grid-cols-4">


          <Phase
            phase="Phase 1"
            title="Pilot Deployment"
            description="Deploy initial renewable energy systems across selected commercial and institutional customers."
          />


          <Phase
            phase="Phase 2"
            title="Platform Validation"
            description="Validate operational performance, customer adoption and recurring service revenues."
          />


          <Phase
            phase="Phase 3"
            title="Commercial Expansion"
            description="Scale deployments across SMEs, healthcare, education and government sectors."
          />


          <Phase
            phase="Phase 4"
            title="Regional Growth"
            description="Expand the Energy-as-a-Service platform across African markets."
          />


        </div>



      </div>

    </section>

  );

}



function Phase({
  phase,
  title,
  description,
}: {
  phase:string;
  title:string;
  description:string;
}) {

  return (

    <div className="rounded-xl border p-6 shadow-sm">


      <p className="text-sm font-semibold text-green-700">
        {phase}
      </p>


      <h3 className="mt-3 text-xl font-bold text-gray-900">
        {title}
      </h3>


      <p className="mt-4 text-sm leading-6 text-gray-600">
        {description}
      </p>


    </div>

  );

}
