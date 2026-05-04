#!/usr/bin/env python3
"""Validate the repository documentation structure.

This script checks for expected files added during the `main` consolidation.
It does not build the native Lazarus project.
"""

from pathlib import Path
import sys

REQUIRED_PATHS = [
    "README.md",
    "docs/architecture.md",
    "docs/build-windows.md",
    "docs/lua-api.md",
    "docs/plugin-sdk.md",
    "docs/memory-scanner.md",
    "docs/debugger.md",
    "docs/ceserver.md",
    "examples/lua/README.md",
    "examples/lua/environment-check.lua",
    "examples/lua/notes-template.lua",
    "plugins/README.md",
    "reports/README.md",
    "reports/session-report.md",
    "reports/repository-audit.md",
    "reports/scan-results.schema.json",
]


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    missing = []

    for relative_path in REQUIRED_PATHS:
        path = root / relative_path
        if not path.exists():
            missing.append(relative_path)

    if missing:
        print("Missing required repository files:")
        for item in missing:
            print(f"- {item}")
        return 1

    print("Repository structure validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
