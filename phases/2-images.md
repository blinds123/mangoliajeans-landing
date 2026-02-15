# Phase 2: Image Generation

Generate **34 images** with TikTok-style comment bubbles for social proof.
Founder image is static by default — duplicate `awards-1.webp` into `images/founder/founder-01.webp` if you do not have a real founder photo.

**Input Required:**

- Completed buyer research (Phase 1)
- Product reference image (use this to match product appearance in prompts)
- Top 6 objections from research (these become the bubble comments)

---

## How to Use the Product Reference Image

When writing prompts, describe the product based on your reference image:

- **Color**: Describe exact colors (e.g., "black sequin with gold undertones")
- **Style**: Describe silhouette (e.g., "floor-length A-line maxi skirt")
- **Material**: Describe texture (e.g., "shimmering iridescent sequins")
- **Details**: Include specific features (e.g., "elastic waistband, silk lining")

---

## 📁 EXACT File Naming Convention

Save images with these EXACT names (WebP preferred):

```
images/
├── product/
│   ├── product-01.webp
│   ├── product-02.webp
│   ├── product-03.webp
│   ├── product-04.webp
│   ├── product-05.webp
│   └── product-06.webp
├── testimonials/
│   ├── testimonial-01.webp
│   ├── testimonial-02.webp
│   ├── ... (through testimonial-25.webp)
│   └── testimonial-25.webp
├── comparison/
│   └── comparison-01.webp
├── founder/
│   └── founder-01.webp
└── order-bump/
    └── order-bump-01.webp
```

---

## 🎯 Quick Reference: Image Requirements

| Image Type             | Count  | TikTok Bubbles       | Position                |
| ---------------------- | ------ | -------------------- | ----------------------- |
| **Product Photos**     | 6      | **2 bubbles EACH**   | Top-left + Bottom-right |
| **Testimonials (20%)** | 5      | **2 bubbles**        | Top-left + Top-right    |
| **Testimonials (80%)** | 20     | **1 bubble**         | Top-right only          |
| **Comparison**         | 1      | None                 | N/A                     |
| **Founder**            | 1      | None                 | N/A                     |
| **Order Bump**         | 1      | None                 | N/A                     |
| **TOTAL**              | **34** | **42 bubbles total** |                         |

---

## 🚨 MANDATORY: TikTok Comment Bubble Specification

### What Bubbles MUST Look Like:

```
┌─────────────────────────────────────┐
│ 👤 @username ✓                      │
│ comment text with emojis 😭🔥       │
└─────────────────────────────────────┘
```

### Required Elements for EACH Bubble:

1. **Profile Photo**: Small circular photo of commenter (Gen Z aesthetic)
2. **Username**: @handle with blue verification checkmark ✓
3. **Comment Text**: Short, punchy, Gen Z language with emojis
4. **White Rounded Rectangle**: With subtle shadow
5. **Positioning**: MUST NOT cover product or model's face

### Bubble Positioning Rules:

- **Question bubble**: Top-left corner, above model's head
- **Answer bubble**: Bottom-right corner OR top-right corner
- **Single bubble (testimonials)**: Top-right corner

### 🚨 CRITICAL: Bubble Content Rules

| Bubble Count  | Content Type                                    | Example                                                                     |
| ------------- | ----------------------------------------------- | --------------------------------------------------------------------------- |
| **2 bubbles** | QUESTION (objection) + ANSWER (handling it)     | Q: "does strapless stay up? 😭" → A: "YES the boning keeps it locked in 💃" |
| **1 bubble**  | STATEMENT ONLY (social proof, never a question) | "literally obsessed, wore it to 3 events ✨"                                |

**⛔ NEVER DO THIS:**

- 2 bubbles with 2 questions (no answer = useless)
- 1 bubble asking a question (leaves objection unhandled)

**✅ ALWAYS DO THIS:**

- 2 bubbles: First bubble asks objection, second bubble HANDLES it
- 1 bubble: Pure social proof/testimonial statement

---

## 📸 PRODUCT PHOTOS (6 Images)

### EVERY Product Photo MUST Have:

✅ **2 TikTok comment bubbles**
✅ **Luxury location** (rooftop bar, resort, upscale restaurant)
✅ **Professional camera specs** (Canon EOS R5 with RF 85mm f/1.2)
✅ **Golden hour or professional studio lighting**
✅ **Specific model description** (body type, ethnicity, styling)

### Product Photo Prompt Template:

```
A professional [TIME OF DAY] photoshoot at [LUXURY LOCATION], with [LIGHTING DESCRIPTION], high resolution, and sharp focus. A [MODEL DESCRIPTION] stands confidently [POSE], facing the camera with [EXPRESSION]. She has [PHYSICAL DETAILS], [MAKEUP], and [HAIR STYLE]. She wears [PRODUCT DESCRIPTION] paired with [STYLING]. [BACKGROUND DETAILS]. Shot on Canon EOS R5 with RF 85mm f/1.2 lens at f/2.0. IN THE TOP-LEFT CORNER positioned above the model's head, a white rounded rectangle TikTok-style comment bubble with subtle shadow contains: a small 40px circular profile photo of [COMMENTER DESCRIPTION], next to it "@[USERNAME]" with a blue verification checkmark, below that in black text "[OBJECTION QUESTION] [EMOJI]". IN THE BOTTOM-RIGHT CORNER positioned to not cover the product, a second white TikTok-style comment bubble contains: a small 40px circular profile photo of [COMMENTER 2 DESCRIPTION], next to it "@[USERNAME2]" with blue checkmark, below that "[OBJECTION ANSWER] [EMOJI]".
```

### ✅ COMPLETE EXAMPLE PROMPT (Copy This Format):

**This is a ready-to-use prompt. Replace the [BRACKETED] items with your product details:**

```
A professional golden hour photoshoot on a luxury rooftop bar in Manhattan, with warm ambient lighting from string lights and candles, soft evening glow, high resolution, and sharp focus. A curvy, plus-sized olive-skinned Latina woman in her late 20s stands confidently beside a marble bar counter, facing the camera with a radiant smile and poised expression. She has full glam makeup with bronzed skin, glossy nude lips, dramatic winged eyeliner, eyelash extensions, and long flowing dark brown hair styled in loose Hollywood waves with a deep side part. She wears a floor-length black sequin cocktail skirt with shimmering iridescent sequins covering the entire garment, creating a luxurious drape from her natural waist down. The sequins catch the golden hour light creating a stunning sparkle effect. She pairs it with a fitted white silk camisole top tucked in at the waist and gold strappy heels. She stands with one hand on her hip, her posture elegant and confident. In the background, the New York City skyline at sunset with glowing skyscrapers, string lights, potted olive trees, and velvet lounge furniture. Shot on Canon EOS R5 with RF 85mm f/1.2 lens at f/2.0, creating an editorial-quality, ultra-high resolution image. IN THE TOP-LEFT CORNER positioned above the model's head, a white rounded rectangle TikTok-style comment bubble with subtle shadow contains: a small 40px circular profile photo of a young blonde Gen Z girl with curtain bangs and soft glam makeup, next to it "@maddierose" with a blue verification checkmark, below that in black text "wait is this actually comfortable for a night out? 😭". IN THE BOTTOM-RIGHT CORNER positioned to not cover the skirt, a second white rounded rectangle TikTok-style comment bubble with subtle shadow contains: a small 40px circular profile photo of a young brunette Gen Z girl with slicked back bun and clean girl aesthetic, next to it "@sophiaylor" with blue checkmark, below that "YES babe it's literally so comfy and the elastic waistband is a lifesaver!! wore it 6 hours straight 🔥".
```

---

### Objection Pairs (Russell Brunson Framework):

| Objection Type       | Question                                                 | Answer                                                                         |
| -------------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Comfort**          | "wait is this actually comfortable for a night out? 😭"  | "YES babe it's literally so comfy, wore it 6 hours straight 🔥"                |
| **Shedding/Quality** | "does it shed sequins everywhere? 😭"                    | "nope 👏 been wearing mine for months, literally zero sequins fell off"        |
| **Price**            | "is it worth the price tho? 🤔"                          | "literally the best $97 I ever spent, looks like a $500 piece no cap ✨"       |
| **Fit**              | "does it run small? worried about sizing 😩"             | "TTS babe! I'm usually a M and the M fit perfect 👑"                           |
| **Durability**       | "can you actually rewear this or is it one and done? 😅" | "I've worn mine to 5 events already and it still looks brand new 🔥"           |
| **Practicality**     | "is it heavy? I hate heavy skirts 😭"                    | "it has weight but that's the quality ✨ cheap ones are literally see-through" |

---

## 📱 TESTIMONIAL PHOTOS (25 Images)

### Style: UGC iPhone Mirror Selfies

- **5 images (20%)**: 2 bubbles = QUESTION (objection) + ANSWER (handling it)
- **20 images (80%)**: 1 bubble = STATEMENT ONLY (social proof, NOT a question)

### Testimonial Prompt Template (2 bubbles):

```
A POV-style iPhone mirror selfie of a confident [MODEL DESCRIPTION]. She has [MAKEUP] with visible skin texture, [LIP DESCRIPTION], [LASHES], and [HAIR DESCRIPTION]. She wears [OUTFIT WITH PRODUCT]. Her figure shows [BODY DESCRIPTION]. She's turned slightly sideways with a poised, self-assured expression and confident smile, one hand on hip. The setting is [SPECIFIC LOCATION] with [ENVIRONMENT DETAILS]. Natural [LIGHTING TYPE]. Realistic iPhone 15 Pro selfie quality with slight grain, authentic UGC aesthetic. IN THE TOP-LEFT CORNER, a white rounded rectangle TikTok-style comment bubble contains: a small 40px circular profile photo of [COMMENTER], next to it "@[USERNAME]" with blue checkmark, below that "[QUESTION] [EMOJI]". IN THE TOP-RIGHT CORNER, a second bubble contains: profile photo of [COMMENTER 2], "@[USERNAME2]" with checkmark, "[ANSWER] [EMOJI]".
```

### Testimonial Prompt Template (1 bubble):

```
[Same base prompt as above]... IN THE TOP-RIGHT CORNER positioned above her head, a white rounded rectangle TikTok-style comment bubble with subtle shadow contains: a small 40px circular profile photo of [COMMENTER DESCRIPTION], next to it "@[USERNAME]" with blue verification checkmark, below that "[SOCIAL PROOF COMMENT] [EMOJI]".
```

### Social Proof Comments (1-bubble testimonials):

- "literally obsessed ✨ wore it to three weddings and everyone asked where I got it"
- "the way this hugs my curves 😭👑 I'm never taking it off"
- "my husband can't stop staring 🔥🔥🔥"
- "finally found a [PRODUCT] that doesn't make me look frumpy 😍"
- "I wear mine every weekend, it's literally my personality now 💀"
- "ordered a backup because I can't imagine life without it no cap"

---

## ⚖️ COMPARISON PHOTO (1 Image)

### NO TikTok bubbles on comparison image!

```
Side-by-side comparison photo in a single wide frame. LEFT: [MODEL DESCRIPTION] wearing [CHEAP COMPETITOR PRODUCT], uncomfortable/frustrated expression, subtle red X and “OLD WAY” label. RIGHT: same model wearing [YOUR PRODUCT], confident smile, subtle green check and “NEW WAY” label. Clean white/grey backdrop, studio lighting. 1100x600px horizontal.
```

---

## 👩‍💼 FOUNDER PHOTO (1 Image)

### NO TikTok bubbles!

### Key Requirements:

- Founder is **HOLDING** the product (not wearing it)
- Product is loose, unstructured, showing fabric quality
- Professional CEO energy, modern entrepreneur vibe
- Luxury location (resort lobby, design studio)

```
A professional morning-hour editorial photoshoot inside [LUXURY LOCATION], with natural ambient lighting. The model is a [FOUNDER DESCRIPTION], confidently embodying a modern CEO and founder presence. She has [PHYSICAL DETAILS], [MAKEUP], and [HAIR]. She wears [PROFESSIONAL OUTFIT] - business-casual luxury. She is NOT wearing the product. Instead, she is HOLDING it in one hand at her side like a featured product — a loose, unstructured [PRODUCT DESCRIPTION] dangling in her grip. Her other hand rests on her hip, and she stands confidently facing the camera, her expression proud and self-assured — the vibe is "this is my brand." Shot on Canon RF 85mm f/1.2. High-resolution, film grain added for realism.
```

---

## 🎁 ORDER BUMP PHOTO (1 Image)

### NO TikTok bubbles!

### NO reference to main product!

### Key Requirements:

- Complementary accessory product
- $10 price point with $70-80 perceived value
- Professional flat-lay or styled product shot
- Clean white or minimal background

| Main Product | Order Bump                                            |
| ------------ | ----------------------------------------------------- |
| Sequin Skirt | Party Glam Essentials Set (belt, earrings, scrunchie) |
| Corset       | Shapewear Care Kit                                    |
| Dress        | Statement Jewelry Set                                 |
| Activewear   | Gym Accessories Kit                                   |

```
A professional product photography shoot with clean white background, luxury e-commerce aesthetic. The "[ORDER BUMP NAME]" - a $10 add-on perfect for completing the look. The set includes: [ITEM 1], [ITEM 2], [ITEM 3]. All pieces arranged in elegant flat-lay composition on [SURFACE] with soft shadows, [STYLING ELEMENTS]. Shot on Canon EOS R5 with 50mm macro lens at f/8 for complete sharpness. Square format 1000x1000px.
```

---

## ✅ PRE-GENERATION CHECKLIST

Before generating ANY image, verify:

- [ ] I have read this entire document
- [ ] I know which category this image belongs to (product/testimonial/comparison/founder/order-bump)
- [ ] I know how many TikTok bubbles this image needs (0, 1, or 2)
- [ ] I have prepared objection-handling comments using Russell Brunson frameworks
- [ ] My prompt includes EXACT bubble positioning (top-left, top-right, bottom-right)
- [ ] My prompt includes profile photo descriptions for commenters
- [ ] My prompt includes @username with blue verification checkmark
- [ ] My prompt includes Gen Z language with emojis

---

## 🚫 COMMON MISTAKES TO AVOID

1. ❌ **Generating product photos WITHOUT TikTok bubbles**
2. ❌ **Putting bubbles on comparison/founder/order-bump images**
3. ❌ **Using generic comments instead of objection-handling pairs**
4. ❌ **Forgetting profile photos in bubbles**
5. ❌ **Positioning bubbles over product or model's face**
6. ❌ **Using formal language instead of Gen Z slang**
7. ❌ **Forgetting emojis in comments**
8. ❌ **Making founder WEAR the product instead of HOLD it**

---

## 📋 GENERATION ORDER

Generate images in this EXACT order:

1. Product Photos 1-6 (2 bubbles each)
2. Testimonials 1-5 (2 bubbles each)
3. Testimonials 6-25 (1 bubble each)
4. Comparison Bad (no bubbles)
5. Comparison Good (no bubbles)
6. Founder (no bubbles)
7. Order Bump (no bubbles)

---

## 🎯 FINAL REMINDER

**EVERY PRODUCT PHOTO NEEDS 2 TIKTOK COMMENT BUBBLES.**

If you generate a product photo without bubbles, it is UNUSABLE and must be regenerated.

The bubbles are not optional. They are the core conversion mechanism using Russell Brunson's objection-handling framework embedded directly into the images.

---

_This document must be read before any image generation begins._

---

## 🛠️ IMAGE SOURCING PRIORITY

### ⚠️ CRITICAL: USE EXISTING IMAGES FIRST

**DO NOT generate images if the user has already provided them.**

Before generating ANY images, check if they already exist:

```bash
# Check existing images
ls -la images/product/
ls -la images/testimonials/
ls -la images/comparison/
ls -la images/founder/
ls -la images/order-bump/
```

### Priority Order:

#### 1. USE EXISTING USER IMAGES - PRIMARY

If images already exist in the correct folders:

- **DO NOT regenerate them**
- **DO NOT overwrite them**
- Simply verify they meet the requirements (count, format)
- Move to the next phase

**The user's images are the source of truth.**

#### 2. ASK USER BEFORE GENERATING - SECONDARY

If images are MISSING, ask the user:

```
"I notice [X images] are missing from images/[folder]/. Would you like me to:
A) Wait for you to add them manually
B) Generate them using the Nano Banana tool
C) Skip and continue (may cause build errors)"
```

**Never auto-generate without explicit user permission.**

#### 3. Nano Banana (generate_image tool) - ONLY IF APPROVED

If the user explicitly requests generation AND you have the `generate_image` tool:

```
Use generate_image with the full prompt text from the examples above
```

#### 4. Google Whisk - MANUAL FALLBACK

If generate_image is not available:

1. Go to: https://labs.google/fx/tools/whisk
2. Click through the intro modals
3. Paste the full prompt into the text area
4. Click the generate button (arrow icon)
5. Wait for images to generate
6. Download and save to correct folder

**No login required.**

---

### Image Specifications

| Image Type     | Dimensions | Format     |
| -------------- | ---------- | ---------- |
| Product Photos | 1024x1024  | PNG → WebP |
| Testimonials   | 1024x1024  | PNG → WebP |
| Comparison     | 1100x600   | PNG → WebP |
| Founder        | 1024x1024  | PNG → WebP |
| Order Bump     | 1000x1000  | PNG → WebP |

### After Generation

Save images to:

```
images/product/product-01.webp through product-06.webp
images/testimonials/testimonial-01.webp through testimonial-25.webp
images/comparison/comparison-01.webp
images/founder/founder-01.webp
images/order-bump/order-bump-01.webp
```

Then run image optimization:

```bash
./optimize-images.sh
```

This converts all PNG/JPG to WebP format for faster loading.

---

**Total: 34 images with 42 TikTok comment bubbles**

---

## ✅ Phase Complete When:

- [ ] 6 product photos generated (each with 2 TikTok bubbles)
- [ ] 25 testimonial photos generated (5 with 2 bubbles, 20 with 1 bubble)
- [ ] 1 comparison photo generated (no bubbles)
- [ ] 1 founder photo generated (no bubbles)
- [ ] 1 order bump photo generated (no bubbles)
- [ ] All images saved to correct folders

## ➡️ Next Phase:

Read: `phases/3-config.md`
