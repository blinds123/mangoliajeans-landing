#!/bin/bash
# Replicates the Awards & Milestones Carousel to another project directory
# Usage: ./scripts/replicate_awards.sh /path/to/target-project

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "Error: Please provide a target directory."
  echo "Usage: ./scripts/replicate_awards.sh /path/to/target-project"
  exit 1
fi

# Resolve the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Source root is one level up from scripts/
SRC_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📂 Source Template: $SRC_ROOT"

# Remove trailing slash from target if present
TARGET="${TARGET%/}"

if [ ! -d "$TARGET" ]; then
  echo "Error: Target directory '$TARGET' does not exist."
  exit 1
fi

# CHECK SOURCE FILES (using absolute path from script location)
if [ ! -f "$SRC_ROOT/sections/13-awards-carousel.html" ]; then
    echo "❌ Error: Source file 'sections/13-awards-carousel.html' not found at expected location:"
    echo "   $SRC_ROOT/sections/13-awards-carousel.html"
    exit 1
fi

echo "🚀 Installing Awards Carousel to '$TARGET'..."

# 1. Copy Section
if [ ! -d "$TARGET/sections" ]; then
  echo "   warn: Target 'sections' directory not found. Creating it..."
  mkdir -p "$TARGET/sections"
fi
cp -f "$SRC_ROOT/sections/13-awards-carousel.html" "$TARGET/sections/"
echo "   ✅ Copied section HTML to $TARGET/sections/"

# 2. Copy Images
if [ ! -d "$TARGET/images/awards" ]; then
  echo "   warn: Target 'images/awards' directory not found. Creating it..."
  mkdir -p "$TARGET/images/awards"
fi
cp -f "$SRC_ROOT"/images/awards/*.webp "$TARGET/images/awards/"
echo "   ✅ Copied award images to $TARGET/images/awards/"

echo ""
echo "✨ Installation Complete!"
echo "   run ./build.sh in the target directory to verify the integration."
