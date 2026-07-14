export default function Navbar() {

  return (

    <header className="sticky top-0 z-50 border-b bg-white/95 backdrop-blur">

      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">


        <a
          href="/"
          className="flex flex-col"
        >

          <span className="text-xl font-bold tracking-tight text-gray-900">
            EaaSGrid Ltd
          </span>

          <span className="text-xs text-gray-500">
            Energy-as-a-Service Infrastructure Platform
          </span>

        </a>



        <nav className="hidden gap-6 text-sm font-medium text-gray-600 md:flex">


          <a href="#investment" className="hover:text-green-700">
            Investment
          </a>


          <a href="#financials" className="hover:text-green-700">
            Financials
          </a>


          <a href="#roadmap" className="hover:text-green-700">
            Roadmap
          </a>


          <a href="#contact" className="hover:text-green-700">
            Contact
          </a>


          <a
            href={process.env.NEXT_PUBLIC_DASHBOARD_URL}
            target="_blank"
            className="hover:text-green-700"
          >
            Dashboard
          </a>


        </nav>



        <a
          href="#investment"
          className="rounded-lg bg-green-700 px-5 py-2 text-sm font-semibold text-white hover:bg-green-800"
        >
          Invest With Us
        </a>


      </div>

    </header>

  );

}
