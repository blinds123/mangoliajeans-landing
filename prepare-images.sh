#!/bin/bash
# prepare-images.sh - Auto-convert and rename images to correct naming convention
# Usage: ./prepare-images.sh
#
# This script:
# 1. Skips images that are ALREADY correctly named (product-01.webp, etc.)
# 2. Converts any new jpg/jpeg/png to webp
# 3. Renames new images sequentially starting from next available number

echo "🖼️  Preparing images..."
echo ""

# Enable nullglob so patterns that match nothing expand to nothing
shopt -s nullglob

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "❌ cwebp not found. Installing via Homebrew..."
    brew install webp || { echo "Failed to install webp. Please install manually."; exit 1; }
fi

# Function to find next available number for a prefix
get_next_number() {
    local dir=$1
    local prefix=$2
    local max=0

    for f in "$dir"/${prefix}-*.webp; do
        [ -f "$f" ] || continue
        num=$(basename "$f" | sed "s/${prefix}-0*\([0-9]*\)\.webp/\1/")
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -gt "$max" ]; then
            max=$num
        fi
    done
    echo $((max + 1))
}

# Function to check if file matches the naming pattern
is_correctly_named() {
    local file=$1
    local prefix=$2
    local bn=$(basename "$file")
    [[ "$bn" =~ ^${prefix}-[0-9]+\.webp$ ]]
}

# Function to convert and rename images in a directory
convert_and_rename() {
    local dir=$1
    local prefix=$2

    if [ ! -d "$dir" ]; then
        echo "  Skipping $dir (not found)"
        return
    fi

    local start_num=$(get_next_number "$dir" "$prefix")
    local i=$start_num
    local processed=0

    pushd "$dir" > /dev/null

    # Count correctly named files
    local existing=0
    for f in ${prefix}-*.webp; do
        [ -f "$f" ] && ((existing++))
    done
    [ $existing -gt 0 ] && echo "  Found $existing existing ${prefix}-XX.webp files"

    # Process jpg/jpeg/png files
    for f in *.jpg *.jpeg *.png *.PNG *.JPG *.JPEG; do
        [ -f "$f" ] || continue
        local output="${prefix}-$(printf %02d $i).webp"
        if cwebp -q 85 "$f" -o "$output" 2>/dev/null; then
            echo "  ✓ $f → $output (converted)"
            rm "$f"
            ((i++))
            ((processed++))
        else
            echo "  ✗ Failed to convert $f"
        fi
    done

    # Process webp files that don't match naming pattern
    for f in *.webp *.WEBP; do
        [ -f "$f" ] || continue
        is_correctly_named "$f" "$prefix" && continue
        local output="${prefix}-$(printf %02d $i).webp"
        mv "$f" "$output" && echo "  ✓ $f → $output (renamed)" && ((i++)) && ((processed++))
    done

    popd > /dev/null

    [ $processed -eq 0 ] && echo "  ✓ All images already correctly named"
}

# Process each directory
echo "📦 Processing product images..."
convert_and_rename "images/product" "product"

echo ""
echo "👥 Processing testimonial images..."
convert_and_rename "images/testimonials" "testimonial"

echo ""
echo "👤 Processing founder image..."
convert_and_rename "images/founder" "founder"

echo ""
echo "⚖️  Processing comparison images..."
if [ -d "images/comparison" ]; then
    pushd "images/comparison" > /dev/null

    if [ -f "comparison-01.webp" ]; then
        echo "  ✓ comparison-01.webp exists"
    else
        # Prefer existing webp, otherwise convert first jpg/png to comparison-01.webp
        for f in *.webp *.WEBP; do
            [ -f "$f" ] || continue
            mv "$f" "comparison-01.webp" && echo "  ✓ $f → comparison-01.webp (renamed)"
            break
        done

        if [ ! -f "comparison-01.webp" ]; then
            for f in *.jpg *.jpeg *.png *.PNG *.JPG *.JPEG; do
                [ -f "$f" ] || continue
                cwebp -q 85 "$f" -o "comparison-01.webp" 2>/dev/null && rm "$f" && echo "  ✓ $f → comparison-01.webp (converted)"
                break
            done
        fi
    fi

    popd > /dev/null
fi

echo ""
echo "🛒 Processing order bump image..."
convert_and_rename "images/order-bump" "order-bump"

echo ""
echo "🏆 Processing awards images..."
if [ -d "images/awards" ]; then
    pushd "images/awards" > /dev/null

    existing=0
    for f in awards-*.webp; do
        [ -f "$f" ] && ((existing++))
    done
    [ $existing -gt 0 ] && echo "  Found $existing existing awards files"

    i=1
    for f in *.jpg *.jpeg *.png; do
        [ -f "$f" ] || continue
        while [ -f "awards-$i.webp" ]; do ((i++)); done
        output="awards-$i.webp"
        cwebp -q 85 "$f" -o "$output" 2>/dev/null && rm "$f" && echo "  ✓ $f → $output" && ((i++))
    done

    popd > /dev/null
fi

echo ""
echo "✅ Image preparation complete!"
echo ""

# Show remaining jpg/png count
JPG_COUNT=$(find images -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) 2>/dev/null | wc -l | tr -d ' ')
if [ "$JPG_COUNT" -gt 0 ]; then
    echo "⚠️  Found $JPG_COUNT original jpg/png files remaining"
    echo "   To delete: find images -type f \\( -name '*.jpg' -o -name '*.png' \\) -delete"
    echo ""
fi

echo "📋 Expected structure:"
echo "   images/product/product-01.webp through product-06.webp"
echo "   images/testimonials/testimonial-01.webp through testimonial-XX.webp"
echo "   images/founder/founder-01.webp"
echo "   images/comparison/comparison-01.webp"
echo "   images/order-bump/order-bump-01.webp"
echo "   images/awards/awards-1.webp through awards-5.webp"
echo ""
echo "🔧 Next: Run ./build.sh"
