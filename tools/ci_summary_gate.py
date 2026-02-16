# MIT License © 2025 Motohiro Suzuki
"""
Stage186 summary gate
"""

import sys
from pathlib import Path

PREFERRED = Path("out/reports/summary.md")
CANONICAL_OUT = Path("out/reports/summary.md")
ROOT_SUMMARY = Path("summary.md")

OK_MARKERS = ["[OK]", "PASS", "passed"]
FAIL_MARKERS = ["[FAIL]", "FAIL", "failed", "error"]


def _read_text(p: Path):
    return p.read_text(encoding="utf-8", errors="replace")


def _find_candidate():
    if PREFERRED.exists():
        return PREFERRED

    out_dir = Path("out")
    if not out_dir.exists():
        return None

    candidates = list(out_dir.rglob("summary.md"))
    if not candidates:
        candidates = [p for p in out_dir.rglob("*summary*.md") if p.is_file()]

    if not candidates:
        return None

    candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    return candidates[0]


def main():
    cand = _find_candidate()
    if cand is None:
        print("[FAIL] summary not found under out/")
        return 2

    text = _read_text(cand)

    if not any(m in text for m in OK_MARKERS):
        print("[FAIL] no OK markers in summary")
        return 3

    if any(m in text for m in FAIL_MARKERS):
        print("[FAIL] failure markers detected in summary")
        return 4

    CANONICAL_OUT.parent.mkdir(parents=True, exist_ok=True)
    CANONICAL_OUT.write_text(text, encoding="utf-8")
    ROOT_SUMMARY.write_text(text, encoding="utf-8")

    print("[OK] summary gate passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
