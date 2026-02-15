#!/usr/bin/env python3
"""
Deterministic Image Sorter for YES-Clean-Jarvis-Template
Uses IMAGE-MAPPING.json to place images exactly where they belong.
"""

import json
import re
import shutil
import sys
from pathlib import Path
from collections import defaultdict

class DeterministicImageSorter:
    """Sorts images into exact slots based on IMAGE-MAPPING.json"""

    def __init__(self, mapping_file="IMAGE-MAPPING.json"):
        self.base_dir = Path(__file__).parent.parent
        self.mapping_file = self.base_dir / mapping_file
        self.mapping = self._load_mapping()
        self.stats = {
            "processed": 0,
            "placed": 0,
            "skipped": 0,
            "missing_required": []
        }
        self.placed_slots = set()

    def _load_mapping(self):
        if not self.mapping_file.exists():
            print(f"❌ Mapping file not found: {self.mapping_file}")
            sys.exit(1)
        with open(self.mapping_file) as f:
            return json.load(f)

    def _extract_slot_id(self, filename):
        """
        Extract slot_id from filename.
        Rule: take prefix up to the first numeric segment (inclusive).
        Examples:
          product-01-hero.webp -> product-01
          testimonial-7-jane.webp -> testimonial-07
          order-bump-01.webp -> order-bump-01
          comparison-01.webp -> comparison-01
        """
        name = Path(filename).stem
        parts = name.split('-')
        slot_parts = []
        for p in parts:
            slot_parts.append(p)
            if p.isdigit():
                slot_id = "-".join(slot_parts).lower()
                # Zero-pad single-digit numeric suffix
                m = re.match(r"^(.*)-(\d)$", slot_id)
                if m:
                    slot_id = f"{m.group(1)}-0{m.group(2)}"
                return slot_id

        # Fallback to first segment
        return parts[0].lower()

    def _build_slot_lookup(self):
        lookup = {}
        for section_name, section_data in self.mapping["sections"].items():
            folder = section_data.get("folder", "images/")
            for slot in section_data.get("slots", []):
                slot_id = slot["slot_id"].lower()
                slot_folder = slot.get("folder", folder)
                lookup[slot_id] = {
                    **slot,
                    "section": section_name,
                    "target_folder": self.base_dir / slot_folder.lstrip("/"),
                    "target_path": self.base_dir / slot_folder.lstrip("/") / slot["filename"]
                }
        return lookup

    def _create_fallback_mapping(self):
        fallback = {}
        for i in range(1, 26):
            slot_id = f"testimonial-{i:02d}"
            fallback[f"testimonial-{i}"] = slot_id
        return fallback

    def sort_images(self, source_dir, dry_run=False):
        source_path = Path(source_dir)
        if not source_path.exists():
            print(f"❌ Source directory not found: {source_path}")
            return False

        print(f"🔍 Scanning: {source_path}")
        print(f"📋 Using mapping: {self.mapping_file}")
        print()

        slot_lookup = self._build_slot_lookup()
        fallback = self._create_fallback_mapping()

        image_extensions = {'.webp', '.png', '.jpg', '.jpeg', '.gif'}
        images = [f for f in source_path.iterdir()
                  if f.is_file() and f.suffix.lower() in image_extensions]

        print(f"Found {len(images)} images to sort")
        print()

        slot_matches = defaultdict(list)
        for img in images:
            slot_id = self._extract_slot_id(img.name)
            slot_matches[slot_id].append(img)

        unsorted = []
        for slot_id, matches in slot_matches.items():
            if slot_id in slot_lookup:
                self._place_image(matches[0], slot_lookup[slot_id], dry_run)
            elif slot_id in fallback:
                fallback_id = fallback[slot_id]
                if fallback_id in slot_lookup:
                    self._place_image(matches[0], slot_lookup[fallback_id], dry_run)
                else:
                    unsorted.extend(matches)
            else:
                unsorted.extend(matches)

        if unsorted:
            unsorted_dir = self.base_dir / "images" / "unsorted"
            if not dry_run:
                unsorted_dir.mkdir(parents=True, exist_ok=True)

            print(f"\n⚠️  {len(unsorted)} images couldn't be mapped (moved to images/unsorted/):")
            for img in unsorted:
                print(f"   - {img.name}")
                if not dry_run:
                    shutil.copy2(img, unsorted_dir / img.name)

            self.stats["skipped"] += len(unsorted)

        self.stats["processed"] = len(images)
        return True

    def _place_image(self, source_img, slot_info, dry_run):
        target_folder = slot_info["target_folder"]
        target_path = slot_info["target_path"]
        slot_id = slot_info["slot_id"]

        if not dry_run:
            target_folder.mkdir(parents=True, exist_ok=True)

        print(f"✅ {source_img.name:45} → {slot_info['folder']}{slot_info['filename']}")

        if not dry_run:
            shutil.copy2(source_img, target_path)

        self.placed_slots.add(slot_id)
        self.stats["placed"] += 1

    def print_summary(self):
        print()
        print("=" * 70)
        print("  IMAGE SORTING SUMMARY")
        print("=" * 70)
        print(f"  Total images processed: {self.stats['processed']}")
        print(f"  Images placed: {self.stats['placed']}")
        print(f"  Images skipped/unmapped: {self.stats['skipped']}")

        print()
        print("🔍 Checking required slots...")
        missing_required = []

        for section_name, section_data in self.mapping["sections"].items():
            for slot in section_data.get("slots", []):
                if slot.get("required", False):
                    slot_id = slot["slot_id"].lower()
                    if slot_id not in self.placed_slots:
                        missing_required.append({
                            "slot_id": slot["slot_id"],
                            "section": section_name,
                            "filename": slot["filename"],
                            "description": slot.get("description", "")
                        })

        if missing_required:
            print()
            print("  ❌ MISSING REQUIRED IMAGES:")
            for missing in missing_required:
                print(f"     • {missing['slot_id']}")
                print(f"       File: {missing['filename']}")
                print(f"       Section: {missing['section']}")
                if missing["description"]:
                    print(f"       {missing['description']}")
                print()
        else:
            print("  ✅ All required images present!")

        self.stats["missing_required"] = missing_required

        print()
        print("  📊 Images placed by category:")
        categories = {
            "product": [s for s in self.placed_slots if s.startswith("product-")],
            "testimonials": [s for s in self.placed_slots if s.startswith("testimonial-")],
            "comparison": [s for s in self.placed_slots if s.startswith("comparison-")],
            "order-bump": [s for s in self.placed_slots if s.startswith("order-bump-")],
            "founder": [s for s in self.placed_slots if s.startswith("founder-")],
            "awards": [s for s in self.placed_slots if s.startswith("awards-")],
            "universal": [s for s in self.placed_slots if s in ["logo", "size-chart-hero"]]
        }

        for cat_name, cat_slots in categories.items():
            if cat_slots:
                print(f"     {cat_name}: {len(cat_slots)} images")

        print()

    def validate_placement(self):
        print("🔍 Validating image placement...")
        print()

        errors = []
        warnings = []

        for section_name, section_data in self.mapping["sections"].items():
            for slot in section_data.get("slots", []):
                folder = slot.get("folder", section_data.get("folder", "images/"))
                target = self.base_dir / folder.lstrip("/") / slot["filename"]

                if slot.get("required", False):
                    if not target.exists():
                        errors.append(f"❌ Missing required: {slot['slot_id']} → {target}")
                else:
                    if not target.exists():
                        warnings.append(f"⚠️  Missing optional: {slot['slot_id']}")

        if errors:
            print("ERRORS (Required images missing):")
            for error in errors:
                print(f"  {error}")

        if warnings:
            print()
            print("WARNINGS (Optional images missing):")
            for warning in warnings[:10]:
                print(f"  {warning}")
            if len(warnings) > 10:
                print(f"  ... and {len(warnings) - 10} more")

        if not errors and not warnings:
            print("✅ All images validated successfully!")

        return len(errors) == 0

    def generate_report(self, output_file="IMAGE-SORT-REPORT.json"):
        report = {
            "stats": self.stats,
            "mapping_version": self.mapping.get("_version", "unknown"),
            "slots_filled": list(self.placed_slots),
            "validation_passed": len(self.stats["missing_required"]) == 0
        }

        output_path = self.base_dir / output_file
        with open(output_path, 'w') as f:
            json.dump(report, f, indent=2)

        print(f"📄 Report saved: {output_path}")


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Deterministic Image Sorter for YES-Clean-Jarvis-Template"
    )
    parser.add_argument(
        "source",
        nargs="?",
        default="images-generated",
        help="Source directory containing images to sort (default: images-generated)"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would happen without copying files"
    )
    parser.add_argument(
        "--validate-only",
        action="store_true",
        help="Only validate current placement, don't sort"
    )

    args = parser.parse_args()

    sorter = DeterministicImageSorter()

    if args.validate_only:
        sorter.validate_placement()
    else:
        success = sorter.sort_images(args.source, dry_run=args.dry_run)
        if success:
            sorter.print_summary()
            if not args.dry_run:
                sorter.validate_placement()
                sorter.generate_report()


if __name__ == "__main__":
    main()
