export default function Navbar() {
  return (
    <header className="sticky top-0 z-50 border-b bg-white/90 backdrop-blur">

      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">

        <div>
          <h1 className="text-xl font-bold text-gray-900">
            EaaSGrid Dashboard
          </h1>

          <p className="text-xs text-gray-500">
            Energy-as-a-Service Infrastructure Platform
          </p>
        </div>


        <nav className="hidden md:flex gap-6 text-sm text-gray-700">

          <a
            href="#overview"
            className="hover:text-black"
          >
            Overview
          </a>


          <a
            href="#sites"
            className="hover:text-black"
          >
            Deployments
          </a>


          <a
            href="#energy"
            className="hover:text-black"
          >
            Energy
          </a>


          <a
            href="#finance"
            className="hover:text-black"
          >
            Finance
          </a>


          <a
            href="#performance"
            className="hover:text-black"
          >
            Operations
          </a>

        </nav>


      </div>

    </header>
  );
}
