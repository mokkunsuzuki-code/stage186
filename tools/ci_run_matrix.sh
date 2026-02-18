#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# Stage186 – Real CI mode
#
# Guarantees:
# - Always produce:
#     out/reports/matrix.log
#     out/reports/summary.md
#     out/reports/matrix.exit
# - Never stop job here (exit 0)
# - Workflow decides final FAIL based on matrix.exit

set -euo pipefail

mkdir -p out/reports proof

GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")"

echo "[stage186] running docker compose matrix..."

set +e
docker compose -f docker/docker-compose.yml run --rm --build matrix \
  2>&1 | tee out/reports/matrix.log
rc=${PIPESTATUS[0]}
set -e

echo "${rc}" > out/reports/matrix.exit

if [ "${rc}" -ne 0 ]; then
  cat > out/reports/summary.md << SUMMARY
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=${rc})

See matrix.log for details.
SUMMARY
else
  cat > out/reports/summary.md << SUMMARY
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: PASS
SUMMARY
fi

echo "[stage186] matrix finished (exit=${rc})"
exit 0
