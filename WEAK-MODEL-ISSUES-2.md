# WEAK MODEL ISSUES - PART 2: CHECKOUT & DISPLAY FIXES

> **FOR:** Haiku 3.5, Haiku 4.5, GLM 4.7, or any model that struggles with these issues
> **PURPOSE:** Fix checkout failures, double dollar signs, and other display issues
> **SITE ANALYZED:** https://example.netlify.app/
> **LAST UPDATED:** 2026-01-23

---

## ISSUES FOUND ON LIVE SITE

| #   | Issue                          | Severity | Status         |
| --- | ------------------------------ | -------- | -------------- |
| 1   | Add to Cart returns 500 error  | CRITICAL | Fix documented |
| 2   | Double dollar signs ($$29.00)  | HIGH     | Fix documented |
| 3   | Escaped quotes showing (4.5\") | MEDIUM   | Fix documented |
| 4   | SimpleSwap pool empty          | CRITICAL | Fix documented |
| 5   | Price tier mismatch            | HIGH     | Fix documented |

---

## ISSUE 1: ADD TO CART RETURNS 500 ERROR

### THE PROBLEM

When clicking "Add to Cart", console shows:

```
Checkout failed Error: No exchange URL returned
```

Network shows:

```
POST /.netlify/functions/buy-now → 500 Internal Server Error
```

### ROOT CAUSE

The `buy-now.js` Netlify function calls the SimpleSwap pool server at:

```
https://simpleswap-automation-1.onrender.com/buy-now
```

The server returns no exchange because:

1. The **$29 pool is empty** (0 of 15 exchanges available)
2. Pool needs manual replenishment

### HOW TO FIX

**Option A: Replenish the pool manually**

```bash
# Check pool status
curl https://simpleswap-automation-1.onrender.com/

# Initialize the $29 pool
curl -X POST https://simpleswap-automation-1.onrender.com/admin/init-pool \
  -H "Content-Type: application/json" \
  -d '{"pricePoint": 29}'

# Or add one exchange at a time
curl -X POST https://simpleswap-automation-1.onrender.com/admin/add-one \
  -H "Content-Type: application/json" \
  -d '{"pricePoint": 29}'
```

**Option B: Update buy-now.js to handle empty pool**

Open `netlify/functions/buy-now.js` and add fallback:

```javascript
// After line 30, add:
if (!data.exchangeUrl) {
  // Fallback: Try different price tier
  const fallbackTiers = [19, 59];
  for (const tier of fallbackTiers) {
    const fallbackResponse = await fetch(`${POOL_SERVER}/buy-now`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ amountUSD: tier }),
    });
    const fallbackData = await fallbackResponse.json();
    if (fallbackData.exchangeUrl) {
      return { statusCode: 200, headers, body: JSON.stringify(fallbackData) };
    }
  }
  throw new Error("All pools empty");
}
```

---

## ISSUE 2: DOUBLE DOLLAR SIGNS ($$29.00)

### THE PROBLEM

Prices display as:

- `$$29.00` instead of `$29.00`
- `$$19.00` instead of `$19.00`
- `$$10.00` instead of `$10.00`

### ROOT CAUSE

The template has BOTH a literal `$` AND a placeholder:

```html
<span class="price">${{SINGLE_PRICE}}</span>
```

If `product.config` has:

```bash
SINGLE_PRICE="$19"  # ❌ WRONG - includes dollar sign
```

Then build produces:

```html
<span class="price">$$19</span> # Double dollar!
```

### THE RULE

**NEVER include `$` in price config values.**

### WRONG (DO NOT USE)

```bash
SINGLE_PRICE="$19"       ❌ WRONG
BUNDLE_PRICE="$59"       ❌ WRONG
ORDER_BUMP_PRICE="$10"   ❌ WRONG
```

### RIGHT (USE THIS)

```bash
SINGLE_PRICE="19"        ✓ CORRECT
BUNDLE_PRICE="59"        ✓ CORRECT
ORDER_BUMP_PRICE="10"    ✓ CORRECT
```

### IF DOUBLE DOLLARS STILL APPEAR

Check these files for `${{`:

1. `sections/05-main-product.html` - lines 914, 922, 923, 946, 961, 1304
2. `product.config` - all PRICE variables

**Fix in template (if config must have $ sign):**

Change:

```html
<span class="price">${{SINGLE_PRICE}}</span>
```

To:

```html
<span class="price">{{SINGLE_PRICE}}</span>
```

Then ensure config has:

```bash
SINGLE_PRICE="$19"
```

---

## ISSUE 3: ESCAPED QUOTES SHOWING (4.5\")

### THE PROBLEM

Text displays as:

```
Compact 4.5\" Base - Big Personality
```

Instead of:

```
Compact 4.5" Base - Big Personality
```

### ROOT CAUSE

Improper quote escaping in product.config or copy variables.

### THE RULE

**In bash config files:**

- Use single quotes for strings with special characters
- Or escape properly within double quotes

### WRONG (DO NOT USE)

```bash
FEATURE_TEXT="Compact 4.5\" Base"    ❌ Shows backslash
```

### RIGHT (USE THIS)

```bash
# Option 1: Single quotes (recommended)
FEATURE_TEXT='Compact 4.5" Base'     ✓ CORRECT

# Option 2: Different quote style
FEATURE_TEXT="Compact 4.5-inch Base" ✓ CORRECT (no quotes)

# Option 3: Proper escaping
FEATURE_TEXT="Compact 4.5″ Base"     ✓ CORRECT (curly quote)
```

### HOW TO FIND AND FIX

```bash
# Find all escaped quotes in config
grep '\\\"' product.config

# Find all problematic patterns
grep -n '\"' product.config
```

Replace `\"` with one of:

- `'..."..."'` (single-quoted string)
- `″` (Unicode double prime: U+2033)
- `-inch` (write out the unit)

---

## ISSUE 4: SIMPLESWAP POOL EMPTY

### THE PROBLEM

SimpleSwap pool server at `https://simpleswap-automation-1.onrender.com/` shows:

- $19 tier: 14/15 available ✓
- $29 tier: 0/15 available ❌ EMPTY
- $59 tier: 5/15 available ✓

### WHY IT MATTERS

When customer clicks checkout:

1. buy-now.js maps price to nearest tier
2. Calls pool server for that tier
3. If tier is empty → 500 error → checkout fails

### HOW TO FIX

**Step 1: Check pool status**

```bash
curl https://simpleswap-automation-1.onrender.com/
```

**Step 2: Identify empty pools**
Look for pools with `0` count.

**Step 3: Replenish empty pools**

```bash
# Replenish $29 pool
curl -X POST https://simpleswap-automation-1.onrender.com/admin/fill-sequential \
  -H "Content-Type: application/json" \
  -d '{"pricePoint": 29}'
```

**Step 4: Monitor replenishment**

```bash
# Check progress
curl https://simpleswap-automation-1.onrender.com/stats
```

---

## ISSUE 5: PRICE TIER MISMATCH

### THE PROBLEM

`buy-now.js` has authorized tiers:

```javascript
const authorizedTiers = [19, 29, 59, 99];
```

But pool server has:

```
PRICE_POINTS=19,29,59
```

$99 tier doesn't exist on pool server!

### HOW TO FIX

**Option A: Add $99 to pool server**

On the Render deployment, set environment variable:

```
PRICE_POINTS=19,29,59,99
```

**Option B: Remove $99 from buy-now.js**

Open `netlify/functions/buy-now.js` and change:

```javascript
const authorizedTiers = [19, 29, 59, 99];
```

To:

```javascript
const authorizedTiers = [19, 29, 59];
```

---

## QUICK DIAGNOSTIC COMMANDS

### Check if checkout will work

```bash
# 1. Test pool server
curl https://simpleswap-automation-1.onrender.com/

# 2. Test buy-now endpoint
curl -X POST https://YOUR-SITE.netlify.app/.netlify/functions/buy-now \
  -H "Content-Type: application/json" \
  -d '{"amountUSD": 19}'
```

### Check for double dollar signs

```bash
# In live HTML
curl -s https://YOUR-SITE.netlify.app/ | grep -o '\$\$[0-9]'

# In templates
grep '\${{' sections/*.html
```

### Check for escaped quotes

```bash
# In config
grep '\\\"' product.config

# In built HTML
curl -s https://YOUR-SITE.netlify.app/ | grep '\\"'
```

---

## CHECKLIST BEFORE DEPLOYMENT

### Checkout Functionality

- [ ] Pool server is running
- [ ] All price tiers have exchanges available
- [ ] buy-now.js tiers match pool server tiers
- [ ] Test checkout completes successfully

### Price Display

- [ ] Config prices do NOT have `$` prefix
- [ ] No `$$` appears on page
- [ ] All prices show correctly formatted

### Text Display

- [ ] No `\"` visible in text
- [ ] No `\'` visible in text
- [ ] Quotes display as proper quote marks

---

## EMERGENCY FIXES

### If checkout completely broken:

1. Check Render server is awake: `curl https://simpleswap-automation-1.onrender.com/`
2. If server sleeping, it takes 30-60 seconds to wake
3. If pool empty, run `/admin/init-pool` endpoint
4. Redeploy Netlify if functions updated

### If double dollars everywhere:

1. Open `product.config`
2. Remove `$` from ALL price values
3. Run `bash build.sh`
4. Redeploy

### If escaped quotes everywhere:

1. Open `product.config`
2. Change double-quoted strings to single-quoted
3. Run `bash build.sh`
4. Redeploy

---

## WEAK MODEL PATTERNS TO AVOID

### Pattern 1: Adding $ to prices

**AI often does:**

```bash
SINGLE_PRICE="$19"
```

**Should be:**

```bash
SINGLE_PRICE="19"
```

### Pattern 2: Escaping quotes wrong

**AI often does:**

```bash
DESC="This is a 4.5\" product"
```

**Should be:**

```bash
DESC='This is a 4.5" product'
```

### Pattern 3: Not checking pool status

**AI should always:**

1. Check pool status before deployment
2. Replenish empty pools
3. Test checkout manually

### Pattern 4: Mismatched price tiers

**AI should verify:**

- buy-now.js tiers match pool server tiers
- All tiers have available exchanges
- Mapping logic is correct

---

## SUMMARY

| Issue       | Cause           | Fix                  |
| ----------- | --------------- | -------------------- |
| 500 error   | Pool empty      | Replenish pool       |
| $$ display  | $ in config     | Remove $ from values |
| \" display  | Bad escaping    | Use single quotes    |
| No exchange | Tier mismatch   | Align tiers          |
| Server down | Render sleeping | Wake with curl       |

ALL ISSUES CAN BE FIXED BY FOLLOWING THIS DOCUMENT EXACTLY.
