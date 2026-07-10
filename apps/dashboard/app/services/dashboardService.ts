import { metrics, pilotSites } from "../data/dashboard";


export async function getDashboardMetrics() {
  return metrics;
}


export async function getPilotSites() {
  return pilotSites;
}
