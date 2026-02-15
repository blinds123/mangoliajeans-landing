#!/bin/bash
# VALIDATE-FEATURES.sh
# Critical Gatekeeper: Ensures all 4 feature cards use ENGAGE 5-element framework

CONFIG="product.config"
RESEARCH="context/research-summary.md"

if [ ! -f "$CONFIG" ]; then
    echo "❌ CRITICAL FAIL: product.config not found"
    exit 1
fi

if [ ! -f "$RESEARCH" ]; then
    echo "⚠️  WARNING: research-summary.md not found - cannot verify research usage"
fi

echo "🔍 Validating 4 Feature Cards (ENGAGE 5-Element Framework)..."

# Check 1: All 4 feature cards exist
MISSING_CARDS=""
for i in 1 2 3 4; do
    if ! grep -q "MULTIROW_HEADLINE_$i=" "$CONFIG"; then
        MISSING_CARDS="$MISSING_CARDS CARD_$i"
    fi
    if ! grep -q "MULTIROW_PARAGRAPH_$i=" "$CONFIG"; then
        MISSING_CARDS="$MISSING_CARDS CARD_${i}_PARAGRAPH"
    fi
done

if [ -n "$MISSING_CARDS" ]; then
    echo "❌ FAIL: Missing feature card variables:$MISSING_CARDS"
    echo "   All 4 cards need: MULTIROW_HEADLINE_X and MULTIROW_PARAGRAPH_X"
    exit 1
fi

echo "   ✅ All 4 feature cards present"

# Check 2: No empty cards
for i in 1 2 3 4; do
    HEADLINE=$(grep "^MULTIROW_HEADLINE_$i=" "$CONFIG" | cut -d'=' -f2-)
    PARAGRAPH=$(grep "^MULTIROW_PARAGRAPH_$i=" "$CONFIG" | cut -d'=' -f2-)

    if [ -z "$HEADLINE" ] || [ -z "$PARAGRAPH" ]; then
        echo "❌ FAIL: Feature Card $i has empty headline or paragraph"
        exit 1
    fi

    # Check headline word count (must be > 3 words)
    HEADLINE_WORD_COUNT=$(echo "$HEADLINE" | wc -w | tr -d ' ')
    if [ "$HEADLINE_WORD_COUNT" -le 3 ]; then
        echo "❌ FAIL: Feature Card $i headline too short ($HEADLINE_WORD_COUNT words)"
        echo "   Headline: $HEADLINE"
        echo "   Requirements: > 3 words with cognitive disruption pattern"
        exit 1
    fi

    # Check headline has cognitive disruption pattern
    if ! echo "$HEADLINE" | grep -qiE "THE |ISN'T|AREN'T|LIE|MYTH|TRUTH|SECRET"; then
        echo "❌ FAIL: Feature Card $i headline lacks cognitive disruption"
        echo "   Headline: $HEADLINE"
        echo "   Must contain: THE, ISN'T, AREN'T, LIE, MYTH, TRUTH, or SECRET"
        echo "   Examples: 'THE CHEAP ZIPPER', 'QUALITY ISN'T WHAT YOU THINK'"
        exit 1
    fi

    # Check character count (minimum 200 chars for narrative depth)
    CHAR_COUNT=$(echo "$PARAGRAPH" | wc -c | tr -d ' ')
    if [ "$CHAR_COUNT" -lt 200 ]; then
        echo "❌ FAIL: Feature Card $i paragraph too short ($CHAR_COUNT characters)"
        echo "   Minimum: 200 characters for full ENGAGE narrative"
        exit 1
    fi

    # Check word count (minimum 30 words for sentence structure)
    WORD_COUNT=$(echo "$PARAGRAPH" | wc -w | tr -d ' ')
    if [ "$WORD_COUNT" -lt 30 ]; then
        echo "❌ FAIL: Feature Card $i paragraph too short ($WORD_COUNT words)"
        echo "   Each card needs 200+ characters (5-6 sentences for full ENGAGE loop)"
        exit 1
    fi
    if [ "$WORD_COUNT" -gt 80 ]; then
        echo "⚠️  WARNING: Feature Card $i paragraph too long ($WORD_COUNT words)"
        echo "   Target is ~40 words. Consider trimming."
    fi
done

echo "   ✅ All cards have content with appropriate length"

# Check 3: ENGAGE Element Detection (5 elements per card)
# We look for indicators of each ENGAGE element

FAILED_CARDS=""

for i in 1 2 3 4; do
    HEADLINE=$(grep "^MULTIROW_HEADLINE_$i=" "$CONFIG" | cut -d'=' -f2-)
    PARAGRAPH=$(grep "^MULTIROW_PARAGRAPH_$i=" "$CONFIG" | cut -d'=' -f2-)
    COMBINED="$HEADLINE $PARAGRAPH"

    ELEMENTS_FOUND=0

    # Element 1: Cognitive Disruption (headline should be provocative/challenging)
    # Look for: THE [X], [X] ISN'T [Y], [X] LIE, [X] MYTH, etc.
    if echo "$HEADLINE" | grep -qiE "THE [A-Z]|ISN'T|AREN'T|LIE|MYTH|TRUTH|SECRET"; then
        ((ELEMENTS_FOUND++))
    fi

    # Element 2: Unfinished Story (should have "You" moments)
    # Look for: You [verb], You've, Your
    if echo "$COMBINED" | grep -qE "\bYou('ve| |\b)|Your"; then
        ((ELEMENTS_FOUND++))
    fi

    # Element 3: Controversial Truth (should state uncomfortable fact)
    # Look for: patterns like "isn't", "aren't", "actually", "really", "truth"
    if echo "$COMBINED" | grep -qiE "isn't|aren't|actually|really|truth|fact|secret"; then
        ((ELEMENTS_FOUND++))
    fi

    # Element 4: High-Stakes Conflict (emotional/identity language)
    # Look for: feel, look, want, need, cheap, frumpy, basic, confidence
    if echo "$COMBINED" | grep -qiE "feel|look|want|need|cheap|frumpy|basic|confidence|identity|frustrat"; then
        ((ELEMENTS_FOUND++))
    fi

    # Element 5: Unconventional Payoff (solution language)
    # Look for: Our, This, [feature] that, finally, without
    if echo "$COMBINED" | grep -qiE "\bOur |This |finally|without"; then
        ((ELEMENTS_FOUND++))
    fi

    if [ "$ELEMENTS_FOUND" -lt 4 ]; then
        FAILED_CARDS="$FAILED_CARDS CARD_$i(only_${ELEMENTS_FOUND}/5_elements)"
        echo "   ❌ Feature Card $i: Only detected $ELEMENTS_FOUND/5 ENGAGE elements"
        echo "      Headline: $HEADLINE"
    else
        echo "   ✅ Feature Card $i: Detected $ELEMENTS_FOUND/5 ENGAGE elements"
    fi
done

if [ -n "$FAILED_CARDS" ]; then
    echo ""
    echo "❌ FAIL: Some cards missing ENGAGE elements:$FAILED_CARDS"
    echo ""
    echo "   Each card MUST have ALL 5 ENGAGE elements:"
    echo "   1. Cognitive Disruption (challenge belief in headline)"
    echo "   2. Unfinished Story ('You' moments)"
    echo "   3. Controversial Truth (uncomfortable fact)"
    echo "   4. High-Stakes Conflict (emotional/identity language)"
    echo "   5. Unconventional Payoff (solution with 'Our'/'finally')"
    echo ""
    echo "   Re-read: context/research-summary.md"
    echo "   Reference: ENGAGE-FASHION-GENZ.md for examples"
    exit 1
fi

echo "   ✅ All 4 cards have ENGAGE elements detected"

# Check 4: Research Context Usage (optional check)
if [ -f "$RESEARCH" ]; then
    # Extract a few pain points/desires from research to see if they appear in features
    PAIN_KEYWORDS=$(grep -i "pain\|frustrat\|problem" "$RESEARCH" 2>/dev/null | head -3 | tr '[:upper:]' '[:lower:]')

    USED_RESEARCH=0
    for i in 1 2 3 4; do
        PARAGRAPH=$(grep "^MULTIROW_PARAGRAPH_$i=" "$CONFIG" | cut -d'=' -f2- | tr '[:upper:]' '[:lower:]')

        # Check if any research keywords appear in this card
        if echo "$PAIN_KEYWORDS" | grep -qf <(echo "$PARAGRAPH"); then
            ((USED_RESEARCH++))
        fi
    done

    if [ "$USED_RESEARCH" -lt 2 ]; then
        echo "   ⚠️  WARNING: Features may not be using research context"
        echo "      Only $USED_RESEARCH/4 cards reference pain points from research"
        echo "      Ensure you're using language from research-summary.md Voice & Tone"
    else
        echo "   ✅ Features reference research context"
    fi
fi

echo ""
echo "✅ PASS: All 4 feature cards validated with ENGAGE framework"
exit 0
