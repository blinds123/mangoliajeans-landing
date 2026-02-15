#!/bin/bash
# validate-interactive.sh - Smoke test interactive elements
# BLOCKING: Build cannot pass if interactive elements are broken
# Tests: FAQ accordion, image carousel, color swatches

set -e

echo "=== INTERACTIVE ELEMENT SMOKE TESTS ==="
echo ""

HTML_FILE="${1:-index.html}"

if [ ! -f "$HTML_FILE" ]; then
    echo "FAIL: HTML file not found: $HTML_FILE"
    exit 1
fi

ERRORS=0

# ============================================
# TEST 1: FAQ Accordion Structure
# ============================================
echo "--- FAQ Accordion Check ---"

# Check for <details> elements (native accordion)
DETAILS_COUNT=$(grep -c '<details' "$HTML_FILE" 2>/dev/null || echo "0")
SUMMARY_COUNT=$(grep -c '<summary' "$HTML_FILE" 2>/dev/null || echo "0")

if [ "$DETAILS_COUNT" -eq 0 ]; then
    echo "WARNING: No <details> elements found - FAQ accordion may not work"
    echo "   Expected: <details><summary>Question</summary>Answer</details>"
else
    echo "   Found $DETAILS_COUNT <details> elements"
    if [ "$SUMMARY_COUNT" -ne "$DETAILS_COUNT" ]; then
        echo "   WARNING: Mismatch - $SUMMARY_COUNT <summary> vs $DETAILS_COUNT <details>"
    fi
fi

# Check for pointer-events that might break clicks
POINTER_DISABLED=$(grep -c 'pointer-events:\s*none' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$POINTER_DISABLED" -gt 0 ]; then
    echo "   WARNING: pointer-events:none found ($POINTER_DISABLED instances)"
    echo "   This may prevent clicks on interactive elements"
fi
echo ""

# ============================================
# TEST 2: Image Carousel Structure
# ============================================
echo "--- Image Carousel Check ---"

# Check for product images
PRODUCT_IMAGES=$(grep -c 'product-0[1-9]' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$PRODUCT_IMAGES" -lt 3 ]; then
    echo "   ERROR: Only $PRODUCT_IMAGES product images found (need at least 3)"
    ((ERRORS++))
else
    echo "   Found $PRODUCT_IMAGES product image references"
fi

# Check for carousel navigation elements
CAROUSEL_NAV=$(grep -c 'carousel\|slider\|swiper\|glide' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$CAROUSEL_NAV" -eq 0 ]; then
    echo "   WARNING: No carousel library markers found"
else
    echo "   Carousel library markers found"
fi

# Check for aria-label on carousel buttons (accessibility)
ARIA_CAROUSEL=$(grep -c 'aria-label.*\(previous\|next\|slide\)' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$ARIA_CAROUSEL" -eq 0 ]; then
    echo "   INFO: No carousel aria-labels found (optional)"
fi
echo ""

# ============================================
# TEST 3: Color Swatch Functionality
# ============================================
echo "--- Color Swatch Check ---"

# Check for COLOR_IMAGE_MAP data attribute
if grep -q 'data-map=' "$HTML_FILE" 2>/dev/null; then
    echo "   Found data-map attribute for color swatches"

    # Verify it's not a raw placeholder
    if grep -q 'data-map="{{COLOR_IMAGE_MAP}}"' "$HTML_FILE" 2>/dev/null; then
        echo "   ERROR: COLOR_IMAGE_MAP placeholder not replaced!"
        ((ERRORS++))
    fi

    # Check for valid JSON structure
    DATA_MAP=$(grep -o 'data-map='\''[^'\'']*'\''' "$HTML_FILE" 2>/dev/null | head -1 || echo "")
    if [ -n "$DATA_MAP" ]; then
        # Extract JSON and validate basic structure
        JSON_CONTENT=$(echo "$DATA_MAP" | sed "s/data-map='//; s/'$//")
        if echo "$JSON_CONTENT" | grep -q '^\s*{' 2>/dev/null; then
            echo "   Color map appears to be valid JSON"
        else
            echo "   WARNING: Color map may not be valid JSON"
        fi
    fi
else
    echo "   INFO: No color swatch data-map found (may be intentional)"
fi

# Check for swatch click handlers
SWATCH_JS=$(grep -c 'swatch\|colorOption\|variant' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$SWATCH_JS" -gt 0 ]; then
    echo "   Found $SWATCH_JS swatch-related references"
fi
echo ""

# ============================================
# TEST 4: JavaScript Syntax Errors
# ============================================
echo "--- JavaScript Syntax Check ---"

# Check for common JS corruption patterns
ORPHANED_BRACES=$(grep -c '^[[:space:]]*};[[:space:]]*$' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$ORPHANED_BRACES" -gt 5 ]; then
    echo "   WARNING: Unusual number of orphaned }; ($ORPHANED_BRACES found)"
    echo "   This may indicate JS corruption from editing"
fi

# Check for spaced placeholders in JS (breaks syntax)
SPACED_IN_SCRIPT=$(grep -A 100 '<script' "$HTML_FILE" 2>/dev/null | grep -c '{{ [A-Z]' || echo "0")
if [ "$SPACED_IN_SCRIPT" -gt 0 ]; then
    echo "   ERROR: Spaced placeholders found in <script> tags!"
    echo "   This breaks JavaScript execution"
    ((ERRORS++))
fi

# Check for const CONFIG
if grep -q 'const CONFIG' "$HTML_FILE" 2>/dev/null; then
    echo "   Found checkout CONFIG object"

    # Verify CONFIG is properly closed
    if ! grep -q 'const CONFIG\s*=\s*{' "$HTML_FILE" 2>/dev/null; then
        echo "   WARNING: CONFIG declaration may be malformed"
    fi
else
    echo "   INFO: No checkout CONFIG found (may use different pattern)"
fi
echo ""

# ============================================
# TEST 5: Add to Cart Button
# ============================================
echo "--- Add to Cart Check ---"

ADD_TO_CART=$(grep -c 'add.*cart\|addToCart\|buy.*now\|buyNow' "$HTML_FILE" 2>/dev/null || echo "0")
if [ "$ADD_TO_CART" -eq 0 ]; then
    echo "   ERROR: No Add to Cart / Buy Now references found!"
    ((ERRORS++))
else
    echo "   Found $ADD_TO_CART cart/buy references"
fi

# Check for form or button elements
BUTTONS=$(grep -c '<button\|type="submit"' "$HTML_FILE" 2>/dev/null || echo "0")
echo "   Found $BUTTONS button/submit elements"
echo ""

# ============================================
# TEST 6: Mobile Responsiveness Markers
# ============================================
echo "--- Mobile Responsiveness Check ---"

VIEWPORT=$(grep -c 'viewport' "$HTML_FILE" 2>/dev/null || echo "0")
MEDIA_QUERIES=$(grep -c '@media' "$HTML_FILE" 2>/dev/null || echo "0")

if [ "$VIEWPORT" -eq 0 ]; then
    echo "   WARNING: No viewport meta tag found"
else
    echo "   Viewport meta tag present"
fi

if [ "$MEDIA_QUERIES" -eq 0 ]; then
    echo "   WARNING: No @media queries found (external CSS?)"
else
    echo "   Found $MEDIA_QUERIES @media queries"
fi
echo ""

# ============================================
# FINAL RESULT
# ============================================
if [ "$ERRORS" -gt 0 ]; then
    echo "=== INTERACTIVE TESTS FAILED ($ERRORS errors) ==="
    echo ""
    echo "FIX: Review the errors above and ensure:"
    echo "   1. All placeholders are replaced"
    echo "   2. No JS syntax corruption"
    echo "   3. Product images exist"
    echo "   4. Cart/checkout elements present"
    exit 1
else
    echo "=== INTERACTIVE TESTS PASSED ==="
    echo ""
    echo "NOTE: For full testing, visually verify:"
    echo "   1. FAQ accordions expand/collapse"
    echo "   2. Image carousel arrows work"
    echo "   3. Color swatches change product image"
    echo "   4. Add to Cart button is clickable"
    exit 0
fi
