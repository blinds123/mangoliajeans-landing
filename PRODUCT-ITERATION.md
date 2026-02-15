# Product Iteration Roadmap

## Purpose

This file captures product improvements identified from TikTok customer research. Use this to track supplier conversations, feature implementation, and ensure research findings actually improve the product.

**Philosophy:** Customer research should drive product changes, not just copy positioning.

---

## How This Works

### 1. Research Phase (Bulletproof-Research Workflow)

After running `/bulletproof-research`, TikTok deep research outputs:

**File:** `context/tiktok_deep_research.json`

**Key Sections:**

- `comment_analysis.top_5_purchase_blockers` → What stops them from buying
- `offer_gap_analysis.feature_claims` → What features they're asking about
- `product_iteration_roadmap.top_3_improvements` → Ranked improvements with demand validation

### 2. Review Improvements (This File)

The workflow automatically populates recommendations below. Your job:

1. ✅ Review top 3 improvements
2. ✅ Contact supplier with exact questions provided
3. ✅ Make approval decisions
4. ✅ Track implementation status

### 3. Update Product & Copy

After supplier confirms changes:

1. Update `product.config` with new features
2. Generate new product images showing improvements
3. Copy automatically emphasizes new features (they solve real objections)

---

## Current Product Iteration Status

**Last Research Date:** [Auto-populated by workflow]

**TikTok Video Analyzed:** [Auto-populated by workflow]

**Comments Analyzed:** [Auto-populated by workflow]

**Pattern Confidence:** [Auto-populated by workflow]

---

## Top 3 Product Improvements (Ranked by Demand)

### Improvement #1: [Feature Name]

**Demand Validation:**

- Frequency: X mentions across Y comments
- Purchase Blocker Solved: [e.g., sizing_fit_uncertainty]
- Evidence:
  ```
  - "Customer quote 1"
  - "Customer quote 2"
  - "Customer quote 3"
  ```

**Customer Dream Product:**

- Exact Ask: "[What they literally asked for]"
- Desired Outcome: "[What problem it solves]"
- Emotional Payoff: "[How it makes them feel]"

**Implementation:**

- **Supplier Question:** "[Exact question to ask - copy/paste this]"
- **Estimated Cost:** $X.XX per unit increase
- **Production Time:** X weeks
- **MOQ Impact:** [None / Higher MOQ / 3x SKUs]

**Conversion Impact:**

- Current Objection Rate: X% of comments mention this concern
- Estimated Reduction: Eliminate X% of objections
- Copy Transformation:
  - **Before:** "[Current feature claim]"
  - **After:** "[New feature claim with improvement]"
- Estimated Conversion Lift: +X%

**Decision:**

- [ ] APPROVED - Contact supplier
- [ ] TESTING - Run validation test first
- [ ] DEFERRED - Revisit in future
- [ ] REJECTED - Not feasible/strategic

**Status:**

- [ ] Pending Supplier Response
- [ ] Samples Ordered
- [ ] Samples Approved
- [ ] In Production
- [ ] Complete - Product Updated

**Supplier Conversation Log:**

```
[Date]: Asked about [feature] → Response: ...
[Date]: Samples received → Decision: ...
[Date]: Production started → ETA: ...
```

---

### Improvement #2: [Feature Name]

[Same structure as #1]

---

### Improvement #3: [Feature Name]

[Same structure as #1]

---

## Offer Gap Analysis (Bonuses & Claims)

### Bonus Opportunities (Digital/Physical Add-Ons)

**Bonus #1: [Name]**

- **Gap Identified:** "[Customer wish from comments]"
- **Frequency:** X mentions
- **Bonus Idea:** "[Specific deliverable]"
- **Perceived Value:** $XX
- **Creation Time:** X hours
- **Status:**
  - [ ] Not Started
  - [ ] In Progress
  - [ ] Complete
- **File Location:** `[resources/bonuses/filename.pdf]`

**Bonus #2: [Name]**
[Same structure]

### Feature Claims (Product Already Has This)

**Claim #1: [Feature]**

- **Question Asked:** "[What customers were asking]"
- **Frequency:** X mentions
- **Current Product Status:**
  - [ ] YES - Product has this (emphasize in copy)
  - [ ] NO - Product doesn't have this (reframe or add)
  - [ ] UNKNOWN - Ask supplier to confirm
- **If YES, Copy Claim:** "[How to describe it in copy]"
- **If NO, Reframe:** "[Alternative positioning]"
- **Priority:** HIGH / MEDIUM / LOW
- **Updated in product.config:** [ ] Yes [ ] No

**Claim #2: [Feature]**
[Same structure]

### Positioning Counters (Competitor Advantages)

**Counter #1: [Competitor Advantage]**

- **Competitor Has:** "[What they offer that we don't]"
- **Frequency:** X mentions
- **Our Counter-Position:** "[How we reframe this]"
- **Copy Hook:** "[Specific headline/hook to use]"
- **Psychological Reframe:** "[Why our way is actually better]"
- **Where to Mention:** [Villain section / Secret 3 / FAQ]

**Counter #2: [Competitor Advantage]**
[Same structure]

---

## Supplier Conversation Script

**CRITICAL:** Use these exact questions when contacting supplier.

### Priority 1: [Top Improvement Name]

**Question to Ask:**

```
Can you [exact modification request]?

Example: "Can you add removable padded cups with elastic underband to the current design?"
```

**Follow-Up Questions:**

1. What's the cost per unit increase?
2. How many weeks to produce samples for review?
3. What's the MOQ for this modification?
4. Can this be ready for next production run?

**Decision Criteria:**

- If cost <$X/unit AND <X weeks → APPROVE immediately
- If cost $X-Y/unit → Evaluate ROI (conversion lift vs. cost)
- If >X weeks → Consider for v2 instead of current batch

### Priority 2: [Second Improvement Name]

[Same structure]

### Priority 3: [Third Improvement Name]

[Same structure]

---

## Copy Transformation Roadmap

### Current Features (Before Product Changes)

```
FEATURE_1_HEADLINE="[Current headline]"
FEATURE_1_BENEFIT="[Current benefit description]"

FEATURE_2_HEADLINE="[Current headline]"
FEATURE_2_BENEFIT="[Current benefit description]"

FEATURE_3_HEADLINE="[Current headline]"
FEATURE_3_BENEFIT="[Current benefit description]"
```

### After Improvements (Update product.config with these)

```
FEATURE_1_HEADLINE="[NEW headline emphasizing improvement #1]"
FEATURE_1_BENEFIT="[NEW benefit - now solves actual objection]"
FEATURE_1_PROOF="[Proof point from research - X people asked for this]"

FEATURE_2_HEADLINE="[NEW headline emphasizing improvement #2]"
FEATURE_2_BENEFIT="[NEW benefit - solves objection #2]"

FEATURE_3_HEADLINE="[Previous feature, now feature #3]"
FEATURE_3_BENEFIT="[Previous benefit]"
```

**Impact:** Features now solve ACTUAL PROBLEMS (from research) vs. just describing product attributes.

---

## Image Update Checklist

After product improvements are implemented, update images:

**Product Images to Create:**

- [ ] Main product image showing [new feature #1]
- [ ] Close-up of [new feature #1] with annotation
- [ ] Lifestyle shot demonstrating [benefit of feature #1]
- [ ] Main product image showing [new feature #2]
- [ ] Close-up of [new feature #2] with annotation
- [ ] Before/After comparison (if applicable)

**Image Requirements:**

- See `IMAGE-REQUIREMENTS.md` for specs
- Follow `IMAGE-SCHEMA.json` for naming
- Update `IMAGE-MAP.md` after adding new images
- Run `prepare-images.sh` to optimize

---

## Integration with Workflow

### Phase 1.1: TikTok Deep Research

→ Outputs `context/tiktok_deep_research.json`

### Phase 1.5: CODEX-GESTALT Extraction

→ Reads `tiktok_deep_research.json`
→ Extracts product improvement recommendations
→ Populates this file automatically

### User Decision (You):

1. Review recommendations in this file
2. Contact supplier with questions provided
3. Make approval decisions
4. Update status checkboxes

### Phase 4: Build

→ Reads updated `product.config` (after you update it)
→ Copy automatically emphasizes new features

### Result:

→ Product matches customer research
→ Copy writes itself (features solve real objections)
→ Higher conversion (product-market fit)

---

## Prioritization Framework

**Implement Immediately If:**

1. ✅ Demand frequency >25 mentions (validated)
2. ✅ Solves top 3 purchase blocker
3. ✅ Cost increase <$5/unit
4. ✅ Production time <6 weeks
5. ✅ Unlocks major copy claim (becomes Feature #1)

**Test First If:**

1. ⚠️ Demand frequency 15-25 mentions (medium validation)
2. ⚠️ Adds complexity (3x SKUs, new materials)
3. ⚠️ Cost increase $5-10/unit
4. ⚠️ Uncertain customer preference (A vs B option)

**Defer to V2 If:**

1. ❌ Demand frequency <15 mentions (weak validation)
2. ❌ Doesn't solve top 5 blockers
3. ❌ Cost increase >$10/unit
4. ❌ Production time >8 weeks

**Reject If:**

1. 🚫 Technically not feasible
2. 🚫 Contradicts brand positioning
3. 🚫 Solves problem for wrong avatar segment

---

## Fast Validation Tests (Before Production Commitment)

If uncertain about an improvement, validate quickly:

### Test Method 1: TikTok Poll

**Time:** 3 hours
**Cost:** $0
**How:**

1. Create mockup image showing improvement
2. Post to TikTok: "Would you buy this if it had [feature]?"
3. Measure comments (goal: >100 "yes" in 48 hours)

### Test Method 2: Fake Product Page

**Time:** 4 hours
**Cost:** $100 ad spend
**How:**

1. Create landing page variant with improvement
2. Run small ad campaign ($100 budget)
3. Measure add-to-cart rate (goal: >3% = validated)

### Test Method 3: Customer Survey

**Time:** 2 hours
**Cost:** $0
**How:**

1. Email existing customers: "Which would you prefer? A or B?"
2. Show images of both options
3. Measure preference (goal: >60% prefer improvement = validated)

---

## Success Metrics

**Product Improvement Success = Research → Product → Copy → Conversion**

### Before Product Changes:

- Features describe product attributes
- Copy fights against objections via positioning
- Conversion rate: X%

### After Product Changes:

- Features solve validated customer problems
- Copy emphasizes solutions to real objections
- Conversion rate: X% + Y% lift (from eliminating blockers)

**Example:**

```
BEFORE:
Feature 1: "Premium Italian Lace"
Objection: "Can I wear without a bra?" (23% of comments)
Strategy: Reframe via positioning

AFTER:
Feature 1: "No Bra Needed - Built-In Support"
Objection: Eliminated (solved at product level)
Result: +15% conversion lift (no friction)
```

---

## Notes for Future Builds

**Key Insight:** Research should change the product, not just the copy.

**Competitive Advantage:**

- Most brands: Research → better positioning
- You: Research → better product → easier copy → higher conversion

**Iteration Loop:**

1. Run TikTok research
2. Identify top improvements
3. Implement changes
4. Product now matches customer dream
5. Copy writes itself
6. Higher conversion
7. Repeat for next product

**Context for AI Agents:**

If you're an AI agent building with this template:

1. ✅ ALWAYS read `context/tiktok_deep_research.json` if it exists
2. ✅ ALWAYS check this file for approved product improvements
3. ✅ ALWAYS update `product.config` to emphasize new features
4. ✅ NEVER just position around gaps - recommend product changes
5. ✅ Features that solve research-validated problems = 10x better copy

---

## Archive (Previous Iterations)

**Product V1.0:**

- Research Date: [Date]
- Changes Made: [List]
- Conversion Lift: +X%

**Product V1.1:**

- Research Date: [Date]
- Changes Made: [List]
- Conversion Lift: +X%

---

## Quick Reference

**File Locations:**

- Research Output: `context/tiktok_deep_research.json`
- Product Config: `product.config`
- Image Requirements: `IMAGE-REQUIREMENTS.md`
- Framework: `BRUNSON-PROTOCOL-V2.md`

**Workflow Commands:**

- Run Research: `/bulletproof-research`
- Build Page: `./build.sh`
- Test Changes: `./tests/validate-build.sh`

**Supplier Contact:**

- Name: [Your supplier name]
- Email: [Your supplier email]
- WhatsApp: [Your supplier number]
- Typical Response Time: [X hours/days]

---

_Last Updated: [Auto-populated by workflow]_
_Template Version: 2.0-comprehensive_
