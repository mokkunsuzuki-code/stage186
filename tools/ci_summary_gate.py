cd ~/Desktop/test/stage186

cat > tools/ci_summary_gate.py << 'EOF'
# MIT License © 2025 Motohiro Suzuki
"""
tools/ci_summary_gate.py  (Stage186)

Purpose:
- Gate CI on the presence and basic validity of out/reports/summary.md
- Sync it to repo root summary.md for humans/reviewers
"""

import sys
from pathlib import Path

REPORT = Path("out/reports/summary.md")
ROOT_SUMMARY = Path("summary.md")

OK_MARKERS = ["PASS", "[OK]"]


def main() -> int:
    if not REPORT.exists():
        print(f"[FAIL] report not found: {REPORT}")
        return 2

    text = REPORT.read_text(encoding="utf-8", errors="replace")

    if not any(m in text for m in OK_MARKERS):
        print("[FAIL] summary has no PASS/OK markers")
        return 3

    ROOT_SUMMARY.write_text(text, encoding="utf-8")
    print("[OK] summary gate passed; synced out/reports/summary.md -> summary.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
EOF
