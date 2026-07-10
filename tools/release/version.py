#!/usr/bin/env python3

"""
EaaSGrid Engineering Toolkit
Version Management
"""

from pathlib import Path
import json


ROOT = Path(__file__).resolve().parents[2]

VERSION_FILE = ROOT / "version.json"


DEFAULT_VERSION = {
    "product": "EaaSGrid Investor Portal",
    "version": "2.3.0",
    "stage": "RC1",
    "status": "Release Candidate"
}


def create_version():

    if not VERSION_FILE.exists():

        VERSION_FILE.write_text(
            json.dumps(
                DEFAULT_VERSION,
                indent=4
            )
        )

        print("✓ Created version.json")

    else:

        print("✓ version.json already exists")


def show_version():

    data = json.loads(
        VERSION_FILE.read_text()
    )

    print()
    print("=" * 50)
    print(data["product"])
    print(
        f'Version: {data["version"]} {data["stage"]}'
    )
    print(
        f'Status: {data["status"]}'
    )
    print("=" * 50)


def main():

    create_version()
    show_version()


if __name__ == "__main__":
    main()
