---
name: antigravity-e2e-functional
description: CRITICAL functional E2E testing that catches CSS conflicts and hidden elements. Tests FAQ toggle, image visibility, and CTA behavior. MUST PASS before deployment.
activation:
  - /e2e-functional
  - test functional behavior
  - verify faq works
  - check images visible
---

# ANTIGRAVITY E2E FUNCTIONAL TESTING

This skill tests **FUNCTIONAL BEHAVIOR** that static analysis and basic visual checks miss:

- FAQ accordions actually OPEN and show content
- Images are VISIBLE (not hidden by CSS)
- CTA buttons RESPOND to clicks
- No JavaScript errors occur

**CRITICAL:** These are the bugs that reach production when skipped.

## WHY THIS EXISTS

Previous builds passed all static checks but failed in production because:

1. FAQ chevron rotated but content stayed hidden (CSS conflict)
2. Images loaded but had 0 dimensions (CSS hiding)
3. Console had no errors but interactions failed

This skill catches these issues.

---

## PREREQUISITES

- Chrome DevTools MCP must be active
- Page URL (local `file://` or live `https://`)

---

## TEST 1: FAQ ACCORDION FUNCTIONALITY

### The Test

For EVERY FAQ item on the page:

1. Take snapshot BEFORE click
2. Click the FAQ question/summary element
3. Wait 500ms for animation
4. Take snapshot AFTER click
5. Verify content area has increased height

### Expected Behavior

- Clicking FAQ reveals answer text
- Content wrapper height goes from 0 to non-zero
- Answer text becomes visible in DOM

### Commands

```javascript
// 1. Find all FAQ items
mcp__chrome - devtools__take_snapshot();
// Look for: .accordion__details, details, [data-faq]

// 2. For each FAQ, get BEFORE state
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const faqs = document.querySelectorAll('.accordion__details, details.faq-item');
    return Array.from(faqs).map((faq, i) => {
      const content = faq.querySelector('.accordion__content-wrapper, .accordion__content, .faq-content');
      const isOpen = faq.hasAttribute('open') || faq.classList.contains('open');
      return {
        index: i,
        isOpen: isOpen,
        contentHeight: content ? content.offsetHeight : 0,
        contentVisible: content ? (content.offsetHeight > 0 && getComputedStyle(content).display !== 'none') : false
      };
    });
  }`,
  });

// 3. Click FIRST FAQ
mcp__chrome - devtools__click({ uid: "[FAQ_SUMMARY_UID]" });

// 4. Wait for animation
mcp__chrome -
  devtools__wait_for({ text: "[first few words of answer]", timeout: 2000 });

// 5. Get AFTER state
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const faq = document.querySelector('.accordion__details[open], details.faq-item[open]');
    if (!faq) return { error: 'No FAQ is open' };

    const content = faq.querySelector('.accordion__content-wrapper, .accordion__content');
    const computedStyle = content ? getComputedStyle(content) : null;

    return {
      isOpen: true,
      contentHeight: content ? content.offsetHeight : 0,
      contentScrollHeight: content ? content.scrollHeight : 0,
      display: computedStyle?.display,
      visibility: computedStyle?.visibility,
      maxHeight: computedStyle?.maxHeight,
      gridTemplateRows: computedStyle?.gridTemplateRows,
      overflow: computedStyle?.overflow,
      contentText: content?.innerText?.slice(0, 100) || 'NO TEXT'
    };
  }`,
  });
```

### PASS Criteria

- `contentHeight > 20` after click
- `display !== 'none'`
- `contentText` contains actual answer (not empty)

### FAIL Indicators

| Symptom                               | Cause                                  | Fix                                                                    |
| ------------------------------------- | -------------------------------------- | ---------------------------------------------------------------------- |
| `contentHeight: 0` but `isOpen: true` | CSS conflict (grid vs max-height)      | Add `display: block !important; grid-template-rows: unset !important;` |
| `gridTemplateRows: "0fr"` after open  | base.css using broken sibling selector | Override with `grid-template-rows: unset !important;`                  |
| `maxHeight: "0px"` after open         | Inline CSS not applied                 | Check selector specificity                                             |
| No `contentText`                      | Content wrapper empty                  | Check template structure                                               |

### Auto-Fix CSS

If FAQ fails, add this to `<style>` in index.html:

```css
/* ACCORDION FIX - Override base.css grid system */
.accordion__details .accordion__content-wrapper {
  display: block !important;
  grid-template-rows: unset !important;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease-out;
}

.accordion__details[open] .accordion__content-wrapper {
  max-height: 1000px;
}

.accordion__content {
  opacity: 1 !important;
  visibility: visible !important;
  padding-bottom: 1.5rem;
}
```

---

## TEST 2: TESTIMONIAL IMAGE VISIBILITY

### The Test

For EVERY testimonial card image:

1. Get image element dimensions
2. Check computed CSS (display, visibility, opacity)
3. Verify image is actually visible to user

### Expected Behavior

- Each testimonial card shows a profile image
- Image has non-zero width AND height
- Image is not hidden by CSS

### Commands

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const cards = document.querySelectorAll('.testimonial-card, .multicolumn-card');
    return Array.from(cards).map((card, i) => {
      const imgWrapper = card.querySelector('.multicolumn-card__image-wrapper');
      const media = card.querySelector('.media, .media--transparent');
      const img = card.querySelector('img, .multicolumn-card__image');

      const getStyles = (el) => {
        if (!el) return null;
        const style = getComputedStyle(el);
        return {
          display: style.display,
          visibility: style.visibility,
          opacity: style.opacity,
          width: el.offsetWidth,
          height: el.offsetHeight,
          position: style.position
        };
      };

      return {
        cardIndex: i,
        hasWrapper: !!imgWrapper,
        hasMedia: !!media,
        hasImg: !!img,
        imgSrc: img?.src?.slice(-40) || 'NO SRC',
        imgNaturalWidth: img?.naturalWidth || 0,
        imgNaturalHeight: img?.naturalHeight || 0,
        wrapperStyles: getStyles(imgWrapper),
        mediaStyles: getStyles(media),
        imgStyles: getStyles(img),
        isVisible: img && img.offsetWidth > 0 && img.offsetHeight > 0 &&
                   getComputedStyle(img).display !== 'none' &&
                   getComputedStyle(img).visibility !== 'hidden'
      };
    });
  }`,
  });
```

### PASS Criteria

For EACH testimonial card:

- `imgStyles.width > 50`
- `imgStyles.height > 50`
- `imgStyles.display !== 'none'`
- `imgStyles.visibility !== 'hidden'`
- `imgStyles.opacity > 0`
- `isVisible === true`

### FAIL Indicators

| Symptom                                      | Cause                      | Fix                                                           |
| -------------------------------------------- | -------------------------- | ------------------------------------------------------------- |
| `width: 0, height: 0` but `naturalWidth > 0` | CSS hiding element         | Add `display: block !important; width: 100% !important;`      |
| `mediaStyles.display: 'none'`                | base.css hiding .media     | Add `.testimonial-card .media { display: block !important; }` |
| `wrapperStyles.height: 0`                    | Parent container collapsed | Add `min-height: 150px !important;`                           |
| Images show in thumbnail but not cards       | Selector specificity issue | Use more specific selectors                                   |

### Auto-Fix CSS

If testimonial images fail, add this to `<style>` in index.html:

```css
/* TESTIMONIAL IMAGE FIX - Force visibility */
.testimonial-card .multicolumn-card__image-wrapper,
.testimonial-card .multicolumn-card__image-wrapper .media,
.testimonial-card .multicolumn-card__image-wrapper .media--transparent {
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
  width: 100% !important;
  height: auto !important;
  min-height: 150px !important;
}

.testimonial-card .multicolumn-card__image,
.testimonial-card img {
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
  width: 100% !important;
  height: auto !important;
  min-height: 150px !important;
  object-fit: cover;
}
```

---

## TEST 3: CTA BUTTON FUNCTIONALITY

### The Test

1. Find all CTA buttons (Add to Cart, Buy Now)
2. Verify they are visible and clickable
3. Click and verify expected behavior

### Commands

```javascript
// 1. Find CTA buttons
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const selectors = [
      '.main-product-atc',
      '#auralo-checkout-btn',
      '.button--full-width',
      '[data-add-to-cart]',
      'button[type="submit"]'
    ];

    const buttons = [];
    selectors.forEach(sel => {
      document.querySelectorAll(sel).forEach(btn => {
        const style = getComputedStyle(btn);
        buttons.push({
          selector: sel,
          text: btn.innerText.slice(0, 30),
          visible: btn.offsetWidth > 0 && btn.offsetHeight > 0,
          display: style.display,
          pointerEvents: style.pointerEvents,
          disabled: btn.disabled,
          clickable: style.pointerEvents !== 'none' && !btn.disabled
        });
      });
    });

    return buttons;
  }`,
  });

// 2. Click CTA
mcp__chrome - devtools__click({ uid: "[CTA_BUTTON_UID]" });

// 3. Wait and check for response
mcp__chrome - devtools__wait_for({ text: "checkout", timeout: 3000 });
// OR check for overlay/modal
mcp__chrome - devtools__take_snapshot();
```

### PASS Criteria

- At least 1 CTA button visible
- `pointerEvents !== 'none'`
- Click triggers checkout/overlay/navigation

### FAIL Indicators

| Symptom                  | Cause                                  | Fix                      |
| ------------------------ | -------------------------------------- | ------------------------ |
| `clickable: false`       | Button disabled or pointer-events none | Check JS initialization  |
| Nothing happens on click | Event listener not attached            | Verify scripts.js loaded |
| Console error on click   | JavaScript bug                         | Check console, fix error |

---

## TEST 4: JAVASCRIPT ERROR CHECK

### The Test

1. Load page
2. Interact with all major elements
3. Check console for errors

### Commands

```javascript
// Check for errors
mcp__chrome -
  devtools__list_console_messages({
    types: ["error", "exception"],
  });
```

### PASS Criteria

- 0 JavaScript errors
- 0 uncaught exceptions

### FAIL Indicators

| Error                                      | Cause              | Fix                               |
| ------------------------------------------ | ------------------ | --------------------------------- |
| `Uncaught TypeError: Cannot read property` | Undefined variable | Check script initialization order |
| `Failed to load resource: 404`             | Missing file       | Verify file paths                 |
| `Uncaught ReferenceError`                  | Script not loaded  | Check script tags                 |

---

## OUTPUT REQUIREMENT

Create `e2e_functional_report.md`:

```markdown
# E2E Functional Test Report

**Page:** [URL]
**Date:** [Date]
**Status:** PASSED / FAILED

## Test Results

| Test                  | Status    | Details                      |
| --------------------- | --------- | ---------------------------- |
| 1. FAQ Opens          | PASS/FAIL | [contentHeight before/after] |
| 2. Testimonial Images | PASS/FAIL | [X/Y visible]                |
| 3. CTA Buttons        | PASS/FAIL | [clickable status]           |
| 4. No JS Errors       | PASS/FAIL | [error count]                |

## CSS Debug Data

### FAQ State After Click

- `display`: [value]
- `gridTemplateRows`: [value]
- `maxHeight`: [value]
- `contentHeight`: [value]

### Testimonial Image States

[Table of each image's computed styles]

## Issues Found

[List issues with specific CSS property values]

## Fixes Applied

[List CSS fixes added]

## E2E_FUNCTIONAL: PASSED/FAILED
```

---

## INTEGRATION

This skill MUST be called:

1. **After build.sh** - Test local index.html
2. **After antigravity-browser-qa** - As additional functional verification
3. **After Netlify deploy** - Test live URL

**BLOCKING GATE:** Do NOT deploy if any test fails.

---

## THE LOOP (UP TO 20 ITERATIONS)

If ANY test fails:

1. Document the failure with specific CSS property values
2. Apply the auto-fix CSS to `<style>` section
3. If editing index.html directly won't work, add to product.config and rebuild
4. Re-run the failing test
5. Repeat until PASS or 20 iterations

**EXIT CODE 0** only when ALL 4 tests pass.
