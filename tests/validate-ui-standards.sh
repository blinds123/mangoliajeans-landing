#!/bin/bash
# =============================================================================
# UI Standards Validator
# Validates that template meets hardcoded UI requirements
# Part of workflow alignment - Template adapts to Workflow (Option A)
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SECTIONS_DIR="$PROJECT_ROOT/sections"
MAIN_PRODUCT="$SECTIONS_DIR/05-main-product.html"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_pass() { echo -e "${GREEN}✓${NC} $1"; }
log_fail() { echo -e "${RED}✗${NC} $1"; ((ERRORS++)); }
log_warn() { echo -e "${YELLOW}!${NC} $1"; ((WARNINGS++)); }
log_info() { echo -e "  $1"; }

echo "========================================"
echo "UI Standards Validation"
echo "========================================"
echo ""

# -----------------------------------------------------------------------------
# 1. Star Rating Color Check (#FFD700)
# -----------------------------------------------------------------------------
echo "1. Star Rating Color..."
if grep -q 'star-color:#FFD700' "$MAIN_PRODUCT"; then
    log_pass "Star color is #FFD700 (gold standard)"
elif grep -q 'star-color:#ffcc00' "$MAIN_PRODUCT"; then
    log_fail "Star color is #ffcc00 (should be #FFD700)"
else
    log_warn "Star color variable not found"
fi

# -----------------------------------------------------------------------------
# 2. Layout Order Check (Order Bump → Shipping → ATC → Features)
# -----------------------------------------------------------------------------
echo ""
echo "2. Layout Order (Conversion Flow)..."

ORDER_BUMP_LINE=$(grep -n "CRITICAL SECTION: ORDER BUMP" "$MAIN_PRODUCT" | head -1 | cut -d: -f1)
SHIPPING_LINE=$(grep -n "SHIPPING URGENCY" "$MAIN_PRODUCT" | head -1 | cut -d: -f1)
ATC_LINE=$(grep -n "ADD TO CART CONTAINER" "$MAIN_PRODUCT" | head -1 | cut -d: -f1)
FEATURE_LINE=$(grep -n "FEATURE ICONS SECTION" "$MAIN_PRODUCT" | head -1 | cut -d: -f1)

if [[ -n "$ORDER_BUMP_LINE" && -n "$SHIPPING_LINE" && -n "$ATC_LINE" && -n "$FEATURE_LINE" ]]; then
    if [[ $ORDER_BUMP_LINE -lt $SHIPPING_LINE && $SHIPPING_LINE -lt $ATC_LINE && $ATC_LINE -lt $FEATURE_LINE ]]; then
        log_pass "Layout order correct: Order Bump (L$ORDER_BUMP_LINE) → Shipping (L$SHIPPING_LINE) → ATC (L$ATC_LINE) → Features (L$FEATURE_LINE)"
    else
        log_fail "Layout order incorrect"
        log_info "Expected: Order Bump → Shipping → ATC → Features"
        log_info "Found: Order Bump (L$ORDER_BUMP_LINE), Shipping (L$SHIPPING_LINE), ATC (L$ATC_LINE), Features (L$FEATURE_LINE)"
    fi
else
    log_fail "Missing layout sections"
    [[ -z "$ORDER_BUMP_LINE" ]] && log_info "- Order Bump section not found"
    [[ -z "$SHIPPING_LINE" ]] && log_info "- Shipping section not found"
    [[ -z "$ATC_LINE" ]] && log_info "- ATC section not found"
    [[ -z "$FEATURE_LINE" ]] && log_info "- Feature Icons section not found"
fi

# -----------------------------------------------------------------------------
# 3. ATC Container Margin Check (35px top/bottom)
# -----------------------------------------------------------------------------
echo ""
echo "3. ATC Container Margins..."
if grep -q 'margin-top: 35px.*margin-bottom: 35px' "$MAIN_PRODUCT" || grep -q 'margin-top:35px.*margin-bottom:35px' "$MAIN_PRODUCT"; then
    log_pass "ATC container has 35px margins"
elif grep -q 'id="atc-container"' "$MAIN_PRODUCT"; then
    ATC_MARGINS=$(grep -A1 'id="atc-container"' "$MAIN_PRODUCT" | grep -o 'margin-[^;]*' || echo "not found")
    log_warn "ATC container found but margins may not be 35px: $ATC_MARGINS"
else
    log_fail "ATC container not found (should have id='atc-container')"
fi

# -----------------------------------------------------------------------------
# 4. Shipping Timeline Padding Check (24px)
# -----------------------------------------------------------------------------
echo ""
echo "4. Shipping Timeline Padding..."
if grep -q 'id="shipping-timeline-section"' "$MAIN_PRODUCT"; then
    if grep -A1 'id="shipping-timeline-section"' "$MAIN_PRODUCT" | grep -q 'margin.*24px'; then
        log_pass "Shipping timeline section has 24px padding"
    else
        log_warn "Shipping timeline section found but padding may vary"
    fi
else
    log_fail "Shipping timeline section not found (should have id='shipping-timeline-section')"
fi

# -----------------------------------------------------------------------------
# 5. No Orphaned Tags Check
# -----------------------------------------------------------------------------
echo ""
echo "5. Orphaned Tags Check..."
CLOSE_DYNAMIC_DATES=$(grep '</dynamic-dates>' "$MAIN_PRODUCT" 2>/dev/null | wc -l | tr -d ' ')
OPEN_DYNAMIC_DATES=$(grep '<dynamic-dates' "$MAIN_PRODUCT" 2>/dev/null | wc -l | tr -d ' ')

if [[ "$CLOSE_DYNAMIC_DATES" -eq "$OPEN_DYNAMIC_DATES" ]]; then
    log_pass "dynamic-dates tags balanced ($OPEN_DYNAMIC_DATES open, $CLOSE_DYNAMIC_DATES close)"
else
    log_fail "dynamic-dates tags unbalanced ($OPEN_DYNAMIC_DATES open, $CLOSE_DYNAMIC_DATES close)"
fi

# -----------------------------------------------------------------------------
# 6. Variable Naming Convention Check
# -----------------------------------------------------------------------------
echo ""
echo "6. Variable Naming Convention..."
COPY_FINAL="$PROJECT_ROOT/context/copy_final.json"
if [[ -f "$COPY_FINAL" ]]; then
    # Check for correct pattern: SECRET_1_HEADLINE (number in middle)
    if grep -q '"SECRET_1_HEADLINE"' "$COPY_FINAL" && grep -q '"SECRET_2_HEADLINE"' "$COPY_FINAL" && grep -q '"SECRET_3_HEADLINE"' "$COPY_FINAL"; then
        log_pass "Variable naming follows SECRET_X_HEADLINE pattern"
    elif grep -q '"SECRET_HEADLINE_1"' "$COPY_FINAL"; then
        log_fail "Variable naming uses wrong pattern (SECRET_HEADLINE_1 should be SECRET_1_HEADLINE)"
    else
        log_warn "Secret headline variables not found in copy_final.json"
    fi
else
    log_warn "copy_final.json not found"
fi

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
echo ""
echo "========================================"
echo "Summary"
echo "========================================"
if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
    echo -e "${GREEN}All UI standards validated successfully!${NC}"
    exit 0
elif [[ $ERRORS -eq 0 ]]; then
    echo -e "${YELLOW}Validation passed with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    exit 1
fi
