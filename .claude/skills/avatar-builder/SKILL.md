---
name: avatar-builder
description: Creates customer avatar profile using Brunson framework. Generates pain points, desires, objections, and language patterns. Auto-activates on "create avatar", "customer profile", "research audience".
---

# Avatar Builder for Claude Code CLI

## Purpose

Creates comprehensive customer avatar for landing page copy using Russell Brunson's framework.

---

## PREREQUISITES

You need:

1. Product name and description
2. Competitor URL (optional but recommended)
3. Product images to analyze

---

## STEP 1: Analyze Product

Look at product images and any provided information. Document:

```markdown
**Product Analysis:**

- Product Name: [exact name]
- Product Type: [category]
- Key Features: [list 4-6]
- Price Point: [single/bundle]
- Target Demographic: [who buys this]
```

---

## STEP 2: Research Competitor (if URL provided)

```bash
# If competitor URL provided, analyze their page
# Look for:
# - Headlines they use
# - Pain points they address
# - Testimonial themes
# - Objections they overcome
```

---

## STEP 3: Create Avatar Profile

Create `avatar_profile.json`:

```json
{
  "target_audience": "[WHO BUYS THIS - be specific]",

  "fears_and_frustrations": [
    "[Fear 1 - what keeps them up at night]",
    "[Fear 2 - what they're afraid of]",
    "[Fear 3 - what frustrates them daily]"
  ],

  "biases_and_false_beliefs": [
    "[False belief about solutions - 'I've tried everything']",
    "[False belief about themselves - 'I can't do this']",
    "[False belief about external factors - 'It's too expensive']"
  ],

  "desires": [
    "[Desire 1 - what they want most]",
    "[Desire 2 - how they want to feel]",
    "[Desire 3 - what outcome they seek]"
  ],

  "objections": [
    {
      "objection": "Is it worth the price?",
      "answer": "[How to overcome this]"
    },
    {
      "objection": "Will it work for me?",
      "answer": "[How to overcome this]"
    },
    {
      "objection": "Is it quality?",
      "answer": "[How to overcome this]"
    }
  ],

  "language_patterns": [
    "[Phrase they would use]",
    "[Another phrase]",
    "[Slang or jargon they use]"
  ],

  "social_proof_triggers": [
    "[What kind of testimonials resonate]",
    "[What credentials matter to them]",
    "[What numbers impress them]"
  ]
}
```

---

## STEP 4: Validate Avatar

Check that avatar has:

- [ ] Specific target audience (not generic)
- [ ] At least 3 fears/frustrations
- [ ] At least 3 false beliefs (for 3 Secrets)
- [ ] At least 3 objections with answers
- [ ] Language that sounds like the customer, not marketer

---

## OUTPUT

Save `avatar_profile.json` to context/ directory.

```markdown
# Avatar Profile Report

**Target:** [Audience description]
**Date:** [Date]

## Key Insights

- Primary fear: [Most important fear]
- Primary desire: [Most important desire]
- Primary objection: [Most common objection]

## Language to Use

[3-5 phrases that resonate with this audience]

## AVATAR_PROFILE: COMPLETE
```
