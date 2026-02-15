---
name: css-conflict-checker
description: Diagnoses CSS conflicts between base.css and inline styles. Use when E2E tests fail to identify specific CSS properties causing issues. Auto-activates on "debug css", "css conflict", "why is element hidden".
---

# CSS Conflict Checker for Claude Code CLI

## Purpose

Identifies CSS conflicts that cause visual bugs even when HTML is correct:

- Grid vs max-height animation conflicts (FAQ issues)
- Hidden elements that should be visible (testimonial images)
- Selector specificity wars

---

## STEP 1: Open Page in Browser

Use Chrome DevTools MCP:

```
mcp__chrome-devtools__navigate_page url="[PAGE_URL]"
```

---

## STEP 2: Run Conflict Detection Script

```javascript
mcp__chrome-devtools__evaluate_script function="() => {
  const report = {
    accordionConflicts: [],
    hiddenElements: [],
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
        fix: 'Check max-height or grid-template-rows'
      });
    }
  });

  // Check for hidden elements
  const shouldBeVisible = [
    '.testimonial-card .media',
    '.testimonial-card img',
    '.multicolumn-card__image'
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
          fix: 'display: block !important; visibility: visible !important;'
        });
      }
    });
  });

  // Generate recommendations
  if (report.accordionConflicts.length > 0) {
    report.recommendations.push(
      '.accordion__details .accordion__content-wrapper { display: block !important; grid-template-rows: unset !important; }'
    );
  }

  if (report.hiddenElements.length > 0) {
    report.recommendations.push(
      '.testimonial-card .media, .testimonial-card img { display: block !important; visibility: visible !important; min-height: 150px !important; }'
    );
  }

  return report;
}"
```

---

## STEP 3: Apply Fixes

If conflicts found, add to `<style>` section in index.html:

**For Accordion Conflicts:**

```css
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
```

**For Hidden Elements:**

```css
.testimonial-card .multicolumn-card__image-wrapper,
.testimonial-card .media,
.testimonial-card img {
  display: block !important;
  visibility: visible !important;
  opacity: 1 !important;
  min-height: 150px !important;
}
```

---

## STEP 4: Verify Fix

Re-run the E2E validator skill to confirm issues resolved.

---

## OUTPUT

Create `css_conflict_report.md`:

```markdown
# CSS Conflict Report

**Date:** [Date]
**Status:** CONFLICTS FOUND / NO CONFLICTS

## Accordion Conflicts

[List any grid vs max-height issues]

## Hidden Elements

[List any elements that should be visible but aren't]

## Recommended CSS Fixes

[Code block with all fixes]

## CSS_CONFLICT_CHECK: PASSED/FAILED
```
