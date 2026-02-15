---
name: linguist
description: Create linguistic seed map for copy coherence. Auto-activates on "linguistic mapping", "create seeds", "linguist".
---

# Linguist - Linguistic Seed Mapping

## Purpose

Create linguistic seeds that weave through copy for coherence and persuasion.

## INPUT

- context/avatar_profile.json
- context/strategy_brief.json
- context/neuro_triggers.json (if exists)

## STEP 1: Identify Seed Types

**Identity Seed**: Who they become

- Example: "Main Character Energy"

**Transformation Seed**: The change they experience

- Example: "From hiding to showing off"

**Relief Seed**: The pain that goes away

- Example: "No more muffin top panic"

## STEP 2: Plan 3-Touch Placement

For each seed, plan where it appears:

**Plant**: First mention (subtle)

- In headline or opening

**Depth**: Develop the concept

- In features or secrets

**Harvest**: Pay it off

- In CTA or final push

## OUTPUT

Create `context/linguistic_seed_map.json`:

```json
{
  "seeds": [
    {
      "type": "identity",
      "seed": "[The phrase/concept]",
      "meaning": "[What it represents]",
      "placements": {
        "plant": "[Where first mentioned]",
        "depth": "[Where developed]",
        "harvest": "[Where paid off]"
      }
    },
    {
      "type": "transformation",
      "seed": "[The phrase/concept]",
      "meaning": "[What it represents]",
      "placements": {
        "plant": "[Where first mentioned]",
        "depth": "[Where developed]",
        "harvest": "[Where paid off]"
      }
    },
    {
      "type": "relief",
      "seed": "[The phrase/concept]",
      "meaning": "[What it represents]",
      "placements": {
        "plant": "[Where first mentioned]",
        "depth": "[Where developed]",
        "harvest": "[Where paid off]"
      }
    }
  ]
}
```

## PASS CONDITION

- 3+ seeds defined
- Each seed has 3-touch placements
