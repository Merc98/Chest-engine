#!/usr/bin/env python3
"""Generate a simple Markdown report from scan/session metadata.

Usage:
  python scripts/generate-report.py reports/example.json reports/output.md

The script expects JSON metadata and writes a Markdown report. It is a utility
for documentation/reporting only.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


def md_escape(value: Any) -> str:
    return str(value).replace("|", "\\|")


def generate_report(data: dict[str, Any]) -> str:
    lines: list[str] = []
    lines.append("# Generated Session Report")
    lines.append("")
    lines.append("## Metadata")
    lines.append("")
    lines.append("| Field | Value |")
    lines.append("|---|---|")

    for key in ["session_id", "date", "process", "scan_type", "value_type", "result_count"]:
        if key in data:
            lines.append(f"| {md_escape(key)} | {md_escape(data[key])} |")

    if "regions" in data:
        regions = data.get("regions") or []
        if isinstance(regions, list):
            lines.append("")
            lines.append("## Regions")
            lines.append("")
            for region in regions:
                lines.append(f"- `{region}`")

    if "notes" in data and data["notes"]:
        lines.append("")
        lines.append("## Notes")
        lines.append("")
        lines.append(str(data["notes"]))

    lines.append("")
    return "\n".join(lines)


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: python scripts/generate-report.py <input.json> <output.md>")
        return 2

    input_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    if not input_path.exists():
        print(f"Input file not found: {input_path}")
        return 1

    with input_path.open("r", encoding="utf-8") as file:
        data = json.load(file)

    if not isinstance(data, dict):
        print("Input JSON must be an object.")
        return 1

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(generate_report(data), encoding="utf-8")
    print(f"Report written to {output_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
