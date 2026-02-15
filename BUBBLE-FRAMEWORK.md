# TikTok Bubble Framework

This document defines the structured bubble overlay system for product and testimonial images. TikTok-style comment bubbles serve as the **3 SECRETS delivery mechanism** through a social proof Q&A format.

=============================================================================
GLM 4.7 BUBBLE TOOL REFERENCE
=============================================================================
CORRECT TOOL LOCATION:
    /Users/nelsonchan/clawd/tools/bubble-overlay/

COMMAND TO GENERATE BUBBLES:
    cd /Users/nelsonchan/clawd/tools/bubble-overlay/
    source .venv/bin/activate && python generate_bubbles.py generate /path/to/images

Note: Bubbles are BAKED into images (not CSS overlays)
=============================================================================

---

## Bubble Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRODUCT IMAGE                                │
│                                                                  │
│  ┌──────────────────────────────┐                               │
│  │ 😱 "Does it really work?"   │ ← QUESTION (False Belief)      │
│  └──────────────────────────────┘                               │
│                                                                  │
│                        ┌───────────────────────────────────────┐│
│                        │ OMG yes! [Proof statement]           ││
│                        │ 💕 Sarah K. - Austin, TX             ││
│                        └───────────────────────────────────────┘│
│                                    ↑ ANSWER (Truth/Proof)       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3 Secrets Bubble Structure

Each product image should deliver ONE secret through the Q&A bubble format:

### Image 1-3: SECRET #1 - Vehicle False Belief

**Theme:** "Does the product/method actually work?"

| Question Bubble                     | Answer Bubble                                     |
| ----------------------------------- | ------------------------------------------------- |
| "Does this actually work?"          | "Yes! I saw results in [timeframe]"               |
| "Is this just like [old solution]?" | "No way! This is completely different because..." |
| "I've tried everything..."          | "Same! But this finally worked for me"            |

### Image 4-6: SECRET #2 - Internal False Belief

**Theme:** "Can I actually do this/use this?"

| Question Bubble                       | Answer Bubble                              |
| ------------------------------------- | ------------------------------------------ |
| "Is it hard to use?"                  | "So easy! Anyone can do it"                |
| "Will this work for someone like me?" | "It works for all [body types/situations]" |
| "I'm not [skilled/young/etc] enough"  | "Neither am I! And it still works"         |

### Image 7-9: SECRET #3 - External False Belief

**Theme:** "What about time/money/circumstances?"

| Question Bubble              | Answer Bubble                    |
| ---------------------------- | -------------------------------- |
| "I don't have time for this" | "Takes less than [X] minutes"    |
| "It's too expensive"         | "Way cheaper than [alternative]" |
| "What will [others] think?"  | "Everyone asks where I got it!"  |

---

## Bubble Visual Specifications

### Question Bubble (Left Side)

```css
Position: top-left or left-center
Background: rgba(0, 0, 0, 0.85)
Text Color: white
Border Radius: 20px
Font Weight: 600
Emoji: Start with emotion emoji (😱, 🤔, 😩, 👀)
Max Width: 200px
Padding: 12px 16px
```

### Answer Bubble (Right Side)

```css
Position: bottom-right or right-center
Background: rgba(255, 255, 255, 0.95)
Text Color: black
Border Radius: 20px
Font Weight: 500
Emoji: End with positive emoji (💕, ✨, 🙌, 😍)
Max Width: 250px
Padding: 12px 16px
Attribution: Name + Location (smaller text)
```

---

## Whisk Prompt Integration

When generating images with Whisk, include bubble overlay instructions:

### Product Shot Bubble Prompt Template

```
[Product description with model wearing/using product]

OVERLAY TEXT BUBBLES:
- Left bubble (black bg, white text): "[QUESTION about false belief]" with [EMOJI]
- Right bubble (white bg, black text): "[ANSWER proving truth]" with [EMOJI]
- Small text below right bubble: "[Name] - [Location]"
```

### Example Prompts by Secret Type

**SECRET #1 (Vehicle):**

```
Young woman wearing [product] looking confident, casual lifestyle photo

OVERLAY TEXT BUBBLES:
- Left bubble: "😱 Does this actually work?"
- Right bubble: "OMG yes! Saw results day 1! 💕"
- Attribution: "Jessica M. - Miami, FL"
```

**SECRET #2 (Internal):**

```
Woman of [body type] wearing [product] looking happy and comfortable

OVERLAY TEXT BUBBLES:
- Left bubble: "🤔 Will this fit me though?"
- Right bubble: "Fits perfectly! Designed for real bodies ✨"
- Attribution: "Amanda K. - Chicago, IL"
```

**SECRET #3 (External):**

```
Woman wearing [product] at [social setting], receiving compliments

OVERLAY TEXT BUBBLES:
- Left bubble: "😩 I don't have time for this"
- Right bubble: "Takes 2 seconds to put on! 🙌"
- Attribution: "Rachel B. - Denver, CO"
```

---

## Testimonial Image Bubbles

For testimonial strip images, use single affirmation bubbles:

### Testimonial Bubble Types

1. **Result Bubble**
   - "Lost 3 inches in 2 weeks! 📏"
   - "Best purchase I've ever made! ⭐"

2. **Transformation Bubble**
   - "Before: 😫 After: 😍"
   - "Finally feel confident! 💪"

3. **Social Proof Bubble**
   - "Everyone keeps asking about it! 👀"
   - "My sister bought 3 after seeing mine! 😱"

4. **Objection Crusher Bubble**
   - "Worth every penny! 💰"
   - "Wish I bought sooner! ⏰"

---

## Bubble Copy Variables

These variables can be set in product.config for consistent bubble messaging:

```bash
# Secret #1 Bubbles (Vehicle)
BUBBLE_Q1_VEHICLE="Does this actually work?"
BUBBLE_A1_VEHICLE="Yes! Saw results immediately"

# Secret #2 Bubbles (Internal)
BUBBLE_Q2_INTERNAL="Will this work for me?"
BUBBLE_A2_INTERNAL="Works for everyone!"

# Secret #3 Bubbles (External)
BUBBLE_Q3_EXTERNAL="Is it worth the price?"
BUBBLE_A3_EXTERNAL="Way better value than alternatives"
```

---

## Image-to-Secret Mapping

| Image Position         | Secret Type    | Bubble Focus             |
| ---------------------- | -------------- | ------------------------ |
| Hero Gallery 1-2       | Vehicle        | "Does it work?"          |
| Hero Gallery 3-4       | Internal       | "Can I do it?"           |
| Hero Gallery 5-6       | External       | "Time/Money/Others?"     |
| Testimonial Strip 1-4  | Vehicle Proof  | Result statements        |
| Testimonial Strip 5-8  | Internal Proof | "I was skeptical but..." |
| Testimonial Strip 9-13 | External Proof | "Worth it!" statements   |

---

## Implementation Checklist

- [ ] Phase 2 generates 9 product images (3 per secret)
- [ ] Each product image has Q&A bubble overlay
- [ ] Questions address specific false beliefs from research
- [ ] Answers provide proof/truth statements
- [ ] Testimonial images have single affirmation bubbles
- [ ] Bubble copy matches Phase 1 research findings
- [ ] Attribution names/locations are diverse and realistic
