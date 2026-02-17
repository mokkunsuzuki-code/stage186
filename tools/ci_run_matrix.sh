cd ~/Desktop/test/stage186

cat > tools/ci_run_matrix.sh << 'EOF'
#!/usr/bin/env bash
# MIT License © 2025 Motohiro Suzuki
#
# tools/ci_run_matrix.sh (Stage186)
#
# Always produce host-side evidence files:
#   - out/reports/matrix.log
#   - out/reports/summary.md
#   - out/reports/matrix.exit
#
# IMPORTANT:
# - This script exits 0 even if the matrix fails.
# - The workflow fails at the end based on matrix.exit,
#   so artifacts are still uploaded.

set -euo pipefail

mkdir -p out/reports proof

GIT_COMMIT="$(git rev-parse --short HEAD 2>/dev/null || echo "nogit")"
echo "${GIT_COMMIT}" > out/reports/git_commit.txt

echo "[stage186] running docker compose matrix..."

set +e
docker compose -f docker/docker-compose.yml run --rm --build matrix 2>&1 | tee out/reports/matrix.log
rc=${PIPESTATUS[0]}
set -e

echo "${rc}" > out/reports/matrix.exit

if [ "${rc}" -ne 0 ]; then
  cat > out/reports/summary.md << SUMMARY
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: FAIL (exit=${rc})

See: out/reports/matrix.log
SUMMARY
  echo "[stage186] matrix failed (exit=${rc}) but artifacts were generated"
  exit 0
fi

cat > out/reports/summary.md << SUMMARY
# Stage186 CI Summary

- commit: ${GIT_COMMIT}
- matrix: PASS

Artifacts:
- out/reports/matrix.log
- out/reports/summary.md
SUMMARY

echo "[stage186] matrix passed"
exit 0
EOF

chmod +x tools/ci_run_matrix.sh
