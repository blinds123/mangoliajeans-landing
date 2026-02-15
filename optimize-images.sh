#!/bin/bash
# optimize-images.sh
# Converts all PNG/JPG images to WebP format for faster loading
# Usage: ./optimize-images.sh

echo "🚀 Starting image optimization..."
echo ""

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "❌ cwebp not found. Installing via Homebrew..."
    brew install webp
fi

# Find and convert PNG files
PNG_COUNT=0
for file in $(find images -type f -name "*.png" 2>/dev/null); do
    output="${file%.png}.webp"
    if [ ! -f "$output" ]; then
        echo "Converting: $file → $output"
        cwebp -q 80 "$file" -o "$output" 2>/dev/null
        ((PNG_COUNT++))
    fi
done

# Find and convert JPG/JPEG files
JPG_COUNT=0
for file in $(find images -type f \( -name "*.jpg" -o -name "*.jpeg" \) 2>/dev/null); do
    output="${file%.*}.webp"
    if [ ! -f "$output" ]; then
        echo "Converting: $file → $output"
        cwebp -q 80 "$file" -o "$output" 2>/dev/null
        ((JPG_COUNT++))
    fi
done

echo ""
echo "✅ Optimization complete!"
echo "   - PNG files converted: $PNG_COUNT"
echo "   - JPG files converted: $JPG_COUNT"
echo ""

# Show size comparison
echo "📊 Size comparison:"
PNG_SIZE=$(find images -name "*.png" -exec du -ch {} + 2>/dev/null | tail -1 | cut -f1)
JPG_SIZE=$(find images -name "*.jpg" -exec du -ch {} + 2>/dev/null | tail -1 | cut -f1)
WEBP_SIZE=$(find images -name "*.webp" -exec du -ch {} + 2>/dev/null | tail -1 | cut -f1)
echo "   - Original (PNG): ${PNG_SIZE:-0}"
echo "   - Original (JPG): ${JPG_SIZE:-0}"
echo "   - Optimized (WebP): ${WEBP_SIZE:-0}"
echo ""

# Reminder to update HTML
echo "⚠️  NEXT STEP: Update your HTML files to use .webp extensions"
echo "   Run this command to find files needing updates:"
echo ""
echo '   grep -rn "\.png\|\.jpg" sections/*.html | grep -v "loading"'
echo ""
