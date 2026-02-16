# MIT License © 2025 Motohiro Suzuki
"""
tools/ci_claim_lint.py  (Stage186)

Purpose:
- Fail CI if claims documentation is missing or incomplete.
- Enforce that Claim A2-A5 are present somewhere in the repo docs.
- This is intentionally simple/robust: we validate presence + minimal structure signals.

Rules (Stage186 baseline):
- At least one of these files must exist:
  - claims/claims_table.md
  - claims/CLAIMS.md
  - docs/claims.md
  - README.md
- The selected claims doc must contain:
  - "Claim A2", "Claim A3", "Claim A4", "Claim A5"
- And at least one of the words:
  - "Evidence" OR "Assumption" (to avoid a meaningless stub)
"""

from __future__ import annotations

from pathlib import Path
import sys


CANDIDATES = [
    Path("claims/claims_table.md"),
    Path("claims/CLAIMS.md"),
    Path("docs/claims.md"),
    Path("README.md"),
]


REQUIRED = ["Claim A2", "Claim A3", "Claim A4", "Claim A5"]
STRUCTURE_HINTS = ["Evidence", "Assumption"]


def _read_text(p: Path) -> str:
    return p.read_text(encoding="utf-8", errors="replace")


def main() -> int:
    existing = [p for p in CANDIDATES if p.exists() and p.is_file()]
    if not existing:
        print("[FAIL] No claims doc found. Expected one of:")
        for p in CANDIDATES:
            print(f"  - {p}")
        return 2

    # Prefer dedicated claims doc over README
    existing.sort(key=lambda p: 0 if "claims/" in str(p) or "docs/" in str(p) else 1)
    target = existing[0]
    text = _read_text(target)

    missing = [k for k in REQUIRED if k not in text]
    if missing:
        print(f"[FAIL] claims doc incomplete: {target}")
        for k in missing:
            print(f"  missing: {k}")
        return 3

    if not any(h in text for h in STRUCTURE_HINTS):
        print(f"[FAIL] claims doc lacks minimal structure hints (Evidence/Assumption): {target}")
        return 4

    print(f"[OK] claims lint passed: {target}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
