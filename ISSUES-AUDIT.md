# Antpink ↔ Template Integration Audit

**Date**: 2026-02-11
**Auditor**: Claude Code

---

## CRITICAL ISSUES FOUND & FIXED

### 1. Template Source Path Mismatch (FIXED)

| File                        | Was                                              | Fixed To                                                     |
| --------------------------- | ------------------------------------------------ | ------------------------------------------------------------ |
| `fullautopink.yaml`         | `YES-template-CLEAN-v3-TEMPLATE`                   | `YES-template-VERY clean-v2-template-bulletproof-dock copy 3`  |
| `SKILL.md` (Phase 0)        | `clawd/TEMPLATE-ANGEL-FLOW-CLEAN/`               | `YES-template-VERY clean-v2-template-bulletproof-dock copy 3/` |
| `orchestrator.sh` (Phase 5) | `YES-template-VERY clean-v2-template-bulletproof/` | `YES-template-VERY clean-v2-template-bulletproof-dock copy 3/` |

**Impact**: Workflow would fail at Phase 0 (setup) and Phase 5 (build) — template not found.

### 2. Image Count Mismatch (FIXED)

| Location                      | Was                       | Fixed To                                   |
| ----------------------------- | ------------------------- | ------------------------------------------ |
| `orchestrator.sh` (organize)  | 37 images, `bundles/ (3)` | 34 images, `comparison/ (1), founder/ (1)` |
| `orchestrator.sh` (preflight) | 37 images                 | 34 images (6+25+1+1+1)                     |
| `fullautopink.yaml` (images)  | 8 folders                 | 5 folders                                  |

**Impact**: Image validation would always fail — wrong count and folder structure.

### 3. Comparison Image Naming (FIXED in previous session)

| Was                                            | Fixed To                            |
| ---------------------------------------------- | ----------------------------------- |
| `comparison-good.webp` + `comparison-bad.webp` | `comparison-01.webp` (single image) |

**Impact**: Fullautopink generates `comparison-01.webp` but template expected `comparison-good.webp`.

### 4. copy_final.json Key Mismatch (FIXED)

| Key in copy_final.json                            | Key in build.sh/template | Fix                                    |
| ------------------------------------------------- | ------------------------ | -------------------------------------- |
| `FEATURE_PARAGRAPH_1_1` + `FEATURE_PARAGRAPH_1_2` | `FEATURE_PARAGRAPH_1`    | Merged to single `FEATURE_PARAGRAPH_1` |
| Missing `FEATURE_PARAGRAPH_3`                     | `FEATURE_PARAGRAPH_3`    | Added                                  |

**Impact**: Feature 1 paragraph would be empty in built page.

### 5. No Playwright Visual QA (FIXED)

| Was                                                       | Fixed To                                                                   |
| --------------------------------------------------------- | -------------------------------------------------------------------------- |
| `validate-visual-qa.sh` (grep-based, no browser)          | `playwright-visual-qa.js` (real browser, screenshots, interaction testing) |
| Workflow YAML: "Screenshot desktop+mobile" (aspirational) | Actual Playwright script with 15 checks on desktop AND mobile              |

**Impact**: No real visual validation before deploy. Pages could ship with broken layouts.

### 6. 17-logos.html Removed from Build (FIXED in previous session)

Contained hardcoded magazine names (Vogue, Elle, Harper's, Glamour). Removed from `build.sh` concatenation.

---

## NEW FILES CREATED

| File                            | Purpose                                                       |
| ------------------------------- | ------------------------------------------------------------- |
| `tests/playwright-visual-qa.js` | Comprehensive Playwright QA with 15 checks, desktop + mobile  |
| `TEMPLATE-MAP.md`               | AI-readable reference: sections, variables, images, data flow |
| `ISSUES-AUDIT.md`               | This file                                                     |

---

## PLAYWRIGHT QA CHECKS (15 total, run on both desktop 1440px + mobile 375px)

1. Page loads without timeout
2. No raw `{{PLACEHOLDER}}` text visible
3. No JS console errors
4. No 404 broken image requests
5. All `<img>` elements have valid naturalWidth (not broken)
6. Header visible with non-zero height
7. Product section visible (height > 100px)
8. CTA buttons exist and are visible/clickable
9. FAQ accordion items click-expand
10. Bundle selector cards clickable
11. No horizontal overflow (especially mobile)
12. Footer present and visible
13. Cart drawer opens on click
14. Section-by-section screenshots (comparison, features, founder, testimonials, awards)
15. Page performance metrics (post-deploy only: load time < 3s, SSL)

**Output**: `qa-report.json` (machine-readable) + `qa-screenshots/` (visual evidence)

---

## SELF-HEALING LOOP

The workflow is designed to:

1. **Pre-deploy**: Run `playwright-visual-qa.js --mode pre-deploy` on `file://` URL
2. Agent reads `qa-report.json`, identifies failing checks with `fix` instructions
3. Agent makes fixes to the specific section files indicated
4. Agent runs `./build.sh` to rebuild
5. Agent re-runs QA → repeat until 0 failures
6. **Deploy** to Netlify
7. **Post-deploy**: Run `playwright-visual-qa.js --mode post-deploy` on live URL
8. Additional checks: page speed, SSL, live interaction testing
9. If issues: fix → rebuild → redeploy → re-run
10. **Sign off** when 100% pass

---

## REMAINING WARNINGS (Non-blocking)

- `stylesheets/component-*.css` and `scripts/scripts.js` are 404 in file:// mode (expected — these are Shopify theme assets)
- FAQ accordion `<details>` elements may be hidden in CSS until scrolled into view
- Cart drawer selector may need updating if template changes drawer markup
- `FEATURE_BENEFIT_TEXT` exists in copy_final.json but has no direct template mapping — used by copy agents as raw material

---

## VARIABLE FLOW VERIFIED

```
copy_final.json keys → config-builder populates product.config → build.sh replace_var → index.html
```

All keys in copy_final.json now match product.config variable names which match build.sh replace_var calls.
