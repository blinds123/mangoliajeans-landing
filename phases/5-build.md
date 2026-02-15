# Phase 5: Build & Deploy

Build the final HTML and deploy to Netlify.

---

## Input Required

- All 34 required images in `images/` folders
- Filled `product.config`
- Updated `sections/*.html`

---

## Step 1: Pre-Build Checklist

Verify before building:

```bash
# Check images exist
ls images/product/ | wc -l      # Should be 6
ls images/testimonials/ | wc -l # Should be 25
ls images/comparison/ | wc -l   # Should be 1
ls images/founder/ | wc -l      # Should be 1
ls images/order-bump/ | wc -l   # Should be 1
ls images/awards/ | wc -l       # Should be 5 (static)
ls images/universal/ | wc -l    # Should be 2 (static)

# Check config
source product.config
echo "Product: $PRODUCT_NAME"    # Should not be empty
echo "Price: $SINGLE_PRICE"      # Should not be empty
echo "Site ID: $NETLIFY_SITE_ID" # Should not be empty
```

---

## Step 2: Optimize Images

Convert all images to WebP for faster loading:

```bash
./optimize-images.sh
```

Or if cwebp is not installed, the build script will handle it.

---

## Step 3: Build

Run the build script:

```bash
./build.sh
```

### What the build script does:

1. ✅ Validates `product.config`
2. ✅ Checks for images
3. ✅ Converts images to WebP
4. ✅ Concatenates `sections/*.html` → `index.html`
5. ✅ Replaces `{{placeholders}}` with config values
6. ✅ Deploys to Netlify
7. ✅ Runs E2E tests

---

## Step 4: Verify Build Output

After build completes, check:

```bash
# No raw placeholders
grep -c "{{" index.html
# Should output: 0

# File size reasonable
du -h index.html
# Should be < 500KB

# Check for tracking bloat
grep -c "trekkie\|monorail\|TriplePixel" index.html
# Should output: 0
```

---

## Step 5: Test Live Site

If deployed, verify:

- [ ] Page loads on mobile (< 2 seconds)
- [ ] All images display correctly
- [ ] Product carousel works
- [ ] Bundle selector toggles
- [ ] Add to Cart button works
- [ ] Checkout redirects correctly
- [ ] No console errors

---

## Troubleshooting

### "Missing required fields"
→ Go back to Phase 3, fill all required fields in product.config

### "Missing images"
→ Go back to Phase 2, generate missing images

### "Raw placeholders visible"
→ The placeholder in sections/*.html doesn't match product.config variable name

### "Deployment failed"
→ Run `npx netlify login` first, then try again

### "Page loads slowly"
→ Run `./optimize-images.sh` to convert to WebP

---

## ✅ Phase Complete When:

- [ ] Build script completes without errors
- [ ] No raw `{{placeholders}}` in index.html
- [ ] Site deployed and accessible
- [ ] All E2E tests pass
- [ ] Page loads < 2 seconds on mobile

---

## 🎉 WORKFLOW COMPLETE

Your landing page is live!

Next steps:
1. Test checkout flow end-to-end
2. Set up analytics
3. Launch ads
