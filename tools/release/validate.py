#!/usr/bin/env python3

"""
EaaSGrid Engineering Toolkit
Project Validation Module
"""

from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]

APP = ROOT / "apps" / "investor-portal"


def check_required_files():

    print("[CHECK] Required files")

    required = [
        APP / "package.json",
        APP / "app" / "layout.tsx",
        APP / "app" / "page.tsx",
        APP / "public",
    ]

    failed = False

    for item in required:

        if item.exists():
            print(f"✓ {item}")
        else:
            print(f"✗ Missing {item}")
            failed = True

    return not failed


def main():

    print("=" * 50)
    print("EaaSGrid Validation Tool")
    print("=" * 50)

    result = check_required_files()

    if result:
        print("\nVALIDATION PASSED")
    else:
        print("\nVALIDATION FAILED")


if __name__ == "__main__":
    main()
