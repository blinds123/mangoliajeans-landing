#!/bin/bash
# Browser Test: FAQ Accordion (Mobile Mode)
# Tests FAQ expand/collapse functionality

cat << 'EOF'
BROWSER TEST: FAQ Accordion (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Navigate to site in mobile viewport (375x667)
2. Scroll to FAQ section
3. Verify 6 FAQ items are visible
4. Click first FAQ question
5. Verify answer expands/becomes visible
6. Click again to collapse
7. Verify answer collapses/hides

ACCEPTANCE CRITERIA:
- 6 FAQ items visible
- Clicking question expands answer
- Clicking again collapses answer
- Smooth animation (optional)
- All 6 FAQs functional

MCP COMMANDS TO USE:
```
# Find FAQ section
mcp__claude-in-chrome__find(query="FAQ section", tabId=X)

# Scroll to FAQ
mcp__claude-in-chrome__computer(action="scroll_to", ref="ref_X", tabId=X)

# Take screenshot showing FAQ closed
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)

# Find first FAQ question
mcp__claude-in-chrome__find(query="FAQ question 1", tabId=X)

# Click to expand
mcp__claude-in-chrome__computer(action="left_click", ref="ref_X", tabId=X)
mcp__claude-in-chrome__computer(action="wait", duration=0.5, tabId=X)

# Take screenshot showing expanded
mcp__claude-in-chrome__computer(action="screenshot", tabId=X)

# Click to collapse
mcp__claude-in-chrome__computer(action="left_click", ref="ref_X", tabId=X)
```

PASS CONDITIONS:
- FAQ section found
- 6 FAQ items present
- Click expands answer (answer becomes visible)
- Click again collapses (answer hides)

FAIL CONDITIONS:
- FAQ section not found
- Less than 6 FAQ items
- Click doesn't expand
- Cannot collapse after expanding

FIX ACTIONS IF FAIL:
1. FAQ not found:
   - Check sections/23-faq.html exists
   - Verify section is included in build

2. Wrong FAQ count:
   - Check product.config has all FAQ_1 through FAQ_6

3. Accordion doesn't work:
   - Check JavaScript is loaded
   - Verify CSS for showing/hiding
   - Check for JS errors in console
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
