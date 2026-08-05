export default function ModuleCard({
module
}){


return (

<div>

<h3>
{module.name}
</h3>

<p>
{module.description}
</p>

<a href={module.route}>
Open Module →
</a>

</div>

);

}
