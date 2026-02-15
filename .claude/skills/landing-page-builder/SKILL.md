---
name: landing-page-builder
description: REFERENCE DOCUMENT for manual phase-by-phase building. Use /launcher for autonomous builds. This skill is for understanding the workflow or running individual phases manually.
---

# Landing Page Builder for Claude Code CLI

## Overview

This skill builds production-ready landing pages by orchestrating these phases:

1. **Template Reset** - Clear stale content
2. **Research** - Create avatar and strategy
3. **Configure** - Populate product.config
4. **Build** - Generate index.html
5. **Validate** - E2E functional testing
6. **Deploy** - Push to Netlify

**IMPORTANT:** Follow each phase in order. Do NOT skip steps.

---

## PHASE 0: TEMPLATE RESET (MANDATORY)

**Skill:** `/template-reset`

### Step 0.1: Check for Stale Content

```bash
grep "^PRODUCT_NAME=" product.config
```

If output shows a DIFFERENT product than what you're building, continue with reset.

### Step 0.2: Backup and Clear

```bash
cp product.config product.config.backup-$(date +%Y%m%d)
rm -rf context/*.json
```

### Step 0.3: Verify Clean

```bash
grep -c "jeans\|lamp\|[previous product]" product.config
```

**Expected:** 0 matches

**OUTPUT:** `template_reset_report.md`

---

## PHASE 1: INITIALIZE

### Step 1.1: Verify Template Files

```bash
ls -la index.html.bak product.config build.sh
```

**Expected:** All 3 files exist

### Step 1.2: Verify Images

```bash
ls images/product/ | wc -l
ls images/testimonials/ | wc -l
```

**Expected:**

- product/: At least 5 images
- testimonials/: At least 12 images

### Step 1.3: Create Mission File

Create `context/mission.json`:

```json
{
  "product_name": "[FROM USER]",
  "competitor_url": "[FROM USER OR EMPTY]",
  "status": "initialized",
  "timestamp": "[DATE]"
}
```

---

## PHASE 2: RESEARCH

**Skills:** `/avatar-builder`, `/strategy-builder`

### Step 2.1: Create Avatar Profile

Run the avatar-builder skill. Output: `context/avatar_profile.json`

Required sections:

- target_audience
- fears_and_frustrations (3+)
- biases_and_false_beliefs (3+)
- desires (3+)
- objections with answers (3+)
- language_patterns

### Step 2.2: Create Strategy Brief

Run the strategy-builder skill. Output: `context/strategy_brief.json`

Required sections:

- big_domino
- secret_1_vehicle (false_belief + truth)
- secret_2_internal (false_belief + truth)
- secret_3_external (false_belief + truth)
- epiphany_bridge (5 elements)

---

## PHASE 3: CONFIGURE

**Skill:** `/config-builder`

### Step 3.1: Update Core Variables

Edit `product.config`:

```bash
PRODUCT_NAME="[FROM RESEARCH]"
BRAND_NAME="[BRAND]"
PRODUCT_HANDLE="[lowercase-hyphens]"
SUBDOMAIN="[brand]-[product]-landing"
```

### Step 3.2: Update Headlines

```bash
HEADLINE_HOOK="[FROM strategy_brief.big_domino]"
TAGLINE="[Supporting text]"
```

### Step 3.3: Update 3 Secrets

From `strategy_brief.json`:

```bash
SECRET_1_FALSE_BELIEF="[secret_1_vehicle.false_belief]"
SECRET_1_TRUTH="[secret_1_vehicle.truth]"
SECRET_HEADLINE_1="[Headline for Secret 1]"

# Repeat for Secrets 2 and 3
```

### Step 3.4: Update Testimonials (1-12)

```bash
TESTIMONIAL_X_TITLE="[Title]"
TESTIMONIAL_X_QUOTE="[Quote addressing a Secret]"
TESTIMONIAL_X_AUTHOR="[Name]"
TESTIMONIAL_X_LOCATION="[City, State]"
```

### Step 3.5: Update FAQ (1-5)

From `avatar_profile.json` objections:

```bash
FAQ_QUESTION_X="[Objection as question]"
FAQ_ANSWER_X="[Answer]"
```

### Step 3.6: Verify Config

```bash
grep -c '{{' product.config
```

**Expected:** 0 (no placeholders remaining)

---

## PHASE 4: BUILD

### Step 4.1: Run Build Script

```bash
./build.sh
```

**Expected:** "Build complete: index.html created"

### Step 4.2: Verify Build

```bash
grep -c '{{' index.html
wc -c index.html
```

**Expected:**

- 0 placeholders
- At least 50000 bytes

---

## PHASE 5: VALIDATE (CRITICAL)

**Skills:** `/e2e-validator`, `/css-conflict-checker`

### Step 5.1: Run E2E Functional Tests

Run the e2e-validator skill on local file.

**MUST PASS:**

- [ ] FAQ opens and shows content (click each FAQ)
- [ ] Testimonial images visible (width > 50, height > 50)
- [ ] CTA buttons work
- [ ] No JavaScript errors

### Step 5.2: If E2E Fails - Debug CSS

Run the css-conflict-checker skill.

Common fixes to add to `<style>`:

**FAQ Fix:**

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

**Image Fix:**

```css
.testimonial-card .media,
.testimonial-card img {
  display: block !important;
  visibility: visible !important;
  min-height: 150px !important;
}
```

### Step 5.3: Re-run E2E Until Pass

After applying fixes, rebuild and re-test.

**OUTPUT:** `e2e_functional_report.md` with `E2E_FUNCTIONAL: PASSED`

---

## PHASE 6: DEPLOY

### Step 6.1: Create Netlify Site

```bash
netlify sites:create --name "[SUBDOMAIN]"
```

### Step 6.2: Deploy

```bash
netlify deploy --prod --dir .
```

### Step 6.3: Verify Live Site

Run e2e-validator skill on live URL.

**MUST PASS:**

- All images load via CDN
- FAQ works on live site
- HTTPS active

**OUTPUT:** Live URL

---

## VALIDATION CHECKLIST

Before marking complete, ALL must be true:

- [ ] template_reset_report.md exists
- [ ] context/avatar_profile.json exists
- [ ] context/strategy_brief.json exists
- [ ] product.config has 0 placeholders
- [ ] product.config has 0 stale product references
- [ ] index.html exists and > 50KB
- [ ] E2E tests PASSED (FAQ opens, images visible)
- [ ] Netlify deployment successful
- [ ] Live site E2E tests PASSED

---

## TROUBLESHOOTING

### FAQ Doesn't Open

**Cause:** CSS grid vs max-height conflict
**Fix:** Add accordion CSS fix to `<style>` section

### Testimonial Images Not Showing

**Cause:** base.css hiding .media elements
**Fix:** Add image CSS fix to `<style>` section

### Build Has Placeholders

**Cause:** Missing variable in product.config
**Fix:** Check build.sh output, add missing variable

### Stale Product Content

**Cause:** Template not reset before new build
**Fix:** Run template-reset skill, clear all previous content

---

## QUICK REFERENCE

| Phase | Skill                | Output                      |
| ----- | -------------------- | --------------------------- |
| 0     | template-reset       | template_reset_report.md    |
| 2     | avatar-builder       | context/avatar_profile.json |
| 2     | strategy-builder     | context/strategy_brief.json |
| 3     | config-builder       | product.config (updated)    |
| 4     | build.sh             | index.html                  |
| 5     | e2e-validator        | e2e_functional_report.md    |
| 5     | css-conflict-checker | css_conflict_report.md      |
| 6     | netlify deploy       | Live URL                    |
