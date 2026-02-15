# Phase 3: Configuration

Fill the product.config file using your buyer research.

---

## Input Required

- Completed `BUYER-RESEARCH-[PRODUCT].md` from Phase 1

---

## Step 1: Open product.config

```bash
# File location
product.config
```

---

## Step 2: Fill Required Fields

Use your buyer research to fill each field:

### Product Information

| Field | Where to Find | Example |
|-------|---------------|---------|
| `PRODUCT_NAME` | Competitor analysis | "Leopard Sequin Maxi Skirt" |
| `BRAND_NAME` | Your brand | "{{BRAND_NAME}}" |
| `PRODUCT_HANDLE` | URL-safe version | "leopard-sequin-maxi-skirt" |
| `SUBDOMAIN` | Short URL-safe name | "yourproduct" → yourproduct.yourbrand.store |

### Pricing

| Field | Source | Example |
|-------|--------|---------|
| `SINGLE_PRICE` | Competitor pricing | "97" |
| `BUNDLE_PRICE` | 2x discount | "147" |
| `BUNDLE_OLD_PRICE` | Original 2x | "194" |
| `BUNDLE_SAVINGS` | Difference | "47" |
| `ORDER_BUMP_PRICE` | Accessory | "10" |

### Guarantee

| Field | Source | Example |
|-------|--------|---------|
| `GUARANTEE_DAYS` | Policy | "30" |
| `GUARANTEE_NAME` | Research objections | "Perfect Fit Guarantee" |
| `GUARANTEE_CONDITION` | Objection reversal | "If it doesn't fit perfectly" |

### Headlines & Copy

| Field | Where to Find | Example |
|-------|---------------|---------|
| `HEADLINE_HOOK` | Pain #1 or Desire #1 | "The Skirt That Stops The Room" |
| `TAGLINE` | New Vehicle positioning | "Finally, sequins without the itch" |
| `BEFORE_PAIN` | Pain Stack #1 | "Boring basics that blend into the crowd" |
| `AFTER_BENEFIT` | Desire Stack #1 | "Statement pieces that demand attention" |
| `AUDIENCE` | Dream customer | "Women" |
| `REVIEW_COUNT` | Social proof | "12,847" |

### Testimonials

Use insights from buyer research:

| Field | Source |
|-------|--------|
| `TESTIMONIAL_1` | Address objection #1 |
| `TESTIMONIAL_1_NAME` | Gen Z name |
| `TESTIMONIAL_2` | Address objection #2 |
| `TESTIMONIAL_2_NAME` | Gen Z name |
| `TESTIMONIAL_3` | Address objection #3 |
| `TESTIMONIAL_3_NAME` | Gen Z name |

### Bundle Description

| Field | Example |
|-------|---------|
| `BUNDLE_DESCRIPTION` | "2x Leopard Sequin Skirts + FREE Belt Set" |
| `SINGLE_DESCRIPTION` | "1x Leopard Sequin Maxi Skirt" |
| `SIZES` | "XS,S,M,L,XL,XXL" (comma-separated) |

### Deployment

| Field | Where to Get |
|-------|--------------|
| `NETLIFY_SITE_ID` | Netlify dashboard → Site settings → Site ID |

---

## Step 3: Validate

Run this to check:

```bash
source product.config
echo "Product: $PRODUCT_NAME"
echo "Price: $SINGLE_PRICE"
```

All required fields should have values (not empty strings).

---

## ✅ Phase Complete When:

- [ ] All required fields filled
- [ ] PRODUCT_NAME not empty
- [ ] SINGLE_PRICE not empty
- [ ] HEADLINE_HOOK uses Pain #1 or Desire #1
- [ ] TESTIMONIALS address top objections

## ➡️ Next Phase:

Read: `phases/4-copy.md`
