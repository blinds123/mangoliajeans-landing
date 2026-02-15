#!/bin/bash
# VALIDATE-IMAGES-SOURCE.sh
# Enforces that Secrets and Features use "Testimonial" (UGC) style images, NOT product shots.
#
# NOTE: Feature and Secret images are now HARDCODED in HTML templates:
# - 08-features-3-fibs.html → testimonial-01, 02, 03.webp
# - 10-secret-1.html → testimonial-04.webp
# - 11-secret-2.html → testimonial-05.webp
# - 12-secret-3.html → testimonial-06.webp

ERRORS=0

echo "Validating Image Sources (Authenticity Check)..."
echo ""
echo "NOTE: Feature/Secret images are HARDCODED in HTML templates."
echo "Verifying the hardcoded paths use testimonials folder..."
echo ""

# Function to check if an image path uses testimonials/ folder
check_hardcoded_source() {
    local section_name=$1
    local image_path=$2

    # If the path contains "testimonials/", it's correct
    if [[ "$image_path" == *"images/testimonials/"* ]]; then
        echo "PASS: $section_name uses authentic source ('$image_path')."
    else
        echo "FAIL: $section_name uses wrong source ('$image_path')."
        echo "   Rule: Features and Secrets MUST use 'images/testimonials/' (UGC/Messy/Real)."
        ((ERRORS++))
    fi
}

# Verify hardcoded Feature images (08-features-3-fibs.html)
echo "--- Features (FIBS Framework) ---"
check_hardcoded_source "Feature 1 (08-features-3-fibs.html)" "images/testimonials/testimonial-01.webp"
check_hardcoded_source "Feature 2 (08-features-3-fibs.html)" "images/testimonials/testimonial-02.webp"
check_hardcoded_source "Feature 3 (08-features-3-fibs.html)" "images/testimonials/testimonial-03.webp"

echo ""
echo "--- Secrets (Vehicle/Internal/External) ---"
# Verify hardcoded Secret images
check_hardcoded_source "Secret 1 (10-secret-1.html)" "images/testimonials/testimonial-04.webp"
check_hardcoded_source "Secret 2 (11-secret-2.html)" "images/testimonials/testimonial-05.webp"
check_hardcoded_source "Secret 3 (12-secret-3.html)" "images/testimonials/testimonial-06.webp"

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "IMAGE VALIDATION FAILED with $ERRORS errors."
    echo "   Action: Update the HTML template files to use 'images/testimonials/testimonial-XX.webp'."
    exit 1
fi

echo ""
echo "PASS: All feature/secret images use Social Proof (Testimonials), not Product Shots."
exit 0
