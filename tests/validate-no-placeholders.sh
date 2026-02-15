#!/bin/bash
# Validate no unreplaced {{VARIABLES}} remain in index.html

set -e

if [ ! -f "index.html" ]; then
  echo "FAIL: index.html not found"
  exit 1
fi

echo "Checking for unreplaced variables in index.html..."

# Count remaining {{VARIABLE}} patterns
PLACEHOLDER_COUNT=$(grep -oE '\{\{[A-Z_]+\}\}' index.html 2>/dev/null | wc -l)

if [ "$PLACEHOLDER_COUNT" -gt 0 ]; then
  echo "FAIL: $PLACEHOLDER_COUNT unreplaced variables found in index.html"
  echo ""
  echo "Variables that need replacement:"
  grep -oE '\{\{[A-Z_]+\}\}' index.html | sort | uniq -c | sort -rn | head -20
  echo ""
  echo "FIX: Run node replace.js to substitute variables from product.config"
  echo "Or check that product.config has values for all these variables"
  exit 1
fi

echo "✓ No {{VARIABLE}} placeholders remain"

# Also check for common placeholder patterns that might have been missed
if grep -qE '\[PLACEHOLDER\]|\[TODO\]|\[INSERT\]' index.html; then
  echo "FAIL: Found [PLACEHOLDER], [TODO], or [INSERT] tags"
  echo "FIX: Replace these with actual content"
  exit 1
fi

echo ""
echo "PASS: No placeholders remain ✓"
exit 0
