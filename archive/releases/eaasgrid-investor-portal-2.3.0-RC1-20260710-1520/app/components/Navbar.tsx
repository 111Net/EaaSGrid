export default function Navbar() {
  return (
    <nav className="w-full border-b bg-white sticky top-0 z-50">

      <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">

        <a
          href="#"
          className="text-xl font-bold text-green-700"
        >
          EaaSGrid
        </a>


        <div className="flex gap-6 text-sm text-gray-700">

          <a href="#solution">
            Solution
          </a>


          <a href="#business">
            Business Model
          </a>


          <a href="#financials">
            Financials
          </a>


          <a href="#roadmap">
            Roadmap
          </a>


          <a href="#contact">
            Contact
          </a>

        </div>

      </div>

    </nav>
  );
}
