---
name: antigravity-css-conflict-checker
description: Detects CSS conflicts between base.css and inline styles. Catches grid vs max-height animation conflicts, selector specificity issues, and hidden elements.
activation:
  - /css-conflict
  - check css conflicts
  - debug css
  - why is element hidden
---

# ANTIGRAVITY CSS CONFLICT CHECKER

This skill identifies CSS conflicts that cause visual bugs even when HTML structure is correct.

## Common Conflict Patterns

### Pattern 1: Grid vs Max-Height Animation Conflict

**The Problem:**

- base.css uses `grid-template-rows: 0fr/1fr` for accordion animation
- Inline CSS uses `max-height: 0/1000px` for accordion animation
- Both compete, grid wins because it defines row height

**Detection:**

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const elements = document.querySelectorAll('.accordion__content-wrapper');
    return Array.from(elements).map(el => {
      const style = getComputedStyle(el);
      return {
        hasGridRows: style.gridTemplateRows && style.gridTemplateRows !== 'none',
        gridTemplateRows: style.gridTemplateRows,
        hasMaxHeight: style.maxHeight && style.maxHeight !== 'none',
        maxHeight: style.maxHeight,
        display: style.display,
        CONFLICT: style.display === 'grid' && style.maxHeight !== 'none'
      };
    });
  }`,
  });
```

**Resolution:**
Add `display: block !important; grid-template-rows: unset !important;`

---

### Pattern 2: Sibling vs Descendant Selector Mismatch

**The Problem:**

- base.css uses `[open]+.child` (sibling selector)
- But HTML has `.child` as a CHILD of `[open]`, not a sibling
- Selector never matches, styles never apply

**Detection:**

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    // Check if accordion content-wrapper is sibling or child of details
    const details = document.querySelectorAll('.accordion__details, details');
    return Array.from(details).map(d => {
      const siblingWrapper = d.nextElementSibling?.classList.contains('accordion__content-wrapper');
      const childWrapper = d.querySelector('.accordion__content-wrapper');
      return {
        hasSiblingWrapper: siblingWrapper,
        hasChildWrapper: !!childWrapper,
        MISMATCH: !siblingWrapper && !!childWrapper
        // If MISMATCH is true, base.css sibling selectors won't work
      };
    });
  }`,
  });
```

**Resolution:**
Use descendant selector in inline CSS to override.

---

### Pattern 3: Specificity War (base.css vs inline)

**The Problem:**

- base.css has `.parent .child .grandchild { display: none }`
- Inline CSS has `.child { display: block }`
- base.css wins due to higher specificity

**Detection:**

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const suspects = [
      '.media',
      '.media--transparent',
      '.multicolumn-card__image',
      '.multicolumn-card__image-wrapper'
    ];

    return suspects.map(sel => {
      const el = document.querySelector(sel);
      if (!el) return { selector: sel, found: false };

      const style = getComputedStyle(el);
      return {
        selector: sel,
        found: true,
        display: style.display,
        visibility: style.visibility,
        opacity: style.opacity,
        width: el.offsetWidth,
        height: el.offsetHeight,
        HIDDEN: style.display === 'none' ||
                style.visibility === 'hidden' ||
                parseFloat(style.opacity) === 0 ||
                (el.offsetWidth === 0 && el.offsetHeight === 0)
      };
    });
  }`,
  });
```

**Resolution:**
Use more specific selectors with `!important`.

---

## FULL CONFLICT SCAN

Run this comprehensive check:

```javascript
mcp__chrome -
  devtools__evaluate_script({
    function: `() => {
    const report = {
      accordionConflicts: [],
      hiddenElements: [],
      selectorMismatches: [],
      recommendations: []
    };

    // Check accordion CSS conflict
    document.querySelectorAll('.accordion__content-wrapper').forEach((el, i) => {
      const style = getComputedStyle(el);
      const parent = el.closest('.accordion__details, details');
      const isOpen = parent?.hasAttribute('open');

      if (style.display === 'grid' && style.gridTemplateRows.includes('0fr')) {
        report.accordionConflicts.push({
          index: i,
          issue: 'Grid animation blocking content',
          gridTemplateRows: style.gridTemplateRows,
          fix: 'display: block !important; grid-template-rows: unset !important;'
        });
      }

      if (isOpen && el.offsetHeight === 0) {
        report.accordionConflicts.push({
          index: i,
          issue: 'Accordion open but content has 0 height',
          computedHeight: style.height,
          maxHeight: style.maxHeight,
          fix: 'Check max-height animation or grid-template-rows'
        });
      }
    });

    // Check for hidden elements that should be visible
    const shouldBeVisible = [
      '.testimonial-card .media',
      '.testimonial-card img',
      '.multicolumn-card__image',
      '.founder-section',
      '.hero-section'
    ];

    shouldBeVisible.forEach(sel => {
      document.querySelectorAll(sel).forEach((el, i) => {
        const style = getComputedStyle(el);
        const hidden = style.display === 'none' ||
                      style.visibility === 'hidden' ||
                      parseFloat(style.opacity) === 0 ||
                      (el.offsetWidth === 0 && el.offsetHeight === 0);

        if (hidden) {
          report.hiddenElements.push({
            selector: sel,
            index: i,
            display: style.display,
            visibility: style.visibility,
            opacity: style.opacity,
            width: el.offsetWidth,
            height: el.offsetHeight,
            fix: 'display: block !important; visibility: visible !important; opacity: 1 !important;'
          });
        }
      });
    });

    // Check selector structure mismatches
    document.querySelectorAll('.accordion__details, details').forEach((d, i) => {
      const siblingWrapper = d.nextElementSibling?.classList.contains('accordion__content-wrapper');
      const childWrapper = d.querySelector('.accordion__content-wrapper');

      if (!siblingWrapper && childWrapper) {
        report.selectorMismatches.push({
          index: i,
          issue: 'Content wrapper is CHILD not SIBLING',
          note: 'base.css [open]+.wrapper selectors will NOT work',
          fix: 'Use descendant selectors in inline CSS'
        });
      }
    });

    // Generate recommendations
    if (report.accordionConflicts.length > 0) {
      report.recommendations.push(
        'Add to <style>: .accordion__details .accordion__content-wrapper { display: block !important; grid-template-rows: unset !important; }'
      );
    }

    if (report.hiddenElements.length > 0) {
      const selectors = [...new Set(report.hiddenElements.map(h => h.selector))];
      report.recommendations.push(
        'Add to <style>: ' + selectors.join(', ') + ' { display: block !important; visibility: visible !important; }'
      );
    }

    return report;
  }`,
  });
```

---

## KNOWN base.css CONFLICTS

### 1. Accordion Grid Animation

**base.css pattern:**

```css
.accordion__content-wrapper {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 0.2s;
}
.accordion__details[open] + .accordion__content-wrapper {
  grid-template-rows: 1fr;
}
```

**Problem:** Uses `+` sibling selector but HTML has wrapper as CHILD.

**Fix:**

```css
.accordion__details .accordion__content-wrapper {
  display: block !important;
  grid-template-rows: unset !important;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s;
}
.accordion__details[open] .accordion__content-wrapper {
  max-height: 1000px;
}
```

### 2. Media Element Hiding

**base.css pattern:**

```css
.media {
  /* various hiding rules */
}
.media--transparent {
  /* more hiding */
}
```

**Problem:** Hides testimonial images.

**Fix:**

```css
.testimonial-card .media,
.testimonial-card .media--transparent {
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
}
```

### 3. Multicolumn Card Images

**base.css pattern:**

```css
.multicolumn-card__image-wrapper {
  /* may have 0 dimensions */
}
.multicolumn-card__image {
  /* may be hidden */
}
```

**Fix:**

```css
.testimonial-card .multicolumn-card__image-wrapper,
.testimonial-card .multicolumn-card__image {
  display: block !important;
  width: 100% !important;
  height: auto !important;
  min-height: 150px !important;
}
```

---

## OUTPUT REQUIREMENT

Create `css_conflict_report.md`:

```markdown
# CSS Conflict Analysis Report

**Date:** [Date]
**Status:** CONFLICTS FOUND / NO CONFLICTS

## Accordion Conflicts

| Index | Issue | Current Value | Fix |
| ----- | ----- | ------------- | --- |
| ...   | ...   | ...           | ... |

## Hidden Elements

| Selector | Display | Visibility | Fix |
| -------- | ------- | ---------- | --- |
| ...      | ...     | ...        | ... |

## Selector Mismatches

| Issue | Note | Fix |
| ----- | ---- | --- |
| ...   | ...  | ... |

## Recommended CSS Fixes

[Code block with all recommended CSS]

## CSS_CONFLICT_CHECK: PASSED/FAILED
```

---

## INTEGRATION

Run this skill:

1. **After build.sh** - Before browser testing
2. **When E2E tests fail** - To diagnose CSS issues
3. **Before deployment** - Final CSS sanity check

This is a DIAGNOSTIC tool. Use the output to fix issues, then re-run E2E functional tests.
