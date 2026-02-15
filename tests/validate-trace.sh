#!/bin/bash
# validate-trace.sh - Validates traceability and hallucination check
set -e

echo "=== TRACEABILITY VALIDATION ==="

# Check provenance report exists
if [ ! -f "copy_provenance_report.md" ]; then
  echo "FAIL: copy_provenance_report.md not found"
  exit 1
fi
echo "✓ Provenance report exists"

# Check file has content
LINES=$(wc -l < copy_provenance_report.md | tr -d ' ')
if [ "$LINES" -lt 10 ]; then
  echo "FAIL: Provenance report too short ($LINES lines). Need detailed sourcing."
  exit 1
fi
echo "✓ Provenance report has content ($LINES lines)"

# Check for source citations
SOURCE_COUNT=$(grep -c "Source File:" copy_provenance_report.md 2>/dev/null || echo "0")
if [ "$SOURCE_COUNT" -lt 5 ]; then
  echo "FAIL: Need at least 5 source citations, found $SOURCE_COUNT"
  exit 1
fi
echo "✓ Source citations: $SOURCE_COUNT"

# Check hallucination check passed
if ! grep -q "HALLUCINATION_CHECK: PASSED" copy_provenance_report.md; then
  echo "FAIL: HALLUCINATION_CHECK: PASSED not found"
  echo "Tip: Verify all claims trace to research before adding this line"
  exit 1
fi
echo "✓ Hallucination check passed"

# Check for unverified flags
UNVERIFIED=$(grep -c "UNVERIFIED\|HALLUCINATION RISK" copy_provenance_report.md 2>/dev/null || echo "0")
if [ "$UNVERIFIED" -gt 0 ]; then
  echo "FAIL: Found $UNVERIFIED unverified claims. Fix before proceeding."
  exit 1
fi
echo "✓ No unverified claims"

# Check research files exist (sources should reference these)
RESEARCH_FILES=("avatar_profile.json" "strategy_brief.json" "mechanism_report.json")
MISSING=0
for f in "${RESEARCH_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "WARN: Research file missing: $f"
    ((MISSING++))
  fi
done

if [ "$MISSING" -eq 0 ]; then
  echo "✓ All research files present"
fi

echo ""
echo "PASS: Traceability validation complete"
exit 0
