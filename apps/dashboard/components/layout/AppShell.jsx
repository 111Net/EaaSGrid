import Sidebar from "./Sidebar";
import Header from "./Header";


export default function AppShell({children}){

return (

<div className="app-shell">

<Sidebar/>


<div className="workspace">

<Header/>


<main className="content">

{children}

</main>


</div>


</div>

)

}
