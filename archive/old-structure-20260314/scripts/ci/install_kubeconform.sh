#!/usr/bin/env bash
set -euo pipefail

if command -v kubeconform >/dev/null 2>&1; then
  exit 0
fi

VERSION="v0.6.7"
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

if [[ "$ARCH" == "x86_64" ]]; then
  ARCH="amd64"
elif [[ "$ARCH" == "aarch64" ]]; then
  ARCH="arm64"
fi

URL="https://github.com/yannh/kubeconform/releases/download/${VERSION}/kubeconform-${OS}-${ARCH}.tar.gz"
curl -sSfL "$URL" -o /tmp/kubeconform.tar.gz
tar -xzf /tmp/kubeconform.tar.gz -C /tmp
sudo install -m 0755 /tmp/kubeconform /usr/local/bin/kubeconform
