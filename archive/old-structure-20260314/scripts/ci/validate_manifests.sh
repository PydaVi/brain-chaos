#!/usr/bin/env bash
set -euo pipefail

mapfile -t kustomizations < <(find k8s -name kustomization.yaml -type f | sort)

if [[ ${#kustomizations[@]} -eq 0 ]]; then
  echo "No kustomizations found under k8s/."
  exit 1
fi

TMP_MANIFEST="$(mktemp)"
trap 'rm -f "$TMP_MANIFEST"' EXIT

for file in "${kustomizations[@]}"; do
  dir="$(dirname "$file")"
  echo "Building $dir"
  kustomize build "$dir" >> "$TMP_MANIFEST"
  printf '\n---\n' >> "$TMP_MANIFEST"
done

echo "Validating rendered manifests with kubeconform"
kubeconform \
  -strict \
  -ignore-missing-schemas \
  -summary \
  "$TMP_MANIFEST"
