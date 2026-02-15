#!/bin/bash
# Validate that copy sections use research and follow requirements

set -e

SECTION_FILE="${1:-}"
RESEARCH_FILE="${2:-context/research-summary.md}"

if [ -z "$SECTION_FILE" ]; then
    echo "Usage: validate-copy-requirements.sh <section-file> [research-file]"
    exit 1
fi

if [ ! -f "$SECTION_FILE" ]; then
    echo "❌ FAIL: Section file not found: $SECTION_FILE"
    exit 1
fi

if [ ! -f "$RESEARCH_FILE" ]; then
    echo "❌ FAIL: Research file not found: $RESEARCH_FILE"
    echo "   You MUST create research-summary.md before writing copy!"
    exit 1
fi

echo "Validating: $SECTION_FILE"
echo "Against research: $RESEARCH_FILE"
echo ""

ERRORS=0

# ============================================
# CHECK 1: Banned generic phrases
# ============================================
echo "[1/6] Checking for banned generic phrases..."

BANNED_PHRASES=(
    "amazing product"
    "life-changing"
    "incredible results"
    "best ever"
    "you won't believe"
    "game changer"
    "revolutionary"
    "transform your life"
    "unlock your potential"
    "take it to the next level"
)

for phrase in "${BANNED_PHRASES[@]}"; do
    if grep -qi "$phrase" "$SECTION_FILE"; then
        echo "  ❌ BANNED PHRASE FOUND: \"$phrase\""
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo "  ✅ No banned phrases found"
fi

# ============================================
# CHECK 2: Uses template variables (not hardcoded)
# ============================================
echo ""
echo "[2/6] Checking for template variable usage..."

# Check that prices use variables, not hardcoded values
if grep -q '\$19' "$SECTION_FILE" && ! grep -q '{{SINGLE_PRICE}}' "$SECTION_FILE"; then
    echo "  ⚠️  WARNING: Found hardcoded $19 - should use {{SINGLE_PRICE}}"
fi

if grep -q '\$10' "$SECTION_FILE" && ! grep -q '{{ORDER_BUMP_PRICE}}' "$SECTION_FILE"; then
    echo "  ⚠️  WARNING: Found hardcoded $10 - should use {{ORDER_BUMP_PRICE}}"
fi

# Check for image variables
if grep -q 'src="images/' "$SECTION_FILE"; then
    echo "  ❌ HARDCODED IMAGE PATH: Use {{IMAGE_VARIABLE}} instead of direct paths"
    ERRORS=$((ERRORS + 1))
else
    echo "  ✅ No hardcoded image paths"
fi

# ============================================
# CHECK 3: Section-specific image requirements
# ============================================
echo ""
echo "[3/6] Checking section-specific requirements..."

BASENAME=$(basename "$SECTION_FILE")

case "$BASENAME" in
    "03-hero.html")
        if ! grep -q '{{HERO_IMAGE' "$SECTION_FILE" && ! grep -q '{{PRODUCT_IMAGE' "$SECTION_FILE"; then
            echo "  ❌ Hero section missing HERO_IMAGE or PRODUCT_IMAGE variable"
            ERRORS=$((ERRORS + 1))
        fi
        ;;
    "08-pricing.html")
        if ! grep -q '{{ORDER_BUMP_IMAGE}}' "$SECTION_FILE"; then
            echo "  ❌ Pricing section missing ORDER_BUMP_IMAGE variable"
            ERRORS=$((ERRORS + 1))
        fi
        if ! grep -q 'checked="checked"' "$SECTION_FILE" && ! grep -q "checked='checked'" "$SECTION_FILE"; then
            echo "  ❌ Order bump checkbox not pre-checked (missing checked=\"checked\")"
            ERRORS=$((ERRORS + 1))
        fi
        ;;
    "11-comparison.html")
        if ! grep -q '{{COMPARISON' "$SECTION_FILE"; then
            echo "  ❌ Comparison section missing COMPARISON image variables"
            ERRORS=$((ERRORS + 1))
        fi
        ;;
    "18-founder-story.html")
        if ! grep -q '{{FOUNDER_IMAGE}}' "$SECTION_FILE"; then
            echo "  ❌ Founder section missing FOUNDER_IMAGE variable"
            ERRORS=$((ERRORS + 1))
        fi
        ;;
    "14-secret-1-vehicle.html")
        if ! grep -q '{{TESTIMONIAL_IMAGE_8}}' "$SECTION_FILE"; then
            echo "  ⚠️  Secret 1 should use TESTIMONIAL_IMAGE_8"
        fi
        ;;
    "16-secret-2-internal.html")
        if ! grep -q '{{TESTIMONIAL_IMAGE_15}}' "$SECTION_FILE"; then
            echo "  ⚠️  Secret 2 should use TESTIMONIAL_IMAGE_15"
        fi
        ;;
    "20-secret-3-external.html")
        if ! grep -q '{{TESTIMONIAL_IMAGE_22}}' "$SECTION_FILE"; then
            echo "  ⚠️  Secret 3 should use TESTIMONIAL_IMAGE_22"
        fi
        ;;
esac

echo "  ✅ Section-specific checks complete"

# ============================================
# CHECK 4: Pattern interrupts (ENGAGE framework)
# ============================================
echo ""
echo "[4/6] Checking pattern interrupt density..."

# Count potential pattern interrupts (questions, specific phrases)
QUESTION_COUNT=$(grep -c '?' "$SECTION_FILE" 2>/dev/null || echo "0")
ENGAGE_PATTERNS=$(grep -ciE "(what if|imagine|here's what|the truth is|you already know|it's not your fault|everyone says|97%|studies show)" "$SECTION_FILE" 2>/dev/null || echo "0")

TOTAL_HOOKS=$((QUESTION_COUNT + ENGAGE_PATTERNS))

# Determine minimum required based on section
case "$BASENAME" in
    "07-big-domino.html"|"14-secret-1-vehicle.html"|"16-secret-2-internal.html"|"20-secret-3-external.html")
        MIN_HOOKS=3
        ;;
    "18-founder-story.html"|"09-features.html")
        MIN_HOOKS=4
        ;;
    "23-faq.html")
        MIN_HOOKS=6
        ;;
    "03-hero.html"|"11-comparison.html"|"24-final-cta.html")
        MIN_HOOKS=2
        ;;
    *)
        MIN_HOOKS=1
        ;;
esac

if [ "$TOTAL_HOOKS" -lt "$MIN_HOOKS" ]; then
    echo "  ⚠️  Low pattern interrupt count: $TOTAL_HOOKS (minimum: $MIN_HOOKS)"
    echo "      Add more hooks: Questions, Contradictions, Stats, Time Travel, etc."
else
    echo "  ✅ Pattern interrupt count: $TOTAL_HOOKS (minimum: $MIN_HOOKS)"
fi

# ============================================
# CHECK 5: Research reference indicators
# ============================================
echo ""
echo "[5/6] Checking for research-derived content..."

# Extract key terms from research (if available)
if [ -f "$RESEARCH_FILE" ]; then
    # Check if copy references pain/desire language patterns
    PAIN_WORDS=$(grep -i "pain" "$RESEARCH_FILE" | head -5 | tr '[:upper:]' '[:lower:]')
    DESIRE_WORDS=$(grep -i "desire" "$RESEARCH_FILE" | head -5 | tr '[:upper:]' '[:lower:]')

    # This is a heuristic - ideally copy should contain specific phrases from research
    WORD_COUNT=$(wc -w < "$SECTION_FILE" | tr -d ' ')

    if [ "$WORD_COUNT" -lt 50 ]; then
        echo "  ⚠️  Section is very short ($WORD_COUNT words) - may lack depth"
    else
        echo "  ✅ Section word count: $WORD_COUNT"
    fi
fi

# ============================================
# CHECK 6: Hook-Story-Offer structure
# ============================================
echo ""
echo "[6/6] Checking content structure..."

# Check for structural elements (headings, paragraphs, CTAs)
HEADING_COUNT=$(grep -cE '<h[1-6]' "$SECTION_FILE" 2>/dev/null || echo "0")
PARA_COUNT=$(grep -c '<p' "$SECTION_FILE" 2>/dev/null || echo "0")
CTA_COUNT=$(grep -ciE '(button|btn|cta|add to cart|buy now|get yours)' "$SECTION_FILE" 2>/dev/null || echo "0")

echo "  Structure: $HEADING_COUNT headings, $PARA_COUNT paragraphs, $CTA_COUNT CTAs"

# ============================================
# FINAL RESULT
# ============================================
echo ""
echo "========================================"
if [ $ERRORS -gt 0 ]; then
    echo "❌ VALIDATION FAILED: $ERRORS error(s) found"
    echo "   Fix the issues above and regenerate this section."
    exit 1
else
    echo "✅ VALIDATION PASSED"
    exit 0
fi
