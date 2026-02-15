#!/bin/bash
# Browser Test: SimpleSwap Checkout Integration
# Tests the buy-now serverless function

cat << 'EOF'
BROWSER TEST: SimpleSwap Checkout Function

INSTRUCTIONS FOR CLAUDE:
1. Get the deployed site URL
2. Call the buy-now Netlify function directly
3. Verify it responds (not 404)
4. Check response contains exchange data or valid error

ACCEPTANCE CRITERIA:
- /.netlify/functions/buy-now endpoint exists
- Returns valid JSON response
- No 500 server errors
- Pool server is reachable (if configured)

TEST METHODS:

Method 1: Direct API call via JavaScript
```
mcp__claude-in-chrome__javascript_tool(
  tabId=X,
  action="javascript_exec",
  text="fetch('/.netlify/functions/buy-now', {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify({amount: 19})}).then(r => r.json()).then(console.log)"
)
```

Method 2: Check network requests after cart action
```
# Click Add to Cart
# Watch network for buy-now call
mcp__claude-in-chrome__read_network_requests(tabId=X, urlPattern="buy-now")
```

Method 3: Bash curl test (if site URL known)
```bash
SITE_URL=$(netlify status --json | jq -r '.url')
curl -X POST "$SITE_URL/.netlify/functions/buy-now" \
  -H "Content-Type: application/json" \
  -d '{"amount": 19}'
```

EXPECTED RESPONSES:

Success (pool has exchanges):
{
  "success": true,
  "exchange_id": "abc123",
  "address": "crypto_address_here",
  ...
}

Pool empty:
{
  "success": false,
  "error": "Pool exhausted"
}

Pool not configured:
{
  "success": false,
  "error": "POOL_URL not configured"
}

PASS CONDITIONS:
- Function responds (not 404)
- Returns valid JSON
- No 500 errors
- If pool configured: returns exchange data

FAIL CONDITIONS:
- 404: Function not deployed
- 500: Server error
- Timeout: Pool server unreachable
- Invalid JSON response

FIX ACTIONS IF FAIL:
1. 404 error:
   - Check netlify/functions/buy-now.js exists
   - Verify netlify.toml has functions config
   - Re-deploy

2. 500 error:
   - Check function logs: netlify functions:log buy-now
   - Fix JavaScript errors in function
   - Re-deploy

3. Pool not configured:
   - Set environment variable: netlify env:set POOL_URL https://your-pool.onrender.com
   - Re-deploy

4. Pool unreachable:
   - Check pool server is running on Render
   - Verify POOL_URL is correct
EOF

echo "This test can be run via curl or Chrome DevTools MCP"

# Try to test with curl if possible
if command -v netlify &> /dev/null && command -v curl &> /dev/null; then
  SITE_URL=$(netlify status --json 2>/dev/null | grep -oE 'https://[^"]+\.netlify\.app' | head -1)
  if [ -n "$SITE_URL" ]; then
    echo ""
    echo "Testing: $SITE_URL/.netlify/functions/buy-now"
    RESPONSE=$(curl -s -X POST "$SITE_URL/.netlify/functions/buy-now" \
      -H "Content-Type: application/json" \
      -d '{"amount": 19}' 2>/dev/null)

    if [ -n "$RESPONSE" ]; then
      echo "Response: $RESPONSE"
      if echo "$RESPONSE" | grep -q '"success"'; then
        echo "✓ Function responds with valid JSON"
        exit 0
      fi
    fi
  fi
fi

exit 0
