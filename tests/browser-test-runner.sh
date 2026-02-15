#!/bin/bash
# Browser Test Runner - Orchestrates all browser tests via Antigravity
# Uses Chrome DevTools MCP through Claude's browser automation

set -e

SITE_URL="${1:-}"
TEST_MODE="${2:-all}"

if [ -z "$SITE_URL" ]; then
  # Try to get from netlify
  SITE_URL=$(netlify status --json 2>/dev/null | grep -oE 'https://[^"]+\.netlify\.app' | head -1 || echo "")

  if [ -z "$SITE_URL" ]; then
    echo "Usage: bash browser-test-runner.sh <site-url> [test-mode]"
    echo ""
    echo "Test modes: all, load, images, mobile, console, cart, a11y, e2e"
    echo ""
    echo "Or deploy first: netlify deploy --prod"
    exit 1
  fi
fi

echo "=============================================="
echo "  ANTIGRAVITY BROWSER TEST RUNNER"
echo "=============================================="
echo ""
echo "Site URL: $SITE_URL"
echo "Test Mode: $TEST_MODE"
echo ""

# Generate test instructions for Claude/Antigravity
cat << EOF

INSTRUCTIONS FOR ANTIGRAVITY BROWSER AUTOMATION:

This test suite uses Chrome DevTools MCP. Execute these tests in order:

## SETUP
1. Use mcp__chrome-devtools__list_pages() to check browser state
2. Use mcp__chrome-devtools__new_page(url="$SITE_URL") to open site
3. Wait for page load: mcp__chrome-devtools__wait_for(text="Add to Cart")

## TEST 1: PAGE LOAD (Mobile 375x667)
mcp__chrome-devtools__resize_page(width=375, height=667)
mcp__chrome-devtools__take_snapshot()
PASS: Content visible, hero section present
FAIL: White screen, timeout, JavaScript errors

## TEST 2: IMAGE LOADING
mcp__chrome-devtools__evaluate_script(function="() => {
  const images = document.querySelectorAll('img');
  const broken = Array.from(images).filter(img => !img.complete || img.naturalWidth === 0);
  return { total: images.length, broken: broken.map(i => i.src) };
}")
PASS: broken.length === 0
FAIL: Any broken images

## TEST 3: CONSOLE ERRORS
mcp__chrome-devtools__list_console_messages(types=["error"])
PASS: 0 critical JavaScript errors
FAIL: Errors blocking functionality

## TEST 4: ACCESSIBILITY (a11y)
mcp__chrome-devtools__evaluate_script(function="() => {
  const issues = [];
  // Check images have alt text
  document.querySelectorAll('img').forEach(img => {
    if (!img.alt) issues.push('Missing alt: ' + img.src.slice(-30));
  });
  // Check buttons have text
  document.querySelectorAll('button').forEach(btn => {
    if (!btn.innerText.trim() && !btn.getAttribute('aria-label'))
      issues.push('Empty button');
  });
  // Check form labels
  document.querySelectorAll('input').forEach(input => {
    if (!input.id || !document.querySelector('label[for=' + input.id + ']'))
      if (!input.getAttribute('aria-label')) issues.push('Unlabeled input');
  });
  // Check color contrast (basic)
  const body = getComputedStyle(document.body);
  return { issues: issues, count: issues.length };
}")
PASS: count < 5 (minor issues OK)
FAIL: count >= 5 (accessibility problems)

## TEST 5: ORDER FLOW (E2E)
1. Find "Add to Cart" button: mcp__chrome-devtools__take_snapshot()
2. Click it: mcp__chrome-devtools__click(uid="[button-uid]")
3. Verify cart updates or checkout initiates
4. Check order bump is pre-checked
PASS: Cart/checkout flow works
FAIL: Button does nothing, errors appear

## TEST 6: MOBILE RESPONSIVENESS
mcp__chrome-devtools__resize_page(width=375, height=667)
mcp__chrome-devtools__take_screenshot(fullPage=true, filePath="mobile-full.png")
mcp__chrome-devtools__evaluate_script(function="() => {
  const body = document.body;
  const hasOverflow = body.scrollWidth > window.innerWidth;
  const textTooSmall = Array.from(document.querySelectorAll('p, span'))
    .some(el => parseFloat(getComputedStyle(el).fontSize) < 14);
  return { overflow: hasOverflow, smallText: textTooSmall };
}")
PASS: No horizontal overflow, text readable
FAIL: Overflow or tiny text

## TEST 7: PERFORMANCE
mcp__chrome-devtools__performance_start_trace(reload=true, autoStop=true)
# Wait for trace to complete
mcp__chrome-devtools__performance_stop_trace()
PASS: LCP < 2.5s, CLS < 0.1
FAIL: Poor Core Web Vitals

## RESULTS
After running all tests, create browser_qa_report.md with:
- Screenshot paths
- Pass/fail for each test
- Issues found and fix recommendations
- Final BROWSER_QA: PASSED/FAILED status

EOF

echo ""
echo "=============================================="
echo "  Run this script, then execute tests via"
echo "  Antigravity browser automation"
echo "=============================================="
exit 0
