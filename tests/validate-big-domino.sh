#!/bin/bash
# Validate Big Domino section has proper Russell Brunson structure
# Checks for Hook-Story-Offer and belief shift elements

set -e

SECTION_FILE="sections/07-big-domino.html"

if [ ! -f "$SECTION_FILE" ]; then
  echo "FAIL: Big Domino section not found: $SECTION_FILE"
  exit 1
fi

echo "Validating Big Domino section structure..."

# Check for belief shift language
if ! grep -qiE 'believe|truth|realize|discover|what if|everything you' "$SECTION_FILE"; then
  echo "FAIL: Missing belief shift language"
  echo "FIX: Big Domino must challenge an existing belief and introduce a new one"
  echo "Example: 'What if everything you've been told about [problem] is wrong?'"
  exit 1
fi
echo "✓ Belief shift language present"

# Check for BIG_DOMINO_HEADLINE variable
if ! grep -q '{{BIG_DOMINO_HEADLINE}}' "$SECTION_FILE"; then
  echo "FAIL: Missing {{BIG_DOMINO_HEADLINE}} variable"
  echo "FIX: Include the Big Domino headline from product.config"
  exit 1
fi
echo "✓ BIG_DOMINO_HEADLINE variable present"

# Check for old belief / new belief contrast
if ! grep -qiE 'but|however|instead|the truth|actually|in reality' "$SECTION_FILE"; then
  echo "WARNING: May be missing old belief vs new belief contrast"
  echo "Consider adding contrast between what they believed and the new truth"
fi

# Check for story elements
if ! grep -qiE 'because|why|reason|discovered|found|learned' "$SECTION_FILE"; then
  echo "WARNING: May be missing story elements"
  echo "Consider adding explanation of WHY the old belief is false"
fi

echo ""
echo "PASS: Big Domino structure validated ✓"
exit 0
