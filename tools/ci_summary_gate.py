cat > tools/ci_summary_gate.py << 'EOF'
# MIT License © 2025 Motohiro Suzuki
"""
tools/ci_summary_gate.py  (Stage186)

Purpose:
- Gate CI on the presence and content of attack summary outputs.
- Discover the generated summary path robustly (repo variations).
- Sync the canonical report into:
  - out/reports/summary.md
  - repo root summary.md
"""

from __future__ import annotations

from pathlib import Path
import sys

PREFERRED = Path("out/reports/summary.md")
CANONICAL_OUT = Path("out/reports/summary.md")
ROOT_SUMMARY = Path("summary.md")

OK_MARKERS = ["[OK]", "PASS", "passed"]
FAIL_MARKERS = ["[FAIL]", "FAIL", "failed", "error"]


def _read_text(p: Path) -> str:
    return p.read_text(encoding="utf-8", errors="replace")


def _find_candidate() -> Path | None:
    if PREFERRED.exists() and PREFERRED.is_file():
        return PREFERRED

    out_dir = Path("out")
    if not out_dir.exists():
        return None

    candidates: list[Path] = []
    candidates.extend(out_dir.rglob("summary.md"))
    candidates.extend([p for p in out_dir.rglob("*summary*.md") if p.is_file()])

    uniq = {str(p): p for p in candidates}
    candidates = list(uniq.values())

    if not candidates:
        return None

    candidates.sort(key=lambda p: p.stat().st_mtime, reverse=True)
    return candidates[0]


def main() -> int:
    cand = _find_candidate()
    if cand is None:
        print("[FAIL] report not found.")
        print("  expected: out/reports/summary.md")
        print("  also searched under: out/**/(summary.md | *summary*.md)")
        return 2

    text = _read_text(cand)

    if not any(m in text for m in OK_MARKERS):
        print("[FAIL] report has no OK markers; looks empty or wrong format")
        print(f"  found report: {cand}")
        return 3

    if any(m in text for m in FAIL_MARKERS):
        print("[FAIL] report contains failure markers")
        print(f"  found report: {cand}")
        return 4

    CANONICAL_OUT.parent.mkdir(parents=True, exist_ok=True)
    CANONICAL_OUT.write_text(text, encoding="utf-8")
    ROOT_SUMMARY.write_text(text, encoding="utf-8")

    if cand != CANONICAL_OUT:
        print(f"[OK] summary discovered: {cand}")
    print(f"[OK] synced -> {CANONICAL_OUT} and {ROOT_SUMMARY}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
EOF
