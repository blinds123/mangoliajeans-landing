#!/bin/bash
# Validate Brand Avatar Research Output
# Tests that BRAND-AVATAR-*.md has all required components

set -e

AVATAR_FILE=$(ls BRAND-AVATAR-*.md 2>/dev/null | head -1)

if [ -z "$AVATAR_FILE" ]; then
  echo "FAIL: No BRAND-AVATAR-*.md file found"
  echo "FIX: Run brand avatar research on competitor URL"
  exit 1
fi

echo "Validating: $AVATAR_FILE"

# Count pain points (look for numbered pain points or "Pain" keyword)
PAIN_COUNT=$(grep -ciE 'pain point|pain:|frustration|struggle|problem' "$AVATAR_FILE" || echo 0)
if [ "$PAIN_COUNT" -lt 5 ]; then
  echo "FAIL: Only $PAIN_COUNT pain points found, need minimum 5"
  echo "FIX: Re-run research, extract more pain points from competitor reviews and copy"
  exit 1
fi
echo "✓ Pain points: $PAIN_COUNT found (minimum 5)"

# Count desire statements
DESIRE_COUNT=$(grep -ciE 'desire|want|goal|dream|transformation|outcome' "$AVATAR_FILE" || echo 0)
if [ "$DESIRE_COUNT" -lt 4 ]; then
  echo "FAIL: Only $DESIRE_COUNT desire statements found, need minimum 4"
  echo "FIX: Extract more desires from competitor testimonials and benefits"
  exit 1
fi
echo "✓ Desire statements: $DESIRE_COUNT found (minimum 4)"

# Check for Big Domino
if ! grep -qiE 'big domino|core belief|belief shift' "$AVATAR_FILE"; then
  echo "FAIL: Big Domino not defined"
  echo "FIX: Identify the ONE belief shift that makes everything else possible"
  exit 1
fi
echo "✓ Big Domino defined"

# Check for 3 Secrets
if ! grep -qiE 'secret 1|vehicle|other products' "$AVATAR_FILE"; then
  echo "FAIL: Secret 1 (Vehicle) not defined"
  echo "FIX: Address why other products/solutions failed"
  exit 1
fi
echo "✓ Secret 1 (Vehicle) defined"

if ! grep -qiE 'secret 2|internal|not your fault|self.doubt' "$AVATAR_FILE"; then
  echo "FAIL: Secret 2 (Internal) not defined"
  echo "FIX: Address internal beliefs and self-doubt"
  exit 1
fi
echo "✓ Secret 2 (Internal) defined"

if ! grep -qiE 'secret 3|external|industry|system' "$AVATAR_FILE"; then
  echo "FAIL: Secret 3 (External) not defined"
  echo "FIX: Address external factors holding them back"
  exit 1
fi
echo "✓ Secret 3 (External) defined"

# Check for objections
OBJECTION_COUNT=$(grep -ciE 'objection|skeptic|concern|doubt|worry' "$AVATAR_FILE" || echo 0)
if [ "$OBJECTION_COUNT" -lt 6 ]; then
  echo "FAIL: Only $OBJECTION_COUNT objections found, need minimum 6"
  echo "FIX: Extract objections from competitor FAQ, reviews, and comments"
  exit 1
fi
echo "✓ Objections: $OBJECTION_COUNT found (minimum 6)"

# Check for Epiphany Bridge elements
if ! grep -qiE 'epiphany|founder|origin|story|journey' "$AVATAR_FILE"; then
  echo "FAIL: Epiphany Bridge elements not found"
  echo "FIX: Add founder story elements for Epiphany Bridge"
  exit 1
fi
echo "✓ Epiphany Bridge elements found"

echo ""
echo "PASS: Brand Avatar research validated ✓"
exit 0
