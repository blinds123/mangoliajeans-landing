#!/bin/bash
# validate-current.sh - Meta validator that runs the appropriate check based on recent changes
# This is called by Ralphy after each task

echo "=== RUNNING VALIDATION ==="

# Determine which validation to run based on what files exist/changed
FAILED=0

# Always check images if folder exists
if [ -d "images" ]; then
  echo ""
  echo "📸 Running image validation..."
  if ! bash tests/validate-images.sh; then
    echo "❌ Image validation issues detected"
    FAILED=1
  fi
fi

# Check avatar if it exists
if [ -f "avatar_profile.json" ]; then
  echo ""
  echo "👤 Running avatar validation..."
  if ! bash tests/validate-avatar.sh; then
    echo "❌ Avatar validation failed"
    FAILED=1
  fi
fi

# Check copy framework if copy file exists
if [ -f "copy_draft.json" ] || [ -f "copy_final.json" ]; then
  echo ""
  echo "📝 Running framework validation..."
  if ! bash tests/validate-framework.sh; then
    echo "❌ Framework validation failed"
    FAILED=1
  fi
fi

# Check traceability if provenance report exists
if [ -f "copy_provenance_report.md" ]; then
  echo ""
  echo "🔍 Running traceability validation..."
  if ! bash tests/validate-trace.sh; then
    echo "❌ Traceability validation failed"
    FAILED=1
  fi
fi

# Check build if index.html exists
if [ -f "index.html" ]; then
  echo ""
  echo "🔨 Running build validation..."
  if ! bash tests/validate-build.sh; then
    echo "❌ Build validation failed"
    FAILED=1
  fi
fi

echo ""
if [ "$FAILED" -eq 1 ]; then
  echo "=== ❌ VALIDATION FAILED ==="
  exit 1
else
  echo "=== ✅ ALL VALIDATIONS PASSED ==="
  exit 0
fi
