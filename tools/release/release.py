#!/usr/bin/env python3

"""
EaaSGrid Engineering Toolkit
Master Release Controller
"""

import subprocess
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[2]

TOOLS = ROOT / "tools" / "release"


STEPS = [
    "validate.py",
    "version.py",
    "build.py",
    "package.py",
    "report.py",
]


def run_step(script):

    print("\n")
    print("=" * 60)
    print(f"RUNNING: {script}")
    print("=" * 60)


    result = subprocess.run(
        [
            "python3",
            str(TOOLS / script)
        ]
    )


    if result.returncode != 0:

        print(
            f"\n✗ FAILED: {script}"
        )

        sys.exit(1)


    print(
        f"\n✓ COMPLETED: {script}"
    )



def main():

    print("""
============================================================
        EaaSGrid Release Automation System
        Investor Portal RC Pipeline
============================================================
""")


    for step in STEPS:

        run_step(step)


    print("""
============================================================
        RELEASE COMPLETED SUCCESSFULLY
============================================================

Artifacts created:

✓ Release package
✓ Version record
✓ Build verification
✓ Release report

Status:
EAASGrid Investor Portal Release Candidate READY

============================================================
""")


if __name__ == "__main__":
    main()
