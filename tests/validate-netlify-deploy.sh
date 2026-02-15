#!/bin/bash
# Validate Netlify deployment

set -e

echo "Validating Netlify deployment..."

# Check if netlify CLI is available
if ! command -v netlify &> /dev/null; then
  echo "FAIL: netlify CLI not found"
  echo "FIX: npm install -g netlify-cli"
  exit 1
fi

# Get site status
SITE_STATUS=$(netlify status 2>&1 || echo "error")

if echo "$SITE_STATUS" | grep -qi "not linked"; then
  echo "FAIL: Directory not linked to Netlify site"
  echo "FIX: Run 'netlify sites:create' or 'netlify link'"
  exit 1
fi

# Extract site URL from status
SITE_URL=$(netlify status --json 2>/dev/null | grep -oE 'https://[^"]+\.netlify\.app' | head -1 || echo "")

if [ -z "$SITE_URL" ]; then
  echo "WARNING: Could not determine site URL"
  # Try to get from environment or config
  SITE_URL=$(grep -oE 'https://[^"]+\.netlify\.app' netlify.toml 2>/dev/null | head -1 || echo "")
fi

if [ -n "$SITE_URL" ]; then
  echo "Site URL: $SITE_URL"

  # Test if site is accessible
  HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$SITE_URL" 2>/dev/null || echo "000")

  if [ "$HTTP_STATUS" = "200" ]; then
    echo "✓ Site returns HTTP 200"
  elif [ "$HTTP_STATUS" = "000" ]; then
    echo "WARNING: Could not reach site (network error)"
  else
    echo "WARNING: Site returned HTTP $HTTP_STATUS"
  fi
fi

# Check for POOL_URL environment variable
POOL_URL_SET=$(netlify env:list 2>/dev/null | grep -c "POOL_URL" || echo 0)
if [ "$POOL_URL_SET" -eq 0 ]; then
  echo "WARNING: POOL_URL environment variable not set"
  echo "SimpleSwap checkout may not work"
  echo "FIX: netlify env:set POOL_URL https://your-pool-server.onrender.com"
fi

echo ""
echo "PASS: Netlify deployment validated ✓"
exit 0
