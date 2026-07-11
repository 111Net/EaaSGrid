interface KPICardProps {

  title: string;

  value: string;

  description: string;

}


export default function KPICard({

  title,

  value,

  description,

}: KPICardProps) {


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
