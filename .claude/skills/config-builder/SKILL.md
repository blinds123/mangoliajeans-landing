---
name: config-builder
description: Populates product.config with all variables from research and strategy. Auto-activates on "build config", "populate config", "update product.config".
---

# Config Builder for Claude Code CLI

## Purpose

Takes research outputs (avatar, strategy) and populates `product.config` with all required variables.

---

## PREREQUISITES

You need:

1. `avatar_profile.json`
2. `strategy_brief.json`
3. Product images in correct directories
4. Pricing information

---

## STEP 1: Verify Template is Clean

```bash
# Check for placeholders
grep -c '{{' product.config
```

**Expected:** High count (template has placeholders)
**If 0:** Run template-reset skill first

---

## STEP 2: Update Core Identity

```bash
# Update these variables:
PRODUCT_NAME="[From product info]"
BRAND_NAME="[Brand name]"
PRODUCT_HANDLE="[lowercase-with-hyphens]"
SUBDOMAIN="[brand]-[product]-landing"
SITE_URL="https://[subdomain].netlify.app"
```

---

## STEP 3: Update Pricing

```bash
SINGLE_PRICE="[Price]"
BUNDLE_PRICE="[Bundle price]"
BUNDLE_OLD_PRICE="[Crossed out price]"
BUNDLE_SAVINGS="[Savings amount]"
```

---

## STEP 4: Update Headlines (from strategy_brief.json)

```bash
HEADLINE_HOOK="[Big Domino as headline]"
TAGLINE="[Supporting subhead]"
```

---

## STEP 5: Update 3 Secrets (from strategy_brief.json)

```bash
SECRET_1_FALSE_BELIEF="[From secret_1_vehicle.false_belief]"
SECRET_1_TRUTH="[From secret_1_vehicle.truth]"
SECRET_HEADLINE_1="[From secret_1_vehicle.headline]"

SECRET_2_FALSE_BELIEF="[From secret_2_internal.false_belief]"
SECRET_2_TRUTH="[From secret_2_internal.truth]"
SECRET_HEADLINE_2="[From secret_2_internal.headline]"

SECRET_3_FALSE_BELIEF="[From secret_3_external.false_belief]"
SECRET_3_TRUTH="[From secret_3_external.truth]"
SECRET_HEADLINE_3="[From secret_3_external.headline]"
```

---

## STEP 6: Update Founder Story (from strategy_brief.json)

```bash
FOUNDER_BACKSTORY="[From epiphany_bridge.backstory]"
FOUNDER_WALL="[From epiphany_bridge.wall]"
FOUNDER_EPIPHANY="[From epiphany_bridge.epiphany]"
FOUNDER_PLAN="[From epiphany_bridge.plan]"
FOUNDER_TRANSFORMATION="[From epiphany_bridge.transformation]"
```

---

## STEP 7: Update Testimonials

For each testimonial (1-12):

```bash
TESTIMONIAL_X_TITLE="[Short title]"
TESTIMONIAL_X_QUOTE="[Quote addressing Secret 1, 2, or 3]"
TESTIMONIAL_X_AUTHOR="[Name]"
TESTIMONIAL_X_LOCATION="[City, State]"
TESTIMONIAL_X_IMAGE="images/testimonials/testimonial-XX.webp"
```

**Distribution:**

- Testimonials 1-4: Address Secret 1 (Vehicle)
- Testimonials 5-8: Address Secret 2 (Internal)
- Testimonials 9-12: Address Secret 3 (External)

---

## STEP 8: Update FAQ (from avatar objections)

```bash
FAQ_QUESTION_1="[Objection 1 as question]"
FAQ_ANSWER_1="[Answer from avatar_profile.json]"

FAQ_QUESTION_2="[Objection 2 as question]"
FAQ_ANSWER_2="[Answer]"

# Continue for FAQ 3-5
```

---

## STEP 9: Validate Config

```bash
# Should be 0 (no placeholders left)
grep -c '{{' product.config

# Should be 0 (no stale content)
grep -ci "[previous product name]" product.config
```

---

## STEP 10: Run Build

```bash
./build.sh
```

**Expected Output:** "Build complete: index.html created"

---

## OUTPUT

```markdown
# Config Builder Report

**Product:** [Name]
**Date:** [Date]

## Variables Updated

- Core Identity: ✅
- Pricing: ✅
- Headlines: ✅
- 3 Secrets: ✅
- Founder Story: ✅
- Testimonials: ✅ (12/12)
- FAQ: ✅ (5/5)

## Validation

- Placeholders remaining: 0
- Stale content: 0

## CONFIG_BUILD: COMPLETE
```
