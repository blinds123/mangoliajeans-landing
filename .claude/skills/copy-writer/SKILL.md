---
name: copy-writer
description: Write all landing page copy using ENGAGE framework and FIBS pattern. Auto-activates on "write copy", "create copy", "copywriting".
---

# Copy Writer - ENGAGE Framework

## Purpose

Write all landing page copy using Russell Brunson's ENGAGE framework.

## INPUT

- context/avatar_profile.json
- context/strategy_brief.json
- context/mechanism_report.json
- context/linguistic_seed_map.json (if exists)

## ENGAGE FRAMEWORK

**E** - Engage with pattern interrupt headline
**N** - Nurture with story/empathy
**G** - Give value (features/benefits)
**A** - Ask for action (CTA)
**G** - Guarantee (risk reversal)
**E** - Exit with urgency

## STEP 1: Write Headline + Subhead

Headline rules:

- Pattern interrupt (challenges belief)
- Uses "Why/Stop/The Lie/You Don't Need"
- Under 12 words
- From big_domino in strategy_brief.json

## STEP 2: Write Opening Hook

- 2-3 sentences
- Agitate the problem
- Create curiosity

## STEP 3: Write 3 Features (FIBS Pattern)

For EACH feature:

- **F**eature: What it is
- **I**mportance: Why it matters
- **B**enefit: What they get
- **S**ocial proof: Who else got this result

## STEP 4: Write 3 Secrets Copy

From strategy_brief.json:

**Secret 1 (Vehicle):**

- False belief they have
- Truth that changes everything
- Proof it's true

**Secret 2 (Internal):**

- False belief about themselves
- Truth that empowers them
- Proof they can do it

**Secret 3 (External):**

- False belief about external factors
- Truth that removes barrier
- Proof the barrier doesn't matter

## STEP 5: Write Founder Story

5 Epiphany Bridge elements:

1. **Backstory**: Relatable problem
2. **Wall**: What wasn't working
3. **Epiphany**: The discovery
4. **Plan**: How they solved it
5. **Transformation**: The result

## STEP 6: Write Testimonials (12)

Distribution:

- Testimonials 1-4: Address Secret 1 (Vehicle)
- Testimonials 5-8: Address Secret 2 (Internal)
- Testimonials 9-12: Address Secret 3 (External)

Each testimonial needs:

- Short title (3-5 words)
- Quote (2-3 sentences)
- Author name
- Location

## STEP 7: Write FAQ (5)

From objections in avatar_profile.json:

- Turn objection into question
- Provide clear answer

## OUTPUT

Create `context/copy_draft.json`:

```json
{
  "engage": {
    "headline": "[Pattern interrupt headline]",
    "subhead": "[Supporting subhead]",
    "opening_hook": "[2-3 sentences]"
  },
  "features": [
    {
      "title": "[Feature 1 title]",
      "feature": "[What it is]",
      "importance": "[Why it matters]",
      "benefit": "[What they get]",
      "social_proof": "[Who else got this]"
    }
  ],
  "secrets": [
    {
      "type": "vehicle",
      "headline": "[Secret 1 headline]",
      "false_belief": "[From strategy_brief]",
      "truth": "[From strategy_brief]",
      "paragraph": "[Full copy]"
    }
  ],
  "founder_story": {
    "backstory": "[Paragraph]",
    "wall": "[Paragraph]",
    "epiphany": "[Paragraph]",
    "plan": "[Paragraph]",
    "transformation": "[Paragraph]"
  },
  "testimonials": [
    {
      "title": "[Title]",
      "quote": "[Quote]",
      "author": "[Name]",
      "location": "[City, State]",
      "addresses_secret": 1
    }
  ],
  "faq": [
    {
      "question": "[Question]",
      "answer": "[Answer]"
    }
  ]
}
```

## PASS CONDITION

- engage has headline, subhead, opening_hook
- features has 3 items with FIBS
- secrets has 3 items (vehicle, internal, external)
- founder_story has all 5 elements
- testimonials has 12 items
- faq has 5 items
