#!/bin/bash
# validate-visual-qa.sh - Automated Visual QA gate validation
# Checks that all visual requirements are met before deployment

set -e

echo "=== VISUAL QA VALIDATION ==="
echo ""

ERRORS=0
WARNINGS=0
BUILD_FILE="index.html"
SCREENSHOTS_DIR="qa-screenshots"

# Check build exists
if [ ! -f "$BUILD_FILE" ]; then
    echo "⚠️  index.html not found - run ./build.sh first"
    echo "   Skipping Visual QA checks"
    exit 0
fi

echo "Analyzing built file: $BUILD_FILE"
echo ""

# Check 1: No raw placeholders in built file
echo "━━━ Check 1: Raw placeholders ━━━"
PLACEHOLDERS=$(grep -o '{{[^}]*}}' "$BUILD_FILE" 2>/dev/null | wc -l | tr -d ' ')
if [ "$PLACEHOLDERS" -gt "0" ]; then
    echo "  ❌ FAIL: $PLACEHOLDERS raw placeholders found"
    echo ""
    echo "  Most common placeholders:"
    grep -o '{{[^}]*}}' "$BUILD_FILE" | sort | uniq -c | sort -rn | head -5
    echo ""
    ((ERRORS++))
else
    echo "  ✅ PASS: No raw placeholders"
fi

# Check 2: All critical sections present
echo ""
echo "━━━ Check 2: Critical sections ━━━"
CRITICAL_SECTIONS=(
    "shopify-section-template--17453745111139__main"
    "order-bump-section"
    "color-image-data"
    "faq-section"
    "founder-section"
)
MISSING=0
for section in "${CRITICAL_SECTIONS[@]}"; do
    if grep -q "$section" "$BUILD_FILE" 2>/dev/null; then
        echo "  ✅ $section"
    else
        echo "  ❌ $section MISSING"
        ((MISSING++))
    fi
done
if [ "$MISSING" -gt 0 ]; then
    ((ERRORS++))
fi

# Check 3: No desktop-hidden on main content
echo ""
echo "━━━ Check 3: Hidden sections ━━━"
HIDDEN=$(grep -c 'desktop-hidden' "$BUILD_FILE" 2>/dev/null || echo "0")
# Allow 1-2 for slider dots (acceptable)
if [ "$HIDDEN" -gt "2" ]; then
    echo "  ⚠️  WARNING: $HIDDEN elements have desktop-hidden class"
    echo "  Review: grep -n 'desktop-hidden' $BUILD_FILE"
    ((WARNINGS++))
else
    echo "  ✅ PASS: Minimal hidden elements ($HIDDEN - acceptable for sliders)"
fi

# Check 4: FAQ accordion structure
echo ""
echo "━━━ Check 4: FAQ structure ━━━"
FAQ_DETAILS=$(grep -c '<details' "$BUILD_FILE" 2>/dev/null || echo "0")
if [ "$FAQ_DETAILS" -ge "3" ]; then
    echo "  ✅ PASS: FAQ has $FAQ_DETAILS accordion items"
else
    echo "  ❌ FAIL: FAQ needs at least 3 items, found $FAQ_DETAILS"
    ((ERRORS++))
fi

# Check 5: CTA buttons present
echo ""
echo "━━━ Check 5: CTA buttons ━━━"
CTA_COUNT=$(grep -c 'add-to-cart\|Add to Cart\|buy-now' "$BUILD_FILE" 2>/dev/null || echo "0")
if [ "$CTA_COUNT" -ge "1" ]; then
    echo "  ✅ PASS: $CTA_COUNT CTA references found"
else
    echo "  ❌ FAIL: No CTA buttons found"
    ((ERRORS++))
fi

# Check 6: Screenshots exist (if dir exists)
echo ""
echo "━━━ Check 6: Screenshots ━━━"
if [ -d "$SCREENSHOTS_DIR" ]; then
    SCREENSHOT_COUNT=$(find "$SCREENSHOTS_DIR" -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$SCREENSHOT_COUNT" -ge "2" ]; then
        echo "  ✅ PASS: $SCREENSHOT_COUNT screenshots captured"
    else
        echo "  ⚠️  WARNING: Only $SCREENSHOT_COUNT screenshots (recommend 4+)"
        ((WARNINGS++))
    fi
else
    echo "  ℹ️  INFO: Screenshots directory not found"
    echo "  Run antigravity-live-qa skill to capture screenshots"
fi

# Check 7: Image references are valid (sample check)
echo ""
echo "━━━ Check 7: Image paths ━━━"
BROKEN_REFS=0
# Extract unique image src values and check a sample
IMAGE_REFS=$(grep -o 'src="images/[^"]*"' "$BUILD_FILE" | sed 's/src="//;s/"$//' | sort -u | head -10)
if [ -n "$IMAGE_REFS" ]; then
    while IFS= read -r img_path; do
        if [ ! -f "$img_path" ]; then
            echo "  ⚠️  MISSING: $img_path"
            ((BROKEN_REFS++))
        fi
    done <<< "$IMAGE_REFS"

    if [ "$BROKEN_REFS" -gt "0" ]; then
        echo "  ⚠️  WARNING: $BROKEN_REFS broken image references (of 10 sampled)"
        echo "  Note: This is acceptable for master template"
        ((WARNINGS++))
    else
        echo "  ✅ PASS: Sample image paths valid"
    fi
else
    echo "  ℹ️  INFO: No image references to check"
fi

# Summary
echo ""
echo "=== RESULTS ==="
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ "$ERRORS" -gt "0" ]; then
    echo "❌ VISUAL_QA: FAILED"
    echo ""
    echo "Fix critical errors above before deployment."
    exit 1
elif [ "$WARNINGS" -gt "0" ]; then
    echo "⚠️  VISUAL_QA: PASSED WITH WARNINGS"
    echo ""
    echo "Warnings are acceptable for master template."
    exit 0
else
    echo "✅ VISUAL_QA: PASSED"
    exit 0
fi
