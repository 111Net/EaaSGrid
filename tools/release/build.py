#!/usr/bin/env python3

"""
EaaSGrid Engineering Toolkit
Build Automation Module
"""

import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]

APP = ROOT / "apps" / "investor-portal"


def run_build():

    print("=" * 50)
    print("EaaSGrid Build Automation")
    print("=" * 50)

    print("\n[BUILD] Running production build\n")


    process = subprocess.run(
        ["npm", "run", "build"],
        cwd=APP,
        text=True
    )


    if process.returncode == 0:

        print("\n✓ BUILD SUCCESSFUL")

        return True

    else:

        print("\n✗ BUILD FAILED")

        return False



def main():

    result = run_build()

    if not result:
        exit(1)


if __name__ == "__main__":
    main()
