# SimpleSwap Exchange Pool Setup Guide

## ⚠️ Current Status
The Render.com deployment of the SimpleSwap pool server may have issues. This guide provides the complete working setup.

---

## Architecture

```
Customer Click "Buy Now"
         ↓
Landing Page (Netlify)
         ↓
Pool Server (Render.com) ←── Pre-created exchanges in memory
         ↓
SimpleSwap Payment Page
         ↓
Customer pays crypto → You receive USDT
```

---

## Step 1: Deploy Pool Server to Render.com

### 1.1 Create New Web Service
1. Go to https://render.com
2. Click "New" → "Web Service"
3. Connect your GitHub repo OR use "Deploy from URL"

### 1.2 Upload Pool Server Files
The pool server files are in: `simpleswap-exchange-pool/`

Required files:
- `pool-server.js` - Main server
- `package.json` - Dependencies
- `.env.example` - Environment template

### 1.3 Configure Web Service
- **Name**: `simpleswap-pool-yoursite`
- **Region**: Oregon (or closest to you)
- **Branch**: main
- **Runtime**: Node
- **Build Command**: `npm install && npx playwright install chromium`
- **Start Command**: `node pool-server.js`
- **Plan**: Starter ($7/month) - Free tier may timeout

### 1.4 Set Environment Variables
In Render Dashboard → Environment:

```
BRIGHTDATA_CUSTOMER_ID=hl_9d12e57c
BRIGHTDATA_ZONE=scraping_browser1
BRIGHTDATA_PASSWORD=u2ynaxqh9899
MERCHANT_WALLET=0x1372Ad41B513b9d6eC008086C03d69C635bAE578
PRICE_POINTS=19,29,59
POOL_SIZE_PER_PRICE=5
MIN_POOL_SIZE=3
ALLOWED_ORIGINS=https://your-site.netlify.app,https://your-custom-domain.com
PORT=3000
```

**IMPORTANT**: Update `ALLOWED_ORIGINS` with your actual Netlify domain.

### 1.5 Deploy
Click "Create Web Service" and wait for deployment (5-10 minutes).

---

## Step 2: Initialize Exchange Pools

After server is running:

```bash
# Initialize all pools (creates 5 exchanges per price point)
curl -X POST https://your-server.onrender.com/admin/init-pool

# Check pool status
curl https://your-server.onrender.com/stats
```

**Expected Response:**
```json
{
  "pools": {
    "19": { "count": 5, "minSize": 3 },
    "29": { "count": 5, "minSize": 3 },
    "59": { "count": 5, "minSize": 3 }
  }
}
```

---

## Step 3: Configure Landing Page

### 3.1 Update Checkout URLs
In `sections/05-main-product.html`, find the checkout function (around line 870):

```javascript
// Update these URLs with your Render server
async function handleCheckout(price, pool) {
  const response = await fetch('https://YOUR-SERVER.onrender.com/buy-now', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ amountUSD: price })
  });
  
  const data = await response.json();
  if (data.url) {
    window.location.href = data.url;
  }
}
```

### 3.2 Update Netlify Function (Optional)
If using the Netlify function at `netlify/functions/buy-now.js`:

```javascript
exports.handler = async (event) => {
  const { amount } = JSON.parse(event.body);
  
  const response = await fetch('https://YOUR-SERVER.onrender.com/buy-now', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ amountUSD: amount })
  });
  
  const data = await response.json();
  
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  };
};
```

---

## Step 4: Test Checkout Flow

### 4.1 Local Test
```bash
# Test getting an exchange from pool
curl -X POST https://your-server.onrender.com/buy-now \
  -H "Content-Type: application/json" \
  -d '{"amountUSD": 19}'
```

**Expected Response:**
```json
{
  "url": "https://simpleswap.io/exchange/abc123",
  "exchangeId": "abc123"
}
```

### 4.2 Live Test
1. Open your deployed site
2. Select a bundle/product
3. Click "Buy Now" or "Add to Cart"
4. Should redirect to SimpleSwap payment page

---

## Common Issues & Fixes

| Issue | Solution |
|-------|----------|
| **Pool empty** | Run `/admin/init-pool` to create new exchanges |
| **Exchange creation fails** | Check BrightData password, ensure it's correct |
| **CORS error** | Add your domain to `ALLOWED_ORIGINS` |
| **Timeout on Render** | Upgrade from free tier (starter $7/month) |
| **Server sleeping** | Render free tier sleeps after 15min, use paid tier |

---

## Pool Maintenance

### Automatic Replenishment
The pool server automatically replenishes when exchanges are used.

### Manual Refill
```bash
# Add single exchange to specific pool
curl -X POST https://your-server.onrender.com/admin/add-one \
  -H "Content-Type: application/json" \
  -d '{"pricePoint": 19}'

# Fill all pools sequentially
curl -X POST https://your-server.onrender.com/admin/fill-sequential
```

### Check Status
```bash
curl https://your-server.onrender.com/stats
```

---

## API Reference

| Endpoint | Method | Body | Description |
|----------|--------|------|-------------|
| `/` | GET | - | Server status |
| `/health` | GET | - | Health check |
| `/stats` | GET | - | Pool statistics |
| `/buy-now` | POST | `{amountUSD: 19}` | Get exchange URL |
| `/admin/init-pool` | POST | `{pricePoint?: 19}` | Initialize pools |
| `/admin/add-one` | POST | `{pricePoint: 19}` | Add one exchange |
| `/admin/fill-sequential` | POST | `{pricePoint?: 19}` | Fill pool slowly |

---

## Alternative: Direct SimpleSwap (No Pool)

If pool server is not working, use direct SimpleSwap links:

```javascript
// Direct link to SimpleSwap (no pre-created exchanges)
const directUrl = `https://simpleswap.io/exchange?to=usdttrc20&address=${MERCHANT_WALLET}&fixed=true&fiat=true&fiatAmount=${price}`;
window.location.href = directUrl;
```

**Pros:** Simpler, no server needed
**Cons:** Slower, customer waits for exchange creation

---

## Credentials

### BrightData (for exchange creation)
- Customer ID: `hl_9d12e57c`
- Zone: `scraping_browser1`
- Host: `brd.superproxy.io`
- Port: `9222`

### Merchant Wallet (Polygon USDT)
- Address: `0x1372Ad41B513b9d6eC008086C03d69C635bAE578`

---

*Last updated: January 2026*
