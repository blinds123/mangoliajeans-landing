#!/bin/bash
# Speed Optimization Script for Landing Page Template
# Run this BEFORE deploying to optimize all images

echo "🚀 Starting Speed Optimization..."

# Check for required tools
if ! command -v cwebp &> /dev/null; then
    echo "⚠️  cwebp not found. Installing via Homebrew..."
    brew install webp
fi

# Image directories
DIRS=("images/product" "images/testimonials" "images/comparison" "images/order-bump" "images/awards" "images/universal")

# Optimize PNG images
echo "📦 Compressing PNG images..."
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        for file in "$dir"/*.png; do
            if [ -f "$file" ]; then
                # Get original size
                original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
                
                # Convert to WebP (creates new file)
                webp_file="${file%.png}.webp"
                cwebp -q 80 "$file" -o "$webp_file" 2>/dev/null
                
                if [ -f "$webp_file" ]; then
                    new_size=$(stat -f%z "$webp_file" 2>/dev/null || stat -c%s "$webp_file")
                    savings=$((100 - (new_size * 100 / original_size)))
                    echo "  ✅ $file → $webp_file (${savings}% smaller)"
                fi
            fi
        done
    fi
done

# Check total image sizes
echo ""
echo "📊 Image Size Report:"
total_png=$(find images -name "*.png" -exec stat -f%z {} \; 2>/dev/null | awk '{s+=$1} END {print s}')
total_webp=$(find images -name "*.webp" -exec stat -f%z {} \; 2>/dev/null | awk '{s+=$1} END {print s}')

echo "  PNG total: $((total_png / 1024))KB"
echo "  WebP total: $((total_webp / 1024))KB"

echo ""
echo "✅ Speed optimization complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Update image references in HTML to use .webp files"
echo "  2. Or keep .png files and let Netlify's image CDN handle conversion"
echo ""
echo "🎯 Target metrics:"
echo "  - Mobile First Contentful Paint: < 1.5s"
echo "  - Mobile Largest Contentful Paint: < 2.5s"
echo "  - Total page weight: < 2MB"
