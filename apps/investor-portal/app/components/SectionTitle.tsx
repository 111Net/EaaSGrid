interface SectionTitleProps {
  eyebrow?: string;
  title: string;
  description?: string;
}

export default function SectionTitle({
  eyebrow,
  title,
  description,
}: SectionTitleProps) {
  return (
    <div className="max-w-3xl">
      {eyebrow && (
        <p className="text-sm font-semibold uppercase tracking-wider text-green-700">
          {eyebrow}
        </p>
      )}

      <h2 className="mt-2 text-3xl font-bold text-gray-900 md:text-4xl">
        {title}
      </h2>

      {description && (
        <p className="mt-4 text-lg text-gray-600">
          {description}
        </p>
      )}
    </div>
  );
}
