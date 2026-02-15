#!/bin/bash
# Validate SimpleSwap pool server is reachable
# This is Phase 0 pre-check - WARN but continue if unreachable

POOL_URL="${1:-${POOL_SERVER_URL:-https://simpleswap-pool.onrender.com}}"

echo "=== VALIDATING POOL SERVER ==="
echo ""
echo "Testing: $POOL_URL"
echo ""

# Try to fetch pool server health endpoint
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L --connect-timeout 10 --max-time 30 "$POOL_URL" 2>/dev/null)

if [ "$HTTP_STATUS" -eq 200 ]; then
  echo "PASS: Pool server returns HTTP 200"
  echo ""
  echo "SimpleSwap integration ready:"
  echo "  ✅ $POOL_URL"
  exit 0
elif [ "$HTTP_STATUS" -eq 000 ]; then
  echo "WARN: Could not connect to pool server"
  echo ""
  echo "POSSIBLE ISSUES:"
  echo "  - Pool server may be asleep (Render free tier)"
  echo "  - Network connectivity issues"
  echo ""
  echo "NOTE: Checkout may not work until pool server is running."
  echo "      You can deploy now and fix checkout later."
  echo ""
  echo "To wake up Render free tier:"
  echo "  curl $POOL_URL"
  echo "  (wait 30-60 seconds for cold start)"
  exit 0  # Exit 0 = continue with warning
elif [ "$HTTP_STATUS" -ge 500 ]; then
  echo "WARN: Pool server returns HTTP $HTTP_STATUS (server error)"
  echo ""
  echo "The pool server may be experiencing issues."
  echo "Checkout functionality may not work."
  echo ""
  echo "You can continue and fix checkout later."
  exit 0  # Exit 0 = continue with warning
else
  echo "PASS: Pool server returns HTTP $HTTP_STATUS"
  echo ""
  echo "Pool server appears to be running."
  exit 0
fi
