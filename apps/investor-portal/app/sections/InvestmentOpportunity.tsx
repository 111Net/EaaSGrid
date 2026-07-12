export default function InvestmentOpportunity() {
  return (
    <section
      id="investment"
      className="border-t bg-white"
    >

      <div className="mx-auto max-w-7xl px-6 py-20">


        <div className="max-w-3xl">

          <p className="text-sm font-semibold uppercase tracking-wider text-green-700">
            Investment Opportunity
          </p>


          <h2 className="mt-4 text-4xl font-bold text-gray-900">

            Building Renewable Energy Infrastructure
            as a Scalable Service Platform

          </h2>


          <p className="mt-6 text-lg leading-8 text-gray-600">

            EaaSGrid is developing a distributed renewable energy
            infrastructure platform that converts clean energy assets
            into predictable recurring service revenue.

          </p>


        </div>



        <div className="mt-12 grid gap-6 md:grid-cols-3">


          <Card
            title="Pilot Capital Requirement"
            value="₦298 Million"
            description="Initial 6-site deployment programme"
          />


          <Card
            title="Deployment Model"
            value="Energy-as-a-Service"
            description="Customers subscribe to reliable renewable energy infrastructure"
          />


          <Card
            title="Revenue Model"
            value="Recurring Income"
            description="Subscription, infrastructure leasing and energy services"
          />


        </div>



        <div className="mt-12 rounded-2xl bg-gray-50 p-8">


          <h3 className="text-2xl font-bold text-gray-900">

            Why Invest in EaaSGrid?

          </h3>



          <div className="mt-6 grid gap-5 md:grid-cols-2">


            <Point>
              Growing demand for reliable renewable power across Africa.
            </Point>


            <Point>
              Infrastructure ownership creates long-term asset value.
            </Point>


            <Point>
              Digital monitoring enables operational visibility and scalability.
            </Point>


            <Point>
              Platform model supports expansion across multiple sectors.
            </Point>


          </div>


        </div>


      </div>

    </section>
  );
}



function Card({
  title,
  value,
  description,
}: {
  title: string;
  value: string;
  description: string;
}) {

  return (

    <div className="rounded-xl border p-6 shadow-sm">


      <p className="text-sm text-gray-500">
        {title}
      </p>


      <p className="mt-3 text-2xl font-bold text-green-700">
        {value}
      </p>


      <p className="mt-3 text-sm text-gray-600">
        {description}
      </p>


    </div>

  );

}



function Point({
  children,
}: {
  children: React.ReactNode;
}) {

  return (

    <div className="rounded-lg border bg-white p-5">

      <p className="text-gray-700">
        ✓ {children}
      </p>

    </div>

  );

}
