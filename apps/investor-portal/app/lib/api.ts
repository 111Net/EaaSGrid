const API_URL = process.env.NEXT_PUBLIC_API_URL;


export async function getInvestorProfile() {

  if (!API_URL) {
    throw new Error(
      "NEXT_PUBLIC_API_URL is not configured"
    );
  }


  const response = await fetch(
    `${API_URL}/investor`,
    {
      cache: "no-store",
    }
  );


  if (!response.ok) {

    throw new Error(
      `Investor API failed: ${response.status}`
    );

  }


  return response.json();

}
