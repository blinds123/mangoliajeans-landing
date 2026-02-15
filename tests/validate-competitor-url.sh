#!/bin/bash
# Validate competitor URL is accessible
# This is Phase 0 pre-check - FAIL FAST if URL inaccessible

COMPETITOR_URL="${1:-$COMPETITOR_URL}"

echo "=== VALIDATING COMPETITOR URL ==="
echo ""

if [ -z "$COMPETITOR_URL" ]; then
  echo "FAIL: No competitor URL provided"
  echo ""
  echo "USAGE: bash tests/validate-competitor-url.sh <URL>"
  echo ""
  echo "OR set COMPETITOR_URL environment variable:"
  echo "  export COMPETITOR_URL=https://example.com/product"
  echo "  bash tests/validate-competitor-url.sh"
  exit 0
fi

echo "Testing: $COMPETITOR_URL"
echo ""

# Check URL format
if [[ ! "$COMPETITOR_URL" =~ ^https?:// ]]; then
  echo "FAIL: Invalid URL format (must start with http:// or https://)"
  echo ""
  echo "FIX: Provide a complete URL like:"
  echo "  https://example.com/products/product-name"
  exit 1
fi

# Try to fetch URL (HEAD request for speed)
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L --connect-timeout 10 --max-time 30 "$COMPETITOR_URL" 2>/dev/null)

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "PASS: URL returns HTTP 200"
  echo ""
  echo "Competitor URL validated:"
  echo "  ✅ $COMPETITOR_URL"
  echo ""
  echo "Ready for Chrome DevTools MCP analysis in Phase 1."
  exit 0
elif [ "$HTTP_STATUS" -eq 000 ]; then
  echo "FAIL: Could not connect to URL (timeout or DNS failure)"
  echo ""
  echo "POSSIBLE ISSUES:"
  echo "  - URL may be incorrect"
  echo "  - Site may be down"
  echo "  - Network connectivity issues"
  echo ""
  echo "FIX: Verify the URL works in a browser, then try again."
  exit 1
elif [ "$HTTP_STATUS" -ge 400 ] && [ "$HTTP_STATUS" -lt 500 ]; then
  echo "FAIL: URL returns HTTP $HTTP_STATUS (client error)"
  echo ""
  echo "POSSIBLE ISSUES:"
  echo "  - 401/403: Site requires authentication"
  echo "  - 404: Page not found"
  echo ""
  echo "FIX: Provide a working product page URL."
  exit 1
elif [ "$HTTP_STATUS" -ge 500 ]; then
  echo "WARN: URL returns HTTP $HTTP_STATUS (server error)"
  echo ""
  echo "The competitor site may be temporarily down."
  echo "Try again in a few minutes."
  exit 1
else
  echo "PASS: URL returns HTTP $HTTP_STATUS (may work)"
  echo ""
  echo "Note: Non-200 responses may still be usable."
  echo "Chrome DevTools MCP will attempt to load the page."
  exit 0
fi
