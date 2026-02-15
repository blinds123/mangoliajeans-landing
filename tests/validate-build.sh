#!/bin/bash
# Validate the built index.html

set -e

if [ ! -f "index.html" ]; then
  echo "FAIL: index.html not found"
  echo "FIX: Run ./build.sh to assemble sections"
  exit 1
fi

echo "Validating index.html..."

# Check file size (should be substantial)
SIZE=$(wc -c < "index.html")
if [ "$SIZE" -lt 10000 ]; then
  echo "FAIL: index.html too small ($SIZE bytes)"
  echo "FIX: Ensure all 25 sections are included"
  exit 1
fi
echo "✓ File size: $SIZE bytes"

# Check all 25 sections are included (look for section markers or unique content)
SECTION_COUNT=$(grep -c 'class="' index.html 2>/dev/null || echo 0)
if [ "$SECTION_COUNT" -lt 20 ]; then
  echo "WARNING: May be missing sections (only $SECTION_COUNT class attributes found)"
fi

# Verify basic HTML structure
if ! grep -q '<html' index.html; then
  echo "FAIL: Missing <html> tag"
  exit 1
fi

if ! grep -q '</html>' index.html; then
  echo "FAIL: Missing </html> closing tag"
  exit 1
fi

if ! grep -q '<head' index.html; then
  echo "FAIL: Missing <head> tag"
  exit 1
fi

if ! grep -q '<body' index.html; then
  echo "FAIL: Missing <body> tag"
  exit 1
fi
echo "✓ Basic HTML structure valid"

# === ANTIGRAVITY: Check for placeholder text ===
echo ""
echo "Checking for unfilled placeholders..."

PLACEHOLDERS=$(grep -c '{{[A-Z_]*}}' index.html 2>/dev/null || echo "0")
if [ "$PLACEHOLDERS" -gt 0 ]; then
  echo "FAIL: Found $PLACEHOLDERS unfilled placeholders"
  grep -o '{{[A-Z_]*}}' index.html | sort | uniq | head -10
  exit 1
fi
echo "✓ No placeholder text found"

# Check for banned placeholder patterns
BANNED_PATTERNS='"\$00"|"00 designer"|"XX%"|"XX months"|\[amount\]|\[number\]'
if grep -qE "$BANNED_PATTERNS" index.html 2>/dev/null; then
  echo "FAIL: Found banned placeholder patterns (\$00, XX%, [amount], etc.)"
  grep -oE "$BANNED_PATTERNS" index.html | head -5
  exit 1
fi
echo "✓ No banned patterns"

# Check for framework labels that shouldn't appear
FRAMEWORK_LABELS='The Backstory:|THE EPIPHANY:|Secret 1:|Secret 2:|Secret 3:|The Plan:|The Result:'
if grep -qE "$FRAMEWORK_LABELS" index.html 2>/dev/null; then
  echo "WARN: Framework labels visible in copy (should be invisible)"
  grep -oE "$FRAMEWORK_LABELS" index.html | head -3
fi

# Check images are referenced
IMG_COUNT=$(grep -c '<img' index.html 2>/dev/null || echo "0")
echo "✓ Images in page: $IMG_COUNT"

# Check for CTA buttons
CTA_COUNT=$(grep -ciE 'add to cart|buy now|get yours|order now' index.html 2>/dev/null || echo "0")
if [ "$CTA_COUNT" -lt 1 ]; then
  echo "WARN: No CTA buttons found"
else
  echo "✓ CTA buttons: $CTA_COUNT"
fi

echo ""
echo "PASS: Build validated ✓"
exit 0
