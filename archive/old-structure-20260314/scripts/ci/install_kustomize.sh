#!/usr/bin/env bash
set -euo pipefail

if command -v kustomize >/dev/null 2>&1; then
  exit 0
fi

VERSION="v5.4.2"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
fi

URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${VERSION}/kustomize_${VERSION#v}_${OS}_${ARCH}.tar.gz"
curl -sSfL "$URL" -o /tmp/kustomize.tar.gz
tar -xzf /tmp/kustomize.tar.gz -C /tmp
sudo install -m 0755 /tmp/kustomize /usr/local/bin/kustomize
