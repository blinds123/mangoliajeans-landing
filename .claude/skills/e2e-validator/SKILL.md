---
name: e2e-validator
description: End-to-end functional testing for landing pages. Tests FAQ accordions, image visibility, button clicks, and JavaScript errors. MUST be run before deployment. Auto-activates on "test landing page", "validate page", "e2e test", "functional test".
---

# E2E Validator for Landing Pages

## Purpose

This skill performs **functional testing** that the static auditor cannot do:

- Clicks interactive elements (FAQ, buttons)
- Verifies images actually render (not just exist in HTML)
- Checks for JavaScript errors
- Tests responsive behavior

**CRITICAL:** This skill catches issues that break user experience but pass static analysis.

---

## PREREQUISITES

You need browser automation. Use ONE of these:

- Chrome DevTools MCP (`mcp__chrome-devtools__*`)
- Claude in Chrome MCP (`mcp__claude-in-chrome__*`)
- Playwright (if configured)

---

## TEST PROCEDURE

### Test 1: Page Loads Successfully

**Steps:**

1. Navigate to page URL (local file:// or https://)
2. Wait for page to fully load
3. Take screenshot

**Pass Criteria:**

- Page loads without error
- Screenshot shows content (not blank)

**Commands:**

```
# Using Chrome DevTools MCP:
mcp__chrome-devtools__navigate_page url="[PAGE_URL]"
mcp__chrome-devtools__take_screenshot
```

---

### Test 2: FAQ Accordions Open

**Steps:**

1. Scroll to FAQ section (look for "COMMON QUESTIONS" or "FAQ")
2. For EACH FAQ item:
   a. Take screenshot BEFORE click
   b. Click the FAQ question
   c. Wait 500ms
   d. Take screenshot AFTER click
   e. Verify content appeared (height increased)

**Pass Criteria:**

- Clicking FAQ item reveals answer text
- Content area has non-zero height after click
- Chevron/icon rotates (visual indicator of open state)

**Commands:**

```
# Using Chrome DevTools MCP:

# 1. Find FAQ section
mcp__chrome-devtools__take_snapshot

# 2. Click first FAQ (find the summary element)
mcp__chrome-devtools__click uid="[FAQ_SUMMARY_UID]"

# 3. Verify content appeared
mcp__chrome-devtools__take_snapshot
# Look for accordion__content with visible text
```

**FAIL INDICATORS:**

- Chevron rotates but no content appears = CSS conflict
- Nothing happens on click = JavaScript error or wrong element

---

### Test 3: Testimonial Images Visible

**Steps:**

1. Scroll to testimonials section
2. Take snapshot
3. For EACH testimonial card:
   a. Find the image element
   b. Check if it has non-zero dimensions
   c. Check if it's visible (not hidden by CSS)

**Pass Criteria:**

- Each testimonial card has visible image
- Image dimensions > 50x50 pixels
- Image is not covered by other elements

**Commands:**

```
# Using Chrome DevTools MCP:

# 1. Navigate to testimonials
mcp__chrome-devtools__take_snapshot

# 2. Run JavaScript to check image dimensions
mcp__chrome-devtools__evaluate_script function="() => {
  const images = document.querySelectorAll('.testimonial-card img, .multicolumn-card__image');
  return Array.from(images).map(img => ({
    src: img.src,
    width: img.offsetWidth,
    height: img.offsetHeight,
    visible: img.offsetWidth > 0 && img.offsetHeight > 0
  }));
}"
```

**FAIL INDICATORS:**

- Image exists in HTML but has 0 width/height = CSS hiding it
- Image shows in thumbnail strip but not in cards = specificity issue

---

### Test 4: CTA Buttons Work

**Steps:**

1. Find all "Add to Cart" or CTA buttons
2. For EACH button:
   a. Verify button is visible
   b. Verify button is clickable (not disabled)
   c. Click button
   d. Verify expected behavior (overlay appears, navigation, etc.)

**Pass Criteria:**

- All CTA buttons are visible
- Clicking shows checkout overlay or navigates

**Commands:**

```
# Using Chrome DevTools MCP:

# 1. Find CTA buttons
mcp__chrome-devtools__take_snapshot
# Look for: .main-product-atc, #auralo-checkout-btn, .button--full-width

# 2. Click CTA
mcp__chrome-devtools__click uid="[CTA_BUTTON_UID]"

# 3. Verify overlay or behavior
mcp__chrome-devtools__take_snapshot
```

---

### Test 5: No JavaScript Errors

**Steps:**

1. Open browser console
2. Navigate to page
3. Interact with page (scroll, click)
4. Check console for errors

**Pass Criteria:**

- No JavaScript errors (red messages)
- Warnings are acceptable but should be minimal

**Commands:**

```
# Using Chrome DevTools MCP:
mcp__chrome-devtools__list_console_messages types=["error"]

# OR using Claude in Chrome MCP:
mcp__claude-in-chrome__read_console_messages onlyErrors=true tabId=[TAB_ID]
```

**FAIL INDICATORS:**

- "Uncaught TypeError" = JavaScript bug
- "Failed to load resource" = Missing file
- "Cannot read property of undefined" = Code error

---

### Test 6: Mobile Responsiveness

**Steps:**

1. Resize browser to mobile viewport (375x667)
2. Take screenshot
3. Verify content is readable
4. Verify buttons are tap-sized (>44px)

**Pass Criteria:**

- No horizontal scrolling
- Text is readable without zooming
- Buttons are large enough to tap

**Commands:**

```
# Using Chrome DevTools MCP:
mcp__chrome-devtools__resize_page width=375 height=667
mcp__chrome-devtools__take_screenshot
```

---

## VALIDATION REPORT

After running all tests, create `e2e_report.md`:

```markdown
# E2E Validation Report

**Page:** [URL]
**Date:** [DATE]
**Status:** PASSED / FAILED

## Test Results

| Test                  | Status    | Notes     |
| --------------------- | --------- | --------- |
| 1. Page Loads         | PASS/FAIL | [details] |
| 2. FAQ Opens          | PASS/FAIL | [details] |
| 3. Testimonial Images | PASS/FAIL | [details] |
| 4. CTA Buttons        | PASS/FAIL | [details] |
| 5. No JS Errors       | PASS/FAIL | [details] |
| 6. Mobile Responsive  | PASS/FAIL | [details] |

## Issues Found

[List any issues with specific details]

## Screenshots

[Reference screenshots taken during testing]
```

---

## COMMON FAILURES AND FIXES

### FAQ Opens But Content Invisible

**Symptom:** Chevron rotates, but answer text doesn't appear
**Cause:** CSS conflict between grid-template-rows and max-height
**Fix:** Add to `<style>` in index.html:

```css
.accordion__details .accordion__content-wrapper {
  display: block !important;
  grid-template-rows: unset !important;
  max-height: 0;
  overflow: hidden;
}
.accordion__details[open] .accordion__content-wrapper {
  max-height: 1000px;
}
```

### Testimonial Images Have 0 Dimensions

**Symptom:** Image element exists but has 0 width/height
**Cause:** Parent container or .media class being hidden
**Fix:** Add to `<style>` in index.html:

```css
.testimonial-card .multicolumn-card__image-wrapper,
.testimonial-card .media,
.testimonial-card .multicolumn-card__image {
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
  width: 100% !important;
  height: auto !important;
  min-height: 150px !important;
}
```

### CTA Button Doesn't Respond

**Symptom:** Button click does nothing
**Cause:** JavaScript not loaded or event listener missing
**Fix:** Check console for errors, verify scripts.js loaded

### Page Has Horizontal Scroll on Mobile

**Symptom:** Content wider than viewport
**Cause:** Fixed-width element breaking layout
**Fix:** Find element with fixed width, add max-width: 100%

---

## MANDATORY EXIT CONDITIONS

**PASS:** All 6 tests pass

- Page loads
- FAQ opens and shows content
- Testimonial images visible with non-zero dimensions
- CTA buttons work
- No JavaScript errors
- Mobile responsive

**FAIL:** Any test fails

- DO NOT DEPLOY until all tests pass
- Fix the issue
- Re-run validation

---

## INTEGRATION WITH BUILD WORKFLOW

This skill should be called:

1. **After build.sh** - Test local index.html
2. **After Netlify deploy** - Test live URL

Both must pass before marking deployment complete.
