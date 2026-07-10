#!/usr/bin/env python3

"""
EaaSGrid Engineering Toolkit
Release Packaging Module
"""

from pathlib import Path
import shutil
import json
from datetime import datetime


ROOT = Path(__file__).resolve().parents[2]

APP = ROOT / "apps" / "investor-portal"

RELEASE_DIR = ROOT / "releases"

VERSION_FILE = ROOT / "version.json"


EXCLUDE = {
    "node_modules",
    ".next",
    ".git",
}


def load_version():

    with open(VERSION_FILE) as f:
        return json.load(f)



def create_release():

    version = load_version()

    release_name = (
        f'eaasgrid-investor-portal-'
        f'{version["version"]}-'
        f'{version["stage"]}-'
        f'{datetime.now().strftime("%Y%m%d-%H%M")}'
    )


    destination = RELEASE_DIR / release_name


    RELEASE_DIR.mkdir(
        exist_ok=True
    )


    print("=" * 50)
    print("EaaSGrid Release Packaging")
    print("=" * 50)


    print(f"\nCreating:")
    print(destination)


    shutil.copytree(
        APP,
        destination,
        ignore=lambda path, names:
            [
                n for n in names
                if n in EXCLUDE
            ]
    )


    print("\n✓ RELEASE PACKAGE CREATED")

    return destination



def main():

    create_release()



if __name__ == "__main__":
    main()
