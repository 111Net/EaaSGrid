"use client";

import { useState } from "react";

export default function Navbar() {

  const [open, setOpen] = useState(false);


  const links = [
    {
      name: "Overview",
      href: "#overview",
    },
    {
      name: "Deployments",
      href: "#sites",
    },
    {
      name: "Energy",
      href: "#energy",
    },
    {
      name: "Finance",
      href: "#finance",
    },
    {
      name: "Operations",
      href: "#performance",
    },
  ];


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

          {links.map((link)=>(

            <a
              key={link.href}
              href={link.href}
              className="hover:text-green-700"
            >
              {link.name}
            </a>

          ))}

        </nav>



        <button

          className="md:hidden rounded border px-3 py-2 text-sm"

          onClick={()=>setOpen(!open)}

        >

          Menu

        </button>


      </div>



      {open && (

        <div className="md:hidden border-t bg-white px-6 py-4">

          <nav className="flex flex-col gap-4 text-sm font-medium text-gray-600">

            {links.map((link)=>(

              <a

                key={link.href}

                href={link.href}

                onClick={()=>setOpen(false)}

                className="hover:text-green-700"

              >

                {link.name}

              </a>

            ))}

          </nav>

        </div>

      )}


    </header>

  );
}
