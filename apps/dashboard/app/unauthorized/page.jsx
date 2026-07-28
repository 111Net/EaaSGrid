export default function Unauthorized(){

return(

<div
style={{
display:"flex",
justifyContent:"center",
alignItems:"center",
height:"100vh",
background:"#0f172a",
color:"white",
flexDirection:"column"
}}
>

<h1 className="page-title">403</h1>

<h2>Access Denied</h2>

<p>
You do not have permission to access this area.
</p>

</div>

);

}
