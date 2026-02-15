---
name: mechanic
description: Define unique product mechanism and proof points. Auto-activates on "define mechanism", "product mechanism", "mechanic".
---

# Mechanic - Product Mechanism

## Purpose

Define what makes this product uniquely effective (the "mechanism").

## STEP 1: Identify Unique Mechanism

What is the ONE thing that makes this product work differently?

- Not just features
- The underlying reason it works
- What competitors don't have

Examples:

- Jeans: "Kick yoke pattern" (specific cut technique)
- Lamp: "360-degree diffusion ring" (lighting tech)
- Supplement: "Nano-encapsulation delivery" (absorption tech)

## STEP 2: Document Specifications

Hard facts about the product:

- Materials
- Dimensions
- Technical specs
- Manufacturing details

## STEP 3: Gather Proof Points

Evidence the mechanism works:

- Test results
- Certifications
- Before/after data
- Expert endorsements

## OUTPUT

Create `context/mechanism_report.json`:

```json
{
  "unique_mechanism": {
    "name": "[Mechanism name]",
    "description": "[How it works]",
    "why_different": "[Why competitors don't have this]"
  },
  "specifications": [
    { "spec": "[Spec 1]", "value": "[Value]" },
    { "spec": "[Spec 2]", "value": "[Value]" },
    { "spec": "[Spec 3]", "value": "[Value]" }
  ],
  "proof_points": [
    { "type": "[Test/Certification/Data]", "detail": "[Specific proof]" },
    { "type": "[Type]", "detail": "[Specific proof]" }
  ]
}
```

## PASS CONDITION

- unique_mechanism has name and description
- specifications has 3+ items
- proof_points has 2+ items
