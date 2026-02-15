#!/bin/bash
# Browser Test: Comparison Section at 40% Scroll (Mobile Mode)
# Verifies comparison section appears at correct position

cat << 'EOF'
BROWSER TEST: Comparison Section Position (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Navigate to site in mobile viewport (375x667)
2. Get total page height
3. Scroll to 40% of page height
4. Verify comparison section is visible
5. Verify before/after images are loaded

ACCEPTANCE CRITERIA:
- Comparison section visible at ~40% scroll position
- Before image loads correctly
- After image loads correctly
- Before/After labels visible

MCP COMMANDS TO USE:
```
# Get page height
mcp__claude-in-chrome__javascript_tool(
  tabId=X,
  action="javascript_exec",
  text="document.documentElement.scrollHeight"
)

# Calculate 40% position
# page_height * 0.4

# Scroll to 40% position
mcp__claude-in-chrome__javascript_tool(
  tabId=X,
  action="javascript_exec",
  text="window.scrollTo(0, document.documentElement.scrollHeight * 0.4)"
)

# Wait for scroll
mcp__claude-in-chrome__computer(action="wait", duration=1, tabId=X)

# Take screenshot
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)

# Find comparison section
mcp__claude-in-chrome__find(query="comparison before after", tabId=X)

# Check if visible in viewport
mcp__claude-in-chrome__read_page(tabId=X)
```

WHY 40% SCROLL?
- WaistMafia conversion optimization
- Shows transformation proof early
- Before user gets bored/distracted
- Increases conversion rate

PASS CONDITIONS:
- Comparison section is in view at 40% scroll
- Before image visible and loaded
- After image visible and loaded
- Clear before/after contrast

FAIL CONDITIONS:
- Comparison section not at 40% position
- Images not loading
- Section not visible

FIX ACTIONS IF FAIL:
1. Wrong position:
   - Check section order in build
   - Section 11 should be comparison
   - Reorder sections if needed

2. Images not loading:
   - Check {{COMPARISON_BAD_IMAGE}} path
   - Check {{COMPARISON_GOOD_IMAGE}} path
   - Verify images exist in images/comparison/

3. Section missing:
   - Regenerate sections/11-comparison.html
   - Re-build
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
