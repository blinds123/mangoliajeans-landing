#!/bin/bash
# Validate a section HTML file exists and has basic structure
# Usage: bash validate-section.sh sections/07-big-domino.html

set -e

SECTION_FILE="$1"

if [ -z "$SECTION_FILE" ]; then
  echo "FAIL: No section file specified"
  echo "Usage: bash validate-section.sh sections/XX-name.html"
  exit 1
fi

if [ ! -f "$SECTION_FILE" ]; then
  echo "FAIL: Section file not found: $SECTION_FILE"
  echo "FIX: Generate the section using the task description"
  exit 1
fi

# Check file is not empty
if [ ! -s "$SECTION_FILE" ]; then
  echo "FAIL: Section file is empty: $SECTION_FILE"
  echo "FIX: Regenerate section with actual content"
  exit 1
fi

# Check for HTML structure
if ! grep -q '<' "$SECTION_FILE"; then
  echo "FAIL: No HTML tags found in $SECTION_FILE"
  echo "FIX: Regenerate section with proper HTML structure"
  exit 1
fi

# Check for hardcoded product names (common mistakes)
HARDCODED=$(grep -iE 'waistmafia|leopard|sequin|360.wrap|specific.product' "$SECTION_FILE" 2>/dev/null || echo "")
if [ -n "$HARDCODED" ]; then
  echo "FAIL: Hardcoded product names found in $SECTION_FILE"
  echo "Found: $HARDCODED"
  echo "FIX: Replace hardcoded names with {{VARIABLES}}"
  exit 1
fi

# Check for broken variable syntax
BROKEN_VARS=$(grep -oE '\{\{[^}]*$' "$SECTION_FILE" 2>/dev/null || echo "")
if [ -n "$BROKEN_VARS" ]; then
  echo "FAIL: Broken variable syntax in $SECTION_FILE"
  echo "Found: $BROKEN_VARS"
  echo "FIX: Ensure all {{VARIABLES}} have closing }}"
  exit 1
fi

# Get file size
SIZE=$(wc -c < "$SECTION_FILE")
if [ "$SIZE" -lt 100 ]; then
  echo "WARNING: Section file seems too small ($SIZE bytes)"
  echo "May be missing content"
fi

echo "PASS: Section validated: $SECTION_FILE ✓"
exit 0
