export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b bg-white/95 backdrop-blur">

      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">

        <a href="/" className="flex flex-col">

          <span className="text-xl font-bold tracking-tight text-gray-900">
            EaaSGrid Ltd
          </span>

          <span className="text-xs text-gray-500">
            Energy-as-a-Service Infrastructure Platform
          </span>

        </a>


        <nav className="hidden md:flex gap-6 text-sm font-medium text-gray-600">

          <a href="#overview" className="hover:text-green-700">
            Overview
          </a>

          <a href="#sites" className="hover:text-green-700">
            Deployments
          </a>

          <a href="#energy" className="hover:text-green-700">
            Energy
          </a>

          <a href="#finance" className="hover:text-green-700">
            Finance
          </a>

          <a href="#performance" className="hover:text-green-700">
            Operations
          </a>

        </nav>


      </div>

    </header>
  );
}
