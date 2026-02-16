# MIT License © 2025 Motohiro Suzuki
"""
tools/ci_summary_gate.py  (Stage186)

Purpose:
- Gate CI on the presence and content of attack summary outputs.
- Sync the canonical report into repo root summary.md for humans/reviewers.

Baseline assumptions:
- The matrix run produces a markdown report in: out/reports/summary.md
- We require that summary contains at least one "[OK]" and no obvious "[FAIL]".

If your repo uses different markers, adjust OK_MARKERS / FAIL_MARKERS.
"""

from __future__ import annotations

from pathlib import Path
import sys


REPORT = Path("out/reports/summary.md")
ROOT_SUMMARY = Path("summary.md")

OK_MARKERS = ["[OK]", "PASS", "passed"]
FAIL_MARKERS = ["[FAIL]", "FAIL", "failed", "error"]


def main() -> int:
    if not REPORT.exists():
        print(f"[FAIL] report not found: {REPORT}")
        return 2

    text = REPORT.read_text(encoding="utf-8", errors="replace")

    if not any(m in text for m in OK_MARKERS):
        print("[FAIL] report has no OK markers; looks empty or wrong format")
        print(f"  report: {REPORT}")
        return 3

    # If your summary contains the word "FAIL" in non-failure contexts,
    # tighten this rule later. For Stage186 baseline we keep it strict.
    if any(m in text for m in FAIL_MARKERS):
        print("[FAIL] report contains failure markers")
        print(f"  report: {REPORT}")
        return 4

    # Sync to root
    ROOT_SUMMARY.write_text(text, encoding="utf-8")
    print(f"[OK] summary gate passed; synced {REPORT} -> {ROOT_SUMMARY}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
