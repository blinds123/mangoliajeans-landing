#!/bin/bash
# Browser Test: Console Errors (Mobile Mode)
# Checks for JavaScript errors in browser console

cat << 'EOF'
BROWSER TEST: Console Errors (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Navigate to deployed site in mobile viewport
2. Wait for page to fully load
3. Use read_console_messages to get all console output
4. Filter for errors and exceptions
5. Report any errors found

ACCEPTANCE CRITERIA:
- Zero JavaScript errors
- Zero uncaught exceptions
- No critical warnings

MCP COMMANDS TO USE:
```
mcp__claude-in-chrome__read_console_messages(tabId=X, onlyErrors=true)
# OR
mcp__claude-in-chrome__read_console_messages(tabId=X, pattern="error|Error|exception|Exception")
```

PASS CONDITIONS:
- No error-level messages in console
- No uncaught exceptions
- No "undefined" errors
- No "null" reference errors

FAIL CONDITIONS:
- Any console.error messages
- Uncaught TypeError
- Uncaught ReferenceError
- Script loading failures
- CORS errors

COMMON ERRORS AND FIXES:
1. "Cannot read property of undefined"
   FIX: Check JavaScript for null checks, ensure DOM elements exist

2. "Script error" (cross-origin)
   FIX: Check external scripts are loaded correctly

3. "Failed to load resource"
   FIX: Check file paths, ensure files are deployed

4. "Unexpected token"
   FIX: JavaScript syntax error - check for typos

FIX ACTIONS IF FAIL:
- Identify the error message
- Find the source file/line
- Fix the JavaScript issue
- Re-build and re-deploy
- Re-test
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
