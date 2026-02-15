# WEAK MODEL COMPATIBILITY GUIDE

> **FOR:** Haiku 3.5, Haiku 4.5, GLM 4.7, or any model that struggles with complex templates
> **PURPOSE:** Step-by-step instructions to fix common template issues
> **RULE:** Follow EXACTLY. Do NOT deviate from these patterns.

---

## HOW TO USE THIS DOCUMENT

1. If you see a problem, find it in the list below
2. Copy the EXACT fix provided
3. Paste it into the correct file
4. Run `bash build.sh` to test

---

## ISSUE 1: FEATURE VARIABLES

### THE RULE

Features ALWAYS use this pattern:

```
FEATURE_HEADLINE_1, FEATURE_PARAGRAPH_1
FEATURE_HEADLINE_2, FEATURE_PARAGRAPH_2
FEATURE_HEADLINE_3, FEATURE_PARAGRAPH_3
```

### WRONG (DO NOT USE)

```
FEATURE_PARAGRAPH_1_1    ❌ WRONG
FEATURE_PARAGRAPH_1_2    ❌ WRONG
FEATURE_BENEFIT_TEXT     ❌ WRONG
```

### RIGHT (USE THIS)

```
FEATURE_PARAGRAPH_1      ✓ CORRECT
FEATURE_PARAGRAPH_2      ✓ CORRECT
FEATURE_PARAGRAPH_3      ✓ CORRECT
```

### IF TEMPLATE HAS WRONG VARIABLES

Open `sections/08-features-3-fibs.html` and change:

```html
<!-- WRONG -->
<p>{{FEATURE_PARAGRAPH_1_1}}</p>
<p>{{FEATURE_PARAGRAPH_1_2}}</p>
```

To:

```html
<!-- RIGHT -->
<p>{{FEATURE_PARAGRAPH_1}}</p>
```

And change:

```html
<!-- WRONG -->
<p>{{FEATURE_BENEFIT_TEXT}}</p>
```

To:

```html
<!-- RIGHT -->
<p>{{FEATURE_PARAGRAPH_3}}</p>
```

---

## ISSUE 2: SECRET VARIABLES

### THE RULE

Secrets ALWAYS use number-in-middle pattern:

```
SECRET_1_HEADLINE    ✓ CORRECT (number in middle)
SECRET_1_FALSE_BELIEF
SECRET_1_TRUTH
```

### WRONG (DO NOT USE)

```
SECRET_HEADLINE_1    ❌ WRONG (number at end)
```

### IF CONFIG HAS DUPLICATES

Open `product.config` and DELETE these lines:

```bash
# DELETE THESE LINES - THEY ARE DUPLICATES
SECRET_HEADLINE_1="..."
SECRET_HEADLINE_2="..."
SECRET_HEADLINE_3="..."
```

KEEP ONLY these:

```bash
# KEEP THESE LINES
SECRET_1_HEADLINE="HUGS NOT SQUEEZES"
SECRET_2_HEADLINE="DESIGNED FOR HIPS"
SECRET_3_HEADLINE="SAFE TO SIT"
```

---

## ISSUE 3: CONTENT NOT SHOWING (animate--hidden)

### THE RULE

If sections are invisible, add this CSS to `sections/01-head.html`:

### COPY THIS EXACT CSS

Find the `<style>` section in `01-head.html` and add:

```css
/* FORCE ALL CONTENT VISIBLE */
.animate-section,
.animate-item,
.animate--hidden,
.content-for-grouping {
  opacity: 1 !important;
  visibility: visible !important;
  transform: none !important;
}

/* FALLBACK IF JAVASCRIPT FAILS */
@keyframes forceShow {
  to {
    opacity: 1 !important;
    visibility: visible !important;
  }
}

.animate--hidden {
  animation: forceShow 0s 2s forwards;
}

html.loaded .animate--hidden,
html.js .animate--hidden {
  opacity: 1 !important;
  visibility: visible !important;
}
```

---

## ISSUE 4: FAQ NOT OPENING

### THE RULE

FAQ accordion needs sibling selector CSS override.

### COPY THIS EXACT CSS

Add to `sections/14-faq.html` in the `<style>` section:

```css
/* FAQ ACCORDION FIX */
.accordion__content {
  display: none !important;
}

details[open] .accordion__content,
details[open] > .accordion__content {
  display: block !important;
}

summary + .accordion__content {
  display: none !important;
}

details[open] summary + .accordion__content {
  display: block !important;
}
```

---

## ISSUE 5: TESTIMONIAL IMAGES NOT SHOWING

### THE RULE

Testimonials need vertical stack layout.

### COPY THIS EXACT CSS

Add to `sections/18-testimonials.html` in the `<style>` section:

```css
/* TESTIMONIAL VERTICAL STACK */
.splide__list {
  display: flex !important;
  flex-direction: column !important;
  gap: 2rem !important;
}

.splide__slide {
  width: 100% !important;
  max-width: 400px !important;
  margin: 0 auto !important;
}

/* FORCE IMAGES VISIBLE */
.multicolumn-card__image,
.multicolumn-card__image img {
  opacity: 1 !important;
  visibility: visible !important;
  display: block !important;
}
```

---

## ISSUE 6: EMPTY VALUES CRASH BUILD

### THE RULE

These variables MUST have values (not empty):

```bash
# REQUIRED - will crash if empty
SIZE_OPTIONS="<option value='S'>S</option>"
COLOR_UI_HTML="<!-- placeholder -->"
```

### IF BUILD FAILS WITH "UNREPLACED PLACEHOLDERS"

Open `product.config` and add:

```bash
SIZE_OPTIONS="<option value='S'>S</option><option value='M'>M</option><option value='L'>L</option><option value='XL'>XL</option>"
COLOR_UI_HTML="<!-- Color options populated at build time -->"
```

---

## ISSUE 7: build.sh MISSING REPLACE_VAR

### THE RULE

Every `{{VARIABLE}}` in HTML needs a matching `replace_var` in build.sh.

### IF BUILD SHOWS UNREPLACED PLACEHOLDERS

1. Note which placeholder is unreplaced (e.g., `{{FEATURE_IMAGE_1}}`)
2. Open `build.sh`
3. Add this line in the appropriate section:

```bash
replace_var "{{FEATURE_IMAGE_1}}" "$FEATURE_IMAGE_1"
```

### COMMON MISSING VARIABLES

Add these to `build.sh` if missing:

```bash
# Feature images
replace_var "{{FEATURE_IMAGE_1}}" "$FEATURE_IMAGE_1"
replace_var "{{FEATURE_IMAGE_2}}" "$FEATURE_IMAGE_2"
replace_var "{{FEATURE_IMAGE_3}}" "$FEATURE_IMAGE_3"

# Secret images
replace_var "{{SECRET_IMAGE_1}}" "$SECRET_IMAGE_1"
replace_var "{{SECRET_IMAGE_2}}" "$SECRET_IMAGE_2"
replace_var "{{SECRET_IMAGE_3}}" "$SECRET_IMAGE_3"

# Other common ones
replace_var "{{FAVICON_IMAGE}}" "$FAVICON_IMAGE"
replace_var "{{COMPARISON_IMAGE}}" "$COMPARISON_IMAGE"
```

---

## VARIABLE QUICK REFERENCE

### FEATURES (3 total)

```
FEATURE_HEADLINE_1="[headline text]"
FEATURE_PARAGRAPH_1="[paragraph text]"
FEATURE_IMAGE_1="images/testimonials/testimonial-01.webp"

FEATURE_HEADLINE_2="[headline text]"
FEATURE_PARAGRAPH_2="[paragraph text]"
FEATURE_IMAGE_2="images/testimonials/testimonial-02.webp"

FEATURE_HEADLINE_3="[headline text]"
FEATURE_PARAGRAPH_3="[paragraph text]"
FEATURE_IMAGE_3="images/testimonials/testimonial-03.webp"
```

### SECRETS (3 total)

```
SECRET_1_HEADLINE="[headline]"
SECRET_1_FALSE_BELIEF="[false belief text]"
SECRET_1_TRUTH="[truth text]"
SECRET_IMAGE_1="images/testimonials/testimonial-04.webp"

SECRET_2_HEADLINE="[headline]"
SECRET_2_FALSE_BELIEF="[false belief text]"
SECRET_2_TRUTH="[truth text]"
SECRET_IMAGE_2="images/testimonials/testimonial-05.webp"

SECRET_3_HEADLINE="[headline]"
SECRET_3_FALSE_BELIEF="[false belief text]"
SECRET_3_TRUTH="[truth text]"
SECRET_IMAGE_3="images/testimonials/testimonial-06.webp"
```

### TESTIMONIALS (12 total)

```
TESTIMONIAL_1_TITLE="[1-2 word title]"
TESTIMONIAL_1_QUOTE="[full quote with before/discovery/result]"
TESTIMONIAL_1_AUTHOR="[Name]"
TESTIMONIAL_1_LOCATION="[City, State]"
TESTIMONIAL_1_IMAGE="images/testimonials/testimonial-07.webp"

... repeat pattern through TESTIMONIAL_12_*
```

### IMAGE MAPPING

```
testimonial-01.webp → FEATURE_IMAGE_1
testimonial-02.webp → FEATURE_IMAGE_2
testimonial-03.webp → FEATURE_IMAGE_3
testimonial-04.webp → SECRET_IMAGE_1
testimonial-05.webp → SECRET_IMAGE_2
testimonial-06.webp → SECRET_IMAGE_3
testimonial-07.webp → TESTIMONIAL_1_IMAGE
testimonial-08.webp → TESTIMONIAL_2_IMAGE
... and so on
```

---

## BUILD CHECKLIST

Before running `bash build.sh`:

1. [ ] All FEATURE variables use `FEATURE_PARAGRAPH_1/2/3` pattern
2. [ ] No duplicate SECRET_HEADLINE_X variables in config
3. [ ] SIZE_OPTIONS has a value (not empty)
4. [ ] COLOR_UI_HTML has a value (not empty)
5. [ ] All image paths exist

After running `bash build.sh`:

1. [ ] No "unreplaced placeholders" error
2. [ ] Page loads at URL
3. [ ] FAQ accordion opens when clicked
4. [ ] Testimonial images visible

---

## EMERGENCY FIX: BUILD COMPLETELY BROKEN

If nothing works, do this:

1. Delete `index.html`
2. Run `bash build.sh`
3. If it fails, read the error message
4. Find the variable name in the error
5. Add the value to `product.config`
6. Run `bash build.sh` again
7. Repeat until no errors

---

## STATUS OF ALL ISSUES

| #   | Issue                   | Status | File to Fix                             |
| --- | ----------------------- | ------ | --------------------------------------- |
| 1   | Feature variable naming | FIXED  | 08-features-3-fibs.html, product.config |
| 2   | Secret dual naming      | FIXED  | product.config                          |
| 3   | Content not showing     | FIXED  | 01-head.html                            |
| 4   | FAQ not opening         | FIXED  | 14-faq.html                             |
| 5   | Testimonial images      | FIXED  | 18-testimonials.html                    |
| 6   | Empty values crash      | FIXED  | product.config                          |
| 7   | Missing replace_var     | FIXED  | build.sh                                |

ALL CRITICAL ISSUES HAVE BEEN FIXED IN THIS TEMPLATE.
