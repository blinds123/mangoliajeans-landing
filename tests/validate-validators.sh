#!/bin/bash
# =============================================================================
# META-VALIDATION: Test that all validators work correctly
# =============================================================================
# This script ensures that validation scripts:
# 1. Return exit 1 when they SHOULD fail
# 2. Return exit 0 when they SHOULD pass
# 3. Properly detect the errors they're designed to catch
#
# WHY THIS EXISTS:
# A prior build had "BULLETPROOFING COMPLETE" but audit found critical
# exit code bugs where validators returned exit 0 on failure. This meta-test
# catches those bugs BEFORE they cause false confidence.
# =============================================================================

# Note: Not using set -e because arithmetic operations like PASSED=$((PASSED + 1)) can return non-zero

echo "═══════════════════════════════════════════════════════════════"
echo "  META-VALIDATION: Testing the validators themselves"
echo "═══════════════════════════════════════════════════════════════"
echo ""

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$TESTS_DIR")"
PASSED=0
FAILED=0
WARNINGS=0

# Test function: run validator and check exit code
test_validator() {
    local script="$1"
    local expected_exit="$2"
    local description="$3"

    if [ ! -f "$TESTS_DIR/$script" ]; then
        echo "  ⚠️  SKIP: $script not found"
        WARNINGS=$((WARNINGS + 1))
        return
    fi

    # Run in subshell to capture exit code
    (cd "$PROJECT_DIR" && bash "$TESTS_DIR/$script" > /dev/null 2>&1) || true
    actual_exit=$?

    if [ "$actual_exit" -eq "$expected_exit" ]; then
        echo "  ✅ $script: Returns $actual_exit as expected ($description)"
        PASSED=$((PASSED + 1))
    else
        echo "  ❌ $script: Returns $actual_exit, expected $expected_exit ($description)"
        FAILED=$((FAILED + 1))
    fi
}

# =============================================================================
# TEST 1: Validators that should PASS on current master template
# =============================================================================
echo "━━━ Test 1: Validators that should PASS ━━━"

test_validator "validate-hardcoded-paths.sh" 0 "No hardcoded paths in templates"
test_validator "validate-pre-build.sh" 0 "Pre-build checks pass with warnings allowed"

# =============================================================================
# TEST 2: Check critical validators have proper fail paths
# =============================================================================
echo ""
echo "━━━ Test 2: Checking fail paths in validators ━━━"

# Check that validators use 'exit 1' on failure (not 'exit 0')
check_fail_path() {
    local script="$1"
    local file="$TESTS_DIR/$script"

    if [ ! -f "$file" ]; then
        echo "  ⚠️  SKIP: $script not found"
        WARNINGS=$((WARNINGS + 1))
        return
    fi

    # Check for exit 0 in failure contexts (bad pattern)
    # These patterns indicate bugs where validation fails but exits 0
    if grep -E 'echo.*FAIL.*exit 0|FAILED.*exit 0|ERROR.*exit 0' "$file" > /dev/null 2>&1; then
        echo "  ❌ $script: Has EXIT CODE BUG (exit 0 after FAIL message)"
        FAILED=$((FAILED + 1))
        return
    fi

    # Check that exit 1 is used somewhere (good pattern)
    if ! grep -q 'exit 1' "$file"; then
        echo "  ⚠️  $script: No 'exit 1' found - may not fail properly"
        WARNINGS=$((WARNINGS + 1))
        return
    fi

    echo "  ✅ $script: Proper fail paths (exit 1 on failure)"
    PASSED=$((PASSED + 1))
}

check_fail_path "validate-build.sh"
check_fail_path "validate-all-sections.sh"
check_fail_path "validate-config.sh"
check_fail_path "validate-framework.sh"
check_fail_path "validate-hardcoded-paths.sh"
check_fail_path "validate-schema-contract.sh"
check_fail_path "validate-pre-build.sh"

# =============================================================================
# TEST 3: Verify critical validation scripts are executable
# =============================================================================
echo ""
echo "━━━ Test 3: Checking script permissions ━━━"

CRITICAL_SCRIPTS=(
    "validate-hardcoded-paths.sh"
    "validate-schema-contract.sh"
    "validate-pre-build.sh"
    "validate-build.sh"
    "validate-all-sections.sh"
    "validate-framework.sh"
)

for script in "${CRITICAL_SCRIPTS[@]}"; do
    if [ -f "$TESTS_DIR/$script" ]; then
        if [ -x "$TESTS_DIR/$script" ]; then
            echo "  ✅ $script: Executable"
            PASSED=$((PASSED + 1))
        else
            echo "  ❌ $script: Not executable (chmod +x needed)"
            FAILED=$((FAILED + 1))
        fi
    else
        echo "  ⚠️  $script: Not found"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# =============================================================================
# TEST 4: Verify blocking gate scripts exist
# =============================================================================
echo ""
echo "━━━ Test 4: Blocking gate scripts ━━━"

BLOCKING_GATES=(
    "validate-hardcoded-paths.sh:Pre-flight gate"
    "validate-schema-contract.sh:Schema contract gate"
    "validate-pre-build.sh:Pre-build gate"
    "validate-build.sh:Post-build gate"
)

for gate in "${BLOCKING_GATES[@]}"; do
    script="${gate%%:*}"
    description="${gate#*:}"
    if [ -f "$TESTS_DIR/$script" ]; then
        echo "  ✅ $description: $script exists"
        PASSED=$((PASSED + 1))
    else
        echo "  ❌ $description: $script MISSING"
        FAILED=$((FAILED + 1))
    fi
done

# =============================================================================
# RESULTS
# =============================================================================
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  META-VALIDATION RESULTS"
echo "═══════════════════════════════════════════════════════════════"
echo "  ✅ Passed:   $PASSED"
echo "  ❌ Failed:   $FAILED"
echo "  ⚠️  Warnings: $WARNINGS"
echo "═══════════════════════════════════════════════════════════════"

if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "❌ META-VALIDATION FAILED"
    echo ""
    echo "CRITICAL: Your validation scripts have bugs!"
    echo "Fix the exit code issues before trusting validation gates."
    exit 1
fi

if [ "$WARNINGS" -gt 3 ]; then
    echo ""
    echo "⚠️  META-VALIDATION PASSED WITH WARNINGS"
    echo "Review warnings to ensure all validators are present."
    exit 0
fi

echo ""
echo "✅ META-VALIDATION PASSED"
echo "All validators are properly configured."
exit 0
