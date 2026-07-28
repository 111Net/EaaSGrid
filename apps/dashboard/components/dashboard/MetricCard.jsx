"use client";

export default function MetricCard({
  title,
  value,
  subtitle,
  description
}) {

  return (

    <div
      style={{
        background:
          "linear-gradient(145deg,rgba(255,255,255,.18),rgba(255,255,255,.05))",

        border:
          "1px solid rgba(255,255,255,.25)",

        color:"#ffffff",

        padding:"25px",

        borderRadius:"22px",

        minHeight:"150px",

        boxShadow:
          "0 20px 50px rgba(0,0,0,.35)",

        backdropFilter:
          "blur(15px)",

        transition:
          "transform .25s ease, box-shadow .25s ease",

        cursor:"default"
      }}

      onMouseEnter={(e)=>{
        e.currentTarget.style.transform="translateY(-6px)";
        e.currentTarget.style.boxShadow=
          "0 25px 60px rgba(0,212,255,.35)";
      }}

      onMouseLeave={(e)=>{
        e.currentTarget.style.transform="translateY(0)";
        e.currentTarget.style.boxShadow=
          "0 20px 50px rgba(0,0,0,.35)";
      }}

    >

      <h3
        style={{
          fontSize:"16px",
          opacity:.85,
          marginBottom:"15px"
        }}
      >
        {title}
      </h3>


      <h1
        style={{
          fontSize:"38px",
          fontWeight:800,
          margin:"0",
          background:
            "linear-gradient(90deg,#00d4ff,#8b5cf6)",
          WebkitBackgroundClip:"text",
          color:"transparent"
        }}
      >
        {value}
      </h1>


      <p
        style={{
          marginTop:"12px",
          opacity:.75
        }}
      >
        {subtitle || description}
      </p>


    </div>

  );
}
