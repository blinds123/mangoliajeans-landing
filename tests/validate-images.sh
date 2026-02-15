#!/bin/bash
# Validate images are optimized to WebP format

set -e

echo "Validating image optimization..."

# TEMPLATE MODE: Check if we're in template state (no BRAND-AVATAR-*.md exists)
IS_TEMPLATE=0
if [ ! -f "$(ls BRAND-AVATAR-*.md 2>/dev/null | head -1)" ]; then
  IS_TEMPLATE=1
  echo "ℹ️  Template mode detected - using relaxed thresholds"
  echo ""
fi

# Count remaining JPG/PNG files
JPG_COUNT=$(find images/ -name "*.jpg" -o -name "*.jpeg" 2>/dev/null | wc -l)
PNG_COUNT=$(find images/ -name "*.png" 2>/dev/null | wc -l)

if [ "$JPG_COUNT" -gt 0 ] || [ "$PNG_COUNT" -gt 0 ]; then
  echo "FAIL: Unoptimized images found"
  echo "JPG files: $JPG_COUNT"
  echo "PNG files: $PNG_COUNT"
  echo ""
  echo "FIX: Run python3 optimize_images.py to convert to WebP"
  exit 1
fi
echo "✓ No JPG/PNG files remain"

# Count WebP files
WEBP_COUNT=$(find images/ -name "*.webp" 2>/dev/null | wc -l)
if [ "$IS_TEMPLATE" -eq 1 ]; then
  # Template mode: relaxed minimum (just need some images for testing)
  if [ "$WEBP_COUNT" -lt 8 ]; then
    echo "INFO: Only $WEBP_COUNT WebP images found (template minimum: 8)"
  fi
else
  # Production mode: full image set required
  if [ "$WEBP_COUNT" -lt 34 ]; then
    echo "WARNING: Only $WEBP_COUNT WebP images found, expected 34+"
    echo "May be missing required images"
  fi
fi
echo "✓ WebP images: $WEBP_COUNT"

# Check for large images (over 150KB)
LARGE_IMAGES=$(find images/ -name "*.webp" -size +150k 2>/dev/null)
if [ -n "$LARGE_IMAGES" ]; then
  echo "WARNING: Some images are over 150KB:"
  echo "$LARGE_IMAGES"
  echo "Consider further compression for faster loading"
fi

# Check required image directories exist
REQUIRED_DIRS=("images/product" "images/testimonials" "images/comparison" "images/founder" "images/order-bump" "images/awards" "images/universal")
for dir in "${REQUIRED_DIRS[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "FAIL: Required directory missing: $dir"
    echo "FIX: Create directory and add images"
    exit 1
  fi
done
echo "✓ All required image directories exist"

# === ANTIGRAVITY: Check for banned mappings in product.config ===
if [ -f "product.config" ]; then
  echo ""
  echo "Checking image mappings..."

  # Check product images are used for hero
  if grep -E "HERO_IMAGE.*testimonial" product.config 2>/dev/null; then
    echo "FAIL: Banned mapping - testimonial images in HERO"
    echo "FIX: Hero images must come from images/product/"
    exit 1
  fi

  echo "✓ No banned image mappings detected"
fi

# Check minimum images per folder
echo ""
echo "Checking image counts..."
PRODUCT_COUNT=$(find images/product -type f -name "*.webp" 2>/dev/null | wc -l | tr -d ' ')
TESTIMONIAL_COUNT=$(find images/testimonials -type f -name "*.webp" 2>/dev/null | wc -l | tr -d ' ')
FOUNDER_COUNT=$(find images/founder -type f -name "*.webp" 2>/dev/null | wc -l | tr -d ' ')
COMPARISON_COUNT=$(find images/comparison -type f -name "*.webp" 2>/dev/null | wc -l | tr -d ' ')
ORDER_BUMP_COUNT=$(find images/order-bump -type f -name "*.webp" 2>/dev/null | wc -l | tr -d ' ')

if [ "$IS_TEMPLATE" -eq 1 ]; then
  # Template mode: informational only with relaxed thresholds
  if [ "$PRODUCT_COUNT" -lt 3 ]; then
    echo "INFO: Found $PRODUCT_COUNT product images (template minimum: 3)"
  fi
  if [ "$TESTIMONIAL_COUNT" -lt 5 ]; then
    echo "INFO: Found $TESTIMONIAL_COUNT testimonial images (template minimum: 5)"
  fi
  if [ "$COMPARISON_COUNT" -lt 1 ]; then
    echo "INFO: No comparison image in images/comparison/ (optional for template)"
  fi
  if [ "$ORDER_BUMP_COUNT" -lt 1 ]; then
    echo "INFO: No order bump image in images/order-bump/ (optional for template)"
  fi
  # Founder is optional in template mode
  if [ "$FOUNDER_COUNT" -lt 1 ]; then
    echo "INFO: No founder image in images/founder/ (optional for template)"
  fi
else
  # Production mode: strict requirements
  if [ "$PRODUCT_COUNT" -lt 6 ]; then
    echo "WARNING: Need 6 product images for hero carousel, found $PRODUCT_COUNT"
  fi
  if [ "$TESTIMONIAL_COUNT" -lt 25 ]; then
    echo "WARNING: Need 25 testimonial images, found $TESTIMONIAL_COUNT"
  fi
  if [ "$COMPARISON_COUNT" -lt 1 ]; then
    echo "WARNING: Need comparison image in images/comparison/"
  fi
  if [ "$ORDER_BUMP_COUNT" -lt 1 ]; then
    echo "WARNING: Need order bump image in images/order-bump/"
  fi
  if [ "$FOUNDER_COUNT" -lt 1 ]; then
    echo "WARNING: Need founder image in images/founder/"
  fi
fi

echo ""
echo "PASS: Images validated ✓"
exit 0
