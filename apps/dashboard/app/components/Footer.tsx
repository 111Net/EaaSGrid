export default function Footer() {
  return (
    <footer className="border-t bg-gray-50">

      <div className="mx-auto max-w-7xl px-6 py-8 text-center text-sm text-gray-600">

        <p>
          © {new Date().getFullYear()} EaaSGrid Platform Ltd.
        </p>

        <p className="mt-2">
          Investor Demonstration Dashboard
        </p>

      </div>

    </footer>
  );
}
