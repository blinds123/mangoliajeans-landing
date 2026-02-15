# Template Map — AI-Readable Reference

## 1. Section Files Reference

| #   | File                                  | Purpose                                                                        | Framework                     | Key Placeholders                                                                                                                                                                    | Image References                                                                                                                                    |
| --- | ------------------------------------- | ------------------------------------------------------------------------------ | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `sections/01-head.html`               | Meta/SEO setup (title, OG tags, preloads, CSS)                                 | —                             | `{{PRODUCT_NAME}}`, `{{META_DESCRIPTION}}`, `{{OG_IMAGE}}`                                                                                                                          | None                                                                                                                                                |
| 2   | `sections/02-body-start.html`         | Body tag start                                                                 | —                             | —                                                                                                                                                                                   | None                                                                                                                                                |
| 3   | `sections/03-header.html`             | Navigation + announcement bar                                                  | —                             | `{{PRODUCT_NAME}}`, `{{ANNOUNCEMENT_TEXT}}`, `{{OVERLAY_PROMO_TEXT}}`                                                                                                               | `universal/logo.webp`                                                                                                                               |
| 4   | `sections/04-cart-drawer.html`        | Cart drawer overlay                                                            | —                             | `{{PRODUCT_NAME}}`, `{{SINGLE_PRICE}}`, `{{BUNDLE_PRICE}}`                                                                                                                          | Product images                                                                                                                                      |
| 5   | `sections/05-main-product.html`       | Hero product section (gallery, pricing, bundles, rotating reviews, order bump) | —                             | `{{PRODUCT_NAME}}`, `{{SINGLE_PRICE}}`, `{{BUNDLE_PRICE}}`, `{{ORDER_BUMP_PRICE}}`, `{{BUNDLE_BADGE_TEXT}}`, `{{ORDER_BUMP_CTA_TEXT}}`, `{{PRODUCT_SUBTITLE}}`, `{{HERO_HEADLINE}}` | `product/product-01.webp` to `product/product-06.webp`, `order-bump/order-bump-01.webp` |
| 6   | `sections/06-comparison.html`         | Before/after comparison                                                        | —                             | `{{COMPARISON_HEADLINE}}`                                                                                                                                                           | `comparison/comparison-01.webp`                                                                                                                     |
| 7   | `sections/07-bridge-headline.html`    | Bridge headline transition                                                     | Epiphany Bridge               | `{{BRIDGE_HEADLINE}}`, `{{BRIDGE_SUBHEADLINE}}`                                                                                                                                     | None                                                                                                                                                |
| 8   | `sections/08-features-3-fibs.html`    | 3 features section                                                             | FIBS (False Internal Beliefs) | `{{FEATURE_1_TITLE}}`, `{{FEATURE_2_TITLE}}`, `{{FEATURE_3_TITLE}}`, `{{FEATURE_1_BODY}}`, `{{FEATURE_2_BODY}}`, `{{FEATURE_3_BODY}}`                                               | `testimonials/testimonial-01.webp` to `testimonials/testimonial-03.webp`                                                                            |
| 9   | `sections/08b-interstitial-1.html`    | Interstitial testimonial                                                       | —                             | `{{INTERSTITIAL_1_QUOTE}}`, `{{INTERSTITIAL_1_NAME}}`                                                                                                                               | None                                                                                                                                                |
| 10  | `sections/08b-testimonial-strip.html` | Testimonial image strip                                                        | —                             | —                                                                                                                                                                                   | Testimonial images                                                                                                                                  |
| 11  | `sections/09-founder-story.html`      | Founder epiphany bridge story                                                  | Epiphany Bridge               | `{{FOUNDER_NAME}}`, `{{FOUNDER_STORY}}`                                                                                                                                             | `founder/founder-01.webp`                                                                                                                           |
| 12  | `sections/09b-interstitial-2.html`    | Interstitial testimonial 2                                                     | —                             | `{{INTERSTITIAL_2_QUOTE}}`, `{{INTERSTITIAL_2_NAME}}`                                                                                                                               | None                                                                                                                                                |
| 13  | `sections/10-secret-1.html`           | Secret / false belief 1                                                        | Secret Formula                | `{{SECRET_1_TITLE}}`, `{{SECRET_1_BODY}}`                                                                                                                                           | `testimonials/testimonial-04.webp`                                                                                                                  |
| 14  | `sections/11-secret-2.html`           | Secret / false belief 2                                                        | Secret Formula                | `{{SECRET_2_TITLE}}`, `{{SECRET_2_BODY}}`                                                                                                                                           | `testimonials/testimonial-05.webp`                                                                                                                  |
| 15  | `sections/12-secret-3.html`           | Secret / false belief 3                                                        | Secret Formula                | `{{SECRET_3_TITLE}}`, `{{SECRET_3_BODY}}`                                                                                                                                           | `testimonials/testimonial-06.webp`                                                                                                                  |
| 16  | `sections/13-awards-carousel.html`    | Awards carousel                                                                | —                             | `{{AWARDS_SECTION_TITLE}}`, `{{AWARD_1_TITLE}}`, `{{AWARD_1_BODY}}`, `{{AWARD_2_TITLE}}`, `{{AWARD_2_BODY}}`, `{{AWARD_3_TITLE}}`, `{{AWARD_3_BODY}}`, `{{AWARD_4_TITLE}}`, `{{AWARD_4_BODY}}`, `{{AWARD_5_TITLE}}`, `{{AWARD_5_BODY}}` | `awards/awards-1.webp` to `awards-5.webp`                                                                                                           |
| 17  | `sections/14-faq.html`                | FAQ section                                                                    | —                             | `{{FAQ_1_Q}}`, `{{FAQ_1_A}}`, etc.                                                                                                                                                  | None                                                                                                                                                |
| 18  | `sections/15-custom-reviews.html`     | Custom review cards                                                            | —                             | Review content placeholders                                                                                                                                                         | `testimonials/testimonial-07.webp` to `testimonials/testimonial-25.webp`                                                                            |
| 19  | `sections/15a-slideshow.html`         | Slideshow 1                                                                    | —                             | —                                                                                                                                                                                   | Slideshow images                                                                                                                                    |
| 20  | `sections/15b-custom-html.html`       | Custom HTML block                                                              | —                             | —                                                                                                                                                                                   | —                                                                                                                                                   |
| 21  | `sections/16-slideshow-2.html`        | Slideshow 2                                                                    | —                             | —                                                                                                                                                                                   | Slideshow images                                                                                                                                    |
| 22  | `sections/18-testimonials.html`       | Testimonials grid                                                              | —                             | Testimonial content placeholders                                                                                                                                                    | Testimonial images                                                                                                                                  |
| 23  | `sections/19-multirow-2.html`         | Multirow feature cards                                                         | —                             | Feature card placeholders                                                                                                                                                           | —                                                                                                                                                   |
| 24  | `sections/20-cta-banner.html`         | CTA banner                                                                     | —                             | `{{CTA_HEADLINE}}`, `{{PRODUCT_NAME}}`                                                                                                                                              | None                                                                                                                                                |
| 25  | `sections/21-pre-footer.html`         | Pre-footer guarantee                                                           | —                             | `{{GUARANTEE_TEXT}}`                                                                                                                                                                | None                                                                                                                                                |
| 26  | `sections/22-footer.html`             | Footer                                                                         | —                             | `{{PRODUCT_NAME}}`, `{{BRAND_NAME}}`                                                                                                                                                | `universal/logo.webp`                                                                                                                               |
| 27  | `sections/23-scripts.html`            | Scripts (JS bundles, analytics)                                                | —                             | —                                                                                                                                                                                   | None                                                                                                                                                |

> **Note:** `17-logos.html` is EXCLUDED from the build (press logos removed).

---

## 2. Image Directory Structure

```
images/
├── product/
│   ├── product-01.webp    (hero carousel image 1)
│   ├── product-02.webp    (hero carousel image 2)
│   ├── product-03.webp    (hero carousel image 3)
│   ├── product-04.webp    (hero carousel image 4)
│   ├── product-05.webp    (hero carousel image 5)
│   └── product-06.webp    (hero carousel image 6)
├── testimonials/
│   ├── testimonial-01.webp to testimonial-03.webp   (features section images)
│   ├── testimonial-04.webp to testimonial-06.webp   (secrets section images)
│   └── testimonial-07.webp to testimonial-25.webp   (testimonials + supporting sections)
├── comparison/
│   └── comparison-01.webp   (single comparison image, matches fullautopink generator)
├── founder/
│   └── founder-01.webp
├── order-bump/
│   └── order-bump-01.webp
├── awards/
│   └── awards-1.webp to awards-5.webp
└── universal/
    ├── logo.webp
    └── size-chart-hero.webp
```

---

## 3. Variable Flow

```
copy_final.json
      │
      ▼
product.config        ← flat key=value pairs extracted from JSON
      │
      ▼
build.sh              ← reads product.config, calls replace_var()
      │                   sed replaces every {{KEY}} with VALUE
      ▼
index.html            ← final assembled page (all sections concatenated)
```

**Flow detail:**

1. `copy_final.json` holds all copywriting and configuration data.
2. `product.config` is a flat `KEY=VALUE` file derived from the JSON.
3. `build.sh` sources `product.config`, concatenates all section files (in order, excluding `17-logos.html`), and runs `replace_var` (sed-based) to substitute every `{{PLACEHOLDER}}` with its corresponding value.
4. Output is a single `index.html` ready for deployment.

---

## 4. Pricing (Placeholders)

| Variable           | Value  |
| ------------------ | ------ |
| `SINGLE_PRICE`     | `{{SINGLE_PRICE}}`     |
| `BUNDLE_PRICE`     | `{{BUNDLE_PRICE}}`     |
| `ORDER_BUMP_PRICE` | `{{ORDER_BUMP_PRICE}}` |
| `BRAND_NAME`       | `{{BRAND_NAME}}`       |

---

## 5. Key Notes

- **`17-logos.html` excluded from build** — press logos section has been removed from the template.
- **Comparison images standardized** — uses `comparison-01.webp` (single file), matching the fullautopink generator naming convention.
- **Deterministic image mapping** — `IMAGE-MAPPING.json` + `sort-images.sh` define slot naming and placement; defaults are set in `product.config`.
- **Full placeholder index** — `PLACEHOLDER-MAP.md` lists every `{{PLACEHOLDER}}` and the section(s) where it appears.
- **Founder image** — currently duplicates `awards-1.webp` until a real founder photo is provided.
- **Unused folders** — `images/bundle/`, `images/single/`, and `images/selectors/` are not referenced in the current build.
- **New variables added to template:**
  - `BUNDLE_BADGE_TEXT` — text displayed on the bundle selection badge
  - `ORDER_BUMP_CTA_TEXT` — call-to-action text on the order bump checkbox
  - `OVERLAY_PROMO_TEXT` — promotional text in the header overlay/announcement
