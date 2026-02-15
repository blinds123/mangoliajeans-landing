#!/bin/bash
# Self-Healing: Fix JavaScript Console Errors
# Common fixes for JS errors found during browser testing

set -e

echo "=== SELF-HEALING: JavaScript Console Errors ==="

BUILD_DIR="${1:-.}"
ERROR_LOG="${2:-}"

echo ""
echo "COMMON JAVASCRIPT ERRORS AND FIXES:"
echo ""

cat << 'FIXES'
1. "Uncaught ReferenceError: X is not defined"
   CAUSE: Script loaded before DOM or dependency missing
   FIX:
   - Move <script> to end of <body>
   - Add defer attribute: <script defer src="...">
   - Ensure all dependencies loaded first

2. "Uncaught TypeError: Cannot read property 'X' of null"
   CAUSE: DOM element not found (wrong selector or not loaded)
   FIX:
   - Wrap in DOMContentLoaded:
     document.addEventListener('DOMContentLoaded', function() { ... });
   - Check element exists before accessing:
     const el = document.querySelector('.class');
     if (el) { el.property = value; }

3. "Failed to load resource: 404"
   CAUSE: File path incorrect or file missing
   FIX:
   - Check file exists at specified path
   - Use relative paths from HTML file location
   - Verify case sensitivity (Linux servers are case-sensitive)

4. "Mixed Content: blocked loading from http://"
   CAUSE: HTTPS page loading HTTP resource
   FIX:
   - Change all http:// to https://
   - Use protocol-relative: //example.com/resource

5. "CORS error" / "Access-Control-Allow-Origin"
   CAUSE: Trying to fetch from different domain
   FIX:
   - Use server-side proxy (Netlify functions)
   - Add CORS headers to API
   - Use JSONP for compatible APIs

6. "Uncaught SyntaxError: Unexpected token"
   CAUSE: Invalid JavaScript syntax
   FIX:
   - Check for missing commas, brackets, quotes
   - Validate JSON if parsing JSON
   - Check for template literal issues

7. "ResizeObserver loop limit exceeded"
   CAUSE: Element resize triggers infinite loop
   FIX:
   - Debounce resize handlers
   - Use requestAnimationFrame
   - Usually safe to ignore (Chrome bug)
FIXES

echo ""
echo "=== CHECKING BUILD FILES ==="

# Check for common issues in HTML/JS
if [ -f "$BUILD_DIR/index.html" ]; then
  echo ""
  echo "Checking index.html..."

  # Check script placement
  SCRIPTS_IN_HEAD=$(grep -c '<script' "$BUILD_DIR/index.html" | head -1 || echo 0)
  if [ "$SCRIPTS_IN_HEAD" -gt 0 ]; then
    # Check if scripts have defer
    SCRIPTS_WITHOUT_DEFER=$(grep '<script' "$BUILD_DIR/index.html" | grep -cv 'defer\|async' || echo 0)
    if [ "$SCRIPTS_WITHOUT_DEFER" -gt 0 ]; then
      echo "WARNING: $SCRIPTS_WITHOUT_DEFER script(s) without defer/async"
      echo "FIX: Add 'defer' attribute to script tags"
    fi
  fi

  # Check for http:// resources
  HTTP_RESOURCES=$(grep -c 'http://' "$BUILD_DIR/index.html" || echo 0)
  if [ "$HTTP_RESOURCES" -gt 0 ]; then
    echo "WARNING: $HTTP_RESOURCES insecure (http://) resource references"
    echo "FIX: Change to https:// or use protocol-relative URLs"
  fi

  # Check for inline event handlers
  INLINE_HANDLERS=$(grep -cE 'on(click|load|error|submit)=' "$BUILD_DIR/index.html" || echo 0)
  if [ "$INLINE_HANDLERS" -gt 0 ]; then
    echo "INFO: $INLINE_HANDLERS inline event handlers found"
    echo "Consider moving to external JS for better maintainability"
  fi
fi

# Check for common JS file issues
for js_file in "$BUILD_DIR"/*.js "$BUILD_DIR"/js/*.js 2>/dev/null; do
  if [ -f "$js_file" ]; then
    echo ""
    echo "Checking: $js_file"

    # Check for console.log statements (should be removed for production)
    CONSOLE_LOGS=$(grep -c 'console.log' "$js_file" || echo 0)
    if [ "$CONSOLE_LOGS" -gt 0 ]; then
      echo "INFO: $CONSOLE_LOGS console.log statements (remove for production)"
    fi

    # Check for debugger statements
    DEBUGGER=$(grep -c 'debugger' "$js_file" || echo 0)
    if [ "$DEBUGGER" -gt 0 ]; then
      echo "WARNING: debugger statement found (remove for production)"
    fi
  fi
done

echo ""
echo "=== NETLIFY FUNCTION ERRORS ==="
echo ""
cat << 'NETLIFY'
If buy-now function has errors:

1. "Cannot find module"
   FIX: Run npm install in netlify/functions directory
   Or add dependency to package.json

2. "Function not found (404)"
   FIX: Check netlify.toml has:
   [functions]
     directory = "netlify/functions"

3. "Internal Server Error (500)"
   FIX: Check function logs:
   netlify functions:log buy-now

4. "POOL_URL not configured"
   FIX: Set environment variable:
   netlify env:set POOL_URL https://your-pool.onrender.com
NETLIFY

echo ""
echo "=== AUTO-FIX ACTIONS ==="
echo ""
echo "For most errors, Ralph will:"
echo "1. Read the specific error message"
echo "2. Identify which file has the issue"
echo "3. Apply the appropriate fix"
echo "4. Re-run browser tests to verify"
echo ""
echo "If errors persist after 3 attempts, check:"
echo "1. Browser console for full stack trace"
echo "2. Network tab for failed requests"
echo "3. Netlify function logs for server errors"

exit 0
