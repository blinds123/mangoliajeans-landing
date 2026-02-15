# Manual Interventions Required

> **Document Purpose:** Track issues found during Haiku 4.5 testing that require manual fixes or skill improvements.
> **Last Updated:** 2026-01-23

---

## Issue Summary

| #   | Issue                              | Severity | Section       | Status        |
| --- | ---------------------------------- | -------- | ------------- | ------------- |
| 1   | Pricing incorrect                  | HIGH     | Hero/Pricing  | SKILL UPDATED |
| 2   | Wrong comparison image             | HIGH     | Comparison    | ✅ FIXED      |
| 3   | Feature 2 doesn't follow FIBS      | MEDIUM   | Features      | SKILL UPDATED |
| 4   | Too many features added            | MEDIUM   | Features      | SKILL UPDATED |
| 5   | Founder story too long + wrong POV | HIGH     | Founder Story | SKILL UPDATED |
| 6   | FAQ accordions don't work          | HIGH     | FAQ           | ✅ FIXED      |
| 7   | Testimonial images not showing     | HIGH     | Testimonials  | ✅ FIXED      |

---

## Issue 1: Pricing Not Correct

**Expected:**

- Single/Pre-Order: $19
- Order Bump: +$10
- Bundle/Order Today: $59

**Actual:**

- Pricing values not displaying $59, $19, $10

**Root Cause:** Haiku likely not reading/injecting pricing from product.config correctly.

**Fix Required:**

- Verify SINGLE_PRICE, BUNDLE_PRICE, ORDER_BUMP_PRICE in product.config
- Ensure build.sh replaces {{SINGLE_PRICE}}, {{BUNDLE_PRICE}}, {{ORDER_BUMP_PRICE}}

**Skill Improvement:**

- Inject pricing explicitly into copy tasks: "Use these EXACT prices: $19 single, $59 bundle, $10 order bump"

---

## Issue 2: Wrong Comparison Image

**Expected:**

- Single combined before/after image: `images/comparison/comparison-01.webp`

**Actual:**

- Was using `images/product/product-03.webp` (a product image, NOT comparison!)

**ROOT CAUSE:**

`COMPARISON_IMAGE` in product.config was pointing to wrong file.

**FIX APPLIED:**

1. Updated `product.config` line 211:

   ```
   COMPARISON_IMAGE="images/comparison/comparison-01.webp"
   ```

2. Updated `IMAGE-MAP.md` to reflect single combined image requirement

3. Template `sections/06-comparison.html` uses single `{{COMPARISON_IMAGE}}` slot (correct)

**Action Required:**

- Create `images/comparison/comparison-01.webp` - a single combined graphic showing:
  - LEFT side: "Before" / Problem / Old Way
  - RIGHT side: "After" / Solution / New Way
- Dimensions: 1100x600px minimum (wide format)
- Can include text overlays for "Before" / "After" labels

---

## Issue 3: Feature 2 Doesn't Follow FIBS

**Expected FIBS Pattern:**

```
F - Feature: What it is (the thing)
I - Importance: Why it matters (the problem it solves)
B - Benefit: What they get (the outcome)
S - Social proof: Who else got this result
```

**Actual:**

- Feature 2 copy missing one or more FIBS elements

**Root Cause:** Haiku not following FIBS framework strictly.

**Fix Required:**

- Rewrite Feature 2 copy to include all 4 FIBS elements
- Each element should be clearly present

**Skill Improvement:**

- Inject FIBS template INSIDE the prompt with fill-in sections:

```
Feature 2:
F - [FEATURE]: _______________
I - [IMPORTANCE]: _______________
B - [BENEFIT]: _______________
S - [SOCIAL PROOF]: _______________
```

---

## Issue 4: Too Many Features Added

**Expected:**

- 3 features (FIBS pattern x 3)
- Matches `08-features-3-fibs.html`

**Actual:**

- More than 3 features appear on page

**Root Cause:** Haiku added extra features beyond the 3 required.

**Fix Required:**

- Remove extra feature content from product.config
- Keep only FEATURE_HEADLINE_1/2/3 and FEATURE_PARAGRAPH_1/2/3

**Skill Improvement:**

- Explicit constraint: "Write EXACTLY 3 features. No more, no less."

---

## Issue 5: Founder Story Too Long + Wrong POV

**Expected:**

- First person POV ("I was...", "I discovered...")
- Epiphany Bridge structure (5 parts, concise)
- ~150-200 words total

**Actual:**

- Third person POV ("She was...", "She realized...")
- Way too long (500+ words)
- Multiple paragraphs instead of focused narrative

**Example of Problem (from test):**

```
"She was an interior designer who loved her job—until the moment when every
project hit the same wall..."
```

**Should Be:**

```
"I was an interior designer who loved my job—until every project hit the same
wall..."
```

**Root Cause:**

- Haiku defaulting to third person narrative style
- No word count constraint enforced
- Epiphany Bridge structure not followed strictly

**Fix Required:**

- Rewrite in FIRST PERSON
- Cut to 150-200 words max
- Follow exact Epiphany Bridge structure:
  1. Backstory (1-2 sentences)
  2. Wall (1-2 sentences)
  3. Epiphany (1-2 sentences)
  4. Plan (1-2 sentences)
  5. Transformation (1-2 sentences)

**Skill Improvement:**

- Inject explicit constraint:

```
CRITICAL RULES FOR FOUNDER STORY:
- MUST be FIRST PERSON ("I was...", "I discovered...")
- NEVER third person ("She was...", "She realized...")
- Maximum 200 words total
- Follow Epiphany Bridge EXACTLY:
  1. Backstory: 1-2 sentences
  2. Wall: 1-2 sentences
  3. Epiphany: 1-2 sentences
  4. Plan: 1-2 sentences
  5. Transformation: 1-2 sentences
```

---

## Issue 6: FAQ Accordions Don't Work

**Expected:**

- Click on FAQ question → answer reveals with smooth animation
- Uses native `<details>` + `<summary>` HTML elements

**Actual:**

- Clicking accordion button does nothing
- Answers don't reveal

**Root Cause (IDENTIFIED):**

CSS cascade conflict between `base.css` and section CSS:

1. `base.css` uses sibling selector (`+`) expecting `accordion__content-wrapper` as sibling of `<details>`
2. Our HTML has `accordion__content-wrapper` as CHILD of `<details>`
3. `base.css` sets `opacity: 0` on `.accordion__content` and only removes via sibling selector
4. `base.css` uses `grid-template-rows: 0fr` animation which conflicts with `max-height` approach

**FIX APPLIED:**

Updated `sections/14-faq.html` with CSS overrides using `!important`:

```css
/* Override base.css grid approach - use height-based animation instead */
.accordion__details .accordion__content-wrapper {
  display: block !important;
  grid-template-rows: unset !important;
  overflow: hidden !important;
  max-height: 0 !important;
  opacity: 1 !important;
  transition:
    max-height 0.3s ease-out,
    padding 0.3s ease-out !important;
}

/* CRITICAL: Override base.css opacity:0 on content */
.accordion__details .accordion__content {
  opacity: 1 !important;
  visibility: visible !important;
  min-height: unset !important;
  padding: 0 0.6rem !important;
}

/* When open - expand to show content */
.accordion__details[open] .accordion__content-wrapper {
  max-height: 500px !important;
  padding-bottom: 1rem !important;
}
```

**Status:** ✅ FIXED - CSS overrides now force visibility regardless of base.css selectors

---

## Issue 7: Testimonial Images Not Showing

**Expected Layout:**

```
┌───────────────────────┐
│       [IMAGE]         │
│       ★★★★★           │
│    "Quote..."         │
│   - Author, Location  │
└───────────────────────┘
        ↓
┌───────────────────────┐
│       [IMAGE]         │
│       ★★★★★           │
│    "Quote..."         │
│   - Author, Location  │
└───────────────────────┘
... repeating vertically
```

**Root Cause (IDENTIFIED):**

Two issues found:

1. **CSS Conflict**: `base.css` uses `position: absolute` on `.media` children which requires explicit height via `padding-bottom`. Without this, images collapse to 0 height.

2. **Layout Conflict**: Section was using 3-column Splide carousel (`--columns-desktop: 3`) instead of single column vertical stack.

**FIX APPLIED:**

Updated `sections/18-testimonials.html` with:

1. **Image visibility overrides:**

```css
/* Override base.css .media absolute positioning */
.testimonial-card .media,
.testimonial-card .media--transparent {
  display: block !important;
  position: relative !important;
  padding-bottom: 0 !important;
  height: auto !important;
}

/* Make image flow normally instead of absolute */
.testimonial-card .multicolumn-card__image {
  position: relative !important;
  width: 100% !important;
  height: auto !important;
  aspect-ratio: 1/1 !important;
  top: unset !important;
  left: unset !important;
}
```

2. **Vertical stack layout:**

```css
/* Override Splide carousel - make it a simple vertical list */
.splide__list {
  display: flex !important;
  flex-direction: column !important;
  gap: 2rem !important;
  max-width: 600px !important;
  margin: 0 auto !important;
}

/* Card layout - image on top, content below */
.testimonial-card {
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
}

/* Image container - centered above text */
.testimonial-card .multicolumn-card__image-wrapper {
  order: 1 !important;
  width: 200px !important;
}

/* Info section - below image */
.testimonial-card .multicolumn-card__info {
  order: 2 !important;
}
```

3. **Changed column settings** from 3 to 1:

```html
--columns-desktop: 1; --columns-mobile: 1;
```

**Status:** ✅ FIXED - Images now display above reviews in vertical stack layout

---

## Skill Improvements Summary

Add these constraints to task-runner SKILL.md:

### For Pricing Tasks:

```
EXACT PRICES - DO NOT CHANGE:
- Single/Pre-Order: $19
- Order Bump: +$10
- Bundle: $59
```

### For Feature Tasks:

```
EXACTLY 3 features using FIBS:
F - Feature: What it is
I - Importance: Why it matters
B - Benefit: What they get
S - Social proof: Who else got this
```

### For Founder Story Tasks:

```
CRITICAL RULES:
- FIRST PERSON ONLY ("I was...", "I discovered...")
- NEVER third person
- Maximum 200 words
- Epiphany Bridge: Backstory → Wall → Epiphany → Plan → Transformation
```

### For Testimonial Tasks:

```
Each testimonial card MUST have:
- Image (from images/testimonials/)
- 5 stars
- Title
- Quote
- Author + Location
```

---

## Testing Checklist (Post-Build)

- [ ] Pricing shows $19 / $59 / $10 correctly
- [ ] Comparison uses single combined comparison-01.webp image
- [ ] Exactly 3 features, each following FIBS
- [ ] Founder story is first person, under 200 words
- [x] All 5 FAQ accordions open when clicked (CSS FIXED)
- [x] All 12 testimonial images visible in vertical stack (CSS FIXED)
- [ ] No console errors in browser

---

## Notes

- These issues are specific to Haiku 4.5 weak model testing
- Root cause is insufficient constraint injection in prompts
- Task-runner skill needs stricter guardrails for weaker models
