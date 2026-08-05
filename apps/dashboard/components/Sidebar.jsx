"use client";

import { MODULES } from "../lib/moduleRegistry";

export default function Sidebar({ role }) {

  const modules = MODULES[role] || [];

  return (

    <div
      style={{
        width: "280px",
        padding: "20px",
        borderRight: "1px solid #ddd"
      }}
    >

      <h2>XaaSGrid</h2>

      {modules.map((module) => (

        <p key={module.href}>

          <a href={module.href}>
            {module.title}
          </a>

        </p>

      ))}

    </div>

  );

}
