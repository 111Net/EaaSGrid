export default function Footer() {

  return (

    <footer className="border-t bg-gray-50">


      <div className="mx-auto max-w-7xl px-6 py-8">


        <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">


          <p className="text-sm text-gray-600">

            © {new Date().getFullYear()} EaaSGrid Platform Ltd.
            All rights reserved.

          </p>


          <p className="text-sm text-gray-500">

            Energy-as-a-Service Infrastructure Platform

          </p>


        </div>


      </div>


    </footer>

  );

}
