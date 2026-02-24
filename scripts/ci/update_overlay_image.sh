#!/usr/bin/env bash
set -euo pipefail

IMAGE_REPO="${1:?IMAGE_REPO is required}"
IMAGE_TAG="${2:?IMAGE_TAG is required}"

pushd k8s/overlays/local >/dev/null
kustomize edit set image "web-frontend=${IMAGE_REPO}:${IMAGE_TAG}"
popd >/dev/null
