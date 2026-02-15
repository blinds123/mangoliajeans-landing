#!/usr/bin/env python3
"""
Brunson-Protocol Image Optimizer
Standardizes all images to WebP format with consistent naming

Requires: pip install Pillow
"""

import sys
from pathlib import Path

from PIL import Image

# Configuration
QUALITY = 85
MAX_WIDTH = 1200
MAX_HEIGHT = 1600

# Standard folder structure (EXACT - matches user's actual folders)
# NOTE: Product images are ALSO used as hero images (no separate hero folder)
# Testimonial images are used for Features, Secrets, Testimonials, and Reviews
FOLDERS = {
    "product": {"prefix": "product", "count": 6},  # Hero carousel
    "testimonials": {"prefix": "testimonial", "count": 25},  # Features, Secrets, Reviews
    "order-bump": {"prefix": "order-bump", "count": 1},  # Order bump product
    "founder": {"prefix": "founder", "count": 1},  # Founder story only (static ok)
    "comparison": {"prefix": "comparison", "count": 1},  # Combined before/after
    "awards": {"prefix": "awards", "count": 5},  # Awards/trust badges (static)
    "universal": {"prefix": "universal", "count": 2},  # Logo + size chart (static)
}


def optimize_image(input_path: Path, output_path: Path) -> bool:
    """Optimize and convert image to WebP"""
    try:
        with Image.open(input_path) as img:
            # Convert to RGB if necessary (for PNG with transparency)
            if img.mode in ("RGBA", "P"):
                img = img.convert("RGB")

            # Resize if too large
            if img.width > MAX_WIDTH or img.height > MAX_HEIGHT:
                img.thumbnail((MAX_WIDTH, MAX_HEIGHT), Image.Resampling.LANCZOS)

            # Save as WebP
            img.save(output_path, "WEBP", quality=QUALITY, method=6)

        return True
    except Exception as e:
        print(f"  Error processing {input_path}: {e}")
        return False


def process_folder(folder_path: Path, config: dict) -> int:
    """Process all images in a folder"""
    if not folder_path.exists():
        print(f"  Folder not found: {folder_path}")
        return 0

    prefix = config["prefix"]
    max_count = config["count"]
    processed = 0

    # Get all image files
    image_extensions = {".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp"}
    images = sorted(
        [f for f in folder_path.iterdir() if f.suffix.lower() in image_extensions]
    )

    if not images:
        print(f"  No images found in {folder_path}")
        return 0

    for i, image_path in enumerate(images[:max_count], 1):
        output_name = f"{prefix}-{i:02d}.webp"
        output_path = folder_path / output_name

        # Skip if already optimized
        if image_path.name == output_name:
            print(f"  Already optimized: {output_name}")
            processed += 1
            continue

        print(f"  Converting: {image_path.name} -> {output_name}")

        if optimize_image(image_path, output_path):
            processed += 1

            # Remove original if different from output
            if image_path != output_path and image_path.suffix.lower() != ".webp":
                # Keep original in case of issues
                backup_path = folder_path / f"_original_{image_path.name}"
                image_path.rename(backup_path)

    return processed


def main():
    """Main optimization routine"""
    print("=" * 50)
    print("  BRUNSON-PROTOCOL IMAGE OPTIMIZER")
    print("=" * 50)
    print()

    # Determine images directory
    if len(sys.argv) > 1:
        images_dir = Path(sys.argv[1])
    else:
        images_dir = Path("images")

    if not images_dir.exists():
        print(f"Creating images directory structure...")
        for folder in FOLDERS.keys():
            (images_dir / folder).mkdir(parents=True, exist_ok=True)
        print(f"Created: {images_dir}")
        print()
        print("Add your images to these folders:")
        for folder, config in FOLDERS.items():
            print(f"  images/{folder}/ - up to {config['count']} images")
        return

    print(f"Processing: {images_dir.absolute()}")
    print()

    total_processed = 0

    for folder_name, config in FOLDERS.items():
        folder_path = images_dir / folder_name
        print(f"[{folder_name}]")

        if not folder_path.exists():
            folder_path.mkdir(parents=True, exist_ok=True)
            print(f"  Created folder: {folder_path}")
            continue

        count = process_folder(folder_path, config)
        total_processed += count
        print(f"  Processed: {count} images")
        print()

    print("=" * 50)
    print(f"  COMPLETE: {total_processed} images optimized")
    print("=" * 50)
    print()
    print("Image paths for product.config:")
    print()
    for folder_name, config in FOLDERS.items():
        prefix = config["prefix"]
        print(f"  {prefix.upper()}_IMAGE=images/{folder_name}/{prefix}-01.webp")


if __name__ == "__main__":
    main()
