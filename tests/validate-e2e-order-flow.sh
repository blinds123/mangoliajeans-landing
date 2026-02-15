#!/bin/bash
# Validate E2E Order Flow - Checks the complete purchase path
# This is documentation for Antigravity browser automation

set -e

SITE_URL="${1:-}"

if [ -z "$SITE_URL" ]; then
  # Try to get from netlify
  SITE_URL=$(netlify status --json 2>/dev/null | grep -oE 'https://[^"]+\.netlify\.app' | head -1 || echo "")
fi

echo "=============================================="
echo "  E2E ORDER FLOW VALIDATION"
echo "=============================================="
echo ""

if [ -z "$SITE_URL" ]; then
  echo "No site URL provided. Running static HTML checks only."
  echo ""

  # Static checks on index.html
  if [ ! -f "index.html" ]; then
    echo "FAIL: index.html not found"
    exit 1
  fi

  ERRORS=0

  # Check 1: CTA buttons exist
  echo "[1/5] Checking CTA buttons..."
  CTA_COUNT=$(grep -ciE 'add to cart|buy now|get yours|order now' index.html 2>/dev/null || echo 0)
  if [ "$CTA_COUNT" -lt 2 ]; then
    echo "  ❌ FAIL: Only $CTA_COUNT CTAs found (need 2+)"
    ERRORS=$((ERRORS + 1))
  else
    echo "  ✅ Found $CTA_COUNT CTA buttons"
  fi

  # Check 2: Order bump checkbox exists and is pre-checked
  echo ""
  echo "[2/5] Checking order bump..."
  if grep -qiE 'type="checkbox".*checked|type=.checkbox.*checked' index.html; then
    echo "  ✅ Order bump checkbox is pre-checked"
  elif grep -qiE 'type="checkbox"|type=.checkbox' index.html; then
    echo "  ⚠️  WARNING: Checkbox found but may not be pre-checked"
  else
    echo "  ⚠️  WARNING: No checkbox found for order bump"
  fi

  # Check 3: SimpleSwap integration
  echo ""
  echo "[3/5] Checking SimpleSwap integration..."
  if grep -q 'simpleswap' index.html 2>/dev/null || grep -q 'buy-now' index.html 2>/dev/null; then
    echo "  ✅ SimpleSwap/buy-now integration detected"
  else
    echo "  ⚠️  WARNING: No checkout integration found in HTML"
  fi

  # Check 4: Price variables
  echo ""
  echo "[4/5] Checking price display..."
  if grep -q '\$' index.html; then
    echo "  ✅ Prices displayed on page"
  else
    echo "  ⚠️  WARNING: No prices visible ($ symbol not found)"
  fi

  # Check 5: Form action/submission
  echo ""
  echo "[5/5] Checking form submission..."
  FORM_COUNT=$(grep -c '<form' index.html 2>/dev/null || echo 0)
  if [ "$FORM_COUNT" -gt 0 ]; then
    echo "  ✅ $FORM_COUNT form(s) found"
  else
    echo "  ℹ️  No traditional forms (may use JavaScript checkout)"
  fi

  echo ""
  if [ "$ERRORS" -gt 0 ]; then
    echo "❌ FAIL: $ERRORS issues found"
    exit 1
  else
    echo "✅ PASS: Static E2E checks complete"
    echo ""
    echo "For full E2E test, run browser automation with:"
    echo "  bash tests/validate-e2e-order-flow.sh https://your-site.netlify.app"
    exit 0
  fi
fi

# Browser-based E2E test instructions
cat << EOF

E2E ORDER FLOW TEST - BROWSER AUTOMATION
========================================

Site: $SITE_URL

INSTRUCTIONS FOR ANTIGRAVITY:

## STEP 1: Setup
mcp__chrome-devtools__new_page(url="$SITE_URL")
mcp__chrome-devtools__wait_for(text="Add to Cart", timeout=10000)

## STEP 2: Find CTA Button
mcp__chrome-devtools__take_snapshot()
# Locate the primary CTA button (Add to Cart / Buy Now / Get Yours)

## STEP 3: Verify Order Bump Pre-checked
mcp__chrome-devtools__evaluate_script(function="() => {
  const checkbox = document.querySelector('input[type=checkbox]');
  return checkbox ? { checked: checkbox.checked, exists: true } : { exists: false };
}")
EXPECTED: { checked: true, exists: true }

## STEP 4: Click CTA
mcp__chrome-devtools__click(uid="[cta-button-uid]")
mcp__chrome-devtools__wait_for(text="Checkout", timeout=5000)

## STEP 5: Verify Checkout Initiated
Options:
A) SimpleSwap popup appears
B) Cart modal opens
C) Redirect to checkout page

mcp__chrome-devtools__take_screenshot(filePath="e2e-checkout.png")

## STEP 6: Check Network for API Call
mcp__chrome-devtools__list_network_requests(resourceTypes=["fetch", "xhr"])
# Look for buy-now or checkout API call

## STEP 7: Verify No Errors
mcp__chrome-devtools__list_console_messages(types=["error"])
# Should be empty or minimal

## PASS CRITERIA
- [ ] CTA button clickable
- [ ] Order bump pre-checked
- [ ] Checkout flow initiates
- [ ] No JavaScript errors
- [ ] API call succeeds (or mock response OK)

## FAIL CRITERIA
- CTA does nothing
- JavaScript error blocks flow
- Checkout API fails
- Order bump not checked by default

## OUTPUT
Create e2e_order_flow_report.md with:
- Screenshot of checkout initiation
- Pass/fail status
- Any errors encountered
- E2E_ORDER_FLOW: PASSED/FAILED

EOF

echo ""
echo "Execute the above steps via Antigravity browser automation"
exit 0
