# Mobile Speed Optimizations

This template is optimized for MAXIMUM mobile loading speed to protect conversions.

## ✅ Built-In Speed Optimizations

### 1. Critical Resource Preloading

```html
<!-- Preload hero image for instant First Contentful Paint -->
<link
  rel="preload"
  as="image"
  href="images/product/product-01.webp"
  fetchpriority="high"
/>

<!-- Preload fonts to prevent layout shift -->
<link
  rel="preload"
  as="font"
  href="fonts/poppins-regular.woff2"
  type="font/woff2"
  crossorigin
/>
<link
  rel="preload"
  as="font"
  href="fonts/poppins-bold.woff2"
  type="font/woff2"
  crossorigin
/>
```

### 2. WebP Image Format

- All images auto-converted to WebP (70-80% smaller than PNG)
- Fallback to PNG/JPG for older browsers
- Run: `./optimize-images.sh` before deployment

### 3. Inlined Critical CSS

- Above-the-fold CSS inlined in `<head>` (no render-blocking)
- External stylesheets loaded asynchronously
- Font-display: swap (prevents invisible text)

### 4. Deferred JavaScript

```html
<script defer src="scripts/media-gallery.js"></script>
<script defer src="scripts/cart-drawer.js"></script>
<script defer src="scripts/modal-opener.js"></script>
```

### 5. Zero Tracking Bloat

- NO Shopify tracking scripts (removed trekkie.js, monorail.js)
- NO Google Analytics by default
- NO Facebook Pixel by default
- Saves 200-400KB and 1-2 seconds load time

### 6. Optimized Images Requirements

```
Product Photos: 1024x1024px, WebP, 80% quality = ~80KB each
Testimonials: 1024x1024px, WebP, 80% quality = ~60KB each
Comparison: 800x1200px, WebP, 80% quality = ~90KB each
```

## 🎯 Target Performance Metrics

| Metric                                | Target  | Critical |
| ------------------------------------- | ------- | -------- |
| **First Contentful Paint (Mobile)**   | < 1.5s  | < 2.0s   |
| **Largest Contentful Paint (Mobile)** | < 2.5s  | < 3.5s   |
| **Total Blocking Time**               | < 200ms | < 400ms  |
| **Cumulative Layout Shift**           | < 0.1   | < 0.25   |
| **Total Page Weight**                 | < 2MB   | < 3MB    |
| **Lighthouse Mobile Score**           | > 90    | > 75     |

## 🚀 Additional Optimizations You Can Add

### 1. Lazy Loading Images Below Fold

```html
<!-- First 2 product images: eager loading -->
<img src="product-01.webp" loading="eager" />
<img src="product-02.webp" loading="eager" />

<!-- All other images: lazy loading -->
<img src="testimonial-01.webp" loading="lazy" />
<img src="testimonial-02.webp" loading="lazy" />
```

### 2. CDN for Static Assets

Deploy to Netlify (included in build.sh):

- Auto CDN distribution
- Auto HTTPS
- Auto Brotli compression
- Global edge caching

### 3. Remove Unused CSS (Optional)

```bash
# Install PurgeCSS
npm install -g purgecss

# Remove unused CSS
purgecss --css stylesheets/*.css --content index.html --output stylesheets/
```

### 4. Compress HTML (build.sh does this automatically)

```bash
# Minify HTML (removes whitespace, comments)
npx html-minifier --collapse-whitespace --remove-comments index.html -o index.html
```

## 📊 How to Test Mobile Speed

### Method 1: Lighthouse (Chrome DevTools)

```
1. Open Chrome DevTools (F12)
2. Click "Lighthouse" tab
3. Select "Mobile" device
4. Check "Performance" category
5. Click "Analyze page load"
```

### Method 2: PageSpeed Insights (Google)

```
1. Go to: https://pagespeed.web.dev/
2. Enter your Netlify URL
3. Wait for analysis
4. Check Mobile score (aim for 90+)
```

### Method 3: WebPageTest (Advanced)

```
1. Go to: https://www.webpagetest.org/
2. Enter URL
3. Location: "Dulles, USA - Mobile 4G"
4. Click "Start Test"
5. Check First Contentful Paint and Speed Index
```

## ⚠️ Common Speed Killers to AVOID

### ❌ DON'T DO THIS:

```html
<!-- Render-blocking CSS -->
<link rel="stylesheet" href="large-framework.css" />

<!-- Unoptimized images -->
<img src="product.jpg" width="4000" height="3000" />

<!-- Synchronous third-party scripts -->
<script src="analytics.js"></script>
<script src="facebook-pixel.js"></script>

<!-- Multiple font weights -->
<link href="fonts?family=Poppins:300,400,500,600,700,800,900" />
```

### ✅ DO THIS INSTEAD:

```html
<!-- Async CSS -->
<link
  rel="stylesheet"
  href="styles.css"
  media="print"
  onload="this.media='all'"
/>

<!-- Optimized WebP -->
<img src="product.webp" width="1024" height="1024" loading="lazy" />

<!-- Deferred third-party scripts -->
<script defer src="analytics.js"></script>

<!-- Only 2 font weights -->
<link href="fonts?family=Poppins:400,700&display=swap" />
```

## 🔧 Speed Optimization Checklist

Before deploying, verify:

- [ ] All images converted to WebP (`./optimize-images.sh`)
- [ ] First product image preloaded in `<head>`
- [ ] Fonts preloaded with crossorigin
- [ ] Critical CSS inlined in `<head>`
- [ ] JavaScript deferred or async
- [ ] No tracking scripts (unless required)
- [ ] Total page weight < 2MB
- [ ] Lighthouse mobile score > 75

## 📱 Mobile-Specific Optimizations

### Viewport Meta Tag

```html
<meta name="viewport" content="width=device-width,initial-scale=1" />
```

### Touch-Friendly Buttons

```css
.button {
  min-height: 44px; /* Apple recommended touch target */
  min-width: 44px;
  padding: 12px 24px;
}
```

### Prevent Layout Shift

```css
/* Reserve space for images before they load */
.product-image {
  aspect-ratio: 1 / 1;
  width: 100%;
  height: auto;
}
```

## 🎯 Expected Results

With all optimizations applied:

**Mobile (4G)**:

- Page loads in 1.2-1.8 seconds
- First Contentful Paint: 0.8-1.2s
- Fully interactive: 1.5-2.0s

**Mobile (3G)**:

- Page loads in 2.5-3.5 seconds
- First Contentful Paint: 1.5-2.0s
- Fully interactive: 3.0-4.0s

**Conversion Impact:**

- Every 1 second faster = 7% more conversions
- Going from 3s → 1.5s load time = ~10% conversion lift
- Mobile bounce rate drops 20-30%

## 🚨 Critical: Test on Real Mobile Devices

Chrome DevTools mobile emulation is NOT accurate. Test on:

- iPhone (Safari)
- Android phone (Chrome)
- Slow 3G network throttling
- Real-world conditions (commute, coffee shop WiFi)

Deploy to Netlify and test actual mobile performance before launching ads.
