const POOL_SERVER = "https://simpleswap-automation-1.onrender.com";
exports.handler = async (event) => {
  // CORS Headers
  const headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type",
    "Content-Type": "application/json"
  };
  if (event.httpMethod === "OPTIONS") return { statusCode: 200, headers, body: "" };
  if (event.httpMethod !== "POST") return { statusCode: 405, headers, body: JSON.stringify({ error: "Method not allowed" }) };
  try {
    const { amountUSD } = JSON.parse(event.body || "{}");
    if (!amountUSD) return { statusCode: 400, headers, body: JSON.stringify({ error: "Missing amountUSD" }) };
    // Smart Mapping: Map any custom price to the nearest valid pool tier
    const authorizedTiers = [19, 29, 59, 99];
    const targetTier = authorizedTiers.reduce((prev, curr) =>
      Math.abs(curr - amountUSD) < Math.abs(prev - amountUSD) ? curr : prev
    );
    console.log(`[buy-now] Mapping $${amountUSD} -> Tier $${targetTier}`);
    // Call Live Pool Server
    const response = await fetch(`${POOL_SERVER}/buy-now`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ amountUSD: targetTier }),
    });
    const data = await response.json();

    if (data.exchangeUrl) {
      return { statusCode: 200, headers, body: JSON.stringify(data) };
    } else {
      throw new Error("No exchange API returned");
    }
  } catch (error) {
    console.error("[buy-now] Error:", error);
    return { statusCode: 500, headers, body: JSON.stringify({ error: error.message }) };
  }
};
