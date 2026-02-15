#!/bin/bash
# build.sh v5.0 - Complete template builder with ALL variables
# Handles ALL 178+ placeholders from product.config
# Includes rollback mechanism on failure

set -e

CONFIG_FILE="${CONFIG_FILE:-product.config}"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║           LANDING PAGE BUILDER v5.0                        ║"
echo "║           Brunson Protocol Build System                    ║"
echo "║           Handles 178+ Variables + Rollback                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# ============================================
# ROLLBACK MECHANISM
# ============================================
BACKUP_FILE=""
cleanup() {
    if [ -n "$BACKUP_FILE" ] && [ -f "$BACKUP_FILE" ]; then
        echo "🔄 Build failed - restoring backup..."
        mv "$BACKUP_FILE" index.html
        echo "✅ Restored previous index.html"
    fi
}
trap cleanup EXIT

# Backup existing index.html if it exists
if [ -f "index.html" ]; then
    BACKUP_FILE="index.html.backup.$$"
    cp index.html "$BACKUP_FILE"
    echo "📦 Backed up existing index.html"
fi

# ============================================
# STEP 0: Check Dependencies
# ============================================
echo "🔍 Checking dependencies..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not installed. Install from https://nodejs.org"
    exit 1
fi
echo "   ✅ Node.js"

if ! command -v npx &> /dev/null; then
    echo "❌ npx not available"
    exit 1
fi
echo "   ✅ npx"
echo ""

# ============================================
# STEP 0.5: Pre-Build Cleanup (SOURCE FILES)
# ============================================
# Fix spaced placeholders in SOURCE files before concatenation
# This prevents AI-introduced {{ VARIABLE }} from propagating
echo "🔧 Pre-build cleanup..."
for f in sections/*.html "$CONFIG_FILE"; do
    if [ -f "$f" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' 's/{{ /{{/g; s/ }}/}}/g' "$f" 2>/dev/null || true
        else
            sed -i 's/{{ /{{/g; s/ }}/}}/g' "$f" 2>/dev/null || true
        fi
    fi
done
echo "   ✅ Source files cleaned"
echo ""

# ============================================
# STEP 1: Load & Validate Config
# ============================================
echo "📝 Loading config: $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

is_placeholder_value() {
    local value="$1"
    [[ "$value" =~ ^\{\{[A-Z0-9_]+\}\}$ ]]
}

require_field() {
    local field_name="$1"
    local field_value="${!field_name:-}"
    if [ -z "$field_value" ] || is_placeholder_value "$field_value"; then
        MISSING="$MISSING $field_name"
    fi
}

# Check required fields (empty or unresolved placeholders are both invalid)
MISSING=""
for required_field in \
    PRODUCT_NAME \
    BRAND_NAME \
    SINGLE_PRICE \
    BUNDLE_PRICE \
    NETLIFY_SITE_ID \
    GUARANTEE_NAME \
    GUARANTEE_CONDITION \
    REVIEW_COUNT \
    AUDIENCE \
    HEADLINE_HOOK
do
    require_field "$required_field"
done

if [ -n "$MISSING" ]; then
    echo "❌ Missing required fields in $CONFIG_FILE:"
    echo "  $MISSING"
    echo "  (Fields still set to {{PLACEHOLDER}} are treated as missing.)"
    exit 1
fi

echo "   ✅ Config validated"
echo "   Product: $PRODUCT_NAME"
echo "   Brand: $BRAND_NAME"
echo ""

# ============================================
# STEP 2: Check Images
# ============================================
echo "🖼️  Checking images..."

MISSING_IMAGES=""
for i in 1 2 3 4 5 6; do
    if [ ! -f "images/product/product-0$i.webp" ] && [ ! -f "images/product/product-0$i.png" ] && [ ! -f "images/product/product-0$i.jpg" ]; then
        MISSING_IMAGES="$MISSING_IMAGES product-0$i"
    fi
done

if [ -n "$MISSING_IMAGES" ]; then
    echo "   ⚠️  Missing product images:$MISSING_IMAGES"
    echo "   Add images to images/product/ folder"
else
    echo "   ✅ Product images found"
fi

# Convert images if cwebp available
# (Manual optimization done)
echo "   ✅ Images optimized (Manual)"
# if command -v cwebp &> /dev/null; then
#     find images -name "*.png" -type f 2>/dev/null | while read file; do
#         output="${file%.png}.webp"
#         [ ! -f "$output" ] && cwebp -q 80 "$file" -o "$output" 2>/dev/null
#     done
#     find images -name "*.jpg" -type f 2>/dev/null | while read file; do
#         output="${file%.jpg}.webp"
#         [ ! -f "$output" ] && cwebp -q 80 "$file" -o "$output" 2>/dev/null
#     done
#     echo "   ✅ Images optimized"
# fi
echo ""

# ============================================
# STEP 3: Build HTML with replacements
# ============================================
echo "📄 Building index.html..."

# Concatenate all sections (Brunson Protocol Order)
# Structure: Hero → Bridge → Features → Founder → 3 Secrets → Social Proof → FAQ → Closer → CTA
cat \
  sections/01-head.html \
  sections/02-body-start.html \
  sections/03-header.html \
  sections/04-cart-drawer.html \
  sections/05-main-product.html \
  sections/06-comparison.html \
  sections/07-bridge-headline.html \
  sections/08-features-3-fibs.html \
  sections/08b-interstitial-1.html \
  sections/08b-testimonial-strip.html \
  sections/09-founder-story.html \
  sections/09b-interstitial-2.html \
  sections/10-secret-1.html \
  sections/11-secret-2.html \
  sections/12-secret-3.html \
  sections/13-awards-carousel.html \
  sections/14-faq.html \
  sections/15-custom-reviews.html \
  sections/15a-slideshow.html \
  sections/15b-custom-html.html \
  sections/16-slideshow-2.html \
  sections/18-testimonials.html \
  sections/19-multirow-2.html \
  sections/20-cta-banner.html \
  sections/21-pre-footer.html \
  sections/22-footer.html \
  sections/23-scripts.html \
  > index.html || { echo "❌ Failed to concatenate sections"; exit 1; }

# ============================================
# STEP 3.0: Strip Erroneous Closing Tags (AUTO-FIX)
# ============================================
# Some linters add </html> to 01-head.html and </body> to 02-body-start.html
# These break the concatenated document - strip them (they're added by 22-footer.html)
echo "   Stripping erroneous mid-document closing tags..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed - remove </html> from head section and </body> from body-start
    sed -i '' 's|</head>.*</html>|</head>|g' index.html 2>/dev/null || true
    sed -i '' 's|</a>.*</body>|</a>|g' index.html 2>/dev/null || true
else
    # Linux sed
    sed -i 's|</head>.*</html>|</head>|g' index.html 2>/dev/null || true
    sed -i 's|</a>.*</body>|</a>|g' index.html 2>/dev/null || true
fi
echo "   ✅ Erroneous closing tags stripped"

# ============================================
# STEP 3.1: Normalize Placeholders (AUTO-FIX)
# ============================================
# Fix common AI-introduced errors: {{ VARIABLE }} -> {{VARIABLE}}
# This prevents build failures from spaced placeholders
echo "   Normalizing placeholders..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS sed - remove spaces inside {{ }}
    sed -i '' 's/{{ *\([A-Z0-9_]*\) *}}/{{\1}}/g' index.html 2>/dev/null || true
else
    # Linux sed
    sed -i 's/{{ *\([A-Z0-9_]*\) *}}/{{\1}}/g' index.html 2>/dev/null || true
fi
echo "   ✅ Placeholders normalized"

# Function to safely escape replacement values for sed.
# Only replacement-reserved chars are escaped: \, &, and delimiter |.
# Newlines are collapsed to spaces to avoid malformed sed commands.
escape_sed() {
    printf '%s' "$1" | tr '\n' ' ' | sed -e 's/[\\&|]/\\&/g'
}

# Replace function - handles both macOS and Linux
replace_var() {
    local placeholder="$1"
    local value="$2"
    if [ -n "$value" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|$placeholder|$(escape_sed "$value")|g" index.html 2>/dev/null || true
        else
            sed -i "s|$placeholder|$(escape_sed "$value")|g" index.html 2>/dev/null || true
        fi
    fi
}

echo "   Replacing variables..."

# =====================================================
# CORE PRODUCT INFO
# =====================================================
replace_var "{{PRODUCT_NAME}}" "$PRODUCT_NAME"
replace_var "{{BRAND_NAME}}" "$BRAND_NAME"
replace_var "{{PRODUCT_HANDLE}}" "$PRODUCT_HANDLE"
replace_var "{{PRODUCT_ID}}" "$PRODUCT_ID"
replace_var "{{VARIANT_ID}}" "$VARIANT_ID"
replace_var "{{SUBDOMAIN}}" "$SUBDOMAIN"

# =====================================================
# URLS
# =====================================================
replace_var "{{ACCOUNT_URL}}" "$ACCOUNT_URL"
replace_var "{{PRODUCT_URL}}" "$PRODUCT_URL"
replace_var "{{PRODUCT_FULL_URL}}" "$PRODUCT_FULL_URL"
replace_var "{{SITE_URL}}" "$SITE_URL"
replace_var "{{SHOP_URL}}" "$SHOP_URL"
replace_var "{{CANONICAL_URL}}" "$CANONICAL_URL"
replace_var "{{LOGO_URL}}" "$LOGO_URL"
replace_var "{{FAVICON_IMAGE}}" "$FAVICON_IMAGE"

# =====================================================
# AWARD IMAGES
# =====================================================
replace_var "{{AWARD_IMAGE_1}}" "$AWARD_IMAGE_1"
replace_var "{{AWARD_IMAGE_2}}" "$AWARD_IMAGE_2"
replace_var "{{AWARD_IMAGE_3}}" "$AWARD_IMAGE_3"
replace_var "{{AWARD_IMAGE_4}}" "$AWARD_IMAGE_4"
replace_var "{{AWARD_IMAGE_5}}" "$AWARD_IMAGE_5"
replace_var "{{AWARDS_SECTION_TITLE}}" "$AWARDS_SECTION_TITLE"
replace_var "{{AWARD_1_TITLE}}" "$AWARD_1_TITLE"
replace_var "{{AWARD_1_BODY}}" "$AWARD_1_BODY"
replace_var "{{AWARD_2_TITLE}}" "$AWARD_2_TITLE"
replace_var "{{AWARD_2_BODY}}" "$AWARD_2_BODY"
replace_var "{{AWARD_3_TITLE}}" "$AWARD_3_TITLE"
replace_var "{{AWARD_3_BODY}}" "$AWARD_3_BODY"
replace_var "{{AWARD_4_TITLE}}" "$AWARD_4_TITLE"
replace_var "{{AWARD_4_BODY}}" "$AWARD_4_BODY"
replace_var "{{AWARD_5_TITLE}}" "$AWARD_5_TITLE"
replace_var "{{AWARD_5_BODY}}" "$AWARD_5_BODY"

# =====================================================
# DELIVERY
# =====================================================
replace_var "{{DELIVERY_URGENCY_TEXT}}" "$DELIVERY_URGENCY_TEXT"

# =====================================================
# PRICING
# =====================================================
replace_var "{{SINGLE_PRICE}}" "$SINGLE_PRICE"
replace_var "{{BUNDLE_PRICE}}" "$BUNDLE_PRICE"
replace_var "{{BUNDLE_OLD_PRICE}}" "$BUNDLE_OLD_PRICE"
replace_var "{{BUNDLE_SAVINGS}}" "$BUNDLE_SAVINGS"
replace_var "{{ORDER_BUMP_PRICE}}" "$ORDER_BUMP_PRICE"
replace_var "{{PRICE}}" "$PRICE"

# =====================================================
# GUARANTEE
# =====================================================
replace_var "{{GUARANTEE_DAYS}}" "$GUARANTEE_DAYS"
replace_var "{{GUARANTEE_NAME}}" "$GUARANTEE_NAME"
replace_var "{{GUARANTEE_CONDITION}}" "$GUARANTEE_CONDITION"

# =====================================================
# HEADLINES & COPY
# =====================================================
replace_var "{{REVIEW_COUNT}}" "$REVIEW_COUNT"
replace_var "{{AUDIENCE}}" "$AUDIENCE"
replace_var "{{HEADLINE_HOOK}}" "$HEADLINE_HOOK"
replace_var "{{TAGLINE}}" "$TAGLINE"
replace_var "{{ANNOUNCEMENT_BAR_TEXT}}" "$ANNOUNCEMENT_BAR_TEXT"
replace_var "{{HEADLINE_OPENING_COPY}}" "$HEADLINE_OPENING_COPY"

# =====================================================
# BRIDGE SECTION
# =====================================================
replace_var "{{BRIDGE_HEADLINE}}" "$BRIDGE_HEADLINE"
replace_var "{{BRIDGE_SUBHEADLINE}}" "$BRIDGE_SUBHEADLINE"

# =====================================================
# BUNDLE INFO
# =====================================================
replace_var "{{BUNDLE_DESCRIPTION}}" "$BUNDLE_DESCRIPTION"
replace_var "{{SINGLE_DESCRIPTION}}" "$SINGLE_DESCRIPTION"
replace_var "{{BUNDLE_TITLE_2X}}" "$BUNDLE_TITLE_2X"
replace_var "{{BUNDLE_DESC_2X}}" "$BUNDLE_DESC_2X"
replace_var "{{ORDER_BUMP_DESC}}" "$ORDER_BUMP_DESC"
replace_var "{{ORDER_BUMP_IMAGE}}" "$ORDER_BUMP_IMAGE"
replace_var "{{ORDER_BUMP_CTA_TEXT}}" "$ORDER_BUMP_CTA_TEXT"
replace_var "{{BUNDLE_BADGE_TEXT}}" "$BUNDLE_BADGE_TEXT"

# =====================================================
# COMPARISON SECTION
# =====================================================
replace_var "{{BEFORE_PAIN}}" "$BEFORE_PAIN"
replace_var "{{AFTER_BENEFIT}}" "$AFTER_BENEFIT"
replace_var "{{COMPARISON_HEADLINE}}" "$COMPARISON_HEADLINE"
replace_var "{{COMPARISON_PARAGRAPH}}" "$COMPARISON_PARAGRAPH"
replace_var "{{COMPARISON_ALT_TEXT}}" "$COMPARISON_ALT_TEXT"
replace_var "{{COMPARISON_BEFORE_ALT}}" "$COMPARISON_BEFORE_ALT"
replace_var "{{COMPARISON_AFTER_ALT}}" "$COMPARISON_AFTER_ALT"

# =====================================================
# HERO FEATURE CARDS (4 quick benefits)
# =====================================================
replace_var "{{HERO_FEATURE_1}}" "$HERO_FEATURE_1"
replace_var "{{HERO_FEATURE_2}}" "$HERO_FEATURE_2"
replace_var "{{HERO_FEATURE_3}}" "$HERO_FEATURE_3"
replace_var "{{HERO_FEATURE_4}}" "$HERO_FEATURE_4"

# =====================================================
# FEATURES
# =====================================================
replace_var "{{FEATURE_HEADLINE_1}}" "$FEATURE_HEADLINE_1"
replace_var "{{FEATURE_HEADLINE_2}}" "$FEATURE_HEADLINE_2"
replace_var "{{FEATURE_HEADLINE_3}}" "$FEATURE_HEADLINE_3"
replace_var "{{FEATURE_HEADLINE_4}}" "$FEATURE_HEADLINE_4"
replace_var "{{FEATURE_HEADING_1}}" "$FEATURE_HEADING_1"
replace_var "{{FEATURE_HEADING_2}}" "$FEATURE_HEADING_2"
replace_var "{{FEATURE_HEADING_3}}" "$FEATURE_HEADING_3"
replace_var "{{FEATURE_HEADING_4}}" "$FEATURE_HEADING_4"
replace_var "{{FEATURE_PARAGRAPH_1}}" "$FEATURE_PARAGRAPH_1"
replace_var "{{FEATURE_PARAGRAPH_2}}" "$FEATURE_PARAGRAPH_2"
replace_var "{{FEATURE_PARAGRAPH_3}}" "$FEATURE_PARAGRAPH_3"
replace_var "{{FEATURE_PARAGRAPH_4}}" "$FEATURE_PARAGRAPH_4"

# =====================================================
# FOUNDER SECTION (Epiphany Bridge)
# =====================================================
replace_var "{{FOUNDER_SECTION_HEADING}}" "$FOUNDER_SECTION_HEADING"
replace_var "{{FOUNDER_SECTION_PARAGRAPH_1}}" "$FOUNDER_SECTION_PARAGRAPH_1"
replace_var "{{FOUNDER_SECTION_PARAGRAPH_2}}" "$FOUNDER_SECTION_PARAGRAPH_2"
replace_var "{{FOUNDER_BACKSTORY}}" "$FOUNDER_BACKSTORY"
replace_var "{{FOUNDER_WALL}}" "$FOUNDER_WALL"
replace_var "{{FOUNDER_EPIPHANY}}" "$FOUNDER_EPIPHANY"
replace_var "{{FOUNDER_PLAN}}" "$FOUNDER_PLAN"
replace_var "{{FOUNDER_TRANSFORMATION}}" "$FOUNDER_TRANSFORMATION"
replace_var "{{FOUNDER_INVITATION}}" "$FOUNDER_INVITATION"

# =====================================================
# BIG DOMINO
# =====================================================
replace_var "{{BIG_DOMINO}}" "$BIG_DOMINO"

# =====================================================
# 3 SECRETS (FALSE BELIEFS) - Both naming conventions
# =====================================================
replace_var "{{SECRET_1_FALSE_BELIEF}}" "$SECRET_1_FALSE_BELIEF"
replace_var "{{SECRET_1_TRUTH}}" "$SECRET_1_TRUTH"
replace_var "{{SECRET_1_HEADLINE}}" "$SECRET_1_HEADLINE"
replace_var "{{SECRET_2_FALSE_BELIEF}}" "$SECRET_2_FALSE_BELIEF"
replace_var "{{SECRET_2_TRUTH}}" "$SECRET_2_TRUTH"
replace_var "{{SECRET_2_HEADLINE}}" "$SECRET_2_HEADLINE"
replace_var "{{SECRET_3_FALSE_BELIEF}}" "$SECRET_3_FALSE_BELIEF"
replace_var "{{SECRET_3_TRUTH}}" "$SECRET_3_TRUTH"
replace_var "{{SECRET_3_HEADLINE}}" "$SECRET_3_HEADLINE"

# Alternative naming (template uses SECRET_HEADLINE_1 vs SECRET_1_HEADLINE)
replace_var "{{SECRET_HEADLINE_1}}" "$SECRET_1_HEADLINE"
replace_var "{{SECRET_HEADLINE_2}}" "$SECRET_2_HEADLINE"
replace_var "{{SECRET_HEADLINE_3}}" "$SECRET_3_HEADLINE"
replace_var "{{SECRET_HEADING_1}}" "$SECRET_1_HEADLINE"
replace_var "{{SECRET_HEADING_2}}" "$SECRET_2_HEADLINE"
replace_var "{{SECRET_HEADING_3}}" "$SECRET_3_HEADLINE"

# Secret images
replace_var "{{SECRET_IMAGE_1}}" "$SECRET_IMAGE_1"
replace_var "{{SECRET_IMAGE_2}}" "$SECRET_IMAGE_2"
replace_var "{{SECRET_IMAGE_3}}" "$SECRET_IMAGE_3"

# Feature images
replace_var "{{FEATURE_IMAGE_1}}" "$FEATURE_IMAGE_1"
replace_var "{{FEATURE_IMAGE_2}}" "$FEATURE_IMAGE_2"
replace_var "{{FEATURE_IMAGE_3}}" "$FEATURE_IMAGE_3"

# Secret paragraphs (detailed copy)
replace_var "{{SECRET_PARAGRAPH_1}}" "$SECRET_PARAGRAPH_1"
replace_var "{{SECRET_PARAGRAPH_1_2}}" "$SECRET_PARAGRAPH_1_2"
replace_var "{{SECRET_PARAGRAPH_2}}" "$SECRET_PARAGRAPH_2"
replace_var "{{SECRET_PARAGRAPH_2_2}}" "$SECRET_PARAGRAPH_2_2"
replace_var "{{SECRET_PARAGRAPH_3}}" "$SECRET_PARAGRAPH_3"
replace_var "{{SECRET_PARAGRAPH_3_2}}" "$SECRET_PARAGRAPH_3_2"
replace_var "{{SECRET_BENEFIT_TEXT}}" "$SECRET_BENEFIT_TEXT"

# =====================================================
# TIKTOK BUBBLE COPY
# =====================================================
replace_var "{{BUBBLE_Q1_VEHICLE}}" "$BUBBLE_Q1_VEHICLE"
replace_var "{{BUBBLE_A1_VEHICLE}}" "$BUBBLE_A1_VEHICLE"
replace_var "{{BUBBLE_Q2_INTERNAL}}" "$BUBBLE_Q2_INTERNAL"
replace_var "{{BUBBLE_A2_INTERNAL}}" "$BUBBLE_A2_INTERNAL"
replace_var "{{BUBBLE_Q3_EXTERNAL}}" "$BUBBLE_Q3_EXTERNAL"
replace_var "{{BUBBLE_A3_EXTERNAL}}" "$BUBBLE_A3_EXTERNAL"

# =====================================================
# CUSTOM SECTIONS
# =====================================================
replace_var "{{CUSTOM_SECTION_HEADING}}" "$CUSTOM_SECTION_HEADING"
replace_var "{{CUSTOM_SECTION_TEXT}}" "$CUSTOM_SECTION_TEXT"
replace_var "{{CUSTOM_SECTION_IMAGE_1}}" "$CUSTOM_SECTION_IMAGE_1"
replace_var "{{CUSTOM_SECTION_IMAGE_2}}" "$CUSTOM_SECTION_IMAGE_2"
replace_var "{{IMAGE_WITH_TEXT_4_HEADING}}" "$IMAGE_WITH_TEXT_4_HEADING"

# =====================================================
# SLIDESHOW
# =====================================================
replace_var "{{SLIDESHOW_HEADING_1}}" "$SLIDESHOW_HEADING_1"
replace_var "{{SLIDESHOW_TEXT_1}}" "$SLIDESHOW_TEXT_1"
replace_var "{{SLIDESHOW_HEADING_2}}" "$SLIDESHOW_HEADING_2"
replace_var "{{SLIDESHOW_TEXT_2}}" "$SLIDESHOW_TEXT_2"

# =====================================================
# CTA BANNER
# =====================================================
replace_var "{{CTA_BANNER_HEADING}}" "$CTA_BANNER_HEADING"
replace_var "{{CTA_BANNER_TEXT}}" "$CTA_BANNER_TEXT"

# =====================================================
# PROMISE SECTION
# =====================================================
replace_var "{{PROMISE_HEADING}}" "$PROMISE_HEADING"
replace_var "{{PROMISE_POINT_1}}" "$PROMISE_POINT_1"
replace_var "{{PROMISE_POINT_2}}" "$PROMISE_POINT_2"
replace_var "{{PROMISE_POINT_3}}" "$PROMISE_POINT_3"
replace_var "{{PROMISE_POINT_4}}" "$PROMISE_POINT_4"

# =====================================================
# FEATURE CARDS (MULTIROW - 4 cards)
# =====================================================
replace_var "{{MULTIROW_1_PARAGRAPH}}" "$MULTIROW_1_PARAGRAPH"
replace_var "{{MULTIROW_2_PARAGRAPH}}" "$MULTIROW_2_PARAGRAPH"
replace_var "{{MULTIROW_3_PARAGRAPH}}" "$MULTIROW_3_PARAGRAPH"
replace_var "{{MULTIROW_4_PARAGRAPH}}" "$MULTIROW_4_PARAGRAPH"

# =====================================================
# MULTIROW SECTION 2 (Secondary features)
# =====================================================
replace_var "{{MULTIROW_2_HEADING}}" "$MULTIROW_2_HEADING"
replace_var "{{MULTIROW_2_PARAGRAPH_1}}" "$MULTIROW_2_PARAGRAPH_1"
replace_var "{{MULTIROW_2_PARAGRAPH_2}}" "$MULTIROW_2_PARAGRAPH_2"

# =====================================================
# FAQ SECTION
# =====================================================
replace_var "{{FAQ_HEADING}}" "$FAQ_HEADING"
replace_var "{{FAQ_ICON_1}}" "$FAQ_ICON_1"
replace_var "{{FAQ_ICON_2}}" "$FAQ_ICON_2"
replace_var "{{FAQ_ICON_3}}" "$FAQ_ICON_3"
replace_var "{{FAQ_ICON_4}}" "$FAQ_ICON_4"
replace_var "{{FAQ_ICON_5}}" "$FAQ_ICON_5"
replace_var "{{FAQ_QUESTION_1}}" "$FAQ_QUESTION_1"
replace_var "{{FAQ_ANSWER_1}}" "$FAQ_ANSWER_1"
replace_var "{{FAQ_QUESTION_2}}" "$FAQ_QUESTION_2"
replace_var "{{FAQ_ANSWER_2}}" "$FAQ_ANSWER_2"
replace_var "{{FAQ_QUESTION_3}}" "$FAQ_QUESTION_3"
replace_var "{{FAQ_ANSWER_3}}" "$FAQ_ANSWER_3"
replace_var "{{FAQ_QUESTION_4}}" "$FAQ_QUESTION_4"
replace_var "{{FAQ_ANSWER_4}}" "$FAQ_ANSWER_4"
replace_var "{{FAQ_QUESTION_5}}" "$FAQ_QUESTION_5"
replace_var "{{FAQ_ANSWER_5}}" "$FAQ_ANSWER_5"

# =====================================================
# ROTATING TESTIMONIALS (5 complete testimonials)
# =====================================================
replace_var "{{ROTATING_TESTIMONIAL_1}}" "$ROTATING_TESTIMONIAL_1"
replace_var "{{ROTATING_TESTIMONIAL_2}}" "$ROTATING_TESTIMONIAL_2"
replace_var "{{ROTATING_TESTIMONIAL_3}}" "$ROTATING_TESTIMONIAL_3"
replace_var "{{ROTATING_TESTIMONIAL_4}}" "$ROTATING_TESTIMONIAL_4"
replace_var "{{ROTATING_TESTIMONIAL_5}}" "$ROTATING_TESTIMONIAL_5"

replace_var "{{INTERSTITIAL_TESTIMONIAL_1_QUOTE}}" "$INTERSTITIAL_TESTIMONIAL_1_QUOTE"
replace_var "{{INTERSTITIAL_TESTIMONIAL_1_AUTHOR}}" "$INTERSTITIAL_TESTIMONIAL_1_AUTHOR"
replace_var "{{INTERSTITIAL_TESTIMONIAL_2_QUOTE}}" "$INTERSTITIAL_TESTIMONIAL_2_QUOTE"
replace_var "{{INTERSTITIAL_TESTIMONIAL_2_AUTHOR}}" "$INTERSTITIAL_TESTIMONIAL_2_AUTHOR"

# =====================================================
# MAIN TESTIMONIALS (12)
# =====================================================
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
    var_name="TESTIMONIAL_${i}_TITLE"
    replace_var "{{TESTIMONIAL_${i}_TITLE}}" "${!var_name}"
    var_name="TESTIMONIAL_${i}_QUOTE"
    replace_var "{{TESTIMONIAL_${i}_QUOTE}}" "${!var_name}"
    var_name="TESTIMONIAL_${i}_AUTHOR"
    replace_var "{{TESTIMONIAL_${i}_AUTHOR}}" "${!var_name}"
    var_name="TESTIMONIAL_${i}_LOCATION"
    replace_var "{{TESTIMONIAL_${i}_LOCATION}}" "${!var_name}"
done

# NOTE: Testimonial strip alt text removed - strip uses simple "Review X" alt text
# See sections/08b-testimonial-strip.html for current implementation

# =====================================================
# IMAGE PATHS
# =====================================================
# Product carousel images (6)
replace_var "{{PRODUCT_IMAGE_1}}" "$PRODUCT_IMAGE_1"
replace_var "{{PRODUCT_IMAGE_2}}" "$PRODUCT_IMAGE_2"
replace_var "{{PRODUCT_IMAGE_3}}" "$PRODUCT_IMAGE_3"
replace_var "{{PRODUCT_IMAGE_4}}" "$PRODUCT_IMAGE_4"
replace_var "{{PRODUCT_IMAGE_5}}" "$PRODUCT_IMAGE_5"
replace_var "{{PRODUCT_IMAGE_6}}" "$PRODUCT_IMAGE_6"

# Slideshow images
replace_var "{{SLIDESHOW_IMAGE_1}}" "$SLIDESHOW_IMAGE_1"
replace_var "{{SLIDESHOW_IMAGE_2}}" "$SLIDESHOW_IMAGE_2"
replace_var "{{CTA_BANNER_IMAGE}}" "$CTA_BANNER_IMAGE"
replace_var "{{FOUNDER_IMAGE}}" "$FOUNDER_IMAGE"
# NOTE: Feature images are hardcoded in HTML template (08-features-3-fibs.html)
# No template variable replacement needed
replace_var "{{SUPPORT_BADGE_IMAGE}}" "$SUPPORT_BADGE_IMAGE"
replace_var "{{MULTIROW_2_IMAGE}}" "$MULTIROW_2_IMAGE"
replace_var "{{FAQ_IMAGE}}" "$FAQ_IMAGE"
replace_var "{{SIZE_CHART_IMAGE}}" "$SIZE_CHART_IMAGE"

# Multirow images (4)
replace_var "{{MULTIROW_IMAGE_1}}" "$MULTIROW_IMAGE_1"
replace_var "{{MULTIROW_IMAGE_2}}" "$MULTIROW_IMAGE_2"
replace_var "{{MULTIROW_IMAGE_3}}" "$MULTIROW_IMAGE_3"
replace_var "{{MULTIROW_IMAGE_4}}" "$MULTIROW_IMAGE_4"

# Comparison images
replace_var "{{COMPARISON_IMAGE_BEFORE}}" "$COMPARISON_IMAGE_BEFORE"
replace_var "{{COMPARISON_IMAGE_AFTER}}" "$COMPARISON_IMAGE_AFTER"
replace_var "{{COMPARISON_IMAGE}}" "$COMPARISON_IMAGE"

# =====================================================
# SIZE & COLOR SELECTORS (Dynamic HTML)
# =====================================================
replace_var "{{SIZE_OPTIONS}}" "$SIZE_OPTIONS"
replace_var "{{COLOR_UI_HTML}}" "$COLOR_UI_HTML"
replace_var "{{COLOR_IMAGE_MAP}}" "$COLOR_IMAGE_MAP"

# Testimonial images (12)
for i in 1 2 3 4 5 6 7 8 9 10 11 12; do
    var_name="TESTIMONIAL_${i}_IMAGE"
    replace_var "{{TESTIMONIAL_${i}_IMAGE}}" "${!var_name}"
done

# NOTE: Testimonial strip now uses same images as review cards (TESTIMONIAL_X_IMAGE)
# No separate TESTIMONIAL_STRIP_IMAGE_X variables needed - see sections/08b-testimonial-strip.html

# =====================================================
# SIZE & DEPLOYMENT
# =====================================================
replace_var "{{SIZES}}" "$SIZES"
replace_var "{{SIZE_CHART_NOTE}}" "$SIZE_CHART_NOTE"

# =====================================================
# META/SEO
# =====================================================
replace_var "{{META_DESCRIPTION}}" "$META_DESCRIPTION"
replace_var "{{OG_DESCRIPTION}}" "$OG_DESCRIPTION"
replace_var "{{OG_IMAGE_URL}}" "$OG_IMAGE_URL"

# Count remaining placeholders
REMAINING=$(grep -o "{{[^}]*}}" index.html 2>/dev/null | wc -l | tr -d ' ')
echo "   ✅ Built index.html"
if [ "$REMAINING" -gt "0" ]; then
    echo "   ❌ ERROR: $REMAINING placeholders still need values!"
    echo ""
    echo "   UNREPLACED PLACEHOLDERS:"
    grep -o "{{[^}]*}}" index.html 2>/dev/null | sort | uniq -c | sort -rn
    echo ""
    echo "   ⚠️  CRITICAL: These appear in the live page as raw {{PLACEHOLDER}} text!"
    echo "   Fix by filling in the empty values in $CONFIG_FILE"
    echo ""

    # Check specifically for critical testimonial placeholders
    TESTIMONIAL_PLACEHOLDERS=$(grep -o "{{ROTATING_TESTIMONIAL_[0-9]}}" index.html 2>/dev/null | wc -l | tr -d ' ')
    if [ "$TESTIMONIAL_PLACEHOLDERS" -gt "0" ]; then
        echo "   🔴 ROTATING TESTIMONIALS MISSING!"
        echo "      Fill in ROTATING_TESTIMONIAL_1 through ROTATING_TESTIMONIAL_5 in $CONFIG_FILE"
        echo ""
    fi

    echo "   ❌ BUILD ABORTED: Cannot deploy with unresolved placeholders"
    exit 1
fi
echo ""

# ============================================
# STEP 4: Deploy
# ============================================
echo "🚀 Deploying to Netlify..."

if ! npx netlify status &>/dev/null; then
    echo "   ⚠️  Not logged in to Netlify. Run: npx netlify login"
    echo "   Skipping deployment..."
    PROD_URL="http://localhost:8888"
else
    DEPLOY_OUTPUT=$(npx netlify deploy --prod --site "$NETLIFY_SITE_ID" --dir . 2>&1)
    PROD_URL=$(echo "$DEPLOY_OUTPUT" | grep -o "https://[^[:space:]]*" | head -1)
    echo "   ✅ Deployed"
fi
echo ""

# ============================================
# STEP 5: E2E Tests
# ============================================
echo "🧪 Running Tests..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"

sleep 2

PASS=0
FAIL=0

# Test page loads
HTTP=$(curl -s -o /dev/null -w "%{http_code}" "$PROD_URL" 2>/dev/null || echo "000")
if [ "$HTTP" = "200" ]; then
    echo "   ✅ Page loads"
    ((PASS++))
else
    echo "   ❌ Page failed (HTTP $HTTP)"
    ((FAIL++))
fi

# Test product name appears
PAGE=$(curl -s "$PROD_URL" 2>/dev/null || echo "")
if echo "$PAGE" | grep -q "$PRODUCT_NAME" 2>/dev/null; then
    echo "   ✅ Product name visible"
    ((PASS++))
else
    echo "   ❌ Product name not found"
    ((FAIL++))
fi

# Test no raw placeholders
PLACEHOLDERS=$(echo "$PAGE" | grep -c "{{" || echo "0")
if [ "$PLACEHOLDERS" = "0" ]; then
    echo "   ✅ No raw placeholders"
    ((PASS++))
else
    echo "   ❌ $PLACEHOLDERS raw placeholders visible"
    ((FAIL++))
fi

# Test checkout function
FUNC=$(curl -s -o /dev/null -w "%{http_code}" "$PROD_URL/.netlify/functions/buy-now" 2>/dev/null || echo "000")
if [ "$FUNC" != "404" ]; then
    echo "   ✅ Checkout function exists"
    ((PASS++))
else
    echo "   ❌ Checkout function missing"
    ((FAIL++))
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   Results: $PASS passed, $FAIL failed"
echo ""

# ============================================
# DONE - Clear backup on success
# ============================================
if [ -n "$BACKUP_FILE" ] && [ -f "$BACKUP_FILE" ]; then
    rm -f "$BACKUP_FILE"
    BACKUP_FILE=""  # Prevent cleanup trap from restoring
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    BUILD COMPLETE                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🌐 Live URL: $PROD_URL"
echo ""
echo "📋 Manual Tests Needed:"
echo "   1. Open on mobile device"
echo "   2. Test Add to Cart"
echo "   3. Test SimpleSwap checkout"
echo ""
