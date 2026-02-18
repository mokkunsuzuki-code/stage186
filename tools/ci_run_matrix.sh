#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# Stage186 – Real CI (fail with evidence)
#
# Guarantees:
# - Always create:
#     out/reports/matrix.log
#     out/reports/summary.md
#     out/reports/matrix.exit
# - Script always exits 0 (workflow decides PASS/FAIL using matrix.exit).
#
# Exit codes written into out/reports/matrix.exit:
# - 0   : matrix PASS
# - 2   : compose file not found
# - 127 : compose command not available
# - N   : underlying matrix command exit code

set -euo pipefail

mkdir -p out/reports proof

GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")"

LOG="out/reports/matrix.log"
EXITF="out/reports/matrix.exit"
SUMMARY="out/reports/summary.md"

# Always create log first
: > "${LOG}"

echo "[stage186] commit=${GIT_COMMIT}" | tee -a "${LOG}"
echo "[stage186] pwd=$(pwd)" | tee -a "${LOG}"
echo "[stage186] listing repo root:" | tee -a "${LOG}"
ls -la | tee -a "${LOG}" || true

# Choose compose command
COMPOSE_CMD=""
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
fi

if [ -z "${COMPOSE_CMD}" ]; then
  echo "[FAIL] neither 'docker compose' nor 'docker-compose' is available." | tee -a "${LOG}"
  echo "127" > "${EXITF}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=127)
- reason: compose command not available

See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

echo "[stage186] compose_cmd=${COMPOSE_CMD}" | tee -a "${LOG}"

# Auto-discover compose file path (value-max: avoid path brittleness)
CANDIDATES=(
  "docker/docker-compose.yml"
  "docker/docker-compose.yaml"
  "docker-compose.yml"
  "docker-compose.yaml"
  "docker/compose.yml"
  "docker/compose.yaml"
  "compose.yml"
  "compose.yaml"
)

COMPOSE_FILE=""
for f in "${CANDIDATES[@]}"; do
  if [ -f "${f}" ]; then
    COMPOSE_FILE="${f}"
    break
  fi
done

if [ -z "${COMPOSE_FILE}" ]; then
  echo "[FAIL] compose file not found. searched:" | tee -a "${LOG}"
  for f in "${CANDIDATES[@]}"; do
    echo "  - ${f}" | tee -a "${LOG}"
  done
  echo "[info] tree (docker/):" | tee -a "${LOG}"
  ls -la docker 2>/dev/null | tee -a "${LOG}" || echo "(no docker/ dir)" | tee -a "${LOG}"

  echo "2" > "${EXITF}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=2)
- reason: compose file not found (path mismatch)

Searched:
- docker/docker-compose.yml
- docker-compose.yml
- docker/compose.yml
- compose.yml

See: out/reports/matrix.log
SUMMARY_EOF
  exit 0
fi

echo "[stage186] compose_file=${COMPOSE_FILE}" | tee -a "${LOG}"
echo "[stage186] running matrix..." | tee -a "${LOG}"

set +e
# shellcheck disable=SC2086
${COMPOSE_CMD} -f "${COMPOSE_FILE}" run --rm --build matrix 2>&1 | tee -a "${LOG}"
rc=${PIPESTATUS[0]}
set -e

echo "${rc}" > "${EXITF}"

if [ "${rc}" -ne 0 ]; then
  echo "[stage186] matrix failed (exit=${rc})" | tee -a "${LOG}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=${rc})
- compose_file: ${COMPOSE_FILE}

See: out/reports/matrix.log
SUMMARY_EOF
else
  echo "[stage186] matrix passed" | tee -a "${LOG}"
  cat > "${SUMMARY}" << SUMMARY_EOF
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: PASS
- compose_file: ${COMPOSE_FILE}
SUMMARY_EOF
fi

exit 0
