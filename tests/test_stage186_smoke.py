# MIT License © 2025 Motohiro Suzuki
"""
Stage186 smoke tests

Purpose:
- Ensure pytest "matrix" has at least one meaningful test target.
- Validate minimal Stage186 CI artifacts exist in repo (reviewer-facing invariants).

These tests are intentionally lightweight and deterministic.
"""

from pathlib import Path


def test_stage186_required_files_exist():
    root = Path(__file__).resolve().parents[1]

    required = [
        root / ".github" / "workflows" / "stage186-ci.yml",
        root / "tools" / "ci_run_matrix.sh",
        root / "tools" / "ci_matrix_pytest.sh",
        root / "tools" / "ci_summary_gate.py",
        root / "tools" / "ci_claim_lint.py",
        root / "claims" / "CLAIMS.md",
        root / "README.md",
    ]

    missing = [p.as_posix() for p in required if not p.exists()]
    assert not missing, "Missing required Stage186 files:\n" + "\n".join(missing)


def test_ci_scripts_are_readable():
    root = Path(__file__).resolve().parents[1]
    scripts = [
        root / "tools" / "ci_run_matrix.sh",
        root / "tools" / "ci_matrix_pytest.sh",
    ]
    for s in scripts:
        assert s.exists(), f"script missing: {s}"
        text = s.read_text(encoding="utf-8", errors="replace")
        assert "Stage186" in text, f"script seems wrong/unexpected: {s}"
