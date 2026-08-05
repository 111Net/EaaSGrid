import Link from "next/link";

export default function Home(){

return (

<div style={{
padding:"50px",
fontFamily:"Arial"
}}>

<h1>
XaaSGrid Enterprise Platform
</h1>

<p>
Everything-as-a-Service Operating System
</p>


<Link href="/dashboard">
Open Enterprise Dashboard →
</Link>


</div>

)

}
