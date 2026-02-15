#!/bin/bash
# Validate Epiphany Bridge (Founder Story) section
# Checks for proper story structure: Backstory → Journey → Epiphany → Bridge

set -e

SECTION_FILE="sections/09-founder-story.html"

if [ ! -f "$SECTION_FILE" ]; then
  echo "FAIL: Founder story section not found: $SECTION_FILE"
  exit 1
fi

echo "Validating Epiphany Bridge structure..."

# Check for FOUNDER_EPIPHANY variable
if ! grep -q '{{FOUNDER_EPIPHANY}}' "$SECTION_FILE"; then
  echo "FAIL: Missing {{FOUNDER_EPIPHANY}} variable"
  echo "FIX: Include the founder's epiphany moment from product.config"
  exit 1
fi
echo "✓ FOUNDER_EPIPHANY variable present"

# Check for FOUNDER_IMAGE variable
if ! grep -q '{{FOUNDER_IMAGE}}' "$SECTION_FILE"; then
  echo "WARNING: Missing {{FOUNDER_IMAGE}} variable"
  echo "Consider adding founder photo for credibility"
fi

# Check for backstory elements
if ! grep -qiE 'i was|my story|years ago|struggled|just like you|i know how' "$SECTION_FILE"; then
  echo "WARNING: May be missing backstory elements"
  echo "Add: 'I was just like you. I struggled with [pain point]...'"
fi

# Check for journey elements
if ! grep -qiE 'tried|attempted|failed|nothing worked|searched|looking for' "$SECTION_FILE"; then
  echo "WARNING: May be missing journey elements"
  echo "Add: 'I tried [solution 1], [solution 2]... Nothing worked until...'"
fi

# Check for epiphany moment
if ! grep -qiE 'realized|discovered|moment|epiphany|everything changed|finally|breakthrough' "$SECTION_FILE"; then
  echo "FAIL: Missing epiphany moment"
  echo "FIX: Add the 'aha' moment where founder discovered the solution"
  exit 1
fi
echo "✓ Epiphany moment present"

# Check for bridge to reader
if ! grep -qiE 'now you|you can|your turn|same transformation|experience|available' "$SECTION_FILE"; then
  echo "WARNING: May be missing bridge to reader"
  echo "Add: 'And now you can experience the same transformation...'"
fi

echo ""
echo "PASS: Epiphany Bridge structure validated ✓"
exit 0
