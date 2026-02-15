#!/bin/bash
# Master Self-Healing Script
# Runs all fix scripts in sequence to repair common issues

set -e

echo "=============================================="
echo "   BRUNSON-PROTOCOL AUTO-FIX SYSTEM"
echo "=============================================="
echo ""

BUILD_DIR="${1:-.}"
CONFIG_FILE="${2:-product.config}"
TESTS_DIR="$(dirname "$0")"

# Track what was fixed
FIXES_APPLIED=0
FIXES_FAILED=0

run_fix() {
  local script="$1"
  local description="$2"
  shift 2

  echo ""
  echo ">>> Running: $description"
  echo "-------------------------------------------"

  if bash "$TESTS_DIR/$script" "$@"; then
    echo "PASS: $description"
    return 0
  else
    echo "NEEDS ATTENTION: $description"
    FIXES_FAILED=$((FIXES_FAILED + 1))
    return 1
  fi
}

echo "Starting auto-fix sequence..."
echo "Build directory: $BUILD_DIR"
echo "Config file: $CONFIG_FILE"
echo ""

# Step 1: Fix Images
echo "=============================================="
echo "STEP 1/5: IMAGE VALIDATION & REPAIR"
echo "=============================================="
run_fix "fix-broken-images.sh" "Image validation" "$BUILD_DIR/images" "$BUILD_DIR" || true

# Step 2: Fix Placeholders
echo ""
echo "=============================================="
echo "STEP 2/5: PLACEHOLDER CHECK"
echo "=============================================="
run_fix "fix-placeholders.sh" "Placeholder validation" "$BUILD_DIR" "$CONFIG_FILE" || true

# Step 3: Validate ENGAGE on key sections
echo ""
echo "=============================================="
echo "STEP 3/5: ENGAGE FRAMEWORK VALIDATION"
echo "=============================================="

KEY_SECTIONS=(
  "sections/03-hero.html:2"
  "sections/07-big-domino.html:3"
  "sections/08-secret-1-vehicle.html:2"
  "sections/09-secret-2-internal.html:2"
  "sections/10-secret-3-external.html:2"
  "sections/13-epiphany-bridge.html:3"
)

for section_spec in "${KEY_SECTIONS[@]}"; do
  section=$(echo "$section_spec" | cut -d: -f1)
  min_hooks=$(echo "$section_spec" | cut -d: -f2)

  if [ -f "$BUILD_DIR/$section" ]; then
    if bash "$TESTS_DIR/validate-engage.sh" "$BUILD_DIR/$section" "$min_hooks" 2>/dev/null; then
      echo "PASS: $section ($min_hooks+ hooks)"
    else
      echo "NEEDS HOOKS: $section (need $min_hooks)"
      # Don't exit, just note it
    fi
  fi
done

# Step 4: Check JavaScript
echo ""
echo "=============================================="
echo "STEP 4/5: JAVASCRIPT VALIDATION"
echo "=============================================="
run_fix "fix-console-errors.sh" "JavaScript check" "$BUILD_DIR" || true

# Step 5: Run all validation tests
echo ""
echo "=============================================="
echo "STEP 5/5: FULL VALIDATION SUITE"
echo "=============================================="

if [ -f "$TESTS_DIR/validate-all-tests-pass.sh" ]; then
  echo "Running full test suite..."
  if bash "$TESTS_DIR/validate-all-tests-pass.sh" "$BUILD_DIR" "$CONFIG_FILE"; then
    echo ""
    echo "ALL TESTS PASSED!"
    FIXES_APPLIED=$((FIXES_APPLIED + 1))
  else
    echo ""
    echo "Some tests still failing - see above for details"
    FIXES_FAILED=$((FIXES_FAILED + 1))
  fi
else
  echo "Warning: validate-all-tests-pass.sh not found"
fi

# Summary
echo ""
echo "=============================================="
echo "   AUTO-FIX SUMMARY"
echo "=============================================="
echo ""

if [ "$FIXES_FAILED" -eq 0 ]; then
  echo "STATUS: ALL SYSTEMS GO"
  echo ""
  echo "Next steps:"
  echo "1. Deploy to Netlify: netlify deploy --prod"
  echo "2. Run browser tests in mobile mode"
  echo "3. Verify SimpleSwap checkout"
  exit 0
else
  echo "STATUS: ISSUES FOUND - MANUAL INTERVENTION NEEDED"
  echo ""
  echo "Issues requiring attention: $FIXES_FAILED"
  echo ""
  echo "Ralph will now:"
  echo "1. Read the specific error messages above"
  echo "2. Apply targeted fixes to each issue"
  echo "3. Re-run this auto-fix script"
  echo "4. Repeat until all tests pass"
  echo ""
  echo "If stuck after 3 attempts, common solutions:"
  echo "- Fill missing variables in product.config"
  echo "- Add more images to images/ directory"
  echo "- Add pattern interrupts to copy sections"
  echo "- Check console for JavaScript errors"
  exit 1
fi
