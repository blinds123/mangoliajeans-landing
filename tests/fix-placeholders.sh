#!/bin/bash
# Self-Healing: Fix Remaining Placeholders
# Detects and reports unfilled template variables

set -e

echo "=== SELF-HEALING: Placeholders ==="

BUILD_DIR="${1:-.}"
CONFIG_FILE="${2:-product.config}"

# Find all placeholders in HTML files
echo "Scanning for unfilled placeholders..."

PLACEHOLDER_COUNT=0
PLACEHOLDER_LIST=""

for html_file in "$BUILD_DIR"/*.html "$BUILD_DIR"/sections/*.html 2>/dev/null; do
  if [ -f "$html_file" ]; then
    # Find {{VARIABLE}} patterns
    FOUND=$(grep -oE '\{\{[A-Z_0-9]+\}\}' "$html_file" 2>/dev/null | sort -u)
    if [ -n "$FOUND" ]; then
      echo ""
      echo "File: $html_file"
      echo "$FOUND" | while read placeholder; do
        echo "  UNFILLED: $placeholder"
        PLACEHOLDER_COUNT=$((PLACEHOLDER_COUNT + 1))
      done
      PLACEHOLDER_LIST="$PLACEHOLDER_LIST $FOUND"
    fi
  fi
done

if [ "$PLACEHOLDER_COUNT" -eq 0 ]; then
  echo "No unfilled placeholders found!"
  echo "=== All variables replaced ==="
  exit 0
fi

echo ""
echo "=== FIXING PLACEHOLDERS ==="

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Config file '$CONFIG_FILE' not found"
  echo ""
  echo "FIX: Create product.config with all required variables"
  echo ""
  echo "REQUIRED VARIABLES:"
  echo "$PLACEHOLDER_LIST" | tr ' ' '\n' | sort -u | while read var; do
    if [ -n "$var" ]; then
      # Strip {{ and }}
      var_name=$(echo "$var" | sed 's/{{//;s/}}//')
      echo "  $var_name="
    fi
  done
  exit 0
fi

# Check which variables are missing from config
echo "Checking config file for missing variables..."
echo ""

MISSING_VARS=""
echo "$PLACEHOLDER_LIST" | tr ' ' '\n' | sort -u | while read var; do
  if [ -n "$var" ]; then
    var_name=$(echo "$var" | sed 's/{{//;s/}}//')
    if ! grep -q "^${var_name}=" "$CONFIG_FILE" 2>/dev/null; then
      echo "MISSING in config: $var_name"
      MISSING_VARS="$MISSING_VARS $var_name"
    else
      # Check if value is empty or placeholder
      VALUE=$(grep "^${var_name}=" "$CONFIG_FILE" | cut -d'=' -f2-)
      if [ -z "$VALUE" ] || [[ "$VALUE" == *"[FILL"* ]] || [[ "$VALUE" == *"TODO"* ]]; then
        echo "EMPTY/TODO in config: $var_name"
      fi
    fi
  fi
done

echo ""
echo "=== FIX ACTIONS ==="
echo ""
echo "1. Open product.config and fill in missing values"
echo "2. Run build script again to replace placeholders"
echo "3. Re-run this check to verify"
echo ""
echo "COMMON MISSING VARIABLES:"
echo ""
cat << 'VARS'
# Product Info
PRODUCT_NAME=Your Product Name
PRODUCT_TAGLINE=The one-liner that hooks
PRICE=19
ORDER_BUMP_PRICE=10
TOTAL_PRICE=29

# Big Domino (The ONE belief)
BIG_DOMINO_HEADLINE=The one thing they need to believe
BIG_DOMINO_SUBHEAD=Why this changes everything

# 3 Secrets (Vehicle, Internal, External)
SECRET_1_HEADLINE=Vehicle: What they need
SECRET_2_HEADLINE=Internal: Their capability
SECRET_3_HEADLINE=External: What's stopping them

# Social Proof
TESTIMONIAL_1_NAME=Sarah M.
TESTIMONIAL_1_QUOTE=This changed my life in 30 days!
# ... repeat for all 25 testimonials

# Images
HERO_IMAGE=images/hero/main.webp
COMPARISON_BAD_IMAGE=images/comparison/before.webp
COMPARISON_GOOD_IMAGE=images/comparison/after.webp
VARS

echo ""
echo "=== Placeholder Check Complete ==="
exit 0
