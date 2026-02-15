#!/bin/bash
# Validate Accessibility (a11y) - Static HTML checks
# Run this BEFORE browser tests for quick feedback

set -e

HTML_FILE="${1:-index.html}"

if [ ! -f "$HTML_FILE" ]; then
  echo "FAIL: $HTML_FILE not found"
  exit 1
fi

echo "=============================================="
echo "  ACCESSIBILITY VALIDATION"
echo "=============================================="
echo ""
echo "File: $HTML_FILE"
echo ""

ERRORS=0
WARNINGS=0

# Check 1: All images have alt attributes
echo "[1/8] Checking image alt attributes..."
IMGS_TOTAL=$(grep -c '<img' "$HTML_FILE" 2>/dev/null || echo 0)
IMGS_WITHOUT_ALT=$(grep '<img' "$HTML_FILE" | grep -cv 'alt=' 2>/dev/null || echo 0)

if [ "$IMGS_WITHOUT_ALT" -gt 0 ]; then
  echo "  ❌ FAIL: $IMGS_WITHOUT_ALT/$IMGS_TOTAL images missing alt attribute"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✅ All $IMGS_TOTAL images have alt attributes"
fi

# Check 2: Empty alt on decorative images only
EMPTY_ALTS=$(grep -c 'alt=""' "$HTML_FILE" 2>/dev/null || echo 0)
if [ "$EMPTY_ALTS" -gt 10 ]; then
  echo "  ⚠️  WARNING: $EMPTY_ALTS empty alt attributes (OK for decorative images)"
  WARNINGS=$((WARNINGS + 1))
fi

# Check 3: Form inputs have labels
echo ""
echo "[2/8] Checking form labels..."
INPUTS=$(grep -c '<input' "$HTML_FILE" 2>/dev/null || echo 0)
LABELS=$(grep -c '<label' "$HTML_FILE" 2>/dev/null || echo 0)
ARIA_LABELS=$(grep -c 'aria-label=' "$HTML_FILE" 2>/dev/null || echo 0)

if [ "$INPUTS" -gt 0 ] && [ "$LABELS" -eq 0 ] && [ "$ARIA_LABELS" -eq 0 ]; then
  echo "  ❌ FAIL: $INPUTS inputs found but no labels or aria-labels"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✅ Form inputs have labels ($LABELS labels, $ARIA_LABELS aria-labels)"
fi

# Check 4: Heading hierarchy
echo ""
echo "[3/8] Checking heading hierarchy..."
H1_COUNT=$(grep -c '<h1' "$HTML_FILE" 2>/dev/null || echo 0)
H2_COUNT=$(grep -c '<h2' "$HTML_FILE" 2>/dev/null || echo 0)
H3_COUNT=$(grep -c '<h3' "$HTML_FILE" 2>/dev/null || echo 0)

if [ "$H1_COUNT" -eq 0 ]; then
  echo "  ❌ FAIL: No <h1> found - page needs main heading"
  ERRORS=$((ERRORS + 1))
elif [ "$H1_COUNT" -gt 1 ]; then
  echo "  ⚠️  WARNING: $H1_COUNT <h1> tags found (should have exactly 1)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  ✅ Heading hierarchy: 1 h1, $H2_COUNT h2, $H3_COUNT h3"
fi

# Check 5: Language attribute
echo ""
echo "[4/8] Checking language attribute..."
if grep -q '<html.*lang=' "$HTML_FILE"; then
  LANG=$(grep -oE 'lang="[^"]+"' "$HTML_FILE" | head -1)
  echo "  ✅ Language declared: $LANG"
else
  echo "  ❌ FAIL: Missing lang attribute on <html>"
  ERRORS=$((ERRORS + 1))
fi

# Check 6: Viewport meta tag
echo ""
echo "[5/8] Checking viewport meta..."
if grep -q 'viewport' "$HTML_FILE"; then
  echo "  ✅ Viewport meta tag present"
else
  echo "  ❌ FAIL: Missing viewport meta tag"
  ERRORS=$((ERRORS + 1))
fi

# Check 7: Skip link or main landmark
echo ""
echo "[6/8] Checking landmarks..."
HAS_MAIN=$(grep -c '<main' "$HTML_FILE" 2>/dev/null || echo 0)
HAS_NAV=$(grep -c '<nav' "$HTML_FILE" 2>/dev/null || echo 0)
HAS_SKIP=$(grep -c 'skip' "$HTML_FILE" 2>/dev/null || echo 0)

if [ "$HAS_MAIN" -eq 0 ]; then
  echo "  ⚠️  WARNING: No <main> landmark (recommended)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  ✅ Main landmark present"
fi

# Check 8: Color contrast (basic check for white text on light bg)
echo ""
echo "[7/8] Checking for potential contrast issues..."
# Look for white/light colors without dark backgrounds
LIGHT_TEXT=$(grep -ciE 'color:\s*(white|#fff|#ffffff|rgb\(255)' "$HTML_FILE" 2>/dev/null || echo 0)
if [ "$LIGHT_TEXT" -gt 20 ]; then
  echo "  ⚠️  WARNING: $LIGHT_TEXT light-colored text instances (verify contrast)"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  ✅ Color usage appears reasonable"
fi

# Check 9: Link text quality
echo ""
echo "[8/8] Checking link text..."
CLICK_HERE=$(grep -ci 'click here' "$HTML_FILE" 2>/dev/null | tr -d ' \n' || echo 0)
READ_MORE=$(grep -ci '>read more<' "$HTML_FILE" 2>/dev/null | tr -d ' \n' || echo 0)
# Ensure values are numeric
CLICK_HERE=${CLICK_HERE:-0}
READ_MORE=${READ_MORE:-0}
if [ "$CLICK_HERE" -gt 0 ] || [ "$READ_MORE" -gt 2 ]; then
  echo "  ⚠️  WARNING: Found vague link text ($CLICK_HERE 'click here', $READ_MORE 'read more')"
  WARNINGS=$((WARNINGS + 1))
else
  echo "  ✅ Link text appears descriptive"
fi

# Summary
echo ""
echo "=============================================="
echo "  SUMMARY"
echo "=============================================="
echo "  Errors:   $ERRORS"
echo "  Warnings: $WARNINGS"
echo ""

if [ "$ERRORS" -gt 0 ]; then
  echo "❌ FAIL: $ERRORS accessibility errors found"
  echo ""
  echo "FIX: Address the errors above before deployment"
  exit 1
else
  if [ "$WARNINGS" -gt 3 ]; then
    echo "⚠️  PASS with warnings: $WARNINGS issues to review"
  else
    echo "✅ PASS: Accessibility validation complete"
  fi
  exit 0
fi
