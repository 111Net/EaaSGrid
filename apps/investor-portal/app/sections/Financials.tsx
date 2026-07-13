import { getInvestorProfile } from "../lib/api";


export default async function Financials() {

  const investor = await getInvestorProfile();


  const fundingAmount =
    new Intl.NumberFormat("en-NG").format(
      investor.funding_required.amount
    );


  return (

    <section
      id="financials"
      className="border-t bg-gray-50"
    >

      <div className="mx-auto max-w-7xl px-6 py-20">


        <div className="max-w-3xl">

          <p className="text-sm font-semibold uppercase tracking-wider text-green-700">
            Financial Model
          </p>


          <h2 className="mt-4 text-4xl font-bold text-gray-900">

            Building a Recurring Renewable Energy Infrastructure Business

          </h2>


          <p className="mt-6 text-lg leading-8 text-gray-600">

            EaaSGrid combines renewable energy assets, digital monitoring
            and subscription-based services to create predictable
            long-term infrastructure revenue.

          </p>

        </div>



        <div className="mt-12 grid gap-6 md:grid-cols-3">


          <Metric
            title="Initial Investment Requirement"
            value={`${investor.funding_required.currency} ${fundingAmount}`}
            description={`Capital required for first ${investor.projected_rollout.pilot_sites}-site pilot deployment`}
          />


          <Metric
            title="Revenue Structure"
            value="Recurring"
            description="Energy subscription and infrastructure service income"
          />


          <Metric
            title="Expansion Model"
            value={`${investor.projected_rollout.annual_expansion_sites}+ Sites / Year`}
            description="Scalable deployment across commercial sectors"
          />


        </div>



        <div className="mt-12 rounded-2xl border bg-white p-8">


          <h3 className="text-2xl font-bold text-gray-900">

            Capital Deployment Strategy

          </h3>



          <div className="mt-6 grid gap-5 md:grid-cols-3">


            <Allocation
              title="Energy Infrastructure"
              description="Solar generation systems, battery storage and installation."
            />


            <Allocation
              title="Technology Platform"
              description="Monitoring, billing and operational management systems."
            />


            <Allocation
              title="Growth Expansion"
              description="Scaling deployments into additional customer sectors."
            />


          </div>


        </div>



      </div>

    </section>

  );

}



function Metric({
  title,
  value,
  description,
}: {
  title:string;
  value:string;
  description:string;
}) {

  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm">

      <p className="text-sm text-gray-500">
        {title}
      </p>


      <p className="mt-3 text-3xl font-bold text-green-700">
        {value}
      </p>


      <p className="mt-3 text-sm text-gray-600">
        {description}
      </p>


    </div>

  );

}




function Allocation({
  title,
  description,
}: {
  title:string;
  description:string;
}) {

  return (

    <div className="rounded-lg bg-gray-50 p-5">

      <h4 className="font-bold text-gray-900">
        {title}
      </h4>


      <p className="mt-3 text-sm text-gray-600">
        {description}
      </p>


    </div>

  );

}
