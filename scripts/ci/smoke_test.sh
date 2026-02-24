#!/usr/bin/env bash
set -euo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found, skipping smoke test"
  exit 0
fi

if ! kubectl get namespace lab-app >/dev/null 2>&1; then
  echo "Namespace lab-app does not exist, skipping smoke test"
  exit 0
fi

kubectl rollout status deployment/web-frontend -n lab-app --timeout=120s
kubectl get pods -n lab-app
