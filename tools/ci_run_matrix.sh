#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# Stage186 – Real CI (fail with evidence)
#
# Strategy:
# - If a compose file exists AND compose cmd exists -> run docker matrix
# - Else -> run pytest fallback matrix
#
# Guarantees:
# - Always create out/reports/{matrix.log,matrix.exit,summary.md}
# - Always exit 0 (workflow decides)

set -euo pipefail
mkdir -p out/reports proof

# prefer docker matrix only if compose file exists
CANDIDATES=(
  "docker/docker-compose.yml"
  "docker-compose.yml"
  "docker/compose.yml"
  "compose.yml"
)

COMPOSE_FILE=""
for f in "${CANDIDATES[@]}"; do
  if [ -f "${f}" ]; then
    COMPOSE_FILE="${f}"
    break
  fi
done

COMPOSE_CMD=""
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
fi

if [ -n "${COMPOSE_FILE}" ] && [ -n "${COMPOSE_CMD}" ]; then
  echo "[stage186] using docker matrix: ${COMPOSE_CMD} -f ${COMPOSE_FILE}" > out/reports/matrix.log
  set +e
  # shellcheck disable=SC2086
  ${COMPOSE_CMD} -f "${COMPOSE_FILE}" run --rm --build matrix 2>&1 | tee -a out/reports/matrix.log
  rc=${PIPESTATUS[0]}
  set -e
  echo "${rc}" > out/reports/matrix.exit
  if [ "${rc}" -ne 0 ]; then
    printf "%s\n" "# Stage186 CI Summary" "- matrix: FAIL (docker exit=${rc})" "See: out/reports/matrix.log" > out/reports/summary.md
  else
    printf "%s\n" "# Stage186 CI Summary" "- matrix: PASS (docker)" > out/reports/summary.md
  fi
  exit 0
fi

# fallback to pytest matrix (value-max when compose not present)
bash tools/ci_matrix_pytest.sh
exit 0
