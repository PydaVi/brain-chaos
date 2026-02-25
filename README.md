# Brain Chaos Lab

Lab pessoal para aprender Kubernetes, GitOps, Chaos Engineering e Cybersecurity em ambiente local (k3d), com foco em prática real e baixo custo.

## Estado atual (24/02/2026)

### Ja implementado
- Cluster local `k3d` (1 control-plane + 2 workers)
- GitOps com Argo CD apontando para este repo
- Pipeline CI/CD com GitHub Actions + GHCR
- Estrutura Kustomize (`k8s/base`, `k8s/apps`, `k8s/overlays`)
- Policy Kyverno inicial (`runAsNonRoot`)
- App minima `web-frontend` publicada e sincronizada via Argo CD
- Manifests da stack core criados: `api-gateway`, `orders-service`, `catalog-service`, `payments-mock`, `redis`, `postgres`

### Rodando agora
- Namespace: `lab-app`
- Deployment: `web-frontend`
- Service: `web-frontend` (ClusterIP)
- Argo CD App: `brain-chaos-local` com status esperado `Synced/Healthy`

### Ainda nao implementado
- Logica de negocio real nos servicos do e-commerce (hoje estao como placeholders HTTP)
- Observabilidade (Prometheus/Grafana/Loki)
- Cenarios de chaos e cyber da trilha completa

## Estrutura do repositorio

- `apps/` codigo das aplicacoes
- `k8s/base/` namespace, quotas e limites base
- `k8s/apps/` manifests das aplicacoes
- `k8s/overlays/` overlays por contexto (local/chaos/security)
- `k8s/argocd/` AppProject e Application do Argo CD
- `k8s/security/` policies e hardening
- `scripts/ci/` utilitarios de validacao/scan/update
- `.github/workflows/` pipelines CI/CD
- `docs/` guia oficial e bootstrap

## Como usar (quickstart)

1. Subir cluster local
```bash
k3d cluster create brain-chaos --servers 1 --agents 2 --k3s-arg "--disable=traefik@server:0"
kubectl config use-context k3d-brain-chaos
kubectl get nodes
```

2. Instalar Argo CD
```bash
kubectl create namespace argocd
kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -k k8s/argocd
```

3. Configurar acesso ao repo privado no Argo CD (token GitHub read-only) e sincronizar app `brain-chaos-local`.

4. Publicar imagem no GHCR e configurar `imagePullSecret` no namespace `lab-app`.

5. Validar saude
```bash
kubectl get app -n argocd
kubectl get all -n lab-app
```

6. Rodar validacao E2E com dados sinteticos
```bash
./scripts/lab/validate_e2e_synthetic.sh
```

## Documentacao principal

- Plano oficial: `docs/plano-projeto-aws-gamificado.md`
- Bootstrap CI/CD: `docs/cicd-bootstrap.md`
