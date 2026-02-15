---
name: scout
description: Research market trends and competitor landscape. First step in research phase. Auto-activates on "research market", "scout competitor", "market trends".
---

# Scout - Market Research

## Purpose

Research market trends, cultural landscape, and competitor positioning.

## STEP 1: Identify Research Sources

If competitor URL provided:

```bash
# Note the competitor URL from mission.json
cat context/mission.json | grep competitor_url
```

## STEP 2: Research Cultural Landscape

Document 3+ cultural trends affecting this market:

- Current social media trends
- Cultural movements relevant to product
- Timing factors (seasons, events)

## STEP 3: Extract Linguistic Markers

Find 5+ terms/phrases the target audience uses:

- Slang and jargon
- Hashtags
- Common complaints phrasing

## STEP 4: Document Freshness

Find recent sources (last 30 days):

- News articles
- Social media posts
- Review sites

## OUTPUT

Create `context/market_trends.json`:

```json
{
  "cultural_landscape": [
    { "trend": "[Trend 1]", "relevance": "[Why it matters]" },
    { "trend": "[Trend 2]", "relevance": "[Why it matters]" },
    { "trend": "[Trend 3]", "relevance": "[Why it matters]" }
  ],
  "linguistic_markers": [
    "[Term 1]",
    "[Term 2]",
    "[Term 3]",
    "[Term 4]",
    "[Term 5]"
  ],
  "freshness_citations": [
    { "url": "[URL]", "date": "[Date]", "insight": "[Key insight]" }
  ]
}
```

## PASS CONDITION

- cultural_landscape has 3+ items
- linguistic_markers has 5+ items
- freshness_citations has at least 1 recent source
