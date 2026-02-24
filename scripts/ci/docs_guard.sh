#!/usr/bin/env bash
set -euo pipefail

BASE_REF="${1:-origin/main}"
PLAN_DOC="docs/plano-projeto-aws-gamificado.md"

CHANGED_FILES="$(git diff --name-only "$BASE_REF"...HEAD)"

if [[ -z "$CHANGED_FILES" ]]; then
  echo "No changed files detected."
  exit 0
fi

RELEVANT_PLATFORM_CHANGES="$(echo "$CHANGED_FILES" | grep -E '^(k8s/|\.github/|scripts/)' || true)"
NON_AUTOGEN_PLATFORM_CHANGES="$(echo "$RELEVANT_PLATFORM_CHANGES" | grep -v '^k8s/overlays/local/kustomization.yaml$' || true)"

if [[ -n "$NON_AUTOGEN_PLATFORM_CHANGES" ]]; then
  if ! echo "$CHANGED_FILES" | grep -Fx "$PLAN_DOC" >/dev/null 2>&1; then
    echo "Changes in k8s/.github/scripts require updating $PLAN_DOC"
    exit 1
  fi
fi

echo "Docs guard passed."
