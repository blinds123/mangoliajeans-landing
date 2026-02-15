/**
 * playwright-visual-qa.js - Comprehensive Visual QA for Antpink Landing Pages
 *
 * Self-healing loop: runs checks → reports failures → agent fixes → re-runs until 100% pass.
 * Supports pre-deploy (file://), post-deploy (https://), desktop (1440px) and mobile (375px).
 *
 * Usage:
 *   npx playwright test tests/playwright-visual-qa.js
 *   node tests/playwright-visual-qa.js --url <url> --mode <pre-deploy|post-deploy>
 *
 * Outputs:
 *   qa-screenshots/   - Screenshots at each section (desktop + mobile)
 *   qa-report.json     - Machine-readable pass/fail report for agent consumption
 */

const { chromium } = require("playwright");
const fs = require("fs");
const path = require("path");

// Parse CLI args
const args = process.argv.slice(2);
const getArg = (name) => {
  const idx = args.indexOf(`--${name}`);
  return idx !== -1 ? args[idx + 1] : null;
};

const TARGET_URL =
  getArg("url") || "file://" + path.resolve(__dirname, "..", "index.html");
const MODE = getArg("mode") || "pre-deploy";
const SCREENSHOT_DIR = path.resolve(__dirname, "..", "qa-screenshots");
const REPORT_PATH = path.resolve(__dirname, "..", "qa-report.json");

// Ensure screenshot dir exists
if (!fs.existsSync(SCREENSHOT_DIR)) {
  fs.mkdirSync(SCREENSHOT_DIR, { recursive: true });
}

/**
 * Run all QA checks for a given viewport
 */
async function runChecks(page, viewport, label) {
  const results = [];
  const screenshotPrefix = `${label}-${viewport.width}x${viewport.height}`;

  const pass = (name, detail) =>
    results.push({ name, status: "PASS", detail, viewport: label });
  const fail = (name, detail, fix) =>
    results.push({ name, status: "FAIL", detail, fix, viewport: label });
  const warn = (name, detail) =>
    results.push({ name, status: "WARN", detail, viewport: label });

  // ─── CHECK 1: Page loads without errors ───
  const consoleErrors = [];
  const networkErrors = [];

  page.on("console", (msg) => {
    if (msg.type() === "error") consoleErrors.push(msg.text());
  });
  page.on("pageerror", (err) => consoleErrors.push(err.message));
  page.on("requestfailed", (req) => {
    networkErrors.push({
      url: req.url(),
      error: req.failure()?.errorText || "unknown",
    });
  });

  try {
    await page.goto(TARGET_URL, { waitUntil: "networkidle", timeout: 30000 });
    pass("page-load", "Page loaded successfully");
  } catch (e) {
    fail(
      "page-load",
      `Page failed to load: ${e.message}`,
      "Check URL is correct and server is running",
    );
    return results;
  }

  // Full page screenshot
  await page.screenshot({
    path: path.join(SCREENSHOT_DIR, `${screenshotPrefix}-full.png`),
    fullPage: true,
  });

  // ─── CHECK 2: No raw {{placeholder}} text ───
  const bodyText = await page.textContent("body");
  const placeholderMatches = bodyText.match(/\{\{[A-Z_]+\}\}/g) || [];
  if (placeholderMatches.length > 0) {
    const unique = [...new Set(placeholderMatches)];
    fail(
      "no-placeholders",
      `${placeholderMatches.length} raw placeholders found: ${unique.slice(0, 5).join(", ")}`,
      "Fill in missing values in product.config and rebuild with ./build.sh",
    );
  } else {
    pass("no-placeholders", "Zero raw placeholders");
  }

  // ─── CHECK 3: No JS console errors ───
  if (consoleErrors.length > 0) {
    fail(
      "no-console-errors",
      `${consoleErrors.length} JS errors: ${consoleErrors.slice(0, 3).join(" | ")}`,
      "Fix JavaScript errors in sections/23-scripts.html",
    );
  } else {
    pass("no-console-errors", "Zero JS console errors");
  }

  // ─── CHECK 4: No 404 network errors ───
  const img404s = networkErrors.filter((e) =>
    e.url.match(/\.(webp|png|jpg|jpeg|svg|gif)/i),
  );
  const other404s = networkErrors.filter(
    (e) => !e.url.match(/\.(webp|png|jpg|jpeg|svg|gif)/i),
  );

  if (img404s.length > 0) {
    fail(
      "no-image-404s",
      `${img404s.length} broken images: ${img404s
        .slice(0, 5)
        .map((e) => path.basename(e.url))
        .join(", ")}`,
      "Missing images in images/ directory. Check IMAGE-MAPPING.md for required files.",
    );
  } else {
    pass("no-image-404s", "All image requests succeeded");
  }

  if (other404s.length > 0) {
    warn(
      "no-other-404s",
      `${other404s.length} non-image 404s: ${other404s
        .slice(0, 3)
        .map((e) => e.url)
        .join(", ")}`,
    );
  }

  // ─── CHECK 5: All critical images visible ───
  const images = await page.$$eval('img[src*="images/"]', (imgs) =>
    imgs.map((img) => ({
      src: img.getAttribute("src"),
      visible: img.offsetWidth > 0 && img.offsetHeight > 0,
      naturalWidth: img.naturalWidth,
      broken: img.naturalWidth === 0,
    })),
  );

  const brokenImages = images.filter((i) => i.broken);
  if (brokenImages.length > 0) {
    fail(
      "images-not-broken",
      `${brokenImages.length} broken image(s): ${brokenImages
        .slice(0, 5)
        .map((i) => i.src)
        .join(", ")}`,
      "Replace missing images or check file paths in sections/*.html",
    );
  } else if (images.length === 0) {
    warn(
      "images-not-broken",
      'No images with src="images/" found - may be a template-only build',
    );
  } else {
    pass("images-not-broken", `${images.length} images loaded correctly`);
  }

  // ─── CHECK 6: Header visible ───
  const header = await page.$("#shopify-section-header, header, .header");
  if (header) {
    const headerBox = await header.boundingBox();
    if (headerBox && headerBox.height > 0) {
      pass(
        "header-visible",
        `Header height: ${Math.round(headerBox.height)}px`,
      );
      await header.screenshot({
        path: path.join(SCREENSHOT_DIR, `${screenshotPrefix}-header.png`),
      });
    } else {
      fail(
        "header-visible",
        "Header has zero height",
        "Check sections/03-header.html CSS",
      );
    }
  } else {
    warn("header-visible", "No header element found");
  }

  // ─── CHECK 7: Product section visible ───
  const productSection = await page.$(
    "#shopify-section-template--17453745111139__main, .product",
  );
  if (productSection) {
    const box = await productSection.boundingBox();
    if (box && box.height > 100) {
      pass(
        "product-section",
        `Product section height: ${Math.round(box.height)}px`,
      );
      await page.screenshot({
        path: path.join(SCREENSHOT_DIR, `${screenshotPrefix}-product.png`),
        clip: {
          x: box.x,
          y: box.y,
          width: box.width,
          height: Math.min(box.height, 2000),
        },
      });
    } else {
      fail(
        "product-section",
        "Product section too small or hidden",
        "Check sections/05-main-product.html",
      );
    }
  } else {
    fail(
      "product-section",
      "Product section not found",
      "Verify sections/05-main-product.html is included in build.sh",
    );
  }

  // ─── CHECK 8: CTA buttons exist and are clickable ───
  const ctaButtons = await page.$$(
    '[data-action="add-to-cart"], .product-form__submit, button:has-text("Add"), button:has-text("BUY"), .btn-add-to-cart',
  );
  if (ctaButtons.length > 0) {
    let clickable = 0;
    for (const btn of ctaButtons.slice(0, 3)) {
      try {
        const isVisible = await btn.isVisible();
        if (isVisible) clickable++;
      } catch (e) {
        /* skip */
      }
    }
    if (clickable > 0) {
      pass("cta-buttons", `${clickable} CTA button(s) visible and clickable`);
    } else {
      fail(
        "cta-buttons",
        "CTA buttons exist but none are visible",
        "Check CSS display/visibility on Add to Cart buttons",
      );
    }
  } else {
    fail(
      "cta-buttons",
      "No CTA buttons found",
      "Check sections/05-main-product.html for add-to-cart buttons",
    );
  }

  // ─── CHECK 9: FAQ accordion works ───
  const faqDetails = await page.$$("details, .faq-item, [data-accordion]");
  if (faqDetails.length >= 3) {
    try {
      const firstFaq = faqDetails[0];
      await firstFaq.click();
      await page.waitForTimeout(500);
      pass(
        "faq-accordion",
        `${faqDetails.length} FAQ items found, accordion clickable`,
      );
      await page.screenshot({
        path: path.join(SCREENSHOT_DIR, `${screenshotPrefix}-faq.png`),
      });
    } catch (e) {
      warn("faq-accordion", `FAQ items exist but click failed: ${e.message}`);
    }
  } else if (faqDetails.length > 0) {
    warn("faq-accordion", `Only ${faqDetails.length} FAQ items (expected 3+)`);
  } else {
    fail(
      "faq-accordion",
      "No FAQ accordion elements found",
      "Check sections/14-faq.html",
    );
  }

  // ─── CHECK 10: Bundle selector works ───
  const bundleCards = await page.$$(".bundle-card, [data-offer]");
  if (bundleCards.length >= 2) {
    try {
      await bundleCards[0].click();
      await page.waitForTimeout(300);
      pass(
        "bundle-selector",
        `${bundleCards.length} bundle options found, clickable`,
      );
    } catch (e) {
      warn("bundle-selector", "Bundle cards exist but click failed");
    }
  } else {
    warn(
      "bundle-selector",
      `Found ${bundleCards.length} bundle cards (expected 2+)`,
    );
  }

  // ─── CHECK 11: No horizontal overflow (mobile especially) ───
  const bodyWidth = await page.evaluate(() => document.body.scrollWidth);
  const viewportWidth = viewport.width;
  if (bodyWidth > viewportWidth + 5) {
    fail(
      "no-overflow",
      `Body width (${bodyWidth}px) exceeds viewport (${viewportWidth}px) by ${bodyWidth - viewportWidth}px`,
      "Check for elements with fixed widths or missing overflow:hidden in CSS",
    );
  } else {
    pass(
      "no-overflow",
      `No horizontal overflow (body: ${bodyWidth}px, viewport: ${viewportWidth}px)`,
    );
  }

  // ─── CHECK 12: Footer present ───
  const footer = await page.$("footer, .footer, #shopify-section-footer");
  if (footer) {
    const footerBox = await footer.boundingBox();
    if (footerBox && footerBox.height > 0) {
      pass("footer-present", "Footer visible");
      await footer.screenshot({
        path: path.join(SCREENSHOT_DIR, `${screenshotPrefix}-footer.png`),
      });
    } else {
      fail(
        "footer-present",
        "Footer has zero height",
        "Check sections/22-footer.html",
      );
    }
  } else {
    warn("footer-present", "No footer element found");
  }

  // ─── CHECK 13: Cart drawer opens ───
  const cartTrigger = await page.$(
    '[data-cart-toggle], .cart-icon, a[href="/cart"], .header__icon--cart',
  );
  if (cartTrigger) {
    try {
      await cartTrigger.click();
      await page.waitForTimeout(500);
      const cartDrawer = await page.$(
        ".cart-drawer, #cart-drawer, [data-cart-drawer]",
      );
      if (cartDrawer) {
        const isVisible = await cartDrawer.isVisible();
        if (isVisible) {
          pass("cart-drawer", "Cart drawer opens on click");
          await page.screenshot({
            path: path.join(
              SCREENSHOT_DIR,
              `${screenshotPrefix}-cart-open.png`,
            ),
          });
          // Close it
          const closeBtn = await page.$(
            ".cart-drawer__close, [data-cart-close], .drawer__close",
          );
          if (closeBtn) await closeBtn.click();
        } else {
          warn("cart-drawer", "Cart drawer exists but not visible after click");
        }
      } else {
        warn("cart-drawer", "Cart trigger clicked but no drawer element found");
      }
    } catch (e) {
      warn("cart-drawer", `Cart trigger click failed: ${e.message}`);
    }
  } else {
    warn("cart-drawer", "No cart trigger button found");
  }

  // ─── CHECK 14: Section-by-section screenshots ───
  const sections = [
    {
      id: "comparison",
      selector: '#comparison-section, .comparison-section, [id*="comparison"]',
    },
    {
      id: "features",
      selector:
        '#features-section, .features-section, [id*="features"], [id*="fibs"]',
    },
    {
      id: "founder",
      selector: '#founder-section, .founder-section, [id*="founder"]',
    },
    {
      id: "testimonials",
      selector: '#testimonials-section, .testimonials, [id*="testimonial"]',
    },
    {
      id: "awards",
      selector: '#awards-section, .awards-carousel, [id*="awards"]',
    },
  ];

  for (const section of sections) {
    const el = await page.$(section.selector);
    if (el) {
      try {
        const box = await el.boundingBox();
        if (box && box.height > 0) {
          await el.screenshot({
            path: path.join(
              SCREENSHOT_DIR,
              `${screenshotPrefix}-${section.id}.png`,
            ),
          });
        }
      } catch (e) {
        /* skip screenshot failures */
      }
    }
  }

  // ─── CHECK 15 (post-deploy only): Page performance ───
  if (MODE === "post-deploy") {
    const perfMetrics = await page.evaluate(() => {
      const nav = performance.getEntriesByType("navigation")[0];
      return {
        loadTime: nav ? Math.round(nav.loadEventEnd - nav.startTime) : null,
        domContentLoaded: nav
          ? Math.round(nav.domContentLoadedEventEnd - nav.startTime)
          : null,
      };
    });

    if (perfMetrics.loadTime) {
      if (perfMetrics.loadTime > 5000) {
        fail(
          "page-speed",
          `Page load: ${perfMetrics.loadTime}ms (>5s is too slow)`,
          "Optimize images, defer non-critical JS, enable compression",
        );
      } else if (perfMetrics.loadTime > 3000) {
        warn(
          "page-speed",
          `Page load: ${perfMetrics.loadTime}ms (borderline, target <3s)`,
        );
      } else {
        pass("page-speed", `Page load: ${perfMetrics.loadTime}ms`);
      }
    }

    // Check SSL
    if (TARGET_URL.startsWith("https://")) {
      pass("ssl-check", "HTTPS URL confirmed");
    } else {
      warn("ssl-check", "Not using HTTPS");
    }
  }

  return results;
}

/**
 * Main execution
 */
async function main() {
  console.log("");
  console.log("╔══════════════════════════════════════════════════════════╗");
  console.log("║  PLAYWRIGHT VISUAL QA - Antpink Landing Page            ║");
  console.log("╠══════════════════════════════════════════════════════════╣");
  console.log(`║  URL:  ${TARGET_URL.substring(0, 50).padEnd(50)}║`);
  console.log(`║  Mode: ${MODE.padEnd(50)}║`);
  console.log("╚══════════════════════════════════════════════════════════╝");
  console.log("");

  const browser = await chromium.launch({ headless: true });
  const allResults = [];

  // Desktop viewport
  console.log("━━━ Desktop (1440x900) ━━━");
  const desktopCtx = await browser.newContext({
    viewport: { width: 1440, height: 900 },
  });
  const desktopPage = await desktopCtx.newPage();
  const desktopResults = await runChecks(
    desktopPage,
    { width: 1440, height: 900 },
    "desktop",
  );
  allResults.push(...desktopResults);

  for (const r of desktopResults) {
    const icon = r.status === "PASS" ? "✅" : r.status === "FAIL" ? "❌" : "⚠️";
    console.log(`  ${icon} ${r.name}: ${r.detail}`);
    if (r.fix) console.log(`     FIX: ${r.fix}`);
  }
  await desktopCtx.close();

  // Mobile viewport
  console.log("");
  console.log("━━━ Mobile (375x812) ━━━");
  const mobileCtx = await browser.newContext({
    viewport: { width: 375, height: 812 },
    isMobile: true,
    hasTouch: true,
    userAgent:
      "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1",
  });
  const mobilePage = await mobileCtx.newPage();
  const mobileResults = await runChecks(
    mobilePage,
    { width: 375, height: 812 },
    "mobile",
  );
  allResults.push(...mobileResults);

  for (const r of mobileResults) {
    const icon = r.status === "PASS" ? "✅" : r.status === "FAIL" ? "❌" : "⚠️";
    console.log(`  ${icon} ${r.name}: ${r.detail}`);
    if (r.fix) console.log(`     FIX: ${r.fix}`);
  }
  await mobileCtx.close();

  await browser.close();

  // Summary
  const passes = allResults.filter((r) => r.status === "PASS").length;
  const fails = allResults.filter((r) => r.status === "FAIL").length;
  const warns = allResults.filter((r) => r.status === "WARN").length;
  const total = allResults.length;

  console.log("");
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  console.log(
    `  RESULTS: ${passes} passed, ${fails} failed, ${warns} warnings (${total} total)`,
  );
  console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

  // Write machine-readable report
  const report = {
    url: TARGET_URL,
    mode: MODE,
    timestamp: new Date().toISOString(),
    summary: { total, passes, fails, warns },
    passed: fails === 0,
    results: allResults,
    screenshots: fs
      .readdirSync(SCREENSHOT_DIR)
      .filter((f) => f.endsWith(".png")),
  };

  fs.writeFileSync(REPORT_PATH, JSON.stringify(report, null, 2));
  console.log(`\n  Report: ${REPORT_PATH}`);
  console.log(`  Screenshots: ${SCREENSHOT_DIR}/`);

  if (fails > 0) {
    console.log("");
    console.log("  ❌ QA FAILED - Fix issues above and re-run");
    console.log("");
    console.log("  FIXES NEEDED:");
    allResults
      .filter((r) => r.status === "FAIL")
      .forEach((r) => {
        console.log(`    [${r.viewport}] ${r.name}: ${r.fix}`);
      });
    process.exit(1);
  } else {
    console.log("");
    console.log("  ✅ QA PASSED - Ready for deployment");
    process.exit(0);
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
