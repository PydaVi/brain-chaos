#!/usr/bin/env bash
set -euo pipefail

cluster_name="brain-chaos"

if ! command -v k3d >/dev/null 2>&1; then
  echo "k3d not found in PATH. Install k3d before running this script." >&2
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found in PATH. Install kubectl before running this script." >&2
  exit 1
fi

echo "[1/3] Creating k3d cluster: ${cluster_name}"
k3d cluster create "${cluster_name}" \
  --servers 1 \
  --agents 2 \
  --k3s-arg "--disable=traefik@server:0"

echo "[2/3] Waiting for all nodes to be Ready"
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo "[3/3] Initial control plane state"
echo "- Nodes"
kubectl get nodes -o wide

echo "- Control plane pods (kube-system)"
kubectl get pods -n kube-system -o wide
