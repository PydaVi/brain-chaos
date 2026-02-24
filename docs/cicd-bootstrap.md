# CI/CD Bootstrap (Local Kubernetes Lab)

## 1) Configure placeholders

Replace placeholders before first run:
- `k8s/overlays/local/kustomization.yaml`: `ghcr.io/pydavi/brain-chaos/web-frontend`
- `k8s/argocd/application-lab-local.yaml`: `https://github.com/PydaVi/brain-chaos.git`

## 2) Enable branch protection in GitHub

Recommended minimum for `main`:
- Require pull request before merging
- Require status checks: `ci-pr / validate-manifests`, `ci-pr / policy-check`, `ci-pr / security-scan`, `docs-guard / docs-guard`
- Require conversation resolution
- Restrict force push

## 3) Install Argo CD on local cluster

Example:
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -k k8s/argocd
```

## 4) Verify GitOps sync

```bash
kubectl get applications -n argocd
kubectl get deploy -n lab-app
```
