interface FinanceProps {

  investment: {

    required_capital_ngn: number;

    currency: string;

    funding_stage: string;

  };


  finance: {

    monthly_revenue: number;

    portfolio_value: number;

  };

}



export default function Finance({

  investment,

  finance,

}: FinanceProps) {


  return (

    <section

      id="finance"

      className="bg-white border-t"

    >


      <div className="mx-auto max-w-7xl px-6 py-16">


        <h2 className="text-3xl font-bold text-gray-900">

          Investment & Financial Performance

        </h2>



        <p className="mt-4 max-w-3xl text-gray-600">

          Investor view of EaaSGrid's Energy-as-a-Service
          infrastructure financing model, recurring revenue
          opportunity and scalable asset portfolio.

        </p>




        <div className="mt-10 grid gap-6 md:grid-cols-3">


          <FinanceCard

            title="Capital Requirement"

            value={formatCurrency(

              investment.required_capital_ngn,

              investment.currency

            )}

            description={investment.funding_stage}

          />



          <FinanceCard

            title="Recurring Monthly Revenue"

            value={formatCurrency(

              finance.monthly_revenue,

              investment.currency

            )}

            description="Energy service subscriptions"

          />



          <FinanceCard

            title="Infrastructure Portfolio Value"

            value={formatCurrency(

              finance.portfolio_value,

              investment.currency

            )}

            description="Distributed energy assets"

          />


        </div>




        <div className="mt-10 rounded-xl border bg-gray-50 p-6">


          <h3 className="text-xl font-semibold text-gray-900">

            Energy-as-a-Service Investment Model

          </h3>



          <p className="mt-3 text-gray-600">

            EaaSGrid transforms renewable energy deployment
            into a recurring infrastructure business by combining
            customer subscriptions, asset financing and digital
            energy management.

          </p>


        </div>



      </div>


    </section>

  );

}





function formatCurrency(

  amount:number,

  currency:string

) {


  return new Intl.NumberFormat(

    "en-NG",

    {

      style:"currency",

      currency,

      maximumFractionDigits:0

    }

  ).format(amount);

}





function FinanceCard({

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
