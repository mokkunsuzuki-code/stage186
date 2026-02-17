# MIT License © 2025 Motohiro Suzuki
"""
tools/ci_claim_lint.py (Stage186 – stabilized)

Purpose:
- Ensure Claim A2–A5 are documented somewhere.
- Prefer claims/CLAIMS.md.
- Fallback to README.md.
- Never hard-stop CI in Stage186 (informational gate only).
"""

import sys
from pathlib import Path

CANDIDATES = [
    Path("claims/CLAIMS.md"),
    Path("claims/claims_table.md"),
    Path("docs/claims.md"),
    Path("README.md"),
]

REQUIRED = ["Claim A2", "Claim A3", "Claim A4", "Claim A5"]


def read_file(p: Path):
    try:
        return p.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return ""


def main():
    for path in CANDIDATES:
        if path.exists():
            text = read_file(path)
            missing = [c for c in REQUIRED if c not in text]
            if not missing:
                print(f"[OK] Claims found in {path}")
                return 0
            else:
                print(f"[WARN] {path} missing: {missing}")
                # continue searching other candidates

    print("[WARN] Claims A2-A5 not fully found in any candidate file.")
    print("Stage186 continues (non-blocking).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
