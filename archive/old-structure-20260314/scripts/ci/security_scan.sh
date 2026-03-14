#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="${1:-.}"
SEVERITY="${SEVERITY:-CRITICAL}"

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  aquasec/trivy:0.58.1 \
  config --exit-code 1 --severity "$SEVERITY" "$TARGET_PATH"
