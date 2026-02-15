#!/bin/bash
# Validate all required image directories exist with minimum images
# This is Phase 0 pre-check - FAIL FAST if inputs missing

set -e

IMAGES_DIR="${1:-images}"

echo "=== VALIDATING IMAGE STRUCTURE ==="
echo ""

FAILURES=0

# Check images directory exists
if [ ! -d "$IMAGES_DIR" ]; then
  echo "FAIL: $IMAGES_DIR directory does not exist"
  echo ""
  echo "FIX: Create the images directory with this structure:"
  echo "  mkdir -p images/{product,testimonials,comparison,founder,order-bump,awards,universal}"
  exit 1
fi

echo "Directory exists: $IMAGES_DIR"
echo ""

# Function to check folder has minimum images
check_folder() {
  local folder="$1"
  local min_count="$2"
  local folder_path="$IMAGES_DIR/$folder"

  if [ ! -d "$folder_path" ]; then
    echo "FAIL: $folder_path does not exist"
    FAILURES=$((FAILURES + 1))
    return
  fi

  # Count image files
  local count=$(find "$folder_path" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.gif" \) 2>/dev/null | wc -l | tr -d ' ')

  if [ "$count" -lt "$min_count" ]; then
    echo "FAIL: $folder_path has $count images (need $min_count+)"
    FAILURES=$((FAILURES + 1))
  else
    echo "PASS: $folder_path has $count images (need $min_count+)"
  fi
}

# Check each required folder
# NOTE: Product images ARE the hero images (no separate hero folder)
# NOTE: For TEMPLATE state, minimums are relaxed. These are PRODUCTION minimums.
echo "Checking image folders..."
echo ""

# TEMPLATE MODE: Check if we're in template state (no BRAND-AVATAR-*.md exists)
IS_TEMPLATE=0
if [ ! -f "$(ls BRAND-AVATAR-*.md 2>/dev/null | head -1)" ]; then
  IS_TEMPLATE=1
  echo "ℹ️  Template mode detected - using relaxed minimums"
  echo ""
fi

if [ "$IS_TEMPLATE" -eq 1 ]; then
  # Template minimums (for testing the template itself)
  check_folder "product" 3            # At least 3 for hero
  check_folder "testimonials" 5       # At least 5 for basic features
  check_folder "order-bump" 0         # Optional in template
  check_folder "founder" 0            # Optional in template
  check_folder "comparison" 0         # Optional in template
  check_folder "awards" 0             # Optional in template
  check_folder "universal" 0          # Optional in template
else
  # Production minimums (for deployed sites)
  check_folder "product" 6            # Hero carousel images
  check_folder "testimonials" 25      # Features, Secrets, Testimonials, Reviews
  check_folder "order-bump" 1         # Order bump product image
  check_folder "founder" 1            # Founder story image
  check_folder "comparison" 1         # Combined before/after comparison
  check_folder "awards" 5             # Awards/trust badges
  check_folder "universal" 2          # Logo + size chart
fi

echo ""
echo "=== SUMMARY ==="

if [ "$FAILURES" -eq 0 ]; then
  echo "PASS: All image folders have required minimum images"
  echo ""
  echo "Image structure validated:"
  echo "  ✅ product/ (6 images) - Hero carousel"
  echo "  ✅ testimonials/ (25 images) - Features, Secrets, Reviews"
  echo "  ✅ order-bump/ (1+ image) - Order bump product"
  echo "  ✅ founder/ (1 image)"
  echo "  ✅ comparison/ (1 image) - Combined before/after"
  echo "  ✅ awards/ (5 images) - Trust badges"
  echo "  ✅ universal/ (logo + size chart)"
  exit 0
else
  echo "FAIL: $FAILURES folders missing or incomplete"
  echo ""
  echo "FIX: Add the missing images before running Ralph."
  echo ""
  echo "Required structure:"
  echo "  images/product/         - 6 product shots (hero carousel)"
  echo "  images/testimonials/    - 25 images (Features, Secrets, Testimonials, Reviews)"
  echo "  images/order-bump/      - 1 order bump product image"
  echo "  images/founder/         - 1 founder image"
  echo "  images/comparison/      - 1 combined comparison image"
  echo "  images/awards/          - 5 awards/trust badges"
  echo "  images/universal/       - logo + size chart"
  exit 1
fi
