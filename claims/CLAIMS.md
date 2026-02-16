cd ~/Desktop/test/stage186
mkdir -p claims

cat > claims/CLAIMS.md << 'EOF'
# Claims Table (Stage186)

This file is a minimal claims baseline for Stage186 CI gates.
(Stage186-2 will expand this with full mapping: impl ↔ lemma ↔ attack.)

---

## Claim A2 — Epoch monotonicity

**Assumption**
- Honest peers increment epoch only via rekey/epoch transition rules.

**Evidence**
- Implementation: (to be linked in Stage186-2)
- Tests/Attacks: matrix includes epoch-related checks (to be linked)

---

## Claim A3 — Fail-closed semantics

**Assumption**
- Any protocol violation must terminate the session.

**Evidence**
- Implementation: (to be linked in Stage186-2)
- Tests/Attacks: matrix includes fail-closed scenarios (to be linked)

---

## Claim A4 — Key separation after rekey

**Assumption**
- KDF/HKDF context separation is correctly used across epochs.

**Evidence**
- Implementation: (to be linked in Stage186-2)
- Tests/Attacks: matrix verifies post-rekey separation properties (to be linked)

---

## Claim A5 — Downgrade resistance

**Assumption**
- Negotiation/mode selection is authenticated or otherwise verified.

**Evidence**
- Implementation: (to be linked in Stage186-2)
- Tests/Attacks: downgrade scenario must be rejected (to be linked)
EOF
