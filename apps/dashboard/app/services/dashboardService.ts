const API_URL = process.env.NEXT_PUBLIC_API_URL;

if (!API_URL) {
  throw new Error("NEXT_PUBLIC_API_URL is not configured");
}


export interface DashboardSite {

  id: number;

  site_code: string;

  site_name: string;

  status: string;

  device_type: string;

  manufacturer: string;

  connectivity: string;

}


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

    sites: DashboardSite[];

    business_model: string;

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

      `Failed to fetch dashboard data: ${response.status}`

    );

  }


  return response.json();

}
