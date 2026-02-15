# Image Mapping Guide (Aligned)

**Source of truth:** `IMAGE-MAPPING.json` and `IMAGE-MAPPING.md`.

=============================================================================
GLM 4.7 QUICK REFERENCE
=============================================================================
Total Images Required: 41 (34 unique)
- Generated: 33 (product, testimonials, comparison, order-bump)
- Static: 8 (awards: 5, universal: 2, founder: 1)

Testimonial Images: 25 (ALL must be mapped - NO spares)
=============================================================================

## Required Images Overview

| Folder | Files Needed | Purpose |
| --- | --- | --- |
| `images/product/` | 6 images | Hero carousel and product visuals |
| `images/testimonials/` | 25 images | Features, secrets, testimonials, supporting sections |
| `images/comparison/` | 1 image | Combined before/after graphic |
| `images/founder/` | 1 image | Founder story section (static) |
| `images/order-bump/` | 1 image | Order bump offer |
| `images/awards/` | 5 images | Awards carousel (static) |
| `images/universal/` | 2 images | Logo + size chart (static) |

## Naming Convention

- Product: `product-01.webp` through `product-06.webp`
- Testimonials: `testimonial-01.webp` through `testimonial-25.webp`
- Comparison: `comparison-01.webp`
- Order bump: `order-bump-01.webp`
- Founder: `founder-01.webp`
- Awards: `awards-1.webp` through `awards-5.webp`
- Universal: `logo.webp`, `size-chart-hero.webp`

## Testimonial Allocation (ALL 25 MUST BE USED - NO SPARES)

| Range | Variable Names | Count |
| --- | --- | --- |
| 01-03 | `FEATURE_IMAGE_1`, `FEATURE_IMAGE_2`, `FEATURE_IMAGE_3` | 3 |
| 04-06 | `SECRET_IMAGE_1`, `SECRET_IMAGE_2`, `SECRET_IMAGE_3` | 3 |
| 07-18 | `TESTIMONIAL_1_IMAGE` through `TESTIMONIAL_12_IMAGE` | 12 |
| 19-20 | `CUSTOM_SECTION_IMAGE_1`, `CUSTOM_SECTION_IMAGE_2` | 2 |
| 21-22 | `SLIDESHOW_IMAGE_1`, `SLIDESHOW_IMAGE_2` | 2 |
| 23 | `MULTIROW_2_IMAGE` | 1 |
| 24 | `CTA_BANNER_IMAGE` | 1 |
| 25 | `FAQ_IMAGE` | 1 |
| **TOTAL** | | **25** |

## Founder + Awards Rule

- Awards are universal assets (pre-populated).
- Founder image currently **duplicates** `awards-1.webp` to avoid a missing placeholder.

## Sorting Helper

Use `./sort-images.sh images-generated` to place images deterministically.

## Validation Commands

### Verify all 25 testimonial images are mapped in product.config:
```bash
# Run from template root directory
for i in $(seq -w 1 25); do
  if ! grep -q "testimonial-$i" product.config; then
    echo "MISSING: testimonial-$i"
  fi
done
# Expected output: EMPTY (no missing images)
```

### Verify all image files exist:
```bash
# Check product images (6 required)
for i in $(seq -w 1 6); do
  [ -f "images/product/product-$i.webp" ] || echo "MISSING: product-$i.webp"
done

# Check testimonial images (25 required)
for i in $(seq -w 1 25); do
  [ -f "images/testimonials/testimonial-$i.webp" ] || echo "MISSING: testimonial-$i.webp"
done

# Check other images
[ -f "images/comparison/comparison-01.webp" ] || echo "MISSING: comparison-01.webp"
[ -f "images/order-bump/order-bump-01.webp" ] || echo "MISSING: order-bump-01.webp"
[ -f "images/founder/founder-01.webp" ] || echo "MISSING: founder-01.webp"
```

### Quick count verification:
```bash
echo "Product: $(ls images/product/*.webp 2>/dev/null | wc -l) (expected: 6)"
echo "Testimonials: $(ls images/testimonials/*.webp 2>/dev/null | wc -l) (expected: 25)"
echo "Awards: $(ls images/awards/*.webp 2>/dev/null | wc -l) (expected: 5)"
```

## Updated

2026-02-14 - Added GLM 4.7 quick reference and validation commands.
