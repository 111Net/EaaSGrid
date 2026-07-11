interface EnergyProps {

  energy: {

    monthly_generation: number;

    battery_utilisation: number;

    connected_assets: number;

  };

}


export default function Energy({
  energy,
}: EnergyProps) {


return (

<section
id="energy"
className="mx-auto max-w-7xl px-6 py-16"
>


<h2 className="text-3xl font-bold text-gray-900">
Energy Performance
</h2>


<p className="mt-4 text-gray-600">
Renewable generation, storage utilisation and connected energy assets.
</p>



<div className="mt-8 grid gap-6 md:grid-cols-3">


<div className="rounded-xl border bg-white p-6 shadow-sm">

<h3 className="text-sm text-gray-500">
Solar Generation
</h3>

<p className="mt-3 text-3xl font-bold">

{energy.monthly_generation} MWh

</p>

<p className="mt-2 text-sm text-gray-600">
Monthly renewable generation
</p>

</div>



<div className="rounded-xl border bg-white p-6 shadow-sm">

<h3 className="text-sm text-gray-500">
Battery Utilisation
</h3>

<p className="mt-3 text-3xl font-bold">

{energy.battery_utilisation}%

</p>


<p className="mt-2 text-sm text-gray-600">
Average storage utilisation
</p>

</div>




<div className="rounded-xl border bg-white p-6 shadow-sm">

<h3 className="text-sm text-gray-500">
Connected Assets
</h3>


<p className="mt-3 text-3xl font-bold">

{energy.connected_assets}

</p>


<p className="mt-2 text-sm text-gray-600">
Sites monitored by platform
</p>


</div>


</div>


</section>

);

}
