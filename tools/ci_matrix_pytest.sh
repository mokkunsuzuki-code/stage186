#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# Stage186 – matrix runner (pytest fallback)
#
# Produces:
#   out/reports/matrix.log
#   out/reports/matrix.exit
#   out/reports/summary.md
#
# Exit policy:
# - Writes real pytest exit code to out/reports/matrix.exit
# - Exits 0 always (workflow decides)

set -euo pipefail

mkdir -p out/reports proof

LOG="out/reports/matrix.log"
EXITF="out/reports/matrix.exit"
SUMMARY="out/reports/summary.md"

: > "${LOG}"

echo "[stage186] pytest-matrix start" | tee -a "${LOG}"
python -V | tee -a "${LOG}" || true

python -m pip show pytest >/dev/null 2>&1 || python -m pip install pytest >/dev/null 2>&1 || true

set +e
python -m pytest -q 2>&1 | tee -a "${LOG}"
rc=${PIPESTATUS[0]}
set -e

echo "${rc}" > "${EXITF}"

if [ "${rc}" -eq 5 ]; then
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary
- matrix: FAIL (pytest exit=5: no tests collected)
Add at least one test under tests/.
See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

if [ "${rc}" -ne 0 ]; then
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary
- matrix: FAIL (pytest exit=${rc})
See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary
- matrix: PASS (pytest)
SUMMARY_EOF

exit 0
