import Image from "next/image";

export default function Navbar() {
  return (
    <nav className="border-b bg-white sticky top-0 z-50">

      <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">

        <div className="flex items-center gap-3">

          <Image
            src="/branding/logo.svg"
            alt="EaaSGrid"
            width={160}
            height={44}
            priority
          />

        </div>


        <div className="flex gap-6 text-sm text-gray-700">

          <a href="#overview">
            Overview
          </a>

          <a href="#sites">
            Sites
          </a>

          <a href="#energy">
            Energy
          </a>

          <a href="#finance">
            Finance
          </a>

          <a href="#performance">
            Performance
          </a>

        </div>

      </div>

    </nav>
  );
}
