#!/bin/bash
# Self-Healing: Fix Broken Images
# Automatically detects and fixes image issues

set -e

echo "=== SELF-HEALING: Broken Images ==="

# Configuration
IMAGES_DIR="${1:-images}"
BUILD_DIR="${2:-.}"

# Check if images directory exists
if [ ! -d "$IMAGES_DIR" ]; then
  echo "ERROR: Images directory '$IMAGES_DIR' not found"
  echo "FIX: Creating images directory structure..."
  mkdir -p "$IMAGES_DIR"/{hero,testimonials,comparison,product,lifestyle}
  echo "Created: $IMAGES_DIR with subdirectories"
fi

# Count images
IMAGE_COUNT=$(find "$IMAGES_DIR" -type f \( -name "*.webp" -o -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) 2>/dev/null | wc -l | tr -d ' ')
echo "Found $IMAGE_COUNT images in $IMAGES_DIR"

if [ "$IMAGE_COUNT" -lt 35 ]; then
  echo "WARNING: Expected 35+ images, found $IMAGE_COUNT"
  echo ""
  echo "REQUIRED IMAGE STRUCTURE:"
  echo "  images/hero/        - Hero section images"
  echo "  images/testimonials/ - 25 testimonial images"
  echo "  images/comparison/  - Before/after images"
  echo "  images/product/     - Product shots"
  echo "  images/lifestyle/   - Lifestyle images"
  echo ""
  echo "FIX ACTIONS:"
  echo "1. Add more images to the images/ directory"
  echo "2. Or run: /whisk-prompter to generate image prompts"
  exit 0
fi

# Convert non-WebP images to WebP
echo ""
echo "Checking for non-WebP images to convert..."
NON_WEBP=$(find "$IMAGES_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) 2>/dev/null | wc -l | tr -d ' ')

if [ "$NON_WEBP" -gt 0 ]; then
  echo "Found $NON_WEBP non-WebP images"

  # Check if cwebp is available
  if command -v cwebp &> /dev/null; then
    echo "Converting to WebP..."
    find "$IMAGES_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | while read img; do
      output="${img%.*}.webp"
      if [ ! -f "$output" ]; then
        echo "  Converting: $img -> $output"
        cwebp -q 85 "$img" -o "$output" 2>/dev/null
      fi
    done
    echo "Conversion complete"
  else
    echo "WARNING: cwebp not installed"
    echo "FIX: brew install webp"
    echo "Or use online converter for images"
  fi
else
  echo "All images are already WebP format"
fi

# Check for broken image references in HTML
echo ""
echo "Checking HTML for broken image references..."

if [ -f "$BUILD_DIR/index.html" ]; then
  # Extract all image sources
  BROKEN_COUNT=0

  grep -oE 'src="[^"]*\.(webp|jpg|png|jpeg)"' "$BUILD_DIR/index.html" 2>/dev/null | while read src_attr; do
    img_path=$(echo "$src_attr" | sed 's/src="//;s/"//')

    # Handle relative paths
    if [[ "$img_path" != /* ]]; then
      full_path="$BUILD_DIR/$img_path"
    else
      full_path="$img_path"
    fi

    if [ ! -f "$full_path" ]; then
      echo "  BROKEN: $img_path"
      BROKEN_COUNT=$((BROKEN_COUNT + 1))
    fi
  done

  if [ "$BROKEN_COUNT" -gt 0 ]; then
    echo ""
    echo "FIX ACTIONS for broken references:"
    echo "1. Verify image files exist at referenced paths"
    echo "2. Check product.config IMAGE variables"
    echo "3. Re-run build after fixing paths"
  else
    echo "All image references are valid"
  fi
else
  echo "No index.html found - run build first"
fi

# Check image file sizes
echo ""
echo "Checking image file sizes..."
LARGE_IMAGES=$(find "$IMAGES_DIR" -type f -size +500k \( -name "*.webp" -o -name "*.jpg" -o -name "*.png" \) 2>/dev/null)

if [ -n "$LARGE_IMAGES" ]; then
  echo "WARNING: Found large images (>500KB):"
  echo "$LARGE_IMAGES" | while read img; do
    size=$(du -h "$img" | cut -f1)
    echo "  $size - $img"
  done
  echo ""
  echo "FIX: Re-compress with higher compression:"
  echo "  cwebp -q 75 input.webp -o output.webp"
else
  echo "All images are reasonably sized (<500KB)"
fi

echo ""
echo "=== Image Check Complete ==="
