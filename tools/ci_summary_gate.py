cd ~/Desktop/test/stage186

cat > tools/ci_summary_gate.py << 'EOF'
# MIT License © 2025 Motohiro Suzuki
"""
tools/ci_summary_gate.py (Stage186)

Purpose:
- Ensure out/reports/summary.md exists.
- Sync it to repo root summary.md for humans/reviewers.
- Do NOT fail on FAIL/PASS content; failure is handled by matrix.exit in workflow.
"""

import sys
from pathlib import Path

REPORT = Path("out/reports/summary.md")
ROOT_SUMMARY = Path("summary.md")


def main() -> int:
    if not REPORT.exists():
        print(f"[FAIL] report not found: {REPORT}")
        return 2

    text = REPORT.read_text(encoding="utf-8", errors="replace")
    ROOT_SUMMARY.write_text(text, encoding="utf-8")
    print("[OK] summary exists; synced to summary.md")
    return 0


if __name__ == "__main__":
    sys.exit(main())
EOF
