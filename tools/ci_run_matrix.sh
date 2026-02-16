#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# tools/ci_run_matrix.sh
#
# Purpose:
# - Run the existing docker compose "matrix" test (attack scenarios) in CI.
# - Fail if docker compose returns non-zero.

set -euo pipefail

echo "[stage186] running docker compose matrix..."

if [ ! -f "docker/docker-compose.yml" ]; then
  echo "[FAIL] docker/docker-compose.yml not found"
  exit 2
fi

# Optional: embed git short sha into logs if available
GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")"
export GIT_COMMIT

# Ensure output dirs exist (some scripts assume them)
mkdir -p out/reports proof

# Run the matrix service (must exist in compose)
docker compose -f docker/docker-compose.yml run --rm --build matrix

echo "[OK] matrix run completed"
