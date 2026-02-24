#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:?IMAGE_REF is required}"
SEVERITY="${SEVERITY:-CRITICAL}"

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:0.58.1 \
  image --exit-code 1 --severity "$SEVERITY" "$IMAGE_REF"
