#!/bin/bash
# validate-variables.sh - STRICT validation of ALL required variables
# This catches the errors that were passing before Ralphy integration

echo "=== STRICT VARIABLE VALIDATION ==="

ERRORS=0

# Source product.config
if [ ! -f "product.config" ]; then
    echo "❌ FAIL: product.config not found"
    exit 1
fi
source product.config

# ============================================
# REQUIRED VARIABLES - These MUST have values
# ============================================

check_required() {
    local var_name="$1"
    local var_value="${!var_name}"
    if [ -z "$var_value" ]; then
        echo "❌ MISSING: $var_name"
        ((ERRORS++))
    fi
}

echo ""
echo "--- Checking Core Product Variables ---"
check_required "PRODUCT_NAME"
check_required "BRAND_NAME"
check_required "SINGLE_PRICE"
check_required "BUNDLE_PRICE"
check_required "HEADLINE_HOOK"
check_required "AUDIENCE"

echo ""
echo "--- Checking ENGAGE Framework Variables ---"
check_required "HEADLINE_OPENING_COPY"
check_required "TAGLINE"

echo ""
echo "--- Checking BRIDGE Variables ---"
check_required "BRIDGE_HEADLINE"
check_required "BRIDGE_SUBHEADLINE"
check_required "COMPARISON_HEADLINE"
check_required "COMPARISON_PARAGRAPH"

echo ""
echo "--- Checking 3 SECRETS Variables (Vehicle/Internal/External) ---"
# NOTE: SECRET_IMAGE_1/2/3 are HARDCODED in HTML templates:
# - 10-secret-1.html → testimonial-04.webp
# - 11-secret-2.html → testimonial-05.webp
# - 12-secret-3.html → testimonial-06.webp

# Secret 1 - Vehicle
check_required "SECRET_1_HEADLINE"
check_required "SECRET_1_FALSE_BELIEF"
check_required "SECRET_1_TRUTH"
# SECRET_IMAGE_1 - hardcoded in template
check_required "SECRET_PARAGRAPH_1"
check_required "SECRET_PARAGRAPH_1_2"

# Secret 2 - Internal
check_required "SECRET_2_HEADLINE"
check_required "SECRET_2_FALSE_BELIEF"
check_required "SECRET_2_TRUTH"
# SECRET_IMAGE_2 - hardcoded in template
check_required "SECRET_PARAGRAPH_2"
check_required "SECRET_PARAGRAPH_2_2"

# Secret 3 - External
check_required "SECRET_3_HEADLINE"
check_required "SECRET_3_FALSE_BELIEF"
check_required "SECRET_3_TRUTH"
# SECRET_IMAGE_3 - hardcoded in template
check_required "SECRET_PARAGRAPH_3"
check_required "SECRET_PARAGRAPH_3_2"

echo ""
echo "--- Checking FOUNDER STORY Variables (Epiphany Bridge) ---"
check_required "FOUNDER_SECTION_HEADING"
check_required "FOUNDER_BACKSTORY"
check_required "FOUNDER_WALL"
check_required "FOUNDER_EPIPHANY"
check_required "FOUNDER_PLAN"
check_required "FOUNDER_TRANSFORMATION"
check_required "FOUNDER_INVITATION"
check_required "FOUNDER_IMAGE"

echo ""
echo "--- Checking FEATURES Variables (FIBS Framework) ---"
check_required "FEATURE_HEADLINE_1"
check_required "FEATURE_HEADLINE_2"
check_required "FEATURE_HEADLINE_3"
check_required "FEATURE_PARAGRAPH_1_1"
check_required "FEATURE_PARAGRAPH_2"

echo ""
echo "--- Checking TESTIMONIALS Variables ---"
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
    check_required "TESTIMONIAL_${i}_TITLE"
    check_required "TESTIMONIAL_${i}_QUOTE"
    check_required "TESTIMONIAL_${i}_AUTHOR"
    check_required "TESTIMONIAL_${i}_IMAGE"
done
check_required "ROTATING_TESTIMONIAL_1"
check_required "ROTATING_TESTIMONIAL_2"
check_required "ROTATING_TESTIMONIAL_3"

echo ""
echo "--- Checking FAQ Variables ---"
check_required "FAQ_HEADING"
check_required "FAQ_QUESTION_1"
check_required "FAQ_ANSWER_1"
check_required "FAQ_QUESTION_2"
check_required "FAQ_ANSWER_2"
check_required "FAQ_QUESTION_3"
check_required "FAQ_ANSWER_3"

echo ""
echo "--- Checking GUARANTEE Variables ---"
check_required "GUARANTEE_DAYS"
check_required "GUARANTEE_NAME"
check_required "GUARANTEE_CONDITION"

echo ""
echo "--- Checking IMAGES Exist ---"
# Check that referenced images actually exist
check_image() {
    local path="$1"
    if [ ! -f "$path" ]; then
        echo "❌ IMAGE MISSING: $path"
        ((ERRORS++))
    fi
}

# Product images
for i in 1 2 3 4 5 6; do
    var_name="PRODUCT_IMAGE_${i}"
    var_value="${!var_name}"
    if [ -n "$var_value" ]; then
        check_image "$var_value"
    fi
done

# Secret images - HARDCODED in templates, verify they exist
# Using fixed paths instead of config variables
check_image "images/testimonials/testimonial-04.webp"
check_image "images/testimonials/testimonial-05.webp"
check_image "images/testimonials/testimonial-06.webp"

# Feature images - HARDCODED in templates
check_image "images/testimonials/testimonial-01.webp"
check_image "images/testimonials/testimonial-02.webp"
check_image "images/testimonials/testimonial-03.webp"

# Founder image
check_image "$FOUNDER_IMAGE"

# ============================================
# OPTIONAL VARIABLES (Logged but not errors)
# ============================================
echo ""
echo "--- Optional Variables (Info Only) ---"
[ -z "$SIZE_OPTIONS" ] && echo "ℹ️  SIZE_OPTIONS is empty (dynamic)"
[ -z "$COLOR_UI_HTML" ] && echo "ℹ️  COLOR_UI_HTML is empty (dynamic)"

# ============================================
# FINAL RESULT
# ============================================
echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "=== ❌ VARIABLE VALIDATION FAILED ($ERRORS errors) ==="
    echo ""
    echo "FIX: Add missing values to product.config"
    exit 1
else
    echo "=== ✅ VARIABLE VALIDATION PASSED ==="
    exit 0
fi
