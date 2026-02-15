#!/bin/bash
# Browser Test: Mobile Responsiveness (375x667)
# Verifies layout works correctly on mobile

cat << 'EOF'
BROWSER TEST: Mobile Responsiveness (375x667)

INSTRUCTIONS FOR CLAUDE:
1. Resize browser to mobile dimensions: 375x667
2. Navigate to deployed site
3. Take screenshot
4. Check for horizontal scrollbar
5. Verify text is readable (not too small)
6. Verify buttons are tappable size (min 44px)
7. Verify no content overflow

ACCEPTANCE CRITERIA:
- Page renders correctly at 375px width
- No horizontal scrollbar
- Text is readable (minimum 14px font)
- Buttons are tappable (minimum 44x44px touch target)
- Images scale correctly
- No overlapping elements

MCP COMMANDS TO USE:
```
# Set mobile viewport
mcp__claude-in-chrome__resize_window(width=375, height=667, tabId=X)

# Take screenshot to verify layout
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)

# Check page structure
mcp__claude-in-chrome__read_page(tabId=X)

# Look for horizontal overflow
mcp__claude-in-chrome__javascript_tool(
  tabId=X,
  action="javascript_exec",
  text="document.documentElement.scrollWidth > document.documentElement.clientWidth"
)
```

PASS CONDITIONS:
- Screenshot shows properly formatted mobile layout
- No horizontal scroll (scrollWidth <= clientWidth)
- All content visible and readable
- Buttons visible and properly sized

FAIL CONDITIONS:
- Horizontal scrollbar visible
- Text overlapping
- Buttons too small to tap
- Content cut off
- Images not scaling

FIX ACTIONS IF FAIL:
- Add missing CSS media queries
- Set max-width: 100% on images
- Increase button padding for touch targets
- Fix font sizes for mobile
- Add viewport meta tag if missing
- Re-build and re-deploy
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
