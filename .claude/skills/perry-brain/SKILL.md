---
name: perry-brain
description: Optimize copy using Perry Belcher principles. "Grease the chute" refinement. Auto-activates on "optimize copy", "perry brain", "refine copy".
---

# Perry Brain - Copy Optimization

## Purpose

Refine copy using Perry Belcher's "greasing the chute" principles.

## INPUT

- context/copy_draft.json
- context/avatar_profile.json
- context/neuro_triggers.json

## PERRY BELCHER PRINCIPLES

### 1. Grease the Chute

- Every line should make them want to read the next
- No friction points
- Remove any confusion

### 2. One Idea Per Sentence

- Short sentences
- Clear thoughts
- Easy to scan

### 3. Use Their Words

- Language from avatar_profile.json
- Not marketer speak
- How THEY would say it

### 4. Specificity Sells

- Replace vague with specific
- "Many people" → "94% of customers"
- "Works fast" → "Works in 7 days"

### 5. Future Pace

- Help them imagine having the result
- "Imagine waking up and..."
- "Picture yourself..."

## STEP 1: Review Each Copy Section

For each section in copy_draft.json:

- Apply Perry principles
- Replace weak words
- Add specificity
- Inject neuro triggers

## STEP 2: Check Flow

Read entire copy aloud mentally:

- Does each line lead to next?
- Any stumbling points?
- Any confusion?

## STEP 3: Verify Avatar Language

Compare copy to avatar_profile.json:

- Are we using their words?
- Does it sound like them?
- Would they say this?

## OUTPUT

Create `context/copy_final.json`:

Same structure as copy_draft.json but with:

- Optimized language
- Neuro triggers injected
- Avatar language verified
- Specificity added

Add optimization notes:

```json
{
  "...all copy sections...",
  "optimization_notes": {
    "changes_made": [
      "[Change 1]",
      "[Change 2]"
    ],
    "neuro_triggers_used": ["[Trigger 1]", "[Trigger 2]"],
    "avatar_language_verified": true
  }
}
```

## PASS CONDITION

- All copy sections present
- optimization_notes included
- avatar_language_verified: true
