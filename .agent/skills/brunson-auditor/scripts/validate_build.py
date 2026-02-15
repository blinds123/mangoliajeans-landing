#!/usr/bin/env python3
"""
Antigravity Build Validator
Checks index.html for common issues before deployment.
Exit code 0 = PASS, Exit code 1 = FAIL
"""

import sys
import re
from pathlib import Path

def validate_build():
    errors = []
    warnings = []
    
    # Check if index.html exists
    index_path = Path("index.html")
    if not index_path.exists():
        errors.append("CRITICAL: index.html does not exist!")
        return errors, warnings
    
    content = index_path.read_text()
    
    # Check for raw placeholders
    placeholders = re.findall(r'\{\{[A-Z_]+\}\}', content)
    if placeholders:
        unique_placeholders = set(placeholders)
        errors.append(f"CRITICAL: {len(unique_placeholders)} unresolved placeholders found: {', '.join(list(unique_placeholders)[:10])}")
    
    # Check for empty critical sections
    critical_checks = [
        (r'<h1[^>]*>.*?</h1>', "No <h1> headline found"),
        (r'class="hero"', "No hero section found"),
        (r'<img[^>]+src="[^"]+"', "No images found"),
    ]
    
    for pattern, error_msg in critical_checks:
        if not re.search(pattern, content, re.IGNORECASE | re.DOTALL):
            warnings.append(f"WARNING: {error_msg}")
    
    # Check for broken image paths
    img_paths = re.findall(r'src="(images/[^"]+)"', content)
    for img_path in img_paths:
        if not Path(img_path).exists():
            errors.append(f"CRITICAL: Missing image: {img_path}")
    
    # Check minimum content length (should be a real page)
    if len(content) < 50000:
        warnings.append(f"WARNING: index.html seems too small ({len(content)} bytes). Expected 50KB+")
    
    return errors, warnings

def main():
    print("=" * 60)
    print("🔍 ANTIGRAVITY BUILD VALIDATOR")
    print("=" * 60)
    
    errors, warnings = validate_build()
    
    for warning in warnings:
        print(f"⚠️  {warning}")
    
    for error in errors:
        print(f"❌ {error}")
    
    if errors:
        print("\n" + "=" * 60)
        print("❌ VALIDATION FAILED - Fix errors before deployment")
        print("=" * 60)
        sys.exit(1)
    else:
        print("\n" + "=" * 60)
        print("✅ VALIDATION PASSED - Ready for deployment")
        print("=" * 60)
        sys.exit(0)

if __name__ == "__main__":
    main()
