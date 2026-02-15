---
name: antigravity-template-reset
description: Resets template for new product build. Clears stale content, validates placeholders, prevents product contamination. MUST run before Phase 1.
activation:
  - /template-reset
  - reset template
  - clear previous product
  - start fresh build
---

# ANTIGRAVITY TEMPLATE RESET

This skill prevents **stale product contamination** - when previous product content (names, URLs, copy) carries over into new builds.

## THE PROBLEM

When reusing a template:

1. `product.config` has previous product's name, URLs, copy
2. Build runs and injects OLD content into new product page
3. Auditor only checks for `{{PLACEHOLDER}}` - not for wrong product names
4. Wrong product goes live

## WHEN TO USE

**MANDATORY** before starting ANY new product build:

- Before Phase 1 (Initialize)
- When duplicating template for new product
- When template has been used for a different product

---

## RESET PROCEDURE

### Step 1: Backup Current Config

```bash
cp product.config product.config.backup-$(date +%Y%m%d)
```

### Step 2: Identify Stale Content

Check product.config for previous product references:

```bash
# Extract current product name
CURRENT_PRODUCT=$(grep "^PRODUCT_NAME=" product.config | cut -d'"' -f2)
CURRENT_BRAND=$(grep "^BRAND_NAME=" product.config | cut -d'"' -f2)

echo "Current product: $CURRENT_PRODUCT"
echo "Current brand: $CURRENT_BRAND"

# Count all references
grep -c "$CURRENT_PRODUCT\|$CURRENT_BRAND" product.config
```

### Step 3: Create Clean Template Config

Replace `product.config` with placeholder version:

```bash
# Core identity - MUST be updated for each product
PRODUCT_NAME="{{PRODUCT_NAME}}"
BRAND_NAME="{{BRAND_NAME}}"
PRODUCT_HANDLE="{{PRODUCT_HANDLE}}"
SUBDOMAIN="{{SUBDOMAIN}}"
SITE_URL="{{SITE_URL}}"

# Pricing
SINGLE_PRICE="{{SINGLE_PRICE}}"
BUNDLE_PRICE="{{BUNDLE_PRICE}}"

# Headlines - MUST come from strategy research
HEADLINE_HOOK="{{HEADLINE_HOOK}}"
TAGLINE="{{TAGLINE}}"

# Copy blocks - MUST come from copywriting phase
FEATURE_PARAGRAPH_1="{{FEATURE_PARAGRAPH_1}}"
FEATURE_PARAGRAPH_2="{{FEATURE_PARAGRAPH_2}}"
FEATURE_PARAGRAPH_3="{{FEATURE_PARAGRAPH_3}}"

# ... (all other variables)
```

### Step 4: Validate Reset Complete

```bash
# Should return high count (all placeholders)
grep -c '{{' product.config

# Should return 0 (no old product names)
grep -c "jeans\|Jeans\|lamp\|Lamp\|[previous product]" product.config
```

---

## STALE CONTENT DETECTION

Add this check to the auditor (brunson-auditor):

```bash
#!/bin/bash
# tests/validate-no-stale-content.sh

# Known stale patterns from previous builds
STALE_PATTERNS=(
  "Low Brand"
  "Super Low Kick"
  "lowbrandjeans"
  "jeans"
  "denim"
  # Add more as products are built
)

ERRORS=0

for pattern in "${STALE_PATTERNS[@]}"; do
  COUNT=$(grep -ci "$pattern" index.html 2>/dev/null || echo 0)
  if [ "$COUNT" -gt 0 ]; then
    echo "ERROR: Found stale content '$pattern' ($COUNT occurrences)"
    ERRORS=$((ERRORS + COUNT))
  fi
done

if [ "$ERRORS" -gt 0 ]; then
  echo "STALE_CONTENT_CHECK: FAILED ($ERRORS stale references found)"
  exit 1
else
  echo "STALE_CONTENT_CHECK: PASSED"
  exit 0
fi
```

---

## PRODUCT-SPECIFIC VALIDATION

For each new product, add validation that correct product appears:

```bash
#!/bin/bash
# tests/validate-correct-product.sh

EXPECTED_PRODUCT="$1"  # Pass expected product name

if [ -z "$EXPECTED_PRODUCT" ]; then
  echo "Usage: validate-correct-product.sh 'Product Name'"
  exit 1
fi

# Check product name appears in key locations
LOCATIONS=(
  "index.html"
  "product.config"
)

for file in "${LOCATIONS[@]}"; do
  if ! grep -q "$EXPECTED_PRODUCT" "$file"; then
    echo "ERROR: '$EXPECTED_PRODUCT' not found in $file"
    exit 1
  fi
done

echo "CORRECT_PRODUCT_CHECK: PASSED"
exit 0
```

---

## OUTPUT REQUIREMENT

Create `template_reset_report.md`:

```markdown
# Template Reset Report

**Date:** [Date]
**Previous Product:** [Name from backup]
**New Product:** [Target product name]

## Reset Actions

- [ ] Backed up product.config to product.config.backup-YYYYMMDD
- [ ] Replaced all product-specific values with {{PLACEHOLDER}}
- [ ] Verified 0 stale product references remain
- [ ] Cleared context/ directory of old research files

## Stale Content Check

| Pattern                 | Before Reset  | After Reset |
| ----------------------- | ------------- | ----------- |
| [Previous Product Name] | X occurrences | 0           |
| [Previous Brand]        | X occurrences | 0           |
| [Previous URL]          | X occurrences | 0           |

## TEMPLATE_RESET: COMPLETE
```

---

## INTEGRATION

Add to beginning of brunson-prd.md:

```markdown
## Phase 0: Template Reset (MANDATORY)

- [ ] **0-reset:** READ `.agent/skills/antigravity-template-reset/SKILL.md`.
      Backup current config. Clear all product-specific content.
      Replace with placeholders. Verify 0 stale references.
      OUTPUT `template_reset_report.md`.
```

This phase MUST complete before Phase 1 (Initialize).
