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

          Financial Performance

        </h2>



        <p className="mt-4 text-gray-600">

          Investor view of recurring
          Energy-as-a-Service economics.

        </p>



        <div className="mt-8 grid gap-6 md:grid-cols-3">



          <Metric

            title="Funding Requirement"

            value={
              formatCurrency(
                investment.required_capital_ngn,
                investment.currency
              )
            }

            description={
              investment.funding_stage
            }

          />



          <Metric

            title="Monthly Revenue"

            value={
              formatCurrency(
                finance.monthly_revenue,
                investment.currency
              )
            }

            description="Current recurring revenue"

          />



          <Metric

            title="Asset Portfolio"

            value={
              formatCurrency(
                finance.portfolio_value,
                investment.currency
              )
            }

            description="Infrastructure portfolio value"

          />


        </div>


      </div>


    </section>

  );

}




function formatCurrency(

  amount:number,

  currency:string

){

  return new Intl.NumberFormat(

    "en-NG",

    {

      style:"currency",

      currency,

      maximumFractionDigits:0

    }

  ).format(amount);

}





function Metric({

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


      <h3 className="text-sm text-gray-500">

        {title}

      </h3>


      <p className="mt-3 text-3xl font-bold">

        {value}

      </p>


      <p className="mt-2 text-sm text-gray-600">

        {description}

      </p>


    </div>

  );

}
