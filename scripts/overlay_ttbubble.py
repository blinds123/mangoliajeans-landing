#!/usr/bin/env python3
"""
TikTok Bubble Overlay Tool - Wrapper for bubble-overlay generator
Integrates with bulletproof-research workflow

=============================================================================
GLM 4.7 COMPATIBILITY NOTE
=============================================================================
This script is a WRAPPER. The actual bubble tool is at:
    /Users/nelsonchan/clawd/tools/bubble-overlay/

PREFERRED DIRECT USAGE:
    cd /Users/nelsonchan/clawd/tools/bubble-overlay/
    source .venv/bin/activate && python generate_bubbles.py generate /path/to/images

Usage (this wrapper):
    python overlay_ttbubble.py --in ./images --research ./research.json
    python overlay_ttbubble.py --in ./images --config ./bubbles.json
=============================================================================
"""

import argparse
import subprocess
import sys
from pathlib import Path

# CORRECT BUBBLE TOOL PATH (Updated 2026-02-14)
BUBBLE_TOOL_DIR = Path("/Users/nelsonchan/clawd/tools/bubble-overlay")
BUBBLE_TOOL_SCRIPT = BUBBLE_TOOL_DIR / "generate_bubbles.py"

def main():
    parser = argparse.ArgumentParser(description='TikTok Bubble Overlay Tool')
    parser.add_argument('--in', dest='input_dir', required=True, help='Input folder with product/ and testimonials/ subfolders')
    parser.add_argument('--research', dest='research_file', help='Research JSON file with V-I-E objections (optional)')
    parser.add_argument('--config', help='Config JSON file (optional, used if no research)')
    parser.add_argument('--quality', type=int, default=82, help='WebP quality (default: 82)')

    args = parser.parse_args()

    # Check if the bubble tool exists
    if not BUBBLE_TOOL_DIR.exists():
        print(f"ERROR: Bubble tool directory not found at {BUBBLE_TOOL_DIR}")
        print()
        print("CORRECT TOOL LOCATION:")
        print("    /Users/nelsonchan/clawd/tools/bubble-overlay/")
        print()
        print("DIRECT USAGE COMMAND:")
        print("    cd /Users/nelsonchan/clawd/tools/bubble-overlay/")
        print("    source .venv/bin/activate && python generate_bubbles.py generate /path/to/images")
        sys.exit(1)

    if not BUBBLE_TOOL_SCRIPT.exists():
        print(f"ERROR: generate_bubbles.py not found at {BUBBLE_TOOL_SCRIPT}")
        print()
        print("DIRECT USAGE COMMAND:")
        print("    cd /Users/nelsonchan/clawd/tools/bubble-overlay/")
        print("    source .venv/bin/activate && python generate_bubbles.py generate /path/to/images")
        sys.exit(1)

    # Build the command
    cmd = [
        sys.executable,  # Use current Python
        str(BUBBLE_TOOL_SCRIPT),
        "generate", args.input_dir
    ]

    # Add research or config
    if args.research_file and Path(args.research_file).exists():
        cmd.extend(["--research", args.research_file])
        print(f"[INFO] Using research data: {args.research_file}")
    elif args.config:
        cmd.extend(["--config", args.config])

    print(f"[INFO] Processing images in: {args.input_dir}")
    print(f"[INFO] Using bubble tool: {BUBBLE_TOOL_SCRIPT}")
    print()

    # Run the tool
    result = subprocess.run(cmd, capture_output=False, text=True)

    if result.returncode == 0:
        print()
        print("[SUCCESS] Bubble overlays complete!")
        print(f"[INFO] Check: {args.input_dir}/product/overlayed/")
        print(f"[INFO] Check: {args.input_dir}/testimonials/overlayed/")
    else:
        print()
        print("[ERROR] Bubble overlay failed")
        sys.exit(1)

if __name__ == "__main__":
    main()
