interface MetricCardProps {
  title: string;
  value: string;
  description?: string;
}


export default function MetricCard({
  title,
  value,
  description,
}: MetricCardProps) {

  return (

    <div className="rounded-xl border bg-white p-6 shadow-sm min-h-[150px]">

      <p className="block text-sm leading-6 text-gray-500">
        {title}
      </p>


      <p className="mt-3 text-3xl font-bold leading-tight text-gray-900">
        {value}
      </p>


      {description && (

        <p className="mt-2 text-sm leading-5 text-gray-600">
          {description}
        </p>

      )}

    </div>

  );

}
