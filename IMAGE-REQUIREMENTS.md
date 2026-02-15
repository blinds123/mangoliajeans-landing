# IMAGE REQUIREMENTS — CANONICAL (Aligned)

**Source of truth:** `IMAGE-MAPPING.json` and `IMAGE-MAPPING.md`.

## Required Images (Generated)

| Category | Count | Files |
| --- | --- | --- |
| Product | 6 | `images/product/product-01.webp` → `product-06.webp` |
| Testimonials | 25 | `images/testimonials/testimonial-01.webp` → `testimonial-25.webp` |
| Comparison | 1 | `images/comparison/comparison-01.webp` |
| Order Bump | 1 | `images/order-bump/order-bump-01.webp` |
| Founder | 1 | `images/founder/founder-01.webp` (static; can duplicate `awards-1.webp`) |

**Generated total:** 33 images (founder is static)

## Static Assets (Already Included)

| Category | Count | Files |
| --- | --- | --- |
| Awards | 5 | `images/awards/awards-1.webp` → `awards-5.webp` |
| Universal | 2 | `images/universal/logo.webp`, `images/universal/size-chart-hero.webp` |

## Placeholder Mapping (Defaults in product.config)

- Product: `PRODUCT_IMAGE_1..6` → `images/product/product-01.webp` → `product-06.webp`
- Features: `FEATURE_IMAGE_1..3` → `testimonial-01.webp` → `testimonial-03.webp`
- Secrets: `SECRET_IMAGE_1..3` → `testimonial-04.webp` → `testimonial-06.webp`
- Testimonials: `TESTIMONIAL_1_IMAGE..12` → `testimonial-07.webp` → `testimonial-18.webp`
- Supporting: `CUSTOM_SECTION_IMAGE_1..2`, `SLIDESHOW_IMAGE_1..2`, `MULTIROW_2_IMAGE` → `testimonial-19.webp` → `testimonial-23.webp`
- Comparison: `COMPARISON_IMAGE` → `images/comparison/comparison-01.webp`
- Order bump: `ORDER_BUMP_IMAGE` → `images/order-bump/order-bump-01.webp`
- Founder: `FOUNDER_IMAGE` → `images/founder/founder-01.webp`
- Awards: `AWARD_IMAGE_1..5` → `images/awards/awards-1.webp` → `awards-5.webp`
- Universal: `LOGO_URL`, `FAVICON_IMAGE` → `images/universal/logo.webp`; `SIZE_CHART_IMAGE` → `images/universal/size-chart-hero.webp`

## Validation

Run:

```bash
./sort-images.sh images-generated
bash tests/validate-images.sh
```

## Rules

- All images must be WebP (`.webp`).
- Naming is hardcoded — template expects exact filenames.
- Founder can be temporarily set by duplicating `awards-1.webp`.
