# MIT License © 2025 Motohiro Suzuki

# QSP Security Claims (A1–A5)

This document lists QSP security claims in a reviewer-friendly format.
Stage186 focuses on **CI evidence plumbing** (fail-with-evidence) and **claim visibility**.
Some protocol-level evidence may be marked as **TBD** until the corresponding
formal/implementation artifacts are wired in later stages.

## Claims Table

| ID | Claim (What we guarantee) | What it blocks / prevents | Evidence (Stage186) | Status |
|---:|---|---|---|---|
| A1 | **Fail-closed semantics**: if validation fails, the session must close and application data must not proceed. | Silent downgrade / continuing on corrupted state | CI plumbing exists to capture failures with evidence (`tools/ci_run_matrix.sh`, `tools/ci_summary_gate.py`, workflow artifacts). Protocol evidence: **TBD** | PARTIAL |
| A2 | **Handshake gating**: application data is only allowed after a completed handshake. | Data injection before authentication / pre-handshake confusion | CI visibility: claim is documented and linked from README. Protocol evidence: **TBD** | PARTIAL |
| A3 | **Epoch monotonicity**: epoch must move forward; replays/rollbacks are rejected. | Replay / rollback attacks | CI visibility: claim is documented and linked from README. Protocol evidence: **TBD** | PARTIAL |
| A4 | **Session binding**: messages are bound to the correct session context (no cross-session mix). | Session mix-up / wrong-session acceptance | CI visibility: claim is documented and linked from README. Protocol evidence: **TBD** | PARTIAL |
| A5 | **Key separation**: keys from different epochs/contexts remain separated (no key reuse across boundaries). | Key reuse / key-crossing between epochs | CI visibility: claim is documented and linked from README. Protocol evidence: **TBD** | PARTIAL |

## Evidence Index (Stage186)

- CI workflow: `.github/workflows/stage186-ci.yml`
- Matrix runner: `tools/ci_run_matrix.sh`
- Pytest matrix fallback: `tools/ci_matrix_pytest.sh`
- Summary gate: `tools/ci_summary_gate.py`
- Claim lint: `tools/ci_claim_lint.py`
- Minimal smoke tests: `tests/test_stage186_smoke.py`

## Notes

- “PARTIAL” means: the claim is **clearly stated and reviewer-visible**, and CI is already structured to attach evidence.
- Protocol-level proofs (formal lemmas, attack scenarios, implementation mappings) will be wired into the Evidence column as they are completed in later stages.
