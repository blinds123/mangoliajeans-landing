#!/bin/bash
# validate-framework.sh - Validates ENGAGE/FIBS/Secrets frameworks in copy
# STRICT MODE: Failures on critical framework violations

echo "=== FRAMEWORK VALIDATION (STRICT) ==="

ERRORS=0

# Check copy_draft.json or copy_final.json exists
COPY_FILE=""
if [ -f "copy_final.json" ]; then
  COPY_FILE="copy_final.json"
elif [ -f "copy_draft.json" ]; then
  COPY_FILE="copy_draft.json"
else
  echo "❌ FAIL: No copy file found (copy_draft.json or copy_final.json)"
  exit 1
fi
echo "✓ Using: $COPY_FILE"

# Check file is valid JSON
if ! jq empty "$COPY_FILE" 2>/dev/null; then
  echo "❌ FAIL: $COPY_FILE is not valid JSON"
  exit 1
fi
echo "✓ Valid JSON"

# === ENGAGE PATTERN CHECK ===
echo ""
echo "--- ENGAGE Pattern Check ---"

# Look for pattern interrupt markers in headlines
ENGAGE_PATTERNS='Why |What if |Stop |The .* Lie|The .* Myth|The .* Secret|Isn.t|Don.t|Never |truth|secret'
HEADLINE=$(jq -r '.engage.headline // .headline // ""' "$COPY_FILE" 2>/dev/null)

if [ -z "$HEADLINE" ]; then
  echo "❌ FAIL: No headline found in engage.headline or headline field"
  ((ERRORS++))
else
  if echo "$HEADLINE" | grep -qiE "$ENGAGE_PATTERNS"; then
    echo "✓ Headline has ENGAGE pattern interrupt"
  else
    echo "❌ FAIL: Headline lacks pattern interrupt (needs: Why/What if/Stop/Myth/Lie/Secret/Truth)"
    echo "   Found: $HEADLINE"
    ((ERRORS++))
  fi
fi

# === FEATURES CHECK (FIBS) ===
echo ""
echo "--- Features Check (FIBS) ---"

FEATURE_COUNT=$(jq '.features | length // 0' "$COPY_FILE" 2>/dev/null)
if [ "$FEATURE_COUNT" -lt 3 ]; then
  echo "❌ FAIL: Need 3+ features with FIBS framework, found $FEATURE_COUNT"
  ((ERRORS++))
else
  echo "✓ Features count: $FEATURE_COUNT"
fi

# === SECRETS CHECK (3 False Beliefs) ===
echo ""
echo "--- Secrets Check (Vehicle/Internal/External) ---"

SECRET_COUNT=$(jq '.secrets | length // 0' "$COPY_FILE" 2>/dev/null)
if [ "$SECRET_COUNT" -lt 3 ]; then
  echo "❌ FAIL: Need 3 secrets (vehicle/internal/external), found $SECRET_COUNT"
  ((ERRORS++))
else
  echo "✓ Secrets count: $SECRET_COUNT"
fi

# === FOUNDER STORY CHECK (Epiphany Bridge) ===
echo ""
echo "--- Founder Story Check (Epiphany Bridge) ---"

HAS_FOUNDER=$(jq 'has("founder_story")' "$COPY_FILE" 2>/dev/null)
if [ "$HAS_FOUNDER" != "true" ]; then
  echo "❌ FAIL: No founder_story section (required for Epiphany Bridge)"
  ((ERRORS++))
else
  # Check for epiphany bridge elements
  BACKSTORY=$(jq -r '.founder_story.backstory // ""' "$COPY_FILE" 2>/dev/null)
  WALL=$(jq -r '.founder_story.wall // ""' "$COPY_FILE" 2>/dev/null)
  EPIPHANY=$(jq -r '.founder_story.epiphany // ""' "$COPY_FILE" 2>/dev/null)
  PLAN=$(jq -r '.founder_story.plan // ""' "$COPY_FILE" 2>/dev/null)
  RESULT=$(jq -r '.founder_story.result // .founder_story.transformation // ""' "$COPY_FILE" 2>/dev/null)

  ELEMENTS=0
  [ -n "$BACKSTORY" ] && [ "$BACKSTORY" != "null" ] && ((ELEMENTS++))
  [ -n "$WALL" ] && [ "$WALL" != "null" ] && ((ELEMENTS++))
  [ -n "$EPIPHANY" ] && [ "$EPIPHANY" != "null" ] && ((ELEMENTS++))
  [ -n "$PLAN" ] && [ "$PLAN" != "null" ] && ((ELEMENTS++))
  [ -n "$RESULT" ] && [ "$RESULT" != "null" ] && ((ELEMENTS++))

  if [ "$ELEMENTS" -lt 3 ]; then
    echo "❌ FAIL: Founder story missing epiphany bridge elements (found $ELEMENTS/5)"
    echo "   Need: backstory, wall, epiphany, plan, result/transformation"
    ((ERRORS++))
  else
    echo "✓ Founder story has $ELEMENTS/5 epiphany bridge elements"
  fi
fi

# === BANNED PATTERNS CHECK ===
echo ""
echo "--- Banned Patterns Check ---"

BANNED_PATTERNS='\$00|XX%|XX months|\[amount\]|\[number\]|The Backstory:|THE EPIPHANY:|Secret 1:|Secret 2:|Secret 3:|{{.*}}'
if grep -qiE "$BANNED_PATTERNS" "$COPY_FILE" 2>/dev/null; then
  echo "❌ FAIL: Banned placeholder patterns found in copy:"
  grep -iE "$BANNED_PATTERNS" "$COPY_FILE" | head -5
  ((ERRORS++))
else
  echo "✓ No banned patterns found"
fi

# === FINAL RESULT ===
echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "=== ❌ FRAMEWORK VALIDATION FAILED ($ERRORS errors) ==="
  exit 1
else
  echo "=== ✅ FRAMEWORK VALIDATION PASSED ==="
  exit 0
fi
