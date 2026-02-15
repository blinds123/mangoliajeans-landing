# SimpleSwap Exchange Pool Setup

> **COMPLETE INSTRUCTIONS** for SimpleSwap crypto checkout with pre-created exchange pools

---

## ⚠️ CRITICAL: ALWAYS USE EXISTING POOLS

**READ THIS FIRST - DO NOT SKIP:**

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  🚨 MANDATORY RULE: USE DEFAULT PRICING ($19/$29/$59) - NEVER CREATE POOLS   ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  The existing pool server has 45 exchanges each for $19, $29, and $59.       ║
║                                                                              ║
║  YOU MUST USE THESE EXISTING POOLS.                                          ║
║                                                                              ║
║  DO NOT:                                                                     ║
║    ❌ Create new exchange pools                                              ║
║    ❌ Use BrightData to create exchanges                                     ║
║    ❌ Modify pool pricing                                                    ║
║    ❌ Run any createExchange functions                                       ║
║                                                                              ║
║  The ONLY exception is if the user EXPLICITLY says:                          ║
║    "I want custom pricing of $XX instead of $19"                             ║
║                                                                              ║
║  Even then, ASK FOR CONFIRMATION before using BrightData.                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## Overview

This landing page uses SimpleSwap for crypto checkout. Pre-created exchange pools are already configured. **No setup required for default pricing.**

## Architecture

```
[Customer] → [Netlify Function] → [Render Pool Server] → [SimpleSwap]
     ↓              ↓                    ↓
  Clicks       buy-now.js           Claims exchange
 Buy Now                            from EXISTING pool
```

---

## 💰 Default Pricing (USE THIS)

**Already configured. No action needed.**

| Tier                   | Price | Pool Size    | Status   |
| ---------------------- | ----- | ------------ | -------- |
| Pre-Order              | $19   | 45 exchanges | ✅ READY |
| Pre-Order + Order Bump | $29   | 45 exchanges | ✅ READY |
| Order Today            | $59   | 45 exchanges | ✅ READY |

```javascript
// HARDCODED VALUES - DO NOT CHANGE
const SINGLE_PRICE = 19;
const ORDER_BUMP_PRICE = 10;
const POOL_SERVER = "https://simpleswap-automation-1.onrender.com";
```

---

## 🔄 AUTO-REPLENISHMENT (CONFIRMED)

**The pool server automatically replenishes exchanges when consumed.**

- ✅ Instant replenishment on consumption
- ✅ 3 retries with exponential backoff
- ✅ 60s health check catches failures
- ✅ 5min self-ping prevents Render sleep

**You do NOT need to create new exchanges. The server handles this automatically.**

---

## ✅ Phase 0: Verify Pool Server Health

**Run this check before deployment:**

```bash
# Check pool server status (root endpoint)
curl -s https://simpleswap-automation-1.onrender.com/

# Expected response includes:
# "pools":{"19":15,"29":15,"59":15}
```

**If pools show 0 or server is down:**

- Wait 30-60 seconds (Render free tier cold start)
- Retry the curl command
- If still 0, contact the pool server administrator

**DO NOT try to create new pools.**

---

## 🚀 Deployment (Simple)

### Step 1: Set Netlify Environment Variable

```bash
netlify env:set POOL_URL https://simpleswap-automation-1.onrender.com
```

### Step 2: Deploy

```bash
netlify deploy --prod --dir=.
```

### Step 3: Test Checkout

```bash
curl -X POST https://your-site.netlify.app/.netlify/functions/buy-now \
  -H "Content-Type: application/json" \
  -d '{"amountUSD": 19}'
```

**That's it. No pool creation needed.**

---

## 📦 Pool Server API Reference

### Check Pool Status

```bash
curl https://simpleswap-automation-1.onrender.com/pool-status
```

Response:

```json
{
  "19": 45,
  "29": 45,
  "59": 45
}
```

### Buy Now (Claim Exchange)

```bash
curl -X POST https://simpleswap-automation-1.onrender.com/buy-now \
  -H "Content-Type: application/json" \
  -d '{"amountUSD": 19}'
```

Response:

```json
{
  "success": true,
  "exchangeUrl": "https://simpleswap.io/exchange?id=abc123",
  "address": "bc1q...",
  "amount": "0.00025"
}
```

---

## 🔐 Infrastructure Reference (READ ONLY)

**This section is for REFERENCE ONLY. Do not execute these commands.**

### Pool Server Location

- URL: `https://simpleswap-automation-1.onrender.com`
- GitHub: `https://github.com/blinds123/simpleswap-automation`
- Service ID: `srv-d4fe0u7pm1nc73et6dkg`

### Merchant Wallet

- Address: `0x1372Ad41B513b9d6eC008086C03d69C635bAE578`

---

## ⛔ Custom Pricing (REQUIRES USER CONFIRMATION)

**STOP: Only proceed if user EXPLICITLY requests custom pricing.**

If the user says something like:

- "I want to charge $25 instead of $19"
- "Can we use $49 pricing?"
- "I need different price tiers"

**Then ask for confirmation:**

```
⚠️ CUSTOM PRICING REQUEST

You've requested custom pricing. This requires:
- Creating 15 new exchanges per tier using BrightData
- ~10-15 minutes additional setup time
- Using BrightData scraping credits

Current default pricing ($19/$29/$59) has 45 exchanges each and is ready to use.

Do you want to:
1. Use default pricing (recommended) - instant, no setup
2. Create custom pricing tiers - requires BrightData, ~15 min

Please confirm your choice.
```

**Only if user confirms option 2, then proceed with BrightData setup.**

---

## Quick Reference

| Component        | URL/Value                                      |
| ---------------- | ---------------------------------------------- |
| Pool Server      | `https://simpleswap-automation-1.onrender.com` |
| Pool Status      | `GET /pool-status`                             |
| Buy Now          | `POST /buy-now`                                |
| Default $19 Pool | 45 exchanges ✅                                |
| Default $29 Pool | 45 exchanges ✅                                |
| Default $59 Pool | 45 exchanges ✅                                |

---

## ✅ Validation Checklist

Before deploying, verify:

- [ ] Pool server returns healthy status
- [ ] POOL_URL env var set in Netlify
- [ ] buy-now.js function exists in netlify/functions/
- [ ] Using default pricing ($19/$29/$59)
- [ ] NOT creating new pools (unless user explicitly requested)
