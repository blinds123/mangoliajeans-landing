#!/bin/bash
# Browser Test: Page Load (Mobile Mode)
# Uses Chrome DevTools MCP to verify page loads correctly on mobile

# This test is executed BY Claude using Chrome DevTools MCP
# The script serves as documentation for what Claude should do

cat << 'EOF'
BROWSER TEST: Page Load (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Get the deployed site URL from netlify status
2. Use Chrome DevTools MCP tabs_context_mcp to get/create a tab
3. Use resize_window to set mobile dimensions: 375x667
4. Use navigate to go to the site URL
5. Use computer action="wait" duration=3 to let page load
6. Use computer action="screenshot" to capture the page
7. Use read_page to check content is visible

ACCEPTANCE CRITERIA:
- Page loads within 5 seconds
- No white screen (content visible)
- Hero section visible
- Main heading visible
- No error messages displayed

MOBILE VIEWPORT:
- Width: 375px (iPhone SE)
- Height: 667px

MCP COMMANDS TO USE:
```
mcp__claude-in-chrome__tabs_context_mcp(createIfEmpty=true)
mcp__claude-in-chrome__tabs_create_mcp()
mcp__claude-in-chrome__resize_window(width=375, height=667, tabId=X)
mcp__claude-in-chrome__navigate(url="https://site.netlify.app", tabId=X)
mcp__claude-in-chrome__computer(action="wait", duration=3, tabId=X)
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)
mcp__claude-in-chrome__read_page(tabId=X)
```

PASS CONDITIONS:
- Screenshot shows content (not white/error page)
- read_page returns hero section elements
- No timeout errors

FAIL CONDITIONS:
- White screen
- Error page displayed
- Timeout waiting for content
- JavaScript errors blocking render

FIX ACTIONS IF FAIL:
- Check if site is deployed (netlify status)
- Check for JavaScript errors (read_console_messages)
- Check network requests for failed resources
- Re-deploy if needed
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
