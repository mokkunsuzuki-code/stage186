cd ~/Desktop/test/stage186

cat > tools/ci_run_matrix.sh << 'EOF'
#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# tools/ci_run_matrix.sh  (Stage186)
#
# Purpose:
# - Run docker compose "matrix" in CI.
# - Always generate host-side evidence files:
#     - out/reports/matrix.log
#     - out/reports/summary.md
# - Fail CI if matrix returns non-zero.

set -euo pipefail

echo "[stage186] running docker compose matrix..."

if [ ! -f "docker/docker-compose.yml" ]; then
  echo "[FAIL] docker/docker-compose.yml not found"
  exit 2
fi

mkdir -p out/reports proof

GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")"
export GIT_COMMIT

# Run matrix and capture logs
set +e
docker compose -f docker/docker-compose.yml run --rm --build matrix 2>&1 | tee out/reports/matrix.log
rc=${PIPESTATUS[0]}
set -e

if [ "$rc" -ne 0 ]; then
  echo "[FAIL] matrix returned non-zero: $rc" | tee -a out/reports/matrix.log
  # Create a summary even on failure (useful for artifacts), but still fail CI.
  cat > out/reports/summary.md << SUMMARY
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=${rc})

See: out/reports/matrix.log
SUMMARY
  exit "$rc"
fi

# If matrix didn't generate a summary itself, create a minimal one.
# (Even if it did, we overwrite with a canonical Stage186 summary to stabilize CI.)
cat > out/reports/summary.md << SUMMARY
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: PASS

Artifacts:
- out/reports/matrix.log
- out/reports/summary.md
SUMMARY

echo "[OK] matrix run completed and summary generated"
EOF

chmod +x tools/ci_run_matrix.sh
