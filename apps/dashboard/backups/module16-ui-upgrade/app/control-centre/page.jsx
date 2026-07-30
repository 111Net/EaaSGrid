"use client";

import DashboardLayout from "@/components/layout/DashboardLayout";
import MetricCard from "@/components/dashboard/MetricCard";
import EnergyChart from "@/components/charts/EnergyChart";
import RevenueChart from "@/components/charts/RevenueChart";

export default function ControlCentre() {
  return (
    <DashboardLayout>
      <div
        style={{
          padding: "30px",
        }}
      >
        {/* Header */}
        <div
          style={{
            background:
              "linear-gradient(135deg,#071426,#123b63,#1d6fa5)",
            padding: "40px",
            borderRadius: "20px",
            color: "#ffffff",
            marginBottom: "30px",
            boxShadow: "0 10px 35px rgba(0,0,0,.35)",
          }}
        >
          <h1
            style={{
              fontSize: "42px",
              fontWeight: 800,
              color: "#ffffff",
              letterSpacing: "-0.8px",
              marginBottom: "12px",
              lineHeight: "1.15",
            }}
          >
            Executive Platform Intelligence
          </h1>

          <p
            style={{
              fontSize: "18px",
            }}
          >
            Real-time XaaSGrid Command Centre
          </p>
        </div>

        {/* Metrics */}
        <div
          style={{
            display: "grid",
            gridTemplateColumns:
              "repeat(auto-fit,minmax(250px,1fr))",
            gap: "20px",
          }}
        >
          <MetricCard
            title="Platform Status"
            value="Operational"
            subtitle="System condition"
          />

          <MetricCard
            title="Pilot Sites"
            value="6"
            subtitle="Deployment portfolio"
          />

          <MetricCard
            title="Annual Target"
            value="60"
            subtitle="Sites planned"
          />

          <MetricCard
            title="Capital Requirement"
            value="₦298,000,000"
            subtitle="Pilot funding"
          />

          <MetricCard
            title="Monthly Revenue"
            value="₦0"
            subtitle="Current revenue"
          />

          <MetricCard
            title="Availability"
            value="0%"
            subtitle="Platform uptime"
          />
        </div>

        {/* Charts */}
        <div
          style={{
            marginTop: "40px",
            display: "grid",
            gridTemplateColumns:
              "repeat(auto-fit,minmax(400px,1fr))",
            gap: "25px",
          }}
        >
          <div
            style={{
              background: "#ffffff",
              padding: "25px",
              borderRadius: "15px",
            }}
          >
            <h2>⚡ Energy Performance</h2>

            <EnergyChart />
          </div>

          <div
            style={{
              background: "#ffffff",
              padding: "25px",
              borderRadius: "15px",
            }}
          >
            <h2>💰 Revenue Intelligence</h2>

            <RevenueChart />
          </div>
        </div>

        {/* Business */}
        <div
          style={{
            marginTop: "35px",
            background: "#f5f7fb",
            padding: "30px",
            borderRadius: "15px",
          }}
        >
          <h2>Business Model</h2>

          <p>Everything-as-a-Service</p>

          <h2>Target Markets</h2>

          <ul>
            <li>Nigeria</li>
            <li>Commercial and institutional energy users</li>
          </ul>
        </div>
      </div>
    </DashboardLayout>
  );
}
