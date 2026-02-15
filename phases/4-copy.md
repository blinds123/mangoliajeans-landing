# Phase 4: Copy Rewrite

Rewrite all sales copy using buyer research and Russell Brunson frameworks.

---

## Input Required

- Completed `BUYER-RESEARCH-[PRODUCT].md`
- Filled `product.config`

---

## Step 1: Identify Hardcoded Content

Search for product-specific terms in `sections/*.html`:

```bash
# Search for hardcoded content (replace with your product terms)
grep -rn "YOUR_OLD_PRODUCT_TERM" sections/*.html
```

Look for:
- Previous brand/product names
- Product-specific descriptions
- Hardcoded prices
- Non-placeholder testimonials

---

## Step 2: Section-by-Section Copywriting Guide

### Section 03-header.html
- Replace brand name with `{{BRAND_NAME}}`

### Section 05-main-product.html (Most Important)

| Element | Framework | Source |
|---------|-----------|--------|
| Hero Headline | "New Opportunity" hook | Desire #1 |
| Subheadline | Benefit + objection destroyer | Pain #1 reversal |
| Feature Cards (4) | Benefits, not features | Top 4 desires |
| Price Anchor | Value comparison | Competitor pricing |

### Section 06-comparison.html

| Element | Source |
|---------|--------|
| "Old Way" | Pain Stack #1-3 |
| "New Way" | Desire Stack #1-3 |

### Section 08-multirow.html (Features)

Each row should address one objection from your research.

### Section 14-faq.html

Map FAQs to objections:

| FAQ Question | Answer Framework |
|--------------|------------------|
| Objection #1 | False Belief Pattern Break |
| Objection #2 | Social Proof + Authority |
| Objection #3 | Value Amplification |
| Objection #4 | Objection Reversal |
| Objection #5 | Urgency + FOMO |

### Section 18-testimonials.html

Replace testimonial quotes with research-driven quotes that:
- Address specific objections
- Use Gen Z language
- Include emotional outcomes

### Section 20-cta-banner.html

| Element | Formula |
|---------|---------|
| Headline | Desire #1 restated |
| Subheadline | Urgency trigger |

---

## Step 3: Apply Russell Brunson Frameworks

### Framework 1: False Belief Pattern Break

```
"Most people think [COMMON BELIEF]...
But the truth is [NEW BELIEF]...
That's why [PRODUCT] was designed to [BENEFIT]."
```

### Framework 2: Future Pacing

```
"Imagine [TIMEFRAME] from now...
You're [DESIRED OUTCOME]...
And you finally feel [EMOTIONAL STATE]."
```

### Framework 3: The Stack

Build perceived value:
```
Component 1: [PRODUCT] - Value $X
Component 2: [BONUS] - Value $Y
Component 3: [GUARANTEE] - Priceless
Total Value: $XXX
Today Only: $YY
```

### Framework 4: Urgency + Scarcity

```
"Due to [REASON], we can only offer this [LIMITATION]..."
"Once this batch sells out [CONSEQUENCE]..."
```

---

## Step 4: Verify No Placeholders Remain

After editing, check:

```bash
grep "{{" sections/*.html
```

**Expected placeholders** (these are OK - build.sh replaces them):
- `{{PRODUCT_NAME}}`, `{{BRAND_NAME}}`, `{{SINGLE_PRICE}}`
- `{{HEADLINE_HOOK}}`, `{{TAGLINE}}`
- `{{TESTIMONIAL_1}}`, `{{TESTIMONIAL_1_NAME}}`

**Unexpected placeholders** (these need fixing):
- Any `{{CUSTOM_THING}}` not in product.config
- Typos like `{{PROUDCT_NAME}}`

---

## ✅ Phase Complete When:

- [ ] All hardcoded product names replaced
- [ ] Headlines use Desire #1
- [ ] FAQs address top objections
- [ ] Testimonials use Gen Z language
- [ ] No broken placeholders

## ➡️ Next Phase:

Read: `phases/5-build.md`
