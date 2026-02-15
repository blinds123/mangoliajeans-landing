---
name: antigravity-browser-qa
description: Comprehensive browser testing using Chrome DevTools MCP. Runs all visual, functional, accessibility, and E2E tests in one automated flow.
activation:
  - /browser-qa
  - run browser tests
  - antigravity browser
  - test in browser
---

# 🌌 ANTIGRAVITY BROWSER QA

Automated browser testing using Chrome DevTools MCP. This skill orchestrates ALL browser tests in a single automated flow.

## When to Use

- After `./build.sh` generates `index.html` (local QA)
- After deployment to Netlify (live QA)
- When you need to verify visual, functional, and accessibility aspects

## Prerequisites

- Chrome DevTools MCP must be active
- Site URL (local file:// or https://)

## 🔒 BLOCKING GATE CHECKLIST (MANDATORY)

**This is a HARD GATE in Phase 9 of brunson-magic workflow. ALL checks must pass before deployment.**

Before proceeding to Phase 10 (Deployment), verify:

| Check                      | Validation                     | Auto-Fix                         | Priority |
| -------------------------- | ------------------------------ | -------------------------------- | -------- |
| ✅ All images load         | No 404s in Network tab         | Re-map to existing files         | CRITICAL |
| ✅ All sections visible    | DOM elements present & visible | Remove `desktop-hidden`          | CRITICAL |
| ✅ FAQ accordions toggle   | Click test passes              | Fix CSS `pointer-events`         | HIGH     |
| ✅ Color swatches work     | Click changes image            | Fix COLOR_IMAGE_MAP              | HIGH     |
| ✅ Carousel navigation     | Prev/Next buttons work         | Fix JS event handlers            | HIGH     |
| ✅ Founder story visible   | Section not `display:none`     | Remove hiding classes            | HIGH     |
| ✅ Reviews section visible | Section rendered               | Check template inclusion         | HIGH     |
| ✅ No raw placeholders     | Zero `{{` in built HTML        | Re-run build with missing values | CRITICAL |

**Exit Criteria (ALL must be true):**

- ✅ `VISUAL_QA: PASSED` in browser_qa_report.md
- ✅ All 8 checks above verified
- ✅ Screenshots saved to `qa-screenshots/`
- ✅ `bash tests/validate-visual-qa.sh` exits 0

**If ANY check fails:**

1. Return to Phase 7 (Build) or Phase 4 (Copywriting) as appropriate
2. Apply auto-fix if available
3. Re-run validation
4. DO NOT proceed to deployment

**Quick Validation:**

```bash
# Run before browser tests to catch issues early
bash tests/validate-visual-qa.sh
```

## THE BROWSER QA PROTOCOL

### PHASE 1: SETUP

```javascript
// Get or create browser tab
mcp__chrome - devtools__list_pages();

// If no tabs, create one
mcp__chrome - devtools__new_page({ url: SITE_URL });

// Set mobile viewport (iPhone SE)
mcp__chrome - devtools__resize_page({ width: 375, height: 667 });

// Wait for page load
mcp__chrome - devtools__wait_for({ text: "Add to Cart", timeout: 10000 });
```

### PHASE 2: VISUAL TESTS

#### Test 2.1: Page Load Screenshot

```javascript
mcp__chrome -
  devtools__take_screenshot({
    filePath: "qa-screenshots/01-page-load.png",
  });
```

PASS: Content visible, hero section present
FAIL: White screen, timeout

#### Test 2.2: Full Page Capture

```javascript
mcp__chrome -
  devtools__take_screenshot({
    fullPage: true,
    filePath: "qa-screenshots/02-full-page.png",
  });
```

### PHASE 3: IMAGE VALIDATION

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const images = document.querySelectorAll('img');
    const results = {
      total: images.length,
      loaded: 0,
      broken: [],
      nonWebp: []
    };

    images.forEach(img => {
      if (img.complete && img.naturalWidth > 0) {
        results.loaded++;
      } else {
        results.broken.push(img.src.slice(-40));
      }
      if (!img.src.includes('.webp')) {
        results.nonWebp.push(img.src.slice(-40));
      }
    });

    return results;
  }`,
  });
```

PASS: `broken.length === 0`
FAIL: Any broken images

### PHASE 4: CONSOLE ERROR CHECK

```javascript
mcp__chrome -
  devtools__list_console_messages({
    types: ["error", "exception"],
  });
```

PASS: 0 errors
FAIL: Critical JavaScript errors

### PHASE 5: ACCESSIBILITY AUDIT

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const issues = [];

    // Check images have alt text
    document.querySelectorAll('img').forEach(img => {
      if (!img.alt && !img.getAttribute('role')?.includes('presentation')) {
        issues.push({ type: 'img-alt', element: img.src.slice(-30) });
      }
    });

    // Check buttons have accessible names
    document.querySelectorAll('button').forEach(btn => {
      if (!btn.innerText.trim() && !btn.getAttribute('aria-label')) {
        issues.push({ type: 'btn-label', element: btn.className });
      }
    });

    // Check form inputs have labels
    document.querySelectorAll('input').forEach(input => {
      const hasLabel = input.id && document.querySelector(\`label[for="\${input.id}"]\`);
      const hasAriaLabel = input.getAttribute('aria-label');
      if (!hasLabel && !hasAriaLabel && input.type !== 'hidden') {
        issues.push({ type: 'input-label', element: input.name || input.type });
      }
    });

    // Check heading hierarchy
    const headings = document.querySelectorAll('h1, h2, h3, h4, h5, h6');
    const h1Count = document.querySelectorAll('h1').length;
    if (h1Count !== 1) {
      issues.push({ type: 'heading', element: \`Found \${h1Count} h1 tags\` });
    }

    return {
      total: issues.length,
      issues: issues.slice(0, 20),
      passed: issues.length < 5
    };
  }`,
  });
```

PASS: `total < 5` (minor issues OK)
FAIL: `total >= 5`

### PHASE 6: E2E ORDER FLOW

#### Step 6.1: Find CTA

```javascript
mcp__chrome - devtools__take_snapshot();
// Locate "Add to Cart" or "Buy Now" button by uid
```

#### Step 6.2: Check Order Bump

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const checkbox = document.querySelector('input[type="checkbox"]');
    return {
      exists: !!checkbox,
      checked: checkbox?.checked || false,
      label: checkbox?.parentElement?.innerText?.slice(0, 50) || 'No label'
    };
  }`,
  });
```

PASS: `checked === true`
FAIL: Checkbox not checked

#### Step 6.3: Click CTA

```javascript
mcp__chrome - devtools__click({ uid: "[cta-button-uid]" });
mcp__chrome -
  devtools__computer({
    action: "wait",
    duration: 2,
    tabId: X,
  });
```

#### Step 6.4: Verify Checkout

```javascript
mcp__chrome -
  devtools__take_screenshot({
    filePath: "qa-screenshots/03-checkout.png",
  });
mcp__chrome -
  devtools__list_network_requests({
    resourceTypes: ["fetch", "xhr"],
  });
// Look for buy-now or checkout API call
```

PASS: Checkout modal/redirect appears
FAIL: Nothing happens

### PHASE 7: MOBILE RESPONSIVENESS

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const body = document.body;
    return {
      hasHorizontalScroll: body.scrollWidth > window.innerWidth,
      viewportWidth: window.innerWidth,
      contentWidth: body.scrollWidth,
      minFontSize: Math.min(...Array.from(document.querySelectorAll('p, span, a'))
        .map(el => parseFloat(getComputedStyle(el).fontSize)))
    };
  }`,
  });
```

PASS: `hasHorizontalScroll === false && minFontSize >= 14`
FAIL: Overflow or tiny text

### PHASE 8: PERFORMANCE

```javascript
mcp__chrome -
  devtools__performance_start_trace({
    reload: true,
    autoStop: true,
  });
// Wait for trace completion
// Check insights for LCP, CLS
```

PASS: LCP < 2.5s, CLS < 0.1
FAIL: Poor Core Web Vitals

## OUTPUT REQUIREMENT

Create `browser_qa_report.md`:

```markdown
# Browser QA Report

**Site:** [URL]
**Date:** [Date]
**Viewport:** 375x667 (Mobile)

## Test Results

| Test              | Status | Details         |
| ----------------- | ------ | --------------- |
| Page Load         | ✅/❌  | [details]       |
| Images            | ✅/❌  | X/Y loaded      |
| Console Errors    | ✅/❌  | X errors        |
| Accessibility     | ✅/❌  | X issues        |
| E2E Order Flow    | ✅/❌  | [details]       |
| Mobile Responsive | ✅/❌  | [details]       |
| Performance       | ✅/❌  | LCP: Xs, CLS: X |

## Screenshots

- qa-screenshots/01-page-load.png
- qa-screenshots/02-full-page.png
- qa-screenshots/03-checkout.png

## Issues Found

[List any issues]

## BROWSER_QA: PASSED/FAILED
```

## THE LOOP (UP TO 20 ITERATIONS)

If ANY test fails:

1. Document the failure
2. Return to the relevant fix step:
   - Image issues → Re-run optimize_images.py
   - Console errors → Fix JavaScript
   - Accessibility → Add alt text/labels
   - E2E → Fix checkout integration
3. Re-run failed tests
4. Repeat until all pass OR 20 iterations reached

## QUICK COMMANDS

```bash
# Static accessibility check (no browser needed)
bash tests/validate-accessibility.sh index.html

# E2E order flow check
bash tests/validate-e2e-order-flow.sh https://site.netlify.app

# Full browser test runner (generates instructions)
bash tests/browser-test-runner.sh https://site.netlify.app
```
