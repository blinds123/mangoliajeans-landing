# Template Robustness Fix Plan

## Problem Summary

When duplicating this template and creating a new landing page, the following errors occurred:

| Error                                        | Frequency | Impact                | Root Cause                                |
| -------------------------------------------- | --------- | --------------------- | ----------------------------------------- |
| `{{ BUNDLE_COLOR_MAP }}` placeholder failure | HIGH      | BUILD BLOCKED         | sed introduced spaces inside `{{}}`       |
| `{{ COLOR_IMAGE_MAP }` JS corruption         | HIGH      | Swatches broken       | Multi-replace tool corrupted braces       |
| Order-bump section deleted                   | MEDIUM    | Manual restore needed | No protection markers                     |
| FAQ accordion won't toggle                   | MEDIUM    | UX broken             | CSS `pointer-events: none` or JS conflict |
| Tool mismatch after sed                      | MEDIUM    | Cascading failures    | Whitespace changes broke subsequent edits |

---

## Fix 1: Placeholder Regex Tolerance (CRITICAL)

**File**: `build.sh`

**Problem**: The placeholder detection regex `{{[^}]*}}` fails when AI tools introduce spaces like `{{ VARIABLE }}`.

**Solution**:

1. Add a pre-processing step to normalize all placeholders (remove internal spaces)
2. Update the regex to be more tolerant: `{{\s*[A-Z0-9_]+\s*}}`
3. Add a cleanup function that auto-fixes spaced placeholders

**Implementation**:

```bash
# Add after concatenation, before replacements:
# Normalize placeholders - remove spaces inside {{ }}
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' 's/{{\s*\([A-Z0-9_]*\)\s*}}/{{\1}}/g' index.html
else
    sed -i 's/{{\s*\([A-Z0-9_]*\)\s*}}/{{\1}}/g' index.html
fi
```

---

## Fix 2: Order-Bump Section Protection (HIGH)

**File**: `sections/05-main-product.html`

**Problem**: The order-bump section was accidentally deleted during HTML relocation edits.

**Solution**: Add clear protection markers that AI agents will recognize and preserve:

```html
<!-- ========================================== -->
<!-- CRITICAL SECTION: ORDER BUMP - DO NOT DELETE -->
<!-- This section is required for checkout upsells -->
<!-- ========================================== -->
<div id="order-bump-section" ...>...</div>
<!-- END CRITICAL: ORDER BUMP -->
<!-- ========================================== -->
```

---

## Fix 3: Externalize COLOR_IMAGE_MAP (HIGH)

**File**: `sections/05-main-product.html` + `product.config`

**Problem**: The inline JavaScript `const imageMap = {{COLOR_IMAGE_MAP}};` gets corrupted when AI tools make edits, introducing broken braces like `{{ COLOR_IMAGE_MAP }` or `{{COLOR_IMAGE_MAP}`.

**Solution**:

1. Move the map to a data attribute on a DOM element
2. Read it via JavaScript `JSON.parse()`
3. This separates the variable from the JS syntax

**Before (fragile)**:

```javascript
const imageMap = {{COLOR_IMAGE_MAP}};
```

**After (robust)**:

```html
<div
  id="color-image-data"
  data-map="{{COLOR_IMAGE_MAP}}"
  style="display:none;"
></div>
<script>
  const imageMap = JSON.parse(
    document.getElementById("color-image-data").dataset.map || "{}",
  );
</script>
```

---

## Fix 4: FAQ Accordion CSS Fix (MEDIUM)

**File**: `sections/14-faq.html`

**Problem**: The `<details>` elements don't toggle. Suspected CSS conflict.

**Solution**: Add explicit CSS to ensure clickability:

```css
.accordion__details summary {
  cursor: pointer;
  pointer-events: auto !important;
  user-select: none;
}

.accordion__details summary::-webkit-details-marker {
  display: none;
}

.accordion__details[open] .accordion__content-wrapper {
  display: block;
}
```

Also add JS fallback for browsers with issues:

```javascript
document.querySelectorAll(".accordion__details summary").forEach((summary) => {
  summary.addEventListener("click", (e) => {
    const details = summary.parentElement;
    details.open = !details.open;
  });
});
```

---

## Fix 5: Pre-Build Validation Script (HIGH)

**File**: `tests/validate-pre-build.sh` (NEW)

**Purpose**: Catch common template corruption BEFORE build.sh runs.

**Checks**:

1. All placeholders have correct format (no spaces inside `{{}}`)
2. All `<script>` tags have matching open/close braces
3. Order-bump section exists
4. COLOR_IMAGE_MAP is valid JSON format
5. No orphaned `};` or `{` in JavaScript blocks

---

## Fix 6: Workflow Documentation Update (MEDIUM)

**File**: `.agent/workflows/brunson-magic.md`

**Add section**: "Fragile Template Areas"

```markdown
## ⚠️ FRAGILE TEMPLATE AREAS - HANDLE WITH CARE

These sections are easily corrupted by find/replace operations:

### 1. Color Swatch Script (05-main-product.html:1510-1558)

- Contains `{{COLOR_IMAGE_MAP}}` inside JavaScript
- DO NOT use multi-replace tools on this block
- If editing, use precise single-line edits only

### 2. Order-Bump Section (05-main-product.html:951-964)

- Critical for checkout upsells
- Look for `<!-- CRITICAL SECTION: ORDER BUMP -->` markers
- NEVER delete this section

### 3. Placeholder Syntax

- MUST be `{{VARIABLE_NAME}}` with NO spaces
- If you see `{{ VARIABLE }}` with spaces, it's broken
- Run `bash tests/validate-pre-build.sh` to check
```

---

## Implementation Order

1. **Fix 1** (Placeholder tolerance) - Prevents build failures
2. **Fix 5** (Validation script) - Catches issues early
3. **Fix 3** (Externalize COLOR_IMAGE_MAP) - Prevents JS corruption
4. **Fix 2** (Order-bump protection) - Prevents accidental deletion
5. **Fix 4** (FAQ CSS) - Fixes UX issue
6. **Fix 6** (Documentation) - Prevents future issues

---

## Success Criteria

After implementing these fixes, the template should:

- [ ] Build successfully even if AI introduces `{{ VARIABLE }}` spacing
- [ ] Catch corrupted placeholders before build.sh runs
- [ ] Preserve order-bump section through any HTML edits
- [ ] Have working color swatches even after script block edits
- [ ] Have functioning FAQ accordions
- [ ] Document fragile areas clearly for future agents
