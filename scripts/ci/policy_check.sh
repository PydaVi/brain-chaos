#!/usr/bin/env bash
set -euo pipefail

if [[ ! -d "k8s/security/kyverno" ]]; then
  echo "No kyverno policies directory found. Skipping policy checks."
  exit 0
fi

mapfile -t POLICIES < <(find k8s/security/kyverno -type f -name '*.yaml' ! -name 'kustomization.yaml' | sort)
if [[ ${#POLICIES[@]} -eq 0 ]]; then
  echo "No Kyverno policy files found. Skipping policy checks."
  exit 0
fi

TMP_MANIFEST=".kyverno-rendered.yaml"
trap 'rm -f "$TMP_MANIFEST"' EXIT

kustomize build k8s/overlays/local > "$TMP_MANIFEST"

docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  ghcr.io/kyverno/kyverno:v1.12.6 \
  apply "${POLICIES[@]}" --resource "$TMP_MANIFEST"
