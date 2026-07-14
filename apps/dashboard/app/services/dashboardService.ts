const API_URL =
  process.env.NEXT_PUBLIC_API_URL ||
  "http://192.168.100.21:4000/api/v1";


export interface DashboardResponse {

  success: boolean;

  message: string;

  data: {

    platform: {
      name: string;
      version: string;
      environment: string;
      server_time: string;
    };

    company: {
      name: string;
      headquarters: string;
      project: string;
    };

    dashboard: {
      status: string;
      last_updated: string;
    };

    infrastructure: {
      pilot_sites: number;
      planned_sites_per_year: number;
      active_sites: number;
      monitored_sites: number;
    };

    investment: {
      required_capital_ngn: number;
      currency: string;
      funding_stage: string;
    };

    energy: {
      monthly_generation: number;
      battery_utilisation: number;
      connected_assets: number;
    };

    finance: {
      monthly_revenue: number;
      portfolio_value: number;
    };

    performance: {
      availability: number;
      maintenance_alerts: number;
    };

    sites: {

      id: string;
      site_name: string;
      customer_type: string;
      system_size_kw: number;
      battery_capacity_kwh: number;
      status: string;
      location: string;
      created_at: string;

    }[];

    business_model: string[];

    target_markets: string[];

  };

}


export async function getDashboardData(): Promise<DashboardResponse> {

  const response = await fetch(
    `${API_URL}/dashboard`,
    {
      cache: "no-store"
    }
  );


  if (!response.ok) {

    throw new Error(
      "Failed to fetch dashboard data"
    );

  }


  return response.json();

}
