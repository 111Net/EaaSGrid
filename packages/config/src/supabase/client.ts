export const supabaseConfig = {
  url: process.env.SUPABASE_URL || "",
  anonKey: process.env.SUPABASE_ANON_KEY || "",
  serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY || "",
};

export function validateSupabaseConfig() {
  if (!supabaseConfig.url) {
    throw new Error("Missing SUPABASE_URL");
  }

  if (!supabaseConfig.anonKey) {
    throw new Error("Missing SUPABASE_ANON_KEY");
  }

  return true;
}
