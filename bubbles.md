# TikTok Bubble Text — IMAGE BAKING REFERENCE

**Critical:** Bubbles are baked into images (not CSS).

## Correct Workflow

1. Generate clean images in Whisk (no text).
2. Run bubble overlay tool:

```bash
# CORRECT BUBBLE TOOL LOCATION AND COMMAND
# Tool path: /Users/nelsonchan/clawd/tools/bubble-overlay/
cd /Users/nelsonchan/clawd/tools/bubble-overlay/
source .venv/bin/activate && python generate_bubbles.py generate /path/to/images
```

3. Use the baked outputs (e.g., `*_bubbled.webp`).
4. Deploy.

## Bubble Placement Rules

- Product images (1-6): 2 bubbles each (Question + Answer).
- Testimonials (25 images):
  - 5 images with 2 bubbles (Question + Answer).
  - 20 images with 1 bubble (statement only).
- Comparison, founder, order bump: **NO bubbles**.
- Awards + universal assets: **NO bubbles**.

## Prompt -> Image Map (Aligned)

- Prompts 1-6 -> `images/product/product-01.webp` to `product-06.webp`
- Prompts 7-31 -> `images/testimonials/testimonial-01.webp` to `testimonial-25.webp`
- Prompt 32 -> `images/comparison/comparison-01.webp`
- Prompt 33 -> `images/order-bump/order-bump-01.webp`
- Prompt 34 -> `images/founder/founder-01.webp` (optional placeholder; otherwise duplicate `awards-1.webp`)

## Tool Reference

**CORRECT BUBBLE TOOL:**
- Location: `/Users/nelsonchan/clawd/tools/bubble-overlay/`
- Command: `source .venv/bin/activate && python generate_bubbles.py generate /path/to/images`
- Output: Bubbled images in same directory or subfolder

**DEPRECATED (DO NOT USE):**
- `scripts/overlay_ttbubble.py` - points to wrong tool location

## Updated

2026-02-14 - Fixed tool path and command for GLM 4.7 compatibility.
