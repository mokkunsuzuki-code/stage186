#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# Stage186 – Real CI (fail with evidence)
#
# Guarantees (even if Docker/Compose is missing):
# - out/reports/matrix.log   (always created)
# - out/reports/summary.md   (always created)
# - out/reports/matrix.exit  (always created)
#
# NOTE:
# - This script ALWAYS exits 0.
# - The workflow decides PASS/FAIL based on matrix.exit.

set -euo pipefail

mkdir -p out/reports proof

GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")"

LOG="out/reports/matrix.log"
EXITF="out/reports/matrix.exit"
SUMMARY="out/reports/summary.md"

# Always create log file first
: > "${LOG}"

echo "[stage186] commit=${GIT_COMMIT}" | tee -a "${LOG}"
echo "[stage186] starting matrix..." | tee -a "${LOG}"

# Pick compose command
COMPOSE_CMD=""
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
fi

if [ -z "${COMPOSE_CMD}" ]; then
  echo "[FAIL] neither 'docker compose' nor 'docker-compose' is available on this runner." | tee -a "${LOG}"
  echo "127" > "${EXITF}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=127)
- reason: compose not available

See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

# Ensure compose file exists
if [ ! -f "docker/docker-compose.yml" ]; then
  echo "[FAIL] docker/docker-compose.yml not found" | tee -a "${LOG}"
  echo "2" > "${EXITF}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=2)
- reason: docker/docker-compose.yml missing

See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

# Run matrix and capture logs
set +e
# shellcheck disable=SC2086
${COMPOSE_CMD} -f docker/docker-compose.yml run --rm --build matrix 2>&1 | tee -a "${LOG}"
rc=${PIPESTATUS[0]}
set -e

echo "${rc}" > "${EXITF}"

if [ "${rc}" -ne 0 ]; then
  echo "[stage186] matrix failed (exit=${rc})" | tee -a "${LOG}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=${rc})

See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

echo "[stage186] matrix passed" | tee -a "${LOG}"
cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: PASS
SUMMARY_EOF

exit 0
