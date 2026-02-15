#!/bin/bash
# Browser Test: Add to Cart Functionality (Mobile Mode)
# Tests the Add to Cart button and order bump

cat << 'EOF'
BROWSER TEST: Add to Cart (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Navigate to site in mobile viewport (375x667)
2. Scroll to find Add to Cart button
3. Verify order bump checkbox is visible and checked
4. Click Add to Cart button
5. Verify cart drawer opens OR checkout initiates
6. Verify order bump is included in cart/checkout

ACCEPTANCE CRITERIA:
- Add to Cart button is visible and clickable
- Order bump checkbox is PRE-CHECKED (checked="checked")
- Clicking Add to Cart opens cart drawer or checkout
- Order bump product is included in cart

MCP COMMANDS TO USE:
```
# Find Add to Cart button
mcp__claude-in-chrome__find(query="Add to Cart button", tabId=X)

# Scroll to it if needed
mcp__claude-in-chrome__computer(action="scroll_to", ref="ref_X", tabId=X)

# Check order bump is pre-checked
mcp__claude-in-chrome__read_page(tabId=X)
# Look for: <input type="checkbox" checked

# Click Add to Cart
mcp__claude-in-chrome__computer(action="left_click", ref="ref_X", tabId=X)

# Wait for cart/checkout
mcp__claude-in-chrome__computer(action="wait", duration=2, tabId=X)

# Take screenshot of result
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)
```

PASS CONDITIONS:
- Add to Cart button found and clickable
- Order bump checkbox is checked by default
- Cart drawer opens OR checkout page loads
- No JavaScript errors on click

FAIL CONDITIONS:
- Add to Cart button not found
- Order bump not pre-checked
- Click does nothing
- JavaScript error on click
- Cart drawer doesn't open

FIX ACTIONS IF FAIL:
1. Button not found:
   - Check sections/08-pricing.html has button
   - Check CSS isn't hiding button

2. Order bump not checked:
   - Add checked="checked" to checkbox
   - Re-build and re-deploy

3. Click doesn't work:
   - Check cart-drawer.js is loaded
   - Check for JavaScript errors
   - Verify onclick handlers

4. Cart doesn't open:
   - Check cart drawer HTML exists
   - Check JavaScript initialization
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
