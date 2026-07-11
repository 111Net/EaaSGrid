export default function Footer() {
  return (
    <footer className="border-t bg-white">

      <div className="mx-auto max-w-7xl px-6 py-8">

        <div className="grid gap-6 md:grid-cols-3">


          <div>

            <h3 className="text-lg font-bold text-gray-900">
              EaaSGrid Platform Ltd
            </h3>

            <p className="mt-2 text-sm text-gray-600">
              Building distributed renewable energy infrastructure
              through Energy-as-a-Service.
            </p>

          </div>



          <div>

            <h4 className="text-sm font-semibold text-gray-900">
              Platform
            </h4>

            <ul className="mt-3 space-y-2 text-sm text-gray-600">

              <li>
                Investor Dashboard
              </li>

              <li>
                Renewable Energy Assets
              </li>

              <li>
                Digital Energy Management
              </li>

            </ul>

          </div>



          <div>

            <h4 className="text-sm font-semibold text-gray-900">
              Deployment Focus
            </h4>

            <ul className="mt-3 space-y-2 text-sm text-gray-600">

              <li>
                Commercial SMEs
              </li>

              <li>
                Education & Healthcare
              </li>

              <li>
                Industrial Energy Users
              </li>

            </ul>

          </div>


        </div>



        <div className="mt-8 border-t pt-6 text-sm text-gray-500">

          © {new Date().getFullYear()} EaaSGrid Platform Ltd.
          All rights reserved.

        </div>


      </div>


    </footer>
  );
}
