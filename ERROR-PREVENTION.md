# Error Prevention System

**Version:** 2.0
**Last Updated:** 2026-01-22

This document explains the 7 systemic errors that previously caused 47+ build failures, and how the brunson-magic workflow now prevents them.

---

## Overview

The template system now includes:

- **5 Blocking Validation Gates** in the workflow
- **3 New Validation Scripts** in the tests directory
- **Auto-Fix Procedures** for common errors
- **Schema Contract Enforcement** via IMAGE-SCHEMA.json

**Goal:** Zero errors when duplicating this template and building with new assets.

---

## The 7 Systemic Errors

### ERROR #1: Hardcoded Image Paths (🔴 CRITICAL - #1 Cause)

**What It Is:**
Templates contain `src="images/product/01.webp"` instead of `{{PRODUCT_IMAGE_1}}`.

**Why It's Bad:**

- build.sh cannot replace hardcoded paths
- Images break when file names change
- Violates IMAGE-SCHEMA.json contract

**How We Prevent It:**

```bash
# Pre-flight gate (before Phase 1)
bash tests/validate-schema-contract.sh
bash tests/validate-hardcoded-paths.sh

# Pre-build gate (Phase 7)
bash tests/validate-hardcoded-paths.sh  # BLOCKING
```

**Auto-Fix:**

1. Detect: `grep -rn 'src="images/' sections/*.html | grep -v '{{'`
2. Identify correct variable from IMAGE-SCHEMA.json
3. Replace with `{{VARIABLE}}`
4. Add variable to product.config if missing
5. Re-run validation

**Example:**

```html
<!-- ❌ WRONG -->
<img src="images/product/black-01.webp" />

<!-- ✅ CORRECT -->
<img src="{{PRODUCT_IMAGE_1}}" />
```

---

### ERROR #2: Missing Images

**What It Is:**
IMAGE-SCHEMA.json requires files that don't exist (e.g., testimonial-06.webp).

**Why It's Bad:**

- Build succeeds but images don't load (404s)
- Visual QA gate fails

**How We Prevent It:**

```bash
# Pre-flight gate
bash tests/validate-images.sh

# Post-build gate (Phase 9)
bash tests/validate-visual-qa.sh  # Checks for 404s
```

**Auto-Fix:**

1. Log missing files
2. Use empty src="" for user to populate later
3. For master template: use fallback/placeholder images

---

### ERROR #3: Insufficient Validation (Before Build)

**What It Is:**
Running build.sh without checking for errors first.

**Why It's Bad:**

- Errors only discovered after build completes
- Wastes time and creates broken HTML

**How We Prevent It:**

```bash
# Phase 7: Pre-build validation gate (MANDATORY)
bash tests/validate-pre-build.sh  # 10 checks before build.sh
```

**Checks Include:**

- Spaced placeholders `{{ VAR }}`
- Order-bump section exists
- COLOR_IMAGE_MAP data element
- JavaScript brace matching
- product.config syntax
- Required section files
- Framework variables defined

---

### ERROR #4: Hidden Sections (desktop-hidden)

**What It Is:**
Content sections have `desktop-hidden` class, making them invisible.

**Why It's Bad:**

- Key content (founder story, reviews, secrets) not visible
- Users can't see the full page

**How We Prevent It:**

```bash
# Phase 9: Visual QA gate checks
grep -c 'desktop-hidden' index.html
```

**Pass:** ≤2 occurrences (slider dots acceptable)
**Fail:** >2 occurrences (main content hidden)

**Auto-Fix:**

1. Remove `desktop-hidden` class from main content sections
2. Keep only for slider pagination dots

---

### ERROR #5: No Visual QA Gate

**What It Is:**
Deploying without verifying the page works in a browser.

**Why It's Bad:**

- Images may not load
- Accordions may not toggle
- Color swatches may not work
- Placeholders may remain in DOM

**How We Prevent It:**

```bash
# Phase 9: MANDATORY BLOCKING GATE
bash tests/validate-visual-qa.sh
# Then run: antigravity-browser-qa skill
```

**8 Required Checks:**

1. ✅ All images load (no 404s)
2. ✅ All sections visible
3. ✅ FAQ accordions toggle
4. ✅ Color swatches work
5. ✅ Carousel navigation works
6. ✅ Founder story visible
7. ✅ Reviews section visible
8. ✅ No raw placeholders in HTML

**This is a HARD GATE - deployment cannot proceed without passing.**

---

### ERROR #6: Framework Violations (ENGAGE/FIBS/3 Secrets)

**What It Is:**
Copy doesn't follow the required frameworks.

**Why It's Bad:**

- Weak headlines (no pattern interrupt)
- Incomplete features (missing FIBS structure)
- 3 Secrets don't map to V-I-E objections

**How We Prevent It:**

```bash
# Phase 4: Framework compliance validation (BLOCKING)
bash tests/validate-framework.sh
```

**ENGAGE Checks:**

- Headline contains pattern interrupt (Why/Stop/Myth/Lie/Secret)
- Tagline contains identity shift
- Story follows Epiphany Bridge structure

**FIBS Checks:**

- 3 Features with Fear/Intrigue/Believability/Stakes
- Each feature mapped to testimonial image

**3 Secrets Checks:**

- SECRET_1 targets Vehicle objection (product type)
- SECRET_2 targets Internal objection (self-doubt)
- SECRET_3 targets External objection (world reaction)
- Each has FALSE_BELIEF → TRUTH pair

**Auto-Fix:**
Return to Phase 4 (engage-fibs-writer) to regenerate affected sections.

---

### ERROR #7: No IMAGE-SCHEMA.json Contract

**What It Is:**
No single source of truth for image requirements.

**Why It's Bad:**

- Templates, config, and files become inconsistent
- Errors cascade across build system

**How We Prevent It:**

```bash
# Pre-flight gate (MANDATORY - before ANY work begins)
bash tests/validate-schema-contract.sh
```

**Schema Enforces:**

- All required directories exist
- All variables defined in product.config
- All templates use `{{VARIABLES}}`, never hardcoded paths

**Contract Elements:**

- `required_images` - directory structure
- `variables` - variable names for each image
- `validation_rules` - max file size, allowed formats

---

## Quick Reference

### Validation Commands

```bash
# Pre-flight (before starting workflow)
bash tests/validate-schema-contract.sh
bash tests/validate-hardcoded-paths.sh

# Pre-build (Phase 7)
bash tests/validate-pre-build.sh

# Post-build (Phase 8)
bash tests/validate-build.sh

# Visual QA (Phase 9 - BLOCKING)
bash tests/validate-visual-qa.sh

# Framework compliance (Phase 4 - BLOCKING)
bash tests/validate-framework.sh

# Full test suite
bash tests/validate-all-tests-pass.sh
```

### Auto-Fix Loop

If errors are detected, the workflow enters an auto-fix loop (Phase 8.5):

1. Run validation suite
2. If errors found, apply auto-fix for each
3. Re-run validation
4. Repeat until PASS or 5 iterations exhausted

**Supported Auto-Fixes:**

- Spaced placeholders → `{{VAR}}`
- Hardcoded paths → `{{VARIABLE}}`
- Missing config variables → Generate from copy_draft.json
- Hidden sections → Remove `desktop-hidden` class

---

## Workflow Integration

The brunson-magic workflow now includes these gates:

| Phase      | Gate                 | Blocking     | Validates         |
| ---------- | -------------------- | ------------ | ----------------- |
| Pre-flight | Schema Contract      | ✅ YES       | Error #1, #7      |
| Phase 4    | Framework Compliance | ✅ YES       | Error #6          |
| Phase 7    | Pre-Build Validation | ✅ YES       | Error #1, #3      |
| Phase 8.5  | Auto-Fix Loop        | 🔄 ITERATIVE | Errors #1-4       |
| Phase 9    | Visual QA Gate       | ✅ YES       | Errors #2, #4, #5 |

**Result:** When you duplicate this template and follow the workflow, these errors cannot occur.

---

## For Future Developers

When duplicating this template:

1. **Copy entire template directory** to new location
2. **Add your product images** to the appropriate folders
3. **Run pre-flight validation** to verify setup
4. **Execute brunson-magic workflow** - it will enforce all gates
5. **Trust the validation scripts** - they catch 99% of errors before build

**Don't:**

- Skip validation gates
- Hardcode image paths
- Modify template files directly without checking schema
- Deploy without running Visual QA

**Do:**

- Use `{{VARIABLES}}` for all dynamic content
- Follow IMAGE-SCHEMA.json contract
- Let auto-fix handle common errors
- Run full test suite before deployment

---

## Support

If you encounter an error not covered by these 7 categories, document it and update this file.

**Validation Scripts:** `/tests/`
**Workflow:** `.agent/workflows/brunson-magic.md`
**Skills:** `.agent/skills/*/SKILL.md`
