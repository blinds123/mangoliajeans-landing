#!/bin/bash
# Browser Test: All Images Load (Mobile Mode)
# Verifies all template images load without 404 errors

cat << 'EOF'
BROWSER TEST: Image Loading (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Navigate to deployed site in mobile viewport (375x667)
2. Scroll through entire page to trigger lazy loading
3. Use read_network_requests to check for failed image requests
4. Use read_page to verify all img elements have loaded

ACCEPTANCE CRITERIA:
- All 42 images load successfully
- Zero 404 errors for images
- All images in WebP format
- Lazy loading works (images load on scroll)
- Hero image loads immediately (not lazy)

MCP COMMANDS TO USE:
```
# Scroll to load lazy images
mcp__claude-in-chrome__computer(action="scroll", scroll_direction="down", scroll_amount=10, tabId=X)
mcp__claude-in-chrome__computer(action="wait", duration=1, tabId=X)
# Repeat scroll until bottom

# Check network for failed images
mcp__claude-in-chrome__read_network_requests(tabId=X, urlPattern=".webp")

# Check all images in DOM
mcp__claude-in-chrome__read_page(tabId=X, filter="all")
# Look for img elements and verify src attributes
```

IMAGE COUNT EXPECTED (minimum):
- Product images: 6
- Testimonial images: 25
- Comparison images: 1
- Founder image: 1
- Order bump image: 1
- Awards: 5
- Universal assets: 2 (logo + size chart)

PASS CONDITIONS:
- 0 failed image requests (no 404s)
- All img elements have valid src
- Images are WebP format

FAIL CONDITIONS:
- Any 404 error for image
- Broken image placeholder visible
- Image src is empty or invalid

FIX ACTIONS IF FAIL:
- Identify which image failed from network requests
- Check if image exists in images/ directory
- Verify image path in product.config matches actual file
- Re-run optimize_images.py if format wrong
- Update HTML with correct path
- Re-deploy
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
