#!/bin/bash
# validate-schema-contract.sh - Enforce IMAGE-SCHEMA.json contract
# Validates that templates, config, and files all match the schema

set -e

echo "=== SCHEMA CONTRACT VALIDATION ==="
echo ""

SCHEMA_FILE="IMAGE-SCHEMA.json"
CONFIG_FILE="product.config"
ERRORS=0
WARNINGS=0

# Check schema exists
if [ ! -f "$SCHEMA_FILE" ]; then
    echo "❌ CRITICAL: IMAGE-SCHEMA.json not found"
    exit 1
fi
echo "✅ Schema file found: $SCHEMA_FILE"
echo ""

# Check jq is available
if ! command -v jq &> /dev/null; then
    echo "⚠️  jq not installed - using basic validation"
    echo "   Install jq for full schema validation: brew install jq"
    echo ""

    # Basic validation without jq - check critical directories
    for dir in images/product images/testimonials images/founder images/awards images/order-bump images/comparison; do
        if [ -d "$dir" ]; then
            COUNT=$(find "$dir" -name "*.webp" -o -name "*.png" -o -name "*.jpg" 2>/dev/null | wc -l | tr -d ' ')
            if [ "$COUNT" -gt 0 ]; then
                echo "  ✅ $dir: $COUNT image files"
            else
                echo "  ⚠️  $dir: 0 image files (empty)"
                ((WARNINGS++))
            fi
        else
            echo "  ❌ MISSING: $dir"
            ((ERRORS++))
        fi
    done
else
    echo "Using jq for full schema validation..."
    echo ""

    # Extract and validate each category
    categories=$(jq -r '.required_images | keys[]' "$SCHEMA_FILE")

    for category in $categories; do
        echo "━━━ Validating: $category ━━━"

        dir=$(jq -r ".required_images.$category.directory" "$SCHEMA_FILE")
        expected_count=$(jq -r ".required_images.$category.count" "$SCHEMA_FILE")
        files=$(jq -r ".required_images.$category.files[]" "$SCHEMA_FILE" 2>/dev/null || echo "")
        variables=$(jq -r ".required_images.$category.variables[]" "$SCHEMA_FILE" 2>/dev/null || echo "")

        # Check directory exists
        if [ ! -d "$dir" ]; then
            echo "  ❌ FAIL: Directory missing: $dir"
            ((ERRORS++))
            echo ""
            continue
        fi

        # Check each required file
        MISSING_FILES=0
        PRESENT_FILES=0
        for file in $files; do
            full_path="$dir/$file"
            if [ -f "$full_path" ]; then
                # Check file size
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    size=$(stat -f%z "$full_path" 2>/dev/null || echo "0")
                else
                    size=$(stat -c%s "$full_path" 2>/dev/null || echo "0")
                fi
                size_kb=$((size / 1024))

                max_size=$(jq -r '.validation_rules.max_file_size_kb // 500' "$SCHEMA_FILE")
                if [ "$size_kb" -gt "$max_size" ]; then
                    echo "  ⚠️  $file is ${size_kb}KB (recommend <${max_size}KB)"
                    ((WARNINGS++))
                else
                    echo "  ✅ $file (${size_kb}KB)"
                fi
                ((PRESENT_FILES++))
            else
                echo "  ⚠️  MISSING: $file"
                ((MISSING_FILES++))
                ((WARNINGS++))
            fi
        done

        if [ "$MISSING_FILES" -gt 0 ]; then
            echo "  ℹ️  Note: $MISSING_FILES files pending - add when generating assets"
        fi

        # Check variables exist in product.config
        if [ -f "$CONFIG_FILE" ]; then
            MISSING_VARS=0
            for var in $variables; do
                if grep -q "^$var=" "$CONFIG_FILE" 2>/dev/null; then
                    echo "  ✅ Variable: $var defined in config"
                else
                    echo "  ⚠️  Variable: $var NOT in product.config"
                    ((MISSING_VARS++))
                    ((WARNINGS++))
                fi
            done
        fi

        echo ""
    done
fi

# Check for banned hardcoded paths
echo "━━━ Checking for banned hardcoded paths ━━━"
BANNED=$(grep -rn 'src="images/' sections/*.html 2>/dev/null | grep -v '{{' | wc -l | tr -d ' ')
if [ "$BANNED" -gt "0" ]; then
    echo "  ❌ FAIL: $BANNED hardcoded paths found (banned by schema)"
    echo "  Run: bash tests/validate-hardcoded-paths.sh for details"
    ((ERRORS++))
else
    echo "  ✅ No hardcoded paths - all use {{VARIABLES}}"
fi

echo ""
echo "=== RESULTS ==="
echo "Errors:   $ERRORS"
echo "Warnings: $WARNINGS"
echo ""

if [ "$ERRORS" -gt "0" ]; then
    echo "❌ SCHEMA VALIDATION FAILED"
    echo ""
    echo "To fix:"
    echo "1. Create missing directories"
    echo "2. Convert hardcoded paths to {{VARIABLES}}"
    echo "3. Add missing variables to product.config"
    echo ""
    echo "ℹ️  Missing image files are warnings (add when generating assets)"
    exit 1
elif [ "$WARNINGS" -gt "0" ]; then
    echo "⚠️  SCHEMA VALIDATION PASSED WITH WARNINGS"
    echo ""
    echo "Warnings are acceptable for master template."
    echo "Add missing images when duplicating template for actual product."
    exit 0
else
    echo "✅ SCHEMA VALIDATION PASSED"
    exit 0
fi
