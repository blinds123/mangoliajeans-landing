#!/bin/bash
# validate-avatar.sh - Validates avatar_profile.json has 7 required sections
set -e

echo "=== AVATAR VALIDATION ==="

# Check file exists
if [ ! -f "avatar_profile.json" ]; then
  echo "FAIL: avatar_profile.json not found"
  exit 1
fi
echo "✓ avatar_profile.json exists"

# Check valid JSON
if ! jq empty avatar_profile.json 2>/dev/null; then
  echo "FAIL: avatar_profile.json is not valid JSON"
  exit 1
fi
echo "✓ Valid JSON"

# Check file size (should have depth)
SIZE=$(wc -c < avatar_profile.json | tr -d ' ')
if [ "$SIZE" -lt 1000 ]; then
  echo "FAIL: Avatar too shallow ($SIZE bytes). Need deep psychological profile."
  exit 1
fi
echo "✓ File size: $SIZE bytes"

# Required 7 sections
SECTIONS=(
  "fears_and_frustrations"
  "biases_and_false_beliefs"
  "jargon_and_language"
  "aspirations_and_identity"
  "objection_matrix"
  "social_proof_triggers"
  "decision_factors"
)

MISSING=0
for section in "${SECTIONS[@]}"; do
  HAS=$(jq "has(\"$section\")" avatar_profile.json 2>/dev/null)
  if [ "$HAS" != "true" ]; then
    echo "FAIL: Missing section: $section"
    ((MISSING++))
  fi
done

if [ "$MISSING" -gt 0 ]; then
  echo ""
  echo "FAIL: Missing $MISSING of 7 required sections"
  exit 1
fi
echo "✓ All 7 sections present"

# Check sections have content
EMPTY=0
for section in "${SECTIONS[@]}"; do
  CONTENT=$(jq -r ".$section | length // 0" avatar_profile.json 2>/dev/null)
  if [ "$CONTENT" -lt 1 ]; then
    echo "WARN: Section '$section' appears empty"
    ((EMPTY++))
  fi
done

if [ "$EMPTY" -gt 2 ]; then
  echo "FAIL: Too many empty sections ($EMPTY). Avatar needs depth."
  exit 1
fi

echo ""
echo "PASS: Avatar validation complete"
exit 0
