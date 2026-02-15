---
name: launcher
description: ONE-COMMAND autonomous landing page builder. ONLY triggers on "/launcher" or "launch build for". Requires product name, competitor URL, and pricing.
---

# Launcher - The Only Command You Need

**TRIGGER PHRASE:** `/launcher` or "launch build for"

**DO NOT USE:** "build landing page", "create landing page" (ambiguous)

---

## Command Format

```
/launcher "PRODUCT" "COMPETITOR_URL"
```

**Example:**

```
/launcher "Auralo Lipstick Lamp" "https://competitor.com/product"
```

**Natural language:**

```
Launch build for Auralo Lipstick Lamp, competitor https://competitor.com/product
```

**Note:** Pricing is preset in template ($19 single / $59 bundle / $10 order bump)

---

## PREREQUISITES CHECK (Run First)

Before starting, verify:

### 1. Images Ready

```bash
ls images/product/ | wc -l    # Need 5+
ls images/testimonials/ | wc -l  # Need 12+
ls images/founder/       # Need founder image
```

### 2. Netlify CLI Ready

```bash
netlify status  # Should show logged in
```

### 3. Browser Automation Ready

- Chrome DevTools MCP must be available for E2E testing
- OR user accepts manual E2E verification

**IF ANY PREREQUISITE FAILS:** Stop and tell user what's missing. Do not proceed.

---

## INPUT CAPTURE

From user command, extract:

| Input          | Required | Example                  |
| -------------- | -------- | ------------------------ |
| PRODUCT_NAME   | Yes      | "Auralo Lipstick Lamp"   |
| COMPETITOR_URL | Yes      | "https://competitor.com" |

**Pricing is preset in template:**

- Single: $19
- Bundle: $59
- Order bump: $10

Create `context/mission.json`:

```json
{
  "product_name": "Auralo Lipstick Lamp",
  "competitor_url": "https://competitor.com",
  "started": "2026-01-23",
  "status": "launched"
}
```

---

## EXECUTION MODE

**AUTONOMOUS:** Do not stop for confirmation unless:

- A prerequisite is missing
- A phase fails 3 times
- Context limit approaching (warn user, save progress)

---

## PHASE EXECUTION

Execute each phase. Create the output file. Verify PASS condition. Then proceed.

### Phase 0: Template Reset

**Action:** Clear stale content from previous builds
**Steps:**

1. Backup product.config
2. Clear context/\*.json
3. Verify 0 stale product references
   **Output:** template_reset_report.md
   **Pass:** TEMPLATE_RESET: COMPLETE

### Phase 1: Initialize

**Action:** Verify all required files exist
**Steps:**

1. Check images/product/ has 5+ images
2. Check images/testimonials/ has 12+ images
3. Check images/founder/ has founder image
4. Verify build.sh and product.config exist
   **Output:** context/mission.json
   **Pass:** All files present

### Phase 2A: Scout

**Action:** Research market trends
**Steps:**

1. Search for cultural trends related to product
2. Identify linguistic markers audience uses
3. Find recent sources (last 30 days)
   **Output:** context/market_trends.json
   **Pass:** 3+ trends, 5+ linguistic markers

### Phase 2B: Spy

**Action:** Analyze competitor page
**Steps:**

1. Navigate to competitor URL
2. Screenshot the page
3. Extract pain points (5+)
4. Extract desires (4+)
5. Extract objections with answers (6+)
   **Output:** context/competitor_funnels.json
   **Pass:** All minimums met

### Phase 2C: Profiler

**Action:** Create customer profile
**Steps:**

1. Define demographics
2. Create day-in-the-life scenario
3. Document voice patterns
   **Output:** context/customer_profile.json
   **Pass:** All 3 sections complete

### Phase 2D: Avatar

**Action:** Create full avatar profile
**Steps:**

1. Document fears/frustrations (3+)
2. Document false beliefs (3+)
3. Document desires (3+)
4. Document objections with answers (3+)
5. Document language patterns
6. Document social proof triggers
7. Document decision factors
   **Output:** context/avatar_profile.json
   **Pass:** 7 sections, 3+ items each

### Phase 2E: Mechanic

**Action:** Define product mechanism
**Steps:**

1. Identify unique mechanism
2. Document specifications (3+)
3. Document proof points (2+)
   **Output:** context/mechanism_report.json
   **Pass:** All sections complete

### Phase 2F: Strategist

**Action:** Create strategy brief
**Steps:**

1. Define Big Domino (one belief)
2. Define Secret 1 - Vehicle (false belief + truth)
3. Define Secret 2 - Internal (false belief + truth)
4. Define Secret 3 - External (false belief + truth)
5. Define Epiphany Bridge (5 elements)
   **Output:** context/strategy_brief.json
   **Pass:** Big Domino + 3 Secrets + Epiphany Bridge

### Phase 2G: Neuro

**Action:** Research neuro triggers
**Steps:**

1. Identify dopamine triggers (3+)
2. Identify serotonin triggers (3+)
3. Identify oxytocin triggers (3+)
4. Identify cortisol triggers (3+)
   **Output:** context/neuro_triggers.json
   **Pass:** 4 categories, 3+ each

### Phase 3: Linguist

**Action:** Create linguistic seed map
**Steps:**

1. Define identity seed
2. Define transformation seed
3. Define relief seed
4. Plan 3-touch placements for each
   **Output:** context/linguistic_seed_map.json
   **Pass:** 3+ seeds with placements

### Phase 4A: Copy Writer

**Action:** Write all copy using ENGAGE framework
**Steps:**

1. Write headline (pattern interrupt)
2. Write subhead and opening hook
3. Write 3 features (FIBS each)
4. Write 3 secrets copy
5. Write founder story (5 epiphany elements)
6. Write 12 testimonials
7. Write 5 FAQ
   **Output:** context/copy_draft.json
   **Pass:** All sections complete

### Phase 4B: Perry Brain

**Action:** Optimize copy
**Steps:**

1. Apply avatar language
2. Inject neuro triggers
3. Grease the chute (every line leads to next)
4. Add specificity
   **Output:** context/copy_final.json
   **Pass:** Optimization notes included

### Phase 5: Config Builder

**Action:** Populate product.config
**Steps:**

1. Set PRODUCT_NAME, BRAND_NAME, SUBDOMAIN
2. Set SINGLE_PRICE, BUNDLE_PRICE from mission.json
3. Set HEADLINE_HOOK from strategy_brief.json
4. Set all SECRET variables
5. Set all TESTIMONIAL variables (12)
6. Set all FAQ variables (5)
7. Verify 0 placeholders remain
   **Output:** product.config (updated)
   **Pass:** grep -c '{{' product.config = 0

### Phase 6: Build

**Action:** Generate index.html
**Steps:**

1. Run ./build.sh
2. Verify output exists
3. Verify file > 50KB
4. Verify 0 placeholders in output
   **Output:** index.html
   **Pass:** All verifications pass

### Phase 7: E2E Validate

**Action:** Functional testing
**Steps:**

1. Open file:// URL in browser
2. Click each FAQ - verify content appears
3. Check each testimonial image visible
4. Click CTA - verify response
5. Check console for JS errors
   **Output:** e2e_functional_report.md
   **Pass:** All 4 tests pass

**IF FAIL:**

1. Run CSS conflict checker
2. Identify specific issue
3. Apply fix to index.html style section
4. Rebuild
5. Re-test
6. Loop until pass (max 3 attempts)

### Phase 8: Deploy

**Action:** Push to Netlify
**Steps:**

1. Generate subdomain: [brand]-[product]-landing
2. Create site: netlify sites:create --name "[SUBDOMAIN]"
3. Deploy: netlify deploy --prod --dir .
   **Output:** Live URL
   **Pass:** Deployment successful

### Phase 9: Live Verify

**Action:** Test live site
**Steps:**

1. Open live URL
2. Run same E2E tests as Phase 7
3. Verify HTTPS active
4. Verify all images load
   **Output:** live_e2e_report.md
   **Pass:** All tests pass on live site

---

## COMPLETION REPORT

```markdown
# BUILD COMPLETE

**Product:** [PRODUCT_NAME]
**Live URL:** https://[subdomain].netlify.app
**Pricing:** $[SINGLE] / $[BUNDLE]

## Files Created

- context/mission.json
- context/market_trends.json
- context/competitor_funnels.json
- context/customer_profile.json
- context/avatar_profile.json
- context/mechanism_report.json
- context/strategy_brief.json
- context/neuro_triggers.json
- context/linguistic_seed_map.json
- context/copy_draft.json
- context/copy_final.json
- product.config (updated)
- index.html
- e2e_functional_report.md
- live_e2e_report.md

## Status

- Research: 7/7 files
- Copy: 3/3 files
- Build: PASSED
- E2E Local: PASSED
- E2E Live: PASSED

Landing page is live and verified.
```

---

## CONTEXT LIMIT WARNING

This workflow is extensive. If context limit approaches:

1. Save current progress to `context/workflow_checkpoint.json`
2. Tell user: "Checkpoint saved at Phase X. Start new session and say: resume from checkpoint"
3. Include file list of what's done vs remaining

---

## RESUME FROM CHECKPOINT

If user says "resume from checkpoint":

1. Read `context/workflow_checkpoint.json`
2. Read all existing context/\*.json files
3. Continue from last incomplete phase
4. Do not re-run completed phases

---

## QUICK START

```
/launcher "Your Product" "https://competitor.com" 49 99
```

That's it. I'll handle the rest.
