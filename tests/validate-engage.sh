#!/bin/bash
# Validate ENGAGE framework pattern interrupts in a section
# Usage: bash validate-engage.sh index.html 3

set -e

SECTION_FILE="$1"
MIN_HOOKS="${2:-3}"

if [ -z "$SECTION_FILE" ]; then
  echo "FAIL: No section file specified"
  exit 1
fi

if [ ! -f "$SECTION_FILE" ]; then
  echo "FAIL: Section file not found: $SECTION_FILE"
  exit 1
fi

echo "Validating ENGAGE framework in: $SECTION_FILE"
echo "Minimum pattern interrupts required: $MIN_HOOKS"

# Robust grep/wc counting that works on both Mac and Linux
count_matches() {
    grep -iE "$1" "$2" | wc -l | tr -d ' '
}

QUESTION_HOOKS=$(count_matches "what if|how can|why does|have you ever|could it be|who said|who else" "$SECTION_FILE")
CONTRADICTION_HOOKS=$(count_matches "everyone says|most people think|you've been told|conventional wisdom|they say|it's not|the problem isn't" "$SECTION_FILE")
STAT_HOOKS=$(count_matches "[0-9]+%|[0-9,]+ (women|people|customers|users)|studies show|research proves" "$SECTION_FILE")
UNEXPECTED_HOOKS=$(count_matches "you don't need|stop|forget|instead of|the truth is|boring|myth:|busted" "$SECTION_FILE")
READER_HOOKS=$(count_matches "if you're reading|you already know|you've probably|you might be" "$SECTION_FILE")
CONFESSION_HOOKS=$(count_matches "here's what|nobody talks about|the secret|what .* won't tell|the real reason|confession" "$SECTION_FILE")
TIME_TRAVEL_HOOKS=$(count_matches "imagine [0-9]+ days|picture yourself|a month from now|in just [0-9]+|tomorrow you could" "$SECTION_FILE")
PERMISSION_HOOKS=$(count_matches "stop .*, start|it's okay to|you have permission|give yourself" "$SECTION_FILE")

# Calculate total
TOTAL_HOOKS=$((QUESTION_HOOKS + CONTRADICTION_HOOKS + STAT_HOOKS + UNEXPECTED_HOOKS + READER_HOOKS + CONFESSION_HOOKS + TIME_TRAVEL_HOOKS + PERMISSION_HOOKS))

echo ""
echo "Pattern Interrupts Found:"
echo "  Question Hooks: $QUESTION_HOOKS"
echo "  Contradiction Hooks: $CONTRADICTION_HOOKS"
echo "  Shocking Stat Hooks: $STAT_HOOKS"
echo "  Unexpected Claim Hooks: $UNEXPECTED_HOOKS"
echo "  Reader Callout Hooks: $READER_HOOKS"
echo "  Confession Hooks: $CONFESSION_HOOKS"
echo "  Time Travel Hooks: $TIME_TRAVEL_HOOKS"
echo "  Permission Hooks: $PERMISSION_HOOKS"
echo "  ─────────────────────────────────"
echo "  TOTAL: $TOTAL_HOOKS"

if [ "$TOTAL_HOOKS" -lt "$MIN_HOOKS" ]; then
  echo ""
  echo "FAIL: Not enough pattern interrupts"
  echo "Found: $TOTAL_HOOKS, Required: $MIN_HOOKS"
  exit 1
fi

if [ "$MIN_HOOKS" -ge 3 ]; then
  TYPES_USED=0
  [ "$QUESTION_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$CONTRADICTION_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$STAT_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$UNEXPECTED_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$READER_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$CONFESSION_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$TIME_TRAVEL_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true
  [ "$PERMISSION_HOOKS" -gt 0 ] && ((TYPES_USED++)) || true

  if [ "$TYPES_USED" -lt 2 ]; then
    echo "WARNING: Low hook variety - only $TYPES_USED type(s) used"
  else
    echo "✓ Hook variety: $TYPES_USED different types used"
  fi
fi

echo ""
echo "PASS: ENGAGE framework validated ✓"
exit 0
