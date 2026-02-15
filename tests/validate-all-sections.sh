#!/bin/bash
# validate-all-sections.sh
# Run after parallel copy generation to validate ALL 25 sections

set -e

SECTIONS_DIR="${1:-sections}"
FAILED=0
PASSED=0

echo "======================================"
echo "  VALIDATING ALL 25 SECTIONS"
echo "======================================"

# Check all sections exist
for i in $(seq -w 1 25); do
    section=$(ls "$SECTIONS_DIR"/*-*.html 2>/dev/null | grep "^$SECTIONS_DIR/$i-" | head -1)
    if [[ -z "$section" ]]; then
        echo "❌ MISSING: Section $i"
        ((FAILED++))
    fi
done

# Validate each section
for section in "$SECTIONS_DIR"/*.html; do
    if [[ -f "$section" ]]; then
        filename=$(basename "$section")
        section_num=$(echo "$filename" | cut -d'-' -f1)

        echo ""
        echo "--- Validating: $filename ---"

        # Run section validation
        if bash tests/validate-section.sh "$section" 2>/dev/null; then
            echo "  ✅ Structure OK"
        else
            echo "  ❌ Structure FAILED"
            ((FAILED++))
            continue
        fi

        # Check for generic phrases (anti-laziness)
        BANNED_PHRASES=("amazing product" "life-changing" "incredible results" "best ever" "you won't believe" "game changer" "revolutionary")
        for phrase in "${BANNED_PHRASES[@]}"; do
            if grep -qi "$phrase" "$section"; then
                echo "  ❌ BANNED PHRASE: '$phrase'"
                ((FAILED++))
            fi
        done

        # Check for placeholder variables not replaced
        if grep -q '{{[A-Z_]*}}' "$section"; then
            placeholders=$(grep -o '{{[A-Z_]*}}' "$section" | sort -u | tr '\n' ' ')
            echo "  ⚠️  PLACEHOLDERS: $placeholders"
        fi

        ((PASSED++))
    fi
done

echo ""
echo "======================================"
echo "  RESULTS"
echo "======================================"
echo "  PASSED: $PASSED"
echo "  FAILED: $FAILED"
echo "======================================"

if [[ $FAILED -gt 0 ]]; then
    echo "❌ VALIDATION FAILED - Fix $FAILED issues"
    exit 1
else
    echo "✅ ALL SECTIONS PASSED"
    exit 0
fi
