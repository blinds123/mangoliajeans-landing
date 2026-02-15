#!/bin/bash
# Browser Test: Core Web Vitals Performance (Mobile Mode)
# Measures LCP, CLS, FID on mobile

cat << 'EOF'
BROWSER TEST: Core Web Vitals (Mobile Mode 375x667)

INSTRUCTIONS FOR CLAUDE:
1. Set mobile viewport (375x667)
2. Start performance trace with reload
3. Wait for page to fully load
4. Stop trace and analyze results
5. Check LCP, CLS, FID metrics

ACCEPTANCE CRITERIA:
- LCP (Largest Contentful Paint) < 2.5 seconds
- CLS (Cumulative Layout Shift) < 0.1
- FID (First Input Delay) < 100ms
- Overall performance score: A or B

MCP COMMANDS TO USE:
```
# Set mobile viewport
mcp__claude-in-chrome__resize_window(width=375, height=667, tabId=X)

# Start performance trace with page reload
mcp__chrome-devtools__performance_start_trace(reload=true, autoStop=true)

# Wait for trace to complete
# (autoStop will stop when page is idle)

# If needed, manually stop:
mcp__chrome-devtools__performance_stop_trace()

# Analyze insights
mcp__chrome-devtools__performance_analyze_insight(insightSetId="X", insightName="LCPBreakdown")
```

CORE WEB VITALS THRESHOLDS:
- LCP:
  - Good: < 2.5s
  - Needs Improvement: 2.5s - 4.0s
  - Poor: > 4.0s

- CLS:
  - Good: < 0.1
  - Needs Improvement: 0.1 - 0.25
  - Poor: > 0.25

- FID:
  - Good: < 100ms
  - Needs Improvement: 100ms - 300ms
  - Poor: > 300ms

PASS CONDITIONS:
- LCP under 2.5 seconds
- CLS under 0.1
- FID under 100ms (if measurable)
- No major performance issues flagged

FAIL CONDITIONS:
- LCP over 2.5 seconds
- CLS over 0.1
- FID over 100ms
- Critical performance warnings

FIX ACTIONS IF FAIL:
1. LCP too slow:
   - Optimize hero image size
   - Add preload for hero image
   - Reduce server response time
   - Remove render-blocking resources

2. CLS too high:
   - Set explicit dimensions on images
   - Reserve space for dynamic content
   - Avoid inserting content above existing content

3. FID too slow:
   - Reduce JavaScript execution time
   - Break up long tasks
   - Defer non-critical JavaScript
EOF

echo "This test requires Chrome DevTools MCP - Claude will execute it"
exit 0
