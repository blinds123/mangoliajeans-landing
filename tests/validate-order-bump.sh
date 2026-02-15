#!/bin/bash
# Validate order bump is pre-checked in pricing section

set -e

SECTION_FILE="sections/08-pricing.html"

if [ ! -f "$SECTION_FILE" ]; then
  echo "FAIL: Pricing section not found: $SECTION_FILE"
  exit 1
fi

echo "Validating order bump configuration..."

# Check for order bump checkbox
if ! grep -qiE 'checkbox|type="checkbox"|type=.checkbox' "$SECTION_FILE"; then
  echo "FAIL: No checkbox found for order bump"
  echo "FIX: Add order bump checkbox input element"
  exit 1
fi
echo "✓ Order bump checkbox present"

# Check that checkbox is pre-checked
if ! grep -qiE 'checked="checked"|checked=.checked.|checked>' "$SECTION_FILE"; then
  echo "FAIL: Order bump checkbox is NOT pre-checked"
  echo "FIX: Add checked=\"checked\" attribute to checkbox"
  echo "Example: <input type=\"checkbox\" checked=\"checked\">"
  exit 1
fi
echo "✓ Order bump is pre-checked"

# Check for ORDER_BUMP_PRICE variable
if ! grep -q '{{ORDER_BUMP_PRICE}}' "$SECTION_FILE"; then
  echo "WARNING: Missing {{ORDER_BUMP_PRICE}} variable"
  echo "Order bump price should use variable from product.config"
fi

echo ""
echo "PASS: Order bump validated ✓"
exit 0
