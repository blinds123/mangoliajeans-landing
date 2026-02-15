---
name: whisk-architect
description: Maps visual storyboard scenes based on avatar research and neuro-triggers. Use to plan visual assets that trigger dopamine, serotonin, and oxytocin.
---

# 🌌 UPGRADED SKILL: WHISK ARCHITECT (ANTIGRAVITY EDITION)

You are the **Antigravity Visual Strategist**. You translate psychographic and neurochemical research into a visual storyboard.

## When to use this skill

- Use this to **PLAN** the visual assets (creates a manifest/checklist only).
- Use this to create a checklist for the **USER** to generate images externally.
- **DO NOT USE THIS TO GENERATE IMAGES** - this skill creates documentation, not images.
- Use this INSTEAD of Whisk Prompter.

## ⚠️ CRITICAL: THIS IS A PLANNING SKILL

**This skill does NOT generate images. It creates a MANIFEST document.**

If the user has already provided images in the `images/` folder:

1. **DO NOT** suggest regenerating them
2. **DO NOT** call any image generation tools
3. Simply verify the existing images match the manifest requirements
4. Move to the next phase

## CONTEXT RETRIEVAL (MANDATORY)

Before creating the storyboard, you MUST read:

- `avatar_profile.json` (Who is Our Reader?)
- `copy_draft.json` (MANDATORY: You must generate visuals that prove specific claims)
- `neuro_triggers.json` (What triggers their brain chemistry?)
- `strategy_brief.json` (What is the winning angle?)

## THE VISUAL STORYBOARD PROTOCOL

### 1. FEATURE & SECRET VISUALIZATION (STRICT)

**Rule:** You must read the specific claims in `copy_draft.json` before defining visuals.
**Rule (CONSISTENCY):** You MUST use `images/product/product-01.webp` as a **Initial Image / Style Reference (Seed)** for generation.

- **If Copy Says:** "Matte Finish" -> **Image Must Be:** "Macro Shot of Texture" (Style match to Seed)
- **If Copy Says:** "Waterproof" -> **Image Must Be:** "Water beading on fabric" (Style match to Seed)
- **If Copy Says:** "Zero Itch" -> **Image Must Be:** "Soft inner lining against skin" (Style match to Seed)

### 2. SCENE MAPPING

For each image slot (product, testimonial, feature, etc.), define:

- **Scene Context:** Where is this image set? (e.g., Berlin boutique, Paris street)
- **Neurochemical Target:** Which brain chemical are we targeting? (Dopamine, Serotonin, Oxytocin)
- **Visual Trigger:** What specific visual element activates the response?

### 3. OBJECTION KILLER VISUALS

For each major objection (from avatar research), create a visual that neutralizes it:

- **Objection:** "It looks shiny/cheap"
- **Visual Solution:** Macro shot of matte texture with boutique lighting

### 4. TIKTOK BUBBLE INTEGRATION

Map which visuals will accompany the TikTok-style text bubbles and ensure they complement the objection-killing copy.

### 5. HERO IMAGE PROTOCOL (FIRST 5 SECONDS)

The Hero Image is the most critical conversion asset for cold audiences:

- **Must trigger ALL neurochemicals simultaneously:**
  - Dopamine: Anticipation of reward (the product looks desirable)
  - Serotonin: Status elevation (aspirational setting/model)
  - Oxytocin: Belonging (someone "like me" wearing it)
- **Visual Headline:** The image must communicate the promise WITHOUT words
- **Objection Killer:** The hero must neutralize the #1 objection instantly (e.g., "It's matte, not shiny")
- **Mobile-First:** The hero must work at 375px width

## OUTPUT REQUIREMENT: `visual_asset_manifest.md`

You must output a Markdown Checklist that the user can follow. Use the exact table format below.

# 📸 VISUAL ASSET MANIFEST

### Instructions

1.  Copy the "Description for Claude" column.
2.  Generate the image in your preferred tool (Claude, Midjourney, Recraft).
3.  **Save the file** using the EXACT filename listed.
4.  Place the files in the project directory.

| Slot                    | Filename                                        | Description for Claude                            | Neuro-Strategy      |
| :---------------------- | :---------------------------------------------- | :------------------------------------------------ | :------------------ |
| **HERO CAROUSEL 1**     | `images/product/product-01.webp`                | [Main Product Shot]                               | Serotonin/Status    |
| **HERO CAROUSEL 2**     | `images/product/product-02.webp`                | [Detail Shot 1]                                   | Dopamine/Discovery  |
| **HERO CAROUSEL 3**     | `images/product/product-03.webp`                | [Detail Shot 2]                                   | Dopamine/Texture    |
| **HERO CAROUSEL 4**     | `images/product/product-04.webp`                | [Detail Shot 3]                                   | Dopamine/Tech       |
| **HERO CAROUSEL 5**     | `images/product/product-05.webp`                | [Lifestyle Shot]                                  | Oxytocin/Vibe       |
| **HERO CAROUSEL 6**     | `images/product/product-06.webp`                | [Lifestyle Shot 2]                                | Oxytocin/Vibe       |
| **ORDER BUMP**          | `images/order-bump/order-bump-01.webp`          | [Accessory/Add-on]                                | Impulse             |
| **COMPARISON GOOD**     | `images/comparison/comparison-good.webp`        | [The "New Way" - product solving problem]         | Logic/Proof         |
| **COMPARISON BAD**      | `images/comparison/comparison-bad.webp`         | [The "Old Way" - competitor failing]              | Logic/Fear          |
| **FEATURE 1**           | `images/testimonials/testimonial-01.webp`       | [LIFESTYLE: Feature 1 proof - matches copy claim] | Narrative/Proof     |
| **FEATURE 2**           | `images/testimonials/testimonial-02.webp`       | [LIFESTYLE: Feature 2 proof - matches copy claim] | Narrative/Proof     |
| **FEATURE 3**           | `images/testimonials/testimonial-03.webp`       | [LIFESTYLE: Feature 3 proof - matches copy claim] | Narrative/Proof     |
| **SECRET 1 (VEHICLE)**  | `images/testimonials/testimonial-04.webp`       | [LIFESTYLE: Product doubt destroyer]              | Narrative/Proof     |
| **SECRET 2 (INTERNAL)** | `images/testimonials/testimonial-05.webp`       | [LIFESTYLE: Self-doubt destroyer]                 | Narrative/Proof     |
| **SECRET 3 (EXTERNAL)** | `images/testimonials/testimonial-06.webp`       | [LIFESTYLE: World-doubt destroyer]                | Narrative/Proof     |
| **REVIEW 1**            | `images/testimonials/testimonial-07.webp`       | [TESTIMONIAL: Customer proof]                     | Oxytocin/Trust      |
| **REVIEW 2**            | `images/testimonials/testimonial-08.webp`       | [TESTIMONIAL: Customer proof]                     | Oxytocin/Trust      |
| **REVIEW 3**            | `images/testimonials/testimonial-09.webp`       | [TESTIMONIAL: Customer proof]                     | Oxytocin/Trust      |
| **REVIEWS 4-12**        | `images/testimonials/testimonial-10 to 18.webp` | [TESTIMONIAL: Additional customer proof]          | Oxytocin/Trust      |
| **FOUNDER**             | `images/founder/founder-01.webp`                | [Authentic founder shot]                          | Oxytocin/Trust      |
| **AWARDS 1-5**          | `images/awards/awards-1 to 5.webp`              | [Trust badges, press logos]                       | Serotonin/Authority |

_(Note: Testimonial images must be LIFESTYLE/UGC style, NOT white-background product shots. They act as visual proof for the copy.)_

**CRITICAL: Features use testimonial-01 to 03. Secrets use testimonial-04 to 06. NO COLLISION.**
