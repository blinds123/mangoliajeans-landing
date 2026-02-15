#!/bin/bash
# VALIDATE-CONFIG.sh
# Critical Gatekeeper: Prevents build if config violates hardcoded rules.

# Load config variables (errors if file missing)
source product.config

ERRORS=0

echo "🔍 Validating Configuration Rules..."

# Rule 1: Price Check ($19 limit)
if [ "$SINGLE_PRICE" != "19" ]; then
    echo "❌ FAIL: SINGLE_PRICE is '$SINGLE_PRICE'. Must be '19'."
    echo "   Corrective Action: Hardcode strict strict Brunson pricing."
    ((ERRORS++))
fi

# Rule 2: Order Bump Check ($10 limit)
if [ "$ORDER_BUMP_PRICE" != "10" ]; then
    echo "❌ FAIL: ORDER_BUMP_PRICE is '$ORDER_BUMP_PRICE'. Must be '10'."
    ((ERRORS++))
fi

# Rule 3: Guarantee Check (Must be defined and reasonable: 30-365 days)
if [ -z "$GUARANTEE_DAYS" ]; then
    echo "❌ FAIL: GUARANTEE_DAYS is not defined."
    ((ERRORS++))
elif [ "$GUARANTEE_DAYS" -lt 30 ] || [ "$GUARANTEE_DAYS" -gt 365 ]; then
    echo "❌ FAIL: GUARANTEE_DAYS is '$GUARANTEE_DAYS'. Must be between 30-365 days."
    ((ERRORS++))
fi

# Rule 4: Secret Headline Presence (check both naming conventions)
SECRET_1="${SECRET_1_HEADLINE:-$SECRET_HEADLINE_1}"
SECRET_2="${SECRET_2_HEADLINE:-$SECRET_HEADLINE_2}"
SECRET_3="${SECRET_3_HEADLINE:-$SECRET_HEADLINE_3}"
if [ -z "$SECRET_1" ] || [ -z "$SECRET_2" ] || [ -z "$SECRET_3" ]; then
    echo "❌ FAIL: Missing Secret Headlines (need SECRET_1_HEADLINE, SECRET_2_HEADLINE, SECRET_3_HEADLINE)."
    ((ERRORS++))
fi

# Rule 5: ENGAGE Headline Pattern Check (The "Anti-Boredom" Filter)
# Checks for cognitive disruption markers and length > 2 words.
check_headline() {
    local hl="$1"
    local var_name="$2"
    local word_count=$(echo "$hl" | wc -w)
    
    # Skip if empty (handled by other rules)
    if [ -z "$hl" ]; then return 0; fi

    # Check 1: Length (Must be >= 3 words)
    if [ "$word_count" -lt 3 ]; then
        echo "❌ FAIL: $var_name ('$hl') is too short ($word_count words). Strict ENGAGE requires 3+ words."
        return 1
    fi

    # Check 2: Pattern Match (Case Insensitive)
    # Looking for: The X, Why X, Stop X, Myth, Lie, Truth, Secret, Isn't, Aren't, Don't, Scam, Hoax, Vs
    if ! echo "$hl" | grep -qiE "THE |WHY |STOP |MYTH|LIE|TRUTH|SECRET|ISN'T|AREN'T|HOAX|SCAM|VS |AGAINST|DON'T"; then
        echo "❌ FAIL: $var_name ('$hl') lacks a disruption marker (Matches: THE/WHY/STOP/MYTH/LIE/TRUTH/SECRET/ISN'T/AREN'T/DON'T)."
        return 1
    fi
    return 0
}

check_headline "$FEATURE_HEADLINE_1" "FEATURE_HEADLINE_1" || ((ERRORS++))
check_headline "$FEATURE_HEADLINE_2" "FEATURE_HEADLINE_2" || ((ERRORS++))
check_headline "$FEATURE_HEADLINE_3" "FEATURE_HEADLINE_3" || ((ERRORS++))
check_headline "$FEATURE_HEADLINE_4" "FEATURE_HEADLINE_4" || ((ERRORS++))

# Rule 6: Feature Copy Length (Strict E-N-G-A Check)
# Must be long enough to contain Exploit-Narrate-Give-Attach (approx 200+ chars)
if [ ${#MULTIROW_1_PARAGRAPH} -lt 150 ] || [ ${#MULTIROW_2_PARAGRAPH} -lt 150 ]; then
   echo "❌ FAIL: Feature copy is too short (< 150 chars). Strict ENGAGE requires Exploit-Narrate-Give-Attach logic."
   ((ERRORS++))
fi

if [ "$ERRORS" -gt 0 ]; then
    echo "⛔ CONFIG VALIDATION FAILED with $ERRORS errors."
    exit 1
fi

echo "✅ PASS: Configuration is compliant."
exit 0
