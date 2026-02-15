#!/bin/bash
# validate-hardcoded-paths.sh - Detect hardcoded image paths in templates
# BLOCKING: Build cannot proceed if hardcoded paths found

set -e

echo "=== HARDCODED PATH DETECTION ==="
echo ""

ERRORS=0
SECTIONS_DIR="sections"

# Check each section file for hardcoded image paths
echo "Scanning section templates for hardcoded paths..."
echo ""

# Find all src="images/..." and href="images/..." that don't have {{ before them
# Note: Both src and href can reference image paths (favicons, preloads, etc.)
HARDCODED_SRC=$(grep -rn 'src="images/' "$SECTIONS_DIR"/*.html 2>/dev/null | grep -v '{{' || true)
HARDCODED_HREF=$(grep -rn 'href="images/' "$SECTIONS_DIR"/*.html 2>/dev/null | grep -v '{{' || true)
HARDCODED=$(printf "%s\n%s" "$HARDCODED_SRC" "$HARDCODED_HREF" | grep -v '^$' || true)

if [ -n "$HARDCODED" ]; then
    echo "❌ HARDCODED PATHS FOUND:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    COUNT=0
    echo "$HARDCODED" | while IFS=: read -r file linenum content; do
        ((COUNT++))

        # Extract the hardcoded path (check both src and href)
        PATH_FOUND=$(echo "$content" | grep -oE '(src|href)="images/[^"]*"' | head -1)

        echo "Error #$COUNT:"
        echo "  FILE: $file"
        echo "  LINE: $linenum"
        echo "  PATH: $PATH_FOUND"

        # Suggest the variable to use based on path
        if [[ "$PATH_FOUND" == *"product"* ]]; then
            NUM=$(echo "$PATH_FOUND" | grep -o '[0-9][0-9]*' | head -1)
            echo "  FIX:  Replace with {{PRODUCT_IMAGE_$NUM}}"
        elif [[ "$PATH_FOUND" == *"testimonial"* ]]; then
            RAW_NUM=$(echo "$PATH_FOUND" | grep -o '[0-9][0-9]*' | head -1)
            NUM=$((10#$RAW_NUM))
            if [ "$NUM" -le 3 ]; then
                echo "  FIX:  Replace with {{FEATURE_IMAGE_$NUM}}"
            elif [ "$NUM" -le 6 ]; then
                SNUM=$((NUM - 3))
                echo "  FIX:  Replace with {{SECRET_IMAGE_$SNUM}}"
            else
                TNUM=$((NUM - 6))
                echo "  FIX:  Replace with {{TESTIMONIAL_${TNUM}_IMAGE}}"
            fi
        elif [[ "$PATH_FOUND" == *"founder"* ]]; then
            echo "  FIX:  Replace with {{FOUNDER_IMAGE}}"
        elif [[ "$PATH_FOUND" == *"awards"* ]]; then
            NUM=$(echo "$PATH_FOUND" | grep -o '[0-9]' | head -1)
            echo "  FIX:  Replace with {{AWARD_IMAGE_$NUM}}"
        elif [[ "$PATH_FOUND" == *"order-bump"* ]]; then
            echo "  FIX:  Replace with {{ORDER_BUMP_IMAGE}}"
        elif [[ "$PATH_FOUND" == *"comparison"* ]]; then
            echo "  FIX:  Replace with {{COMPARISON_IMAGE}}"
        elif [[ "$PATH_FOUND" == *"size-chart"* ]]; then
            echo "  FIX:  Replace with {{SIZE_CHART_IMAGE}}"
        elif [[ "$PATH_FOUND" == *"universal"* ]] && [[ "$PATH_FOUND" == *"logo"* ]]; then
            echo "  FIX:  Replace with {{FAVICON_IMAGE}} or {{LOGO_IMAGE}}"
        elif [[ "$PATH_FOUND" == *"universal"* ]]; then
            echo "  FIX:  Replace with appropriate {{UNIVERSAL_*}} variable"
        fi
        echo ""
    done

    TOTAL=$(echo "$HARDCODED" | wc -l | tr -d ' ')
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "TOTAL HARDCODED PATHS: $TOTAL"
    echo ""
    echo "🔧 ACTION REQUIRED:"
    echo "1. Replace each hardcoded path with the suggested {{VARIABLE}}"
    echo "2. Add the variable to product.config if not already present"
    echo "3. Ensure build.sh has replace_var for this variable"
    echo "4. Re-run this validation"
    echo ""
    exit 1
else
    echo "✅ No hardcoded image paths found in templates."
    echo ""
    echo "All image references use {{VARIABLE}} placeholders."
    echo ""
    echo "=== VALIDATION PASSED ==="
    exit 0
fi
