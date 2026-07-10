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
    <div className="rounded-xl border bg-white p-6 shadow-sm">

      <h3 className="text-sm font-medium text-gray-500">
        {title}
      </h3>


      <p className="mt-3 text-3xl font-bold text-gray-900">
        {value}
      </p>


      {description && (
        <p className="mt-2 text-sm text-gray-600">
          {description}
        </p>
      )}

    </div>
  );
}
