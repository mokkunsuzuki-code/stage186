# MIT License © 2025 Motohiro Suzuki

# QSP Stage186
## Claims Visibility + Attack-Aware CI + Internet-Draft Integration

Stage186 elevates QSP from implementation-centric development
to reviewer-facing structured specification.

This stage integrates:

- 🔵 Evidence-preserving CI
- 🟢 Security Claim visibility (A1–A5)
- 🟣 Internet-Draft structured documentation
- 🛡 Explicit attack-model categorization

---

# 🔵 Continuous Integration (Fail with Evidence)

Stage186 ensures CI never fails silently.

Artifacts always generated:

- `out/reports/matrix.exit` (machine-readable result)
- `out/reports/matrix.log` (execution log)
- `out/reports/summary.md` (human-readable summary)

CI behavior:

- If matrix fails → exit code preserved → artifacts uploaded
- If matrix passes → deterministic PASS

Workflow:
`.github/workflows/stage186-ci.yml`

Matrix runner:
`tools/ci_run_matrix.sh`

Pytest fallback:
`tools/ci_matrix_pytest.sh`

---

# 🟢 Security Claims (A1–A5)

Full table: `claims/CLAIMS.md`

| ID | Claim | Prevents |
|----|-------|----------|
| A1 | Fail-Closed Semantics | Silent continuation after validation failure |
| A2 | Handshake Gating | Pre-handshake data injection |
| A3 | Epoch Monotonicity | Rollback / Replay |
| A4 | Session Binding | Cross-session mix-up |
| A5 | Key Separation | Cross-epoch key reuse |

Stage186 guarantees:

- Claims are reviewer-visible
- CI structure preserves evidence when violated
- Scope boundaries are explicit

---

# 🟣 Internet-Draft (I-D) Format

Structured draft:

`docs/draft-qsp-stage186-00.md`

Includes:

- Terminology
- Declared Security Claims
- Attack-model classification
- Security Considerations
- Non-goals
- Implementation status

Stage186 transitions QSP toward specification maturity.

---

# 🛡 Attack Model Classification

Stage186 explicitly categorizes:

- Replay attacks
- Epoch regression
- Session mix-up
- Pre-handshake injection
- Key reuse
- Downgrade attacks
- CI bypass risks
- Artifact tampering

Security Considerations define:

- What is mitigated
- What is partially mitigated
- What is out of scope

---

# 🧪 Minimal Smoke Validation

Tests:

`tests/test_stage186_smoke.py`

Ensures:

- Required CI files exist
- Stage186 invariants are structurally intact

---

# 🎯 Stage186 Scope

This stage does NOT:

- Introduce new cryptographic primitives
- Provide formal symbolic proofs
- Guarantee quantum-resistance proofs
- Modify handshake internals

It focuses on structured claims and evidence plumbing.

---

# 📈 Why Stage186 Matters

Stage186 transforms QSP into:

- An attack-aware specification
- A fail-with-evidence CI system
- A reviewer-visible claims framework

It establishes research posture over feature expansion.

---

# License

MIT License © 2025 Motohiro Suzuki

