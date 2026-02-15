#!/bin/bash
# =============================================================================
# sync-copy-to-config.sh
# Syncs copy_final.json values into product.config
# This bridges the gap between workflow output and build input
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
COPY_FINAL="$PROJECT_ROOT/context/copy_final.json"
PRODUCT_CONFIG="$PROJECT_ROOT/product.config"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================"
echo "Copy Final → Product Config Sync"
echo "========================================"
echo ""

# Check files exist
if [[ ! -f "$COPY_FINAL" ]]; then
    echo -e "${RED}ERROR: copy_final.json not found at $COPY_FINAL${NC}"
    exit 1
fi

if [[ ! -f "$PRODUCT_CONFIG" ]]; then
    echo -e "${RED}ERROR: product.config not found at $PRODUCT_CONFIG${NC}"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo -e "${RED}ERROR: jq is required but not installed${NC}"
    echo "Install with: brew install jq"
    exit 1
fi

# Backup product.config
cp "$PRODUCT_CONFIG" "$PRODUCT_CONFIG.backup"
echo -e "${GREEN}✓${NC} Backed up product.config"

# Function to update a variable in product.config
update_config() {
    local key="$1"
    local value="$2"

    # Escape special characters for sed
    value=$(echo "$value" | sed 's/[&/\]/\\&/g' | sed "s/'/\\\\'/g")

    if grep -q "^${key}=" "$PRODUCT_CONFIG"; then
        # Update existing
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|^${key}=.*|${key}=\"${value}\"|" "$PRODUCT_CONFIG"
        else
            sed -i "s|^${key}=.*|${key}=\"${value}\"|" "$PRODUCT_CONFIG"
        fi
    else
        # Append new (find appropriate section)
        echo "${key}=\"${value}\"" >> "$PRODUCT_CONFIG"
    fi
}

UPDATED=0
SKIPPED=0

echo ""
echo "Syncing ENGAGE framework..."

# ENGAGE section
for key in HEADLINE_HOOK TAGLINE HEADLINE_OPENING_COPY; do
    value=$(jq -r ".engage.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

echo ""
echo "Syncing FEATURES section..."

# Features section
for key in FEATURE_HEADLINE_1 FEATURE_HEADING_1 FEATURE_PARAGRAPH_1_1 FEATURE_PARAGRAPH_1_2 \
           FEATURE_HEADLINE_2 FEATURE_HEADING_2 FEATURE_PARAGRAPH_2 \
           FEATURE_HEADLINE_3 FEATURE_HEADING_3 FEATURE_BENEFIT_TEXT; do
    value=$(jq -r ".features.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

echo ""
echo "Syncing SECRETS section..."

# Secrets section
for key in SECRET_1_HEADLINE SECRET_HEADING_1 SECRET_PARAGRAPH_1 SECRET_PARAGRAPH_1_2 \
           SECRET_1_FALSE_BELIEF SECRET_1_TRUTH \
           SECRET_2_HEADLINE SECRET_HEADING_2 SECRET_PARAGRAPH_2 SECRET_PARAGRAPH_2_2 \
           SECRET_2_FALSE_BELIEF SECRET_2_TRUTH \
           SECRET_3_HEADLINE SECRET_HEADING_3 SECRET_PARAGRAPH_3 SECRET_PARAGRAPH_3_2 \
           SECRET_3_FALSE_BELIEF SECRET_3_TRUTH SECRET_BENEFIT_TEXT; do
    value=$(jq -r ".secrets.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

echo ""
echo "Syncing FOUNDER STORY section..."

# Founder story section
for key in FOUNDER_SECTION_HEADING FOUNDER_SECTION_PARAGRAPH_1 FOUNDER_SECTION_PARAGRAPH_2 \
           FOUNDER_BACKSTORY FOUNDER_WALL FOUNDER_EPIPHANY FOUNDER_PLAN \
           FOUNDER_TRANSFORMATION FOUNDER_INVITATION; do
    value=$(jq -r ".founder_story.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

echo ""
echo "Syncing FAQ section..."

# FAQ section
for i in 1 2 3 4 5; do
    for suffix in QUESTION ANSWER; do
        key="FAQ_${suffix}_${i}"
        value=$(jq -r ".faq.${key} // empty" "$COPY_FINAL" 2>/dev/null)
        if [[ -n "$value" && "$value" != "null" ]]; then
            update_config "$key" "$value"
            echo -e "  ${GREEN}✓${NC} $key"
            ((UPDATED++))
        fi
    done
done

echo ""
echo "Syncing TESTIMONIALS section..."

# Rolling testimonials
for i in 1 2 3 4 5; do
    key="ROTATING_TESTIMONIAL_${i}"
    value=$(jq -r ".rolling_reviews.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

# Main testimonials
for i in 1 2 3 4 5 6; do
    for suffix in TITLE QUOTE AUTHOR LOCATION; do
        key="TESTIMONIAL_${i}_${suffix}"
        value=$(jq -r ".main_reviews.${key} // empty" "$COPY_FINAL" 2>/dev/null)
        if [[ -n "$value" && "$value" != "null" ]]; then
            update_config "$key" "$value"
            echo -e "  ${GREEN}✓${NC} $key"
            ((UPDATED++))
        fi
    done
done

echo ""
echo "Syncing COMPARISON section..."

# Comparison
for key in COMPARISON_HEADLINE COMPARISON_PARAGRAPH BEFORE_PAIN AFTER_BENEFIT; do
    value=$(jq -r ".comparison.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

echo ""
echo "Syncing OTHER variables..."

# Big domino and order bump
for key in BIG_DOMINO ORDER_BUMP_DESC; do
    value=$(jq -r ".${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

# TikTok bubbles
for key in BUBBLE_Q1_VEHICLE BUBBLE_A1_VEHICLE BUBBLE_Q2_INTERNAL BUBBLE_A2_INTERNAL \
           BUBBLE_Q3_EXTERNAL BUBBLE_A3_EXTERNAL; do
    value=$(jq -r ".tiktok_bubbles.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

# Multirow 2
for key in MULTIROW_2_HEADING MULTIROW_2_PARAGRAPH_1 MULTIROW_2_PARAGRAPH_2; do
    value=$(jq -r ".multirow_2.${key} // empty" "$COPY_FINAL" 2>/dev/null)
    if [[ -n "$value" && "$value" != "null" ]]; then
        update_config "$key" "$value"
        echo -e "  ${GREEN}✓${NC} $key"
        ((UPDATED++))
    fi
done

echo ""
echo "========================================"
echo "Sync Complete"
echo "========================================"
echo -e "Updated: ${GREEN}$UPDATED${NC} variables"
echo -e "Backup: ${YELLOW}$PRODUCT_CONFIG.backup${NC}"
echo ""
echo "Next step: ./build.sh"
