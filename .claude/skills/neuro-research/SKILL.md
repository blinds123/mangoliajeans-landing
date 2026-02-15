---
name: neuro-research
description: Research neuro triggers (dopamine, serotonin, oxytocin, cortisol) for this audience. Auto-activates on "neuro triggers", "neuro research", "brain triggers".
---

# Neuro Research - Brain Chemistry Triggers

## Purpose

Identify words/phrases that trigger specific neurochemical responses.

## INPUT

- context/avatar_profile.json

## STEP 1: Dopamine Triggers (Reward/Anticipation)

Words that create excitement about reward:

- "Discover", "Unlock", "Exclusive"
- "Finally", "Secret", "Revealed"
- Numbers and specifics

## STEP 2: Serotonin Triggers (Status/Confidence)

Words that elevate self-image:

- "Expert", "Insider", "VIP"
- "Proven", "Trusted", "Premium"
- Social proof indicators

## STEP 3: Oxytocin Triggers (Trust/Connection)

Words that build rapport:

- "Together", "Community", "Family"
- Personal stories
- "We understand", empathy language

## STEP 4: Cortisol Triggers (Urgency/Fear)

Words that create healthy urgency:

- "Limited", "Last chance", "Don't miss"
- FOMO language
- Problem agitation

## OUTPUT

Create `context/neuro_triggers.json`:

```json
{
  "dopamine": {
    "trigger_words": ["[Word 1]", "[Word 2]", "[Word 3]"],
    "usage": "[When to use these]"
  },
  "serotonin": {
    "trigger_words": ["[Word 1]", "[Word 2]", "[Word 3]"],
    "usage": "[When to use these]"
  },
  "oxytocin": {
    "trigger_words": ["[Word 1]", "[Word 2]", "[Word 3]"],
    "usage": "[When to use these]"
  },
  "cortisol": {
    "trigger_words": ["[Word 1]", "[Word 2]", "[Word 3]"],
    "usage": "[When to use these - carefully]"
  }
}
```

## PASS CONDITION

- All 4 neurochemicals have trigger_words
- Each has 3+ words
