#!/bin/bash
# Master validation script - runs all tests and reports overall status

set -e

TESTS_DIR="$(dirname "$0")"
FAILED=0
PASSED=0

echo "=========================================="
echo "RUNNING ALL VALIDATION TESTS"
echo "=========================================="
echo ""

run_test() {
  local test_name="$1"
  local test_script="$2"

  echo "─────────────────────────────────────────"
  echo "TEST: $test_name"
  echo "─────────────────────────────────────────"

  if bash "$test_script" 2>&1; then
    echo "✓ PASSED: $test_name"
    ((PASSED++))
  else
    echo "✗ FAILED: $test_name"
    ((FAILED++))
  fi
  echo ""
}

# Core validation tests
run_test "Brand Avatar Research" "$TESTS_DIR/validate-brand-avatar.sh"
run_test "Product Config" "$TESTS_DIR/validate-config.sh"
run_test "Images Optimized" "$TESTS_DIR/validate-images.sh"
run_test "Build Output" "$TESTS_DIR/validate-build.sh"
run_test "No Placeholders" "$TESTS_DIR/validate-no-placeholders.sh"
run_test "GitHub Repository" "$TESTS_DIR/validate-github.sh"
run_test "Netlify Deployment" "$TESTS_DIR/validate-netlify-deploy.sh"

# NEW: Systemic Error Prevention Tests
run_test "Hardcoded Paths" "$TESTS_DIR/validate-hardcoded-paths.sh"
run_test "Schema Contract" "$TESTS_DIR/validate-schema-contract.sh"

# NEW: Visual QA (if index.html exists)
if [ -f "index.html" ]; then
  run_test "Visual QA" "$TESTS_DIR/validate-visual-qa.sh"
fi

# Section-specific tests
for section in sections/*.html; do
  if [ -f "$section" ]; then
    section_name=$(basename "$section")
    run_test "Section: $section_name" "$TESTS_DIR/validate-section.sh $section"
  fi
done

# Framework-specific tests
if [ -f "sections/07-big-domino.html" ]; then
  run_test "Big Domino Structure" "$TESTS_DIR/validate-big-domino.sh"
fi

if [ -f "sections/18-founder-story.html" ]; then
  run_test "Epiphany Bridge Structure" "$TESTS_DIR/validate-epiphany-bridge.sh"
fi

if [ -f "sections/08-pricing.html" ]; then
  run_test "Order Bump Pre-checked" "$TESTS_DIR/validate-order-bump.sh"
fi

echo "=========================================="
echo "TEST RESULTS SUMMARY"
echo "=========================================="
echo "PASSED: $PASSED"
echo "FAILED: $FAILED"
echo "TOTAL:  $((PASSED + FAILED))"
echo ""

if [ "$FAILED" -gt 0 ]; then
  echo "✗ SOME TESTS FAILED"
  echo "Review failures above and fix issues"
  exit 1
else
  echo "✓ ALL TESTS PASSED"
  exit 0
fi
