---
name: strategy-builder
description: Creates strategy brief with Big Domino and 3 Secrets using Brunson framework. Auto-activates on "create strategy", "3 secrets", "big domino".
---

# Strategy Builder for Claude Code CLI

## Purpose

Creates the strategic framework for landing page copy using Russell Brunson's methodology:

- Big Domino (one belief that makes purchase inevitable)
- 3 Secrets (overcome Vehicle, Internal, External objections)

---

## PREREQUISITES

You need:

1. `avatar_profile.json` from avatar-builder skill
2. Product information

---

## STEP 1: Identify the Big Domino

The Big Domino is the ONE belief that, if the customer believes it, makes the purchase inevitable.

**Formula:** "If I can make them believe [X], then they MUST buy."

**Examples:**

- Jeans: "If they believe low-rise jeans CAN be comfortable for curvy women..."
- Lamp: "If they believe this lamp WILL make their lips look perfect..."
- Course: "If they believe they CAN learn this skill in 30 days..."

Write your Big Domino:

```
"If I can make them believe _________________________, then they MUST buy."
```

---

## STEP 2: Define 3 Secrets

The 3 Secrets overcome the 3 types of false beliefs:

### Secret 1: Vehicle (External Solution)

**False Belief:** "I've tried other [solutions] and they don't work."
**Truth:** "This is different because [unique mechanism]."

### Secret 2: Internal (Self-Doubt)

**False Belief:** "Even if it works, it won't work for ME."
**Truth:** "It works for people like you because [proof]."

### Secret 3: External (Outside Factors)

**False Belief:** "Even if it works for me, [external factor] will stop me."
**Truth:** "[External factor] doesn't matter because [reason]."

---

## STEP 3: Create Strategy Brief

Create `strategy_brief.json`:

```json
{
  "big_domino": {
    "belief": "[The one belief]",
    "statement": "If I can make them believe [X], they MUST buy."
  },

  "secret_1_vehicle": {
    "false_belief": "[What they wrongly believe about solutions]",
    "truth": "[Why THIS product is the right vehicle]",
    "headline": "[Short headline for this secret]",
    "proof_points": ["[Evidence 1]", "[Evidence 2]"]
  },

  "secret_2_internal": {
    "false_belief": "[What they wrongly believe about themselves]",
    "truth": "[Why THEY can succeed with this]",
    "headline": "[Short headline for this secret]",
    "proof_points": ["[Evidence 1]", "[Evidence 2]"]
  },

  "secret_3_external": {
    "false_belief": "[What they wrongly believe about external factors]",
    "truth": "[Why external factors don't matter]",
    "headline": "[Short headline for this secret]",
    "proof_points": ["[Evidence 1]", "[Evidence 2]"]
  },

  "epiphany_bridge": {
    "backstory": "[Founder's relatable problem]",
    "wall": "[The moment of realization]",
    "epiphany": "[The discovery]",
    "plan": "[How they solved it]",
    "transformation": "[The result]"
  }
}
```

---

## STEP 4: Validate Strategy

Check that:

- [ ] Big Domino is ONE clear belief
- [ ] Each Secret addresses a different objection type
- [ ] False beliefs come from avatar_profile.json
- [ ] Truths are specific and provable
- [ ] Epiphany bridge tells a story

---

## OUTPUT

Save `strategy_brief.json` to context/ directory.

```markdown
# Strategy Brief Report

**Big Domino:** [The one belief]

## 3 Secrets Summary

1. **Vehicle:** [False belief] → [Truth]
2. **Internal:** [False belief] → [Truth]
3. **External:** [False belief] → [Truth]

## STRATEGY_BRIEF: COMPLETE
```
