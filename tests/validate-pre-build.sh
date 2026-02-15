#!/bin/bash
# validate-pre-build.sh - Catch template corruption BEFORE build.sh runs
# Run this before ./build.sh to prevent common failures

set -e

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           PRE-BUILD TEMPLATE VALIDATION                    ║"
echo "║           Catches AI-introduced errors early               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

PASS=0
FAIL=0
WARN=0

# ============================================
# CHECK 1: Spaced Placeholders
# ============================================
echo "🔍 Check 1: Spaced placeholders..."
SPACED=$(grep -r '{{ *[A-Z0-9_]* *}}' sections/*.html 2>/dev/null | grep -v '{{[A-Z]' || true)
if [ -n "$SPACED" ]; then
    echo "   ⚠️  WARNING: Found spaced placeholders (will be auto-fixed by build.sh):"
    echo "$SPACED" | head -5
    ((WARN++))
else
    echo "   ✅ No spaced placeholders found"
    ((PASS++))
fi

# ============================================
# CHECK 2: Order-Bump Section Exists
# ============================================
echo ""
echo "🔍 Check 2: Order-bump section..."
if grep -q 'id="order-bump-section"' sections/05-main-product.html 2>/dev/null; then
    echo "   ✅ Order-bump section exists"
    ((PASS++))
else
    echo "   ❌ CRITICAL: Order-bump section is MISSING!"
    echo "      This section is required for checkout upsells."
    echo "      Restore from backup or template."
    ((FAIL++))
fi

# ============================================
# CHECK 3: COLOR_IMAGE_MAP Data Element
# ============================================
echo ""
echo "🔍 Check 3: COLOR_IMAGE_MAP data element..."
if grep -q 'id="color-image-data"' sections/05-main-product.html 2>/dev/null; then
    echo "   ✅ COLOR_IMAGE_MAP data element exists"
    ((PASS++))
else
    echo "   ⚠️  WARNING: COLOR_IMAGE_MAP data element not found"
    echo "      Color swatches may not work correctly."
    ((WARN++))
fi

# ============================================
# CHECK 4: Broken JavaScript Braces
# ============================================
echo ""
echo "🔍 Check 4: JavaScript brace matching..."
# Count open and close braces in the entire 05-main-product.html file
# (more reliable than trying to extract just script sections)
OPEN_BRACES=$(grep -o '{' sections/05-main-product.html 2>/dev/null | wc -l | tr -d ' ')
CLOSE_BRACES=$(grep -o '}' sections/05-main-product.html 2>/dev/null | wc -l | tr -d ' ')

if [ "$OPEN_BRACES" -eq "$CLOSE_BRACES" ]; then
    echo "   ✅ Brace count matches (${OPEN_BRACES} open, ${CLOSE_BRACES} close)"
    ((PASS++))
else
    DIFF=$((OPEN_BRACES - CLOSE_BRACES))
    if [ "$DIFF" -gt 0 ]; then
        echo "   ⚠️  WARNING: ${DIFF} more open braces than close braces"
    else
        echo "   ⚠️  WARNING: $((-DIFF)) more close braces than open braces"
    fi
    echo "      This could indicate corrupted JS, but may be valid CSS/HTML."
    echo "      Run build.sh to verify if this is actually a problem."
    ((WARN++))
fi

# ============================================
# CHECK 5: product.config Syntax
# ============================================
echo ""
echo "🔍 Check 5: product.config syntax..."
if [ -f "product.config" ]; then
    # Try to source it in a subshell
    if bash -n product.config 2>/dev/null; then
        echo "   ✅ product.config has valid bash syntax"
        ((PASS++))
    else
        echo "   ❌ CRITICAL: product.config has syntax errors!"
        bash -n product.config 2>&1 | head -5
        ((FAIL++))
    fi
else
    echo "   ❌ CRITICAL: product.config not found!"
    ((FAIL++))
fi

# ============================================
# CHECK 6: Required Sections Exist
# ============================================
echo ""
echo "🔍 Check 6: Required section files..."
REQUIRED_SECTIONS=(
    "01-head.html"
    "02-body-start.html"
    "03-header.html"
    "05-main-product.html"
    "14-faq.html"
    "23-scripts.html"
)
MISSING_SECTIONS=0
for section in "${REQUIRED_SECTIONS[@]}"; do
    if [ ! -f "sections/$section" ]; then
        echo "   ❌ Missing: sections/$section"
        ((MISSING_SECTIONS++))
    fi
done
if [ "$MISSING_SECTIONS" -eq 0 ]; then
    echo "   ✅ All critical sections present"
    ((PASS++))
else
    echo "   ❌ CRITICAL: $MISSING_SECTIONS required sections missing!"
    ((FAIL++))
fi

# ============================================
# CHECK 7: Orphaned Placeholders in JS
# ============================================
echo ""
echo "🔍 Check 7: Placeholders inside JavaScript..."
# This is risky - placeholders inside <script> tags can corrupt JS
JS_PLACEHOLDERS=$(grep -n '{{[A-Z_]*}}' sections/05-main-product.html 2>/dev/null | grep -v 'data-map' | grep -v '<' || true)
if [ -n "$JS_PLACEHOLDERS" ]; then
    # Check if it's in a script block
    SCRIPT_PLACEHOLDERS=$(echo "$JS_PLACEHOLDERS" | head -3)
    echo "   ⚠️  Placeholders found that may be in JavaScript:"
    echo "$SCRIPT_PLACEHOLDERS"
    echo "      If inside <script> tags, they should be in data- attributes instead."
    ((WARN++))
else
    echo "   ✅ No risky JavaScript placeholders found"
    ((PASS++))
fi

# ============================================
# CHECK 8: Hardcoded Image Paths (CRITICAL)
# ============================================
echo ""
echo "🔍 Check 8: Hardcoded image paths..."
HARDCODED=$(grep -rn 'src="images/' sections/*.html 2>/dev/null | grep -v '{{' | wc -l | tr -d ' ')
if [ "$HARDCODED" -gt 0 ]; then
    echo "   ❌ CRITICAL: Found $HARDCODED hardcoded image paths!"
    echo "      These MUST be converted to {{VARIABLES}}"
    echo "      Run: bash tests/validate-hardcoded-paths.sh for details"
    ((FAIL++))
else
    echo "   ✅ No hardcoded image paths found"
    ((PASS++))
fi

# ============================================
# CHECK 9: Schema Contract
# ============================================
echo ""
echo "🔍 Check 9: Schema contract..."
if [ -f "IMAGE-SCHEMA.json" ]; then
    # Quick check: critical directories exist
    SCHEMA_FAIL=0
    for dir in images/product images/testimonials images/founder images/awards; do
        if [ ! -d "$dir" ]; then
            echo "   ⚠️  Schema directory missing: $dir"
            ((SCHEMA_FAIL++))
        fi
    done

    if [ "$SCHEMA_FAIL" -eq 0 ]; then
        echo "   ✅ Schema directories present"
        ((PASS++))
    else
        echo "   ⚠️  Some schema directories missing (acceptable for master template)"
        ((WARN++))
    fi
else
    echo "   ❌ CRITICAL: IMAGE-SCHEMA.json not found"
    ((FAIL++))
fi

# ============================================
# CHECK 10: Framework Variables Defined
# ============================================
echo ""
echo "🔍 Check 10: Framework variables..."
if [ -f "product.config" ]; then
    source product.config 2>/dev/null || true

    FRAMEWORK_FAIL=0
    # Check 3 Secrets defined
    [ -z "$SECRET_1_FALSE_BELIEF" ] && ((FRAMEWORK_FAIL++))
    [ -z "$SECRET_2_FALSE_BELIEF" ] && ((FRAMEWORK_FAIL++))
    [ -z "$SECRET_3_FALSE_BELIEF" ] && ((FRAMEWORK_FAIL++))

    # Check ENGAGE headline
    if [ -n "$HEADLINE_HOOK" ]; then
        # Check for pattern interrupt keywords
        if echo "$HEADLINE_HOOK" | grep -qiE 'why|stop|myth|lie|secret|truth|what if'; then
            echo "   ✅ HEADLINE_HOOK has pattern interrupt"
        else
            echo "   ⚠️  HEADLINE_HOOK may lack pattern interrupt"
            ((WARN++))
        fi
    else
        ((FRAMEWORK_FAIL++))
    fi

    if [ "$FRAMEWORK_FAIL" -eq 0 ]; then
        echo "   ✅ Framework variables present"
        ((PASS++))
    else
        echo "   ⚠️  $FRAMEWORK_FAIL framework variables missing (check product.config)"
        ((WARN++))
    fi
else
    echo "   ❌ product.config not found"
    ((FAIL++))
fi

# ============================================
# SUMMARY
# ============================================
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "VALIDATION SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ Passed:   $PASS"
echo "   ⚠️  Warnings: $WARN"
echo "   ❌ Failed:   $FAIL"
echo ""

if [ "$FAIL" -gt 0 ]; then
    echo "❌ PRE-BUILD VALIDATION FAILED"
    echo "   Fix the critical issues above before running build.sh"
    exit 1
elif [ "$WARN" -gt 0 ]; then
    echo "⚠️  PRE-BUILD VALIDATION PASSED WITH WARNINGS"
    echo "   build.sh should handle these, but review if issues occur."
    exit 0
else
    echo "✅ PRE-BUILD VALIDATION PASSED"
    echo "   Safe to run ./build.sh"
    exit 0
fi
