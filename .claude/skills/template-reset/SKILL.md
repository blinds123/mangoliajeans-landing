---
name: template-reset
description: Resets template for new product. Clears stale content from previous builds. MUST run before starting any new product. Auto-activates on "reset template", "start new product", "clear previous build".
---

# Template Reset for Claude Code CLI

## Purpose

Prevents stale product contamination - when previous product content carries over into new builds.

---

## STEP 1: Check Current Product in Config

```bash
grep "^PRODUCT_NAME=\|^BRAND_NAME=\|^SUBDOMAIN=" product.config
```

**If output shows a different product than what you're building:** Continue with reset.
**If output shows placeholders or correct product:** Skip to Step 4.

---

## STEP 2: Backup Current Config

```bash
cp product.config product.config.backup-$(date +%Y%m%d)
```

---

## STEP 3: Count Stale References

```bash
# Check for common stale patterns
grep -ci "jeans\|denim\|Low Brand" product.config
grep -ci "lamp\|light\|lipstick" product.config
```

**If count > 0:** Product config has stale content that needs clearing.

---

## STEP 4: Clear Context Directory

```bash
rm -rf context/*.json
ls context/
```

**Expected:** Empty or only template files.

---

## STEP 5: Create Placeholder Config

Replace product-specific values in `product.config` with placeholders:

| Variable        | Replace With        |
| --------------- | ------------------- |
| PRODUCT_NAME    | `{{PRODUCT_NAME}}`  |
| BRAND_NAME      | `{{BRAND_NAME}}`    |
| SUBDOMAIN       | `{{SUBDOMAIN}}`     |
| SITE_URL        | `{{SITE_URL}}`      |
| HEADLINE_HOOK   | `{{HEADLINE_HOOK}}` |
| All copy blocks | `{{VARIABLE_NAME}}` |

---

## STEP 6: Verify Reset

```bash
# Should be 0
grep -cv '{{' product.config | grep -v '^#' | grep -v '^$'

# Should show many placeholders
grep -c '{{' product.config
```

---

## OUTPUT

Create `template_reset_report.md`:

```markdown
# Template Reset Report

**Date:** [Date]
**Previous Product:** [Name from backup]
**Target Product:** [New product name]

## Actions Completed

- [x] Backed up product.config
- [x] Cleared stale product references
- [x] Cleared context/ directory
- [x] Verified placeholders in place

## Stale Content Check

- Previous product references: 0
- Placeholder count: [X]

## TEMPLATE_RESET: COMPLETE
```

---

## WHEN TO USE

**MANDATORY** before:

- Starting any new product build
- Duplicating template for new product
- When unsure if template is clean
