# Image Mapping - 34 Generated + Static Universal Assets

**Source of truth:** `IMAGE-MAPPING.json` (used by `scripts/image-sorter.py`).

=============================================================================
GLM 4.7 QUICK REFERENCE
=============================================================================
Total Images Required: 41 (34 unique)
- Generated: 33 (product, testimonials, comparison, order-bump)
- Static: 8 (awards: 5, universal: 2, founder: 1)

Testimonial Images: 25 (ALL must be mapped - NO spares)
- 24 = CTA_BANNER_IMAGE (NOT a product image!)
- 25 = FAQ_IMAGE (NOT a product image!)
=============================================================================

## Summary

| Category | Count | Generated | Folder |
| --- | --- | --- | --- |
| Product | 6 | Yes | `images/product/` |
| Testimonials | 25 | Yes | `images/testimonials/` |
| Comparison | 1 | Yes | `images/comparison/` |
| Order Bump | 1 | Yes | `images/order-bump/` |
| Founder | 1 | No (static) | `images/founder/` |
| Awards | 5 | No (static) | `images/awards/` |
| Universal (logo + size chart) | 2 | No (static) | `images/universal/` |

**Total required:** 41 images (34 unique, 33 generated + 1 founder static)

**Static assets:** awards + logo + size chart are already in the template.

## Required Directory Structure

```
images/
├── product/        (product-01.webp ... product-06.webp)
├── testimonials/   (testimonial-01.webp ... testimonial-25.webp)
├── comparison/     (comparison-01.webp)
├── order-bump/     (order-bump-01.webp)
├── founder/        (founder-01.webp)
├── awards/         (awards-1.webp ... awards-5.webp)
└── universal/      (logo.webp, size-chart-hero.webp)
```

## Testimonial Pool Mapping (25 Images - ALL USED)

| Range | Use | Placeholders |
| --- | --- | --- |
| 01-03 | Feature images | `FEATURE_IMAGE_1`, `FEATURE_IMAGE_2`, `FEATURE_IMAGE_3` |
| 04-06 | Secret images | `SECRET_IMAGE_1`, `SECRET_IMAGE_2`, `SECRET_IMAGE_3` |
| 07-18 | Main testimonials (12) | `TESTIMONIAL_1_IMAGE` through `TESTIMONIAL_12_IMAGE` |
| 19-20 | Custom section images | `CUSTOM_SECTION_IMAGE_1`, `CUSTOM_SECTION_IMAGE_2` |
| 21-22 | Slideshow images | `SLIDESHOW_IMAGE_1`, `SLIDESHOW_IMAGE_2` |
| 23 | Multirow image | `MULTIROW_2_IMAGE` |
| 24 | CTA Banner | `CTA_BANNER_IMAGE` (uses testimonial-24.webp) |
| 25 | FAQ Section | `FAQ_IMAGE` (uses testimonial-25.webp) |

**IMPORTANT:** Images 24 and 25 are NOT spares - they are used for CTA Banner and FAQ sections!

## Placeholder - Default Image Paths

These defaults are already set in `product.config`:

### Product Images (6)
- `PRODUCT_IMAGE_1` through `PRODUCT_IMAGE_6` -> `images/product/product-01.webp` to `product-06.webp`
- `PRODUCT_IMAGE_6_CTA` -> `images/product/product-06.webp`

### Feature Images (3) - Uses testimonials 01-03
- `FEATURE_IMAGE_1` -> `images/testimonials/testimonial-01.webp`
- `FEATURE_IMAGE_2` -> `images/testimonials/testimonial-02.webp`
- `FEATURE_IMAGE_3` -> `images/testimonials/testimonial-03.webp`

### Secret Images (3) - Uses testimonials 04-06
- `SECRET_IMAGE_1` -> `images/testimonials/testimonial-04.webp`
- `SECRET_IMAGE_2` -> `images/testimonials/testimonial-05.webp`
- `SECRET_IMAGE_3` -> `images/testimonials/testimonial-06.webp`

### Main Testimonials (12) - Uses testimonials 07-18
- `TESTIMONIAL_1_IMAGE` through `TESTIMONIAL_12_IMAGE` -> `images/testimonials/testimonial-07.webp` to `testimonial-18.webp`

### Supporting Sections - Uses testimonials 19-25
- `CUSTOM_SECTION_IMAGE_1` -> `images/testimonials/testimonial-19.webp`
- `CUSTOM_SECTION_IMAGE_2` -> `images/testimonials/testimonial-20.webp`
- `SLIDESHOW_IMAGE_1` -> `images/testimonials/testimonial-21.webp`
- `SLIDESHOW_IMAGE_2` -> `images/testimonials/testimonial-22.webp`
- `MULTIROW_2_IMAGE` -> `images/testimonials/testimonial-23.webp`
- `CTA_BANNER_IMAGE` -> `images/testimonials/testimonial-24.webp`
- `FAQ_IMAGE` -> `images/testimonials/testimonial-25.webp`

### Other Images
- `COMPARISON_IMAGE` -> `images/comparison/comparison-01.webp`
- `ORDER_BUMP_IMAGE` -> `images/order-bump/order-bump-01.webp`
- `FOUNDER_IMAGE` -> `images/founder/founder-01.webp`
- `AWARD_IMAGE_1` through `AWARD_IMAGE_5` -> `images/awards/awards-1.webp` to `awards-5.webp`
- `LOGO_URL` + `FAVICON_IMAGE` -> `images/universal/logo.webp`
- `SIZE_CHART_IMAGE` -> `images/universal/size-chart-hero.webp`

## Whisk Prompt Order (Style Consistency)

1. `product-01` (style seed)
2. `product-02` through `product-06`
3. `testimonial-01` through `testimonial-25`
4. `comparison-01`
5. `order-bump-01`

**Founder image:** static. If no founder photo exists, duplicate `awards-1.webp` into `founder-01.webp`.
If you need an AI placeholder for founder, add an extra Whisk prompt and name it `founder-01`.

## Deterministic Sorting (Image Sorter)

1. Drop generated images in `images-generated/` (any filenames).
2. Prefix each filename with the slot id (e.g., `product-01-hero.webp`, `testimonial-07-jane.webp`).
3. Run:

```bash
./sort-images.sh images-generated
```

The sorter uses `IMAGE-MAPPING.json` and writes to the correct `images/*` folders.

## Workflow Compatibility Notes

- Some clawd workflows output `images/bump/bundle-01.webp` and `images/bump/single-01.webp`. This template does not use those files. Keep them as optional or ignore them unless you add matching placeholders.
- Comparison is **single combined image** (`comparison-01.webp`), not separate good/bad files.

## Updated

2026-02-14 - Fixed testimonial-24/25 mapping, added GLM 4.7 quick reference.
