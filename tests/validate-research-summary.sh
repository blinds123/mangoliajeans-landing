#!/bin/bash
# Validate research-summary.md is properly filled
# This file is CRITICAL - all copy tasks depend on it

set -e

CONTEXT_DIR="${1:-context}"
SUMMARY_FILE="$CONTEXT_DIR/research-summary.md"

echo "=== VALIDATING RESEARCH SUMMARY ==="
echo ""

# Check file exists
if [ ! -f "$SUMMARY_FILE" ]; then
  echo "FAIL: $SUMMARY_FILE does not exist"
  echo ""
  echo "FIX: Copy the template and fill it in:"
  echo "  cp $CONTEXT_DIR/research-summary.template.md $SUMMARY_FILE"
  echo "  Then fill in all sections from competitor research"
  exit 1
fi

echo "File exists: $SUMMARY_FILE"
echo ""

# Track failures
FAILURES=0

# Check Big Domino is filled
echo "Checking Big Domino..."
BIG_DOMINO=$(grep -A2 "## 🎯 BIG DOMINO" "$SUMMARY_FILE" | grep -v "^#" | grep -v "^\s*$" | head -1)
if [[ "$BIG_DOMINO" == *"[Write the"* ]] || [ -z "$BIG_DOMINO" ]; then
  echo "  FAIL: Big Domino not filled"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: Big Domino defined"
fi

# Check 3 Secrets are filled
echo "Checking 3 Secrets..."
for secret in "VEHICLE" "INTERNAL" "EXTERNAL"; do
  SECRET_CONTENT=$(grep -A3 "### Secret.*$secret" "$SUMMARY_FILE" | grep -v "^#" | grep -v "^\*\*" | head -1)
  if [[ "$SECRET_CONTENT" == *"["* ]] || [ -z "$SECRET_CONTENT" ]; then
    echo "  FAIL: Secret ($secret) not filled"
    FAILURES=$((FAILURES + 1))
  else
    echo "  PASS: Secret ($secret) defined"
  fi
done

# Check Pain Points (minimum 5)
echo "Checking Pain Points..."
PAIN_COUNT=$(grep -c "^\*\*Pain [0-9]:\*\*" "$SUMMARY_FILE" 2>/dev/null || echo 0)
FILLED_PAINS=$(grep "^\*\*Pain [0-9]:\*\*" "$SUMMARY_FILE" | grep -cv ":\*\*$" 2>/dev/null || echo 0)
if [ "$FILLED_PAINS" -lt 5 ]; then
  echo "  FAIL: Only $FILLED_PAINS pain points filled (need 5+)"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: $FILLED_PAINS pain points defined"
fi

# Check Desires (minimum 4)
echo "Checking Desires..."
FILLED_DESIRES=$(grep "^\*\*Desire [0-9]:\*\*" "$SUMMARY_FILE" | grep -cv ":\*\*$" 2>/dev/null || echo 0)
if [ "$FILLED_DESIRES" -lt 4 ]; then
  echo "  FAIL: Only $FILLED_DESIRES desires filled (need 4+)"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: $FILLED_DESIRES desires defined"
fi

# Check Objections (minimum 6)
echo "Checking Objections..."
FILLED_OBJECTIONS=$(grep -c "^\*\*Objection [0-9]:\*\*" "$SUMMARY_FILE" 2>/dev/null || echo 0)
OBJECTIONS_WITH_ANSWERS=$(grep -A1 "^\*\*Objection [0-9]:\*\*" "$SUMMARY_FILE" | grep -c "Answer:" 2>/dev/null || echo 0)
if [ "$OBJECTIONS_WITH_ANSWERS" -lt 6 ]; then
  echo "  FAIL: Only $OBJECTIONS_WITH_ANSWERS objections have answers (need 6+)"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: $OBJECTIONS_WITH_ANSWERS objections with answers"
fi

# Check Epiphany Bridge elements
echo "Checking Epiphany Bridge..."
EPIPHANY_ELEMENTS=0
for element in "Backstory" "Struggle" "Epiphany Moment" "Solution" "Result"; do
  CONTENT=$(grep -A3 "^\*\*The $element" "$SUMMARY_FILE" | grep -v "^\*\*" | grep -v "^\`\`\`" | head -1)
  if [[ "$CONTENT" != *"["* ]] && [ -n "$CONTENT" ]; then
    EPIPHANY_ELEMENTS=$((EPIPHANY_ELEMENTS + 1))
  fi
done
if [ "$EPIPHANY_ELEMENTS" -lt 5 ]; then
  echo "  FAIL: Only $EPIPHANY_ELEMENTS/5 Epiphany Bridge elements filled"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: All Epiphany Bridge elements defined"
fi

# Check Voice & Tone
echo "Checking Voice & Tone..."
VOICE_CONTENT=$(grep -A3 "Language patterns from competitor" "$SUMMARY_FILE" | grep -v "^\*\*" | grep -v "^\`\`\`" | head -1)
if [[ "$VOICE_CONTENT" == *"["* ]] || [ -z "$VOICE_CONTENT" ]; then
  echo "  FAIL: Voice & Tone not filled"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: Voice & Tone defined"
fi

# Check Dream Customer
echo "Checking Dream Customer..."
CUSTOMER_CONTENT=$(grep -A3 "Who they are:" "$SUMMARY_FILE" | grep -v "^\*\*" | grep -v "^\`\`\`" | head -1)
if [[ "$CUSTOMER_CONTENT" == *"["* ]] || [ -z "$CUSTOMER_CONTENT" ]; then
  echo "  FAIL: Dream Customer not filled"
  FAILURES=$((FAILURES + 1))
else
  echo "  PASS: Dream Customer defined"
fi

# Summary
echo ""
echo "=== SUMMARY ==="
if [ "$FAILURES" -eq 0 ]; then
  echo "PASS: Research summary is complete"
  echo ""
  echo "All copy tasks can now reference this file for:"
  echo "- Specific pain points"
  echo "- Specific desires"
  echo "- Big Domino belief"
  echo "- 3 Secrets framework"
  echo "- Epiphany Bridge story"
  echo "- Voice & Tone guidance"
  exit 0
else
  echo "FAIL: $FAILURES sections need attention"
  echo ""
  echo "FIX: Edit $SUMMARY_FILE and fill in missing sections"
  echo "     Use competitor research to populate each field"
  echo "     Do NOT leave placeholder text like [Write here]"
  exit 1
fi
