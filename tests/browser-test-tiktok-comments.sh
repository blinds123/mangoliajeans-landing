#!/bin/bash
# Browser Test: TikTok Comment Overlays (Mobile Mode)
# Verifies TikTok-style comments are visible

cat << 'EOF'
BROWSER TEST: TikTok Comments (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Navigate to site in mobile viewport (375x667)
2. Check hero section for TikTok comment overlays
3. Verify 3-5 comment bubbles are visible
4. Verify comments have actual text content
5. Verify comments are styled as overlays

ACCEPTANCE CRITERIA:
- TikTok comment elements present in hero
- 3-5 comment bubbles visible
- Comments contain Gen Z slang + emojis
- Comments positioned as floating overlays
- Comments don't block main content

MCP COMMANDS TO USE:
```
# Navigate and wait for load
mcp__claude-in-chrome__navigate(url="https://site.netlify.app", tabId=X)
mcp__claude-in-chrome__computer(action="wait", duration=2, tabId=X)

# Take screenshot of hero with comments
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)

# Find TikTok comment elements
mcp__claude-in-chrome__find(query="tiktok comment bubble overlay", tabId=X)

# Read page to check for comment classes/elements
mcp__claude-in-chrome__read_page(tabId=X)
# Look for: class="tiktok-comment" or similar

# Check comment content via JavaScript
mcp__claude-in-chrome__javascript_tool(
  tabId=X,
  action="javascript_exec",
  text="Array.from(document.querySelectorAll('.tiktok-comment, [class*=\"comment\"]')).map(el => el.textContent)"
)
```

EXPECTED COMMENT STYLE:
- "omgggg this actually works 😭🙌"
- "bestie where has this been all my life 💀"
- "no bc why is this so good 😩✨"
- "slayyy queen 👑💕"
- "the way I NEED this rn 🔥"

PASS CONDITIONS:
- Comments visible in hero section
- 3-5 comment elements found
- Comments have text content (not empty)
- Comments styled as overlays/bubbles
- Gen Z language/emojis present

FAIL CONDITIONS:
- No TikTok comments visible
- Comments are empty
- Comments block main content
- Comments not styled as bubbles

FIX ACTIONS IF FAIL:
1. Comments missing:
   - Check sections/03-hero.html has TikTok comment divs
   - Verify {{TIKTOK_COMMENT_*}} variables in product.config
   - Regenerate hero section

2. Comments empty:
   - Fill TIKTOK_COMMENT_1 through TIKTOK_COMMENT_5 in config
   - Use Gen Z slang + emojis
   - Re-build

3. Styling wrong:
   - Check CSS for .tiktok-comment class
   - Ensure position: absolute or similar
   - Add bubble styling
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
