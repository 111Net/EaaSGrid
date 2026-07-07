export default function DashboardHome() {
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">
        EAASGrid Dashboard
      </h1>

      <p className="text-gray-400 mt-2">
        System operations, monitoring, and control panel
      </p>

      <div className="grid grid-cols-3 gap-4 mt-6">
        <div className="bg-gray-900 p-4 rounded-xl">
          Energy Nodes
        </div>

        <div className="bg-gray-900 p-4 rounded-xl">
          Live Consumption
        </div>

        <div className="bg-gray-900 p-4 rounded-xl">
          Billing Engine
        </div>
      </div>
    </div>
  );
}
