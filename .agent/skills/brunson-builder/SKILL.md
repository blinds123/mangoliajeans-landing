---
name: brunson-builder
description: Injects copy into HTML templates and builds the final index.html. Use after copy is finalized to generate the production page.
---

# 🌌 BRUNSON BUILDER (ANTIGRAVITY EDITION)

You are the **Antigravity Builder**. You translate high-depth copy and strategy into a functional, pixel-perfect production site.

---

## 🛡️ SAFE EDIT PROTOCOL (MANDATORY - PREVENTS BUILD FAILURES)

### RULE 1: SINGLE-LINE EDITS ONLY

```
❌ FORBIDDEN ACTIONS:
- Replacing more than 5 lines at once
- Using multi_replace_file_content with >2 replacements
- Bulk editing any file containing {{VARIABLE}} placeholders
- Using regex near curly braces { or }

✅ REQUIRED ACTIONS:
- Make ONE edit at a time
- Verify the edit worked by reading the line back
- Run build.sh after each significant edit
- If anything breaks, restore from backup immediately
```

### RULE 2: BACKUP BEFORE EDIT

```bash
# ALWAYS run this before editing 05-main-product.html:
cp sections/05-main-product.html sections/05-main-product.html.bak

# If build breaks:
cp sections/05-main-product.html.bak sections/05-main-product.html
```

### RULE 3: PLACEHOLDER SYNTAX

```
❌ NEVER CREATE: {{ VARIABLE }} (spaces inside)
❌ NEVER CREATE: {{VARIABLE } (mismatched braces)
❌ NEVER CREATE: { {VARIABLE}} (split braces)

✅ ALWAYS USE: {{VARIABLE}} (no spaces, matched braces)
```

### RULE 4: VERIFY AFTER EVERY EDIT

```bash
# After ANY file modification, run:
grep '{{ ' sections/*.html product.config
# If this returns ANY results, you introduced corruption. Fix immediately.
```

### RULE 5: PRODUCT.CONFIG IS THE SINGLE SOURCE OF COPY

```
❌ NEVER: Edit HTML to change text content
❌ NEVER: Hardcode prices, names, or copy in HTML

✅ ALWAYS: Add/edit variables in product.config
✅ ALWAYS: HTML contains only {{VARIABLE}} placeholders
✅ ALWAYS: build.sh performs all substitution
```

---

## When to use this skill

- Use this AFTER `copy_final.json` is created
- Use this to inject content into `product.config`
- Use this to run `./build.sh`

---

## BUILD EXECUTION PROTOCOL

### Step 1: Pre-Build Cleanup (MANDATORY)

```bash
# Auto-fix any spaced placeholders before building
for f in sections/*.html product.config; do
    sed -i '' 's/{{ /{{/g; s/ }}/}}/g' "$f" 2>/dev/null
done
echo "✅ Spaced placeholders auto-fixed"
```

### Step 2: Pre-Build Validation

```bash
bash tests/validate-hardcoded-paths.sh
if [ $? -ne 0 ]; then
    echo "❌ Hardcoded paths found - fix before building"
    exit 1
fi

bash tests/validate-pre-build.sh
if [ $? -ne 0 ]; then
    echo "❌ Pre-build validation failed"
    exit 1
fi
```

### Step 3: Execute Build

```bash
./build.sh
```

### Step 4: Post-Build Verification

```bash
# Verify no placeholders remain
REMAINING=$(grep -c '{{[A-Z_]*}}' index.html 2>/dev/null || echo "0")
if [ "$REMAINING" -gt 0 ]; then
    echo "❌ $REMAINING placeholders still in index.html"
    grep -o '{{[A-Z_]*}}' index.html | sort | uniq -c
    exit 1
fi
echo "✅ Build complete - 0 placeholders remaining"
```

---

## COPY INJECTION PROTOCOL

### How to inject copy from copy_final.json into product.config:

1. Read `copy_final.json`
2. For EACH key-value pair:
   - Find matching variable in `product.config`
   - Replace the value using EXACT string match (not regex)
   - Verify the replacement worked
3. DO NOT edit sections/\*.html directly

### Example (CORRECT):

```bash
# In product.config, change:
HEADLINE_HOOK="Old headline"
# To:
HEADLINE_HOOK="New headline from copy_final.json"
```

### Example (WRONG):

```html
<!-- DO NOT edit HTML directly like this: -->
<h1>New headline</h1>
<!-- This bypasses the variable system -->
```

---

## PROTECTED SECTIONS (DO NOT EDIT)

### 05-main-product.html Protected Zones:

| Zone              | Identifier                             | Why Protected                |
| ----------------- | -------------------------------------- | ---------------------------- |
| Color Swatch Data | `data-map='{{COLOR_IMAGE_MAP}}'`       | JS reads from data attribute |
| Order Bump        | `<!-- CRITICAL SECTION: ORDER BUMP`    | Revenue-critical             |
| Checkout Config   | `const CONFIG =`                       | Breaks payment flow          |
| Price Display     | `{{SINGLE_PRICE}}`, `{{BUNDLE_PRICE}}` | Dynamic pricing              |

**If you need to modify these, ask the user first.**

---

## IMAGE HANDLING

### Rules:

1. All images MUST come from `images/` subdirectories
2. All image paths MUST use `{{VARIABLE}}` syntax
3. If an image is missing, leave `src=""` (empty)
4. NEVER generate or download images without user approval

### Variable Mapping:

| Image Type  | Variable Pattern                                        | Directory              |
| ----------- | ------------------------------------------------------- | ---------------------- |
| Product     | `{{PRODUCT_IMAGE_1}}` to `{{PRODUCT_IMAGE_6}}`          | `images/product/`      |
| Feature     | `{{FEATURE_IMAGE_1}}` to `{{FEATURE_IMAGE_3}}`          | `images/testimonials/` |
| Secret      | `{{SECRET_IMAGE_1}}` to `{{SECRET_IMAGE_3}}`            | `images/testimonials/` |
| Testimonial | `{{TESTIMONIAL_1_IMAGE}}` to `{{TESTIMONIAL_12_IMAGE}}` | `images/testimonials/` |
| Founder     | `{{FOUNDER_IMAGE}}`                                     | `images/founder/`      |
| Comparison  | `{{COMPARISON_IMAGE}}`                                  | `images/comparison/`   |
| Order Bump  | `{{ORDER_BUMP_IMAGE}}`                                  | `images/order-bump/`   |

---

## ERROR RECOVERY

### If build fails:

1. Check for spaced placeholders: `grep '{{ ' sections/*.html`
2. Check for hardcoded paths: `bash tests/validate-hardcoded-paths.sh`
3. Check for syntax errors: `grep -c '{$\|^}' sections/*.html`

### If file is corrupted:

```bash
# Restore from backup
cp sections/05-main-product.html.bak sections/05-main-product.html

# Or restore from git
git checkout sections/05-main-product.html
```

### If JS is broken:

Look for these patterns:

- Orphaned `};` on its own line
- Missing closing braces in objects
- `{{ VARIABLE }}` inside script tags (spaces break JS)

---

## EXIT CRITERIA

Build is complete when:

- ✅ `./build.sh` exits with code 0
- ✅ `grep '{{' index.html` returns 0 results
- ✅ `bash tests/validate-build.sh` passes
- ✅ No console errors when opening index.html in browser
