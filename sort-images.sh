#!/bin/bash
# =============================================================================
# Image Sorting Wrapper - YES-Clean-Jarvis-Template
# =============================================================================

set -e

SOURCE_DIR="${1:-images-generated}"
DRY_RUN=""

if [ "$2" = "--dry-run" ]; then
    DRY_RUN="--dry-run"
fi

echo "═══════════════════════════════════════════════════════════"
echo "  IMAGE SORTER - YES-Clean-Jarvis-Template"
echo "═══════════════════════════════════════════════════════════"
echo "   Source: ${SOURCE_DIR}"
echo "   Target: Template image folders"
echo ""

python3 scripts/image-sorter.py "${SOURCE_DIR}" ${DRY_RUN}

echo ""
echo "✅ Image sorting complete!"
