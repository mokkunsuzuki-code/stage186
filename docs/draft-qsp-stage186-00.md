---
title: "QSP Stage186 - Claims Visibility and CI Evidence Model"
abbrev: "QSP-Stage186"
docname: draft-qsp-stage186-00
category: info
ipr: trust200902
submissiontype: independent
author:
 -
    ins: Motohiro Suzuki
    name: Motohiro Suzuki
    org: Independent Research
    email: (private)
---

# Abstract

This document describes Stage186 of the Quantum-Safe Protocol (QSP),
focusing on two primary goals:

1. Security Claim Visibility (A2–A5)
2. Continuous Integration (CI) Evidence Preservation

Stage186 does not introduce new cryptographic primitives.
Instead, it formalizes claim presentation and ensures CI failures
produce verifiable artifacts.

# Status of This Memo

This Internet-Draft is submitted for documentation and review purposes.
It is not an IETF working group item.

# 1. Introduction

QSP (Quantum-Safe Protocol) is a hybrid protocol design aiming to
combine post-quantum cryptographic techniques with structured lifecycle control.

Stage186 introduces structured claim visibility and fail-with-evidence CI behavior.

# 2. Terminology

- **Epoch**: A strictly increasing lifecycle version identifier.
- **Handshake**: The process that establishes session validity.
- **Fail-closed**: Immediate termination on validation failure.
- **Matrix**: The CI validation execution (docker or pytest fallback).

# 3. Protocol Overview (Stage186 Scope)

Stage186 does not modify handshake or cryptographic primitives.
Instead, it standardizes:

- Claims documentation (A1–A5)
- CI enforcement of artifact generation
- Machine-readable exit codes (`matrix.exit`)
- Human-readable summary (`summary.md`)
- Log preservation (`matrix.log`)

# 4. Security Claims

The following claims are declared:

## A1 – Fail-Closed Semantics

If validation fails, the session MUST terminate.

## A2 – Handshake Gating

Application data MUST NOT be accepted before handshake completion.

## A3 – Epoch Monotonicity

Epoch values MUST strictly increase and rollback MUST be rejected.

## A4 – Session Binding

Messages MUST be bound to the correct session context.

## A5 – Key Separation

Keys from different epochs or contexts MUST remain separated.

# 5. Security Considerations

Stage186 ensures:

- CI failures preserve verifiable evidence.
- Claims are visible to reviewers.
- Exit codes are deterministic and machine-readable.
- Artifact preservation is mandatory.

Stage186 does not claim formal cryptographic proof.
Proof integration is deferred to later stages.

# 6. Non-Goals

Stage186 does NOT:

- Introduce new cryptographic algorithms.
- Provide formal symbolic proofs.
- Guarantee quantum attack resistance.
- Modify handshake structure.

# 7. Implementation Status

The following components are implemented:

- CI workflow: `.github/workflows/stage186-ci.yml`
- Matrix runner: `tools/ci_run_matrix.sh`
- Pytest fallback: `tools/ci_matrix_pytest.sh`
- Claims document: `claims/CLAIMS.md`
- Smoke tests: `tests/test_stage186_smoke.py`

# 8. IANA Considerations

This document has no IANA actions.

# 9. References

No normative external references are included in this stage.

