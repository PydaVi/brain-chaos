#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-lab-app}"
SECRET_NAME="${SECRET_NAME:-ghcr-pull-secret}"
GHCR_SERVER="${GHCR_SERVER:-ghcr.io}"
GHCR_USERNAME="${GHCR_USERNAME:-${GITHUB_USERNAME:-}}"
GHCR_EMAIL="${GHCR_EMAIL:-devnull@example.com}"
GHCR_TOKEN="${GHCR_TOKEN:-}"

usage() {
  cat <<USAGE
Usage:
  GHCR_USERNAME=PydaVi GHCR_TOKEN=<token> ./scripts/lab/bootstrap_ghcr_pull_secret.sh

Optional env vars:
  NAMESPACE       Kubernetes namespace (default: lab-app)
  SECRET_NAME     Secret name (default: ghcr-pull-secret)
  GHCR_SERVER     Registry host (default: ghcr.io)
  GHCR_EMAIL      Docker email field (default: devnull@example.com)

Notes:
  - GHCR_TOKEN must have at least read:packages.
  - Token is never written to repository files.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -z "$GHCR_USERNAME" ]]; then
  echo "GHCR_USERNAME is required."
  usage
  exit 1
fi

if [[ -z "$GHCR_TOKEN" ]]; then
  read -r -s -p "Enter GHCR token (read:packages): " GHCR_TOKEN
  echo
fi

if [[ -z "$GHCR_TOKEN" ]]; then
  echo "GHCR_TOKEN is required."
  exit 1
fi

echo "Ensuring namespace ${NAMESPACE} exists"
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || kubectl create namespace "$NAMESPACE"

echo "Recreating secret ${SECRET_NAME} in namespace ${NAMESPACE}"
kubectl create secret docker-registry "$SECRET_NAME" \
  --namespace "$NAMESPACE" \
  --docker-server "$GHCR_SERVER" \
  --docker-username "$GHCR_USERNAME" \
  --docker-password "$GHCR_TOKEN" \
  --docker-email "$GHCR_EMAIL" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Verifying secret exists"
kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o name

echo "Done. ServiceAccount lab-app-sa will use ${SECRET_NAME} via GitOps manifests."
