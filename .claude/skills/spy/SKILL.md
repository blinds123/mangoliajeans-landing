---
name: spy
description: Analyze competitor page for pain points, desires, and objections. Auto-activates on "analyze competitor", "spy on competitor", "competitor analysis".
---

# Spy - Competitor Analysis

## Purpose

Extract marketing intelligence from competitor pages.

## STEP 1: Open Competitor Page

If competitor URL exists:

```javascript
// Use browser automation
mcp__chrome-devtools__navigate_page url="[COMPETITOR_URL]"
mcp__chrome-devtools__take_screenshot filePath="context/competitor_screenshot.png"
```

## STEP 2: Extract Pain Points (5+)

Find what problems they address:

- Headlines mentioning problems
- "Tired of..." statements
- Before/after comparisons
- Negative reviews they counter

## STEP 3: Extract Desires (4+)

Find what outcomes they promise:

- Benefit statements
- Transformation language
- Results claims

## STEP 4: Extract Objections (6+)

Find objections they overcome:

- FAQ sections
- "But what if..." responses
- Guarantee language
- Risk reversals

## OUTPUT

Create `context/competitor_funnels.json`:

```json
{
  "competitor_url": "[URL]",
  "screenshot": "context/competitor_screenshot.png",
  "pain_points": [
    { "pain": "[Pain 1]", "quote": "[Exact quote if found]" },
    { "pain": "[Pain 2]", "quote": "[Exact quote if found]" },
    { "pain": "[Pain 3]", "quote": "[Exact quote if found]" },
    { "pain": "[Pain 4]", "quote": "[Exact quote if found]" },
    { "pain": "[Pain 5]", "quote": "[Exact quote if found]" }
  ],
  "desires": [
    { "desire": "[Desire 1]", "quote": "[Exact quote if found]" },
    { "desire": "[Desire 2]", "quote": "[Exact quote if found]" },
    { "desire": "[Desire 3]", "quote": "[Exact quote if found]" },
    { "desire": "[Desire 4]", "quote": "[Exact quote if found]" }
  ],
  "objections": [
    { "objection": "[Objection 1]", "their_answer": "[How they handle it]" },
    { "objection": "[Objection 2]", "their_answer": "[How they handle it]" },
    { "objection": "[Objection 3]", "their_answer": "[How they handle it]" },
    { "objection": "[Objection 4]", "their_answer": "[How they handle it]" },
    { "objection": "[Objection 5]", "their_answer": "[How they handle it]" },
    { "objection": "[Objection 6]", "their_answer": "[How they handle it]" }
  ]
}
```

## PASS CONDITION

- pain_points has 5+ items
- desires has 4+ items
- objections has 6+ items with answers
