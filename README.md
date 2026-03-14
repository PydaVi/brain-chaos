# brain-chaos

Laboratório Kubernetes local para aprender segurança Cloud Native com profundidade real.

A premissa é simples: você não aprende a defender um cluster lendo documentação.
Você aprende montando o ambiente, entendendo cada camada, simulando os ataques e medindo o que foi detectado, e o que passou despercebido.

---

## O que este lab cobre

```
Kubernetes internals → CI/CD seguro → políticas de cluster →
rede com eBPF → runtime security → observabilidade →
aplicação alvo → chaos engineering → red team → cenários mistos
```

Cada fase tem um objetivo de aprendizado, não de instalação.
O critério de avanço é entender por que a ferramenta funciona — não só tê-la rodando.

---

## Stack

| Camada | Ferramentas |
|--------|-------------|
| Cluster local | k3d, kubectl, helm |
| CI/CD e GitOps | GitHub Actions, GHCR, ArgoCD |
| Supply chain | Trivy, Cosign, Kyverno |
| CNI | Cilium, Hubble |
| Runtime security | Falco |
| Políticas de cluster | Kyverno, NetworkPolicy, RBAC |
| Observabilidade | Prometheus, Grafana, Loki, Alertmanager |
| Chaos | LitmusChaos |
| Aplicação alvo | e-commerce sintético (Go/Node) |

**Pré-requisitos:** Docker, k3d, kubectl, helm, conta no GitHub com Actions habilitado.

---

## Roteiro

O projeto tem 10 fases em ordem obrigatória.
Não existe atalho: cada fase depende do entendimento da anterior.

| Fase | Foco |
|------|------|
| 1 | Fundamentos Kubernetes — control plane, data plane, namespaces Linux, cgroups |
| 2 | CI/CD e Supply Chain — GitHub Actions, Trivy, Cosign, assinatura de imagem, ArgoCD |
| 3 | Segurança de cluster — Kyverno, RBAC, NetworkPolicy, PodSecurity |
| 4 | CNI com eBPF — Cilium, Hubble, L7 visibility, substituição do kube-proxy |
| 5 | Runtime security — Falco, syscalls, regras customizadas, integração com Loki |
| 6 | Observabilidade — Prometheus, Grafana, Loki, dashboard de segurança |
| 7 | Aplicação alvo — instrumentação, health checks, gerador de tráfego, baseline |
| 8 | Chaos Engineering — LitmusChaos, MTTD, MTTR, 6 cenários de falha |
| 9 | Red Team — 10 simulações de ataque mapeadas ao MITRE ATT&CK for Containers |
| 10 | Integração — chaos e ataque simultâneos, incidente real simulado |

---

## Como começar

```bash
# Suba o cluster
./scripts/lab/bootstrap-cluster.sh

# Estude os fundamentos da Fase 1
cat docs/fase-1/00-fundamentos.md

# Execute os exercícios e registre suas respostas
cat docs/fase-1/exercicios.md
```

A Fase 1 não instala nada além do cluster.
O objetivo é entender o que já existe antes de adicionar qualquer camada.

---

## Gamificação

Cada cenário de chaos ou red team termina com pontuação:

| Resultado | Pontos |
|-----------|--------|
| Detectou o evento (log, alerta, dashboard) | +100 |
| Conteve sem impacto nos outros serviços | +150 |
| Corrigiu a causa raiz | +200 |
| Documentou runbook reutilizável | +100 |
| Correção causou regressão | -150 |
| Solução sem RCA documentado | -200 |
| Ferramenta que deveria bloquear não bloqueou | -100 |

Placar em `score/placar.md`. Nível atual: Bronze.

---

## Estrutura do repositório

```
k8s/
  base/           # namespaces, quotas, limits
  apps/           # manifests da aplicação alvo
  security/       # Kyverno, Cilium, Falco, RBAC
  observability/  # Prometheus, Grafana, Loki
  argocd/         # AppProject, Application
  chaos/          # experimentos LitmusChaos

apps/             # código fonte dos serviços (Fase 7)

.github/
  workflows/      # pipelines CI/CD (Fase 2)

scenarios/
  chaos/          # documentação dos experimentos por fase
  cyber/          # documentação dos ataques por fase

docs/
  fase-N/         # notas, exercícios e decisões por fase
  runbooks/       # playbooks reutilizáveis

score/
  placar.md       # pontuação acumulada
```

---

## Contexto

Este laboratório é construído em paralelo ao [`witness`](https://github.com/PydaVi/witness), um proxy reverso HTTP/1.1 em Go puro.
Os dois projetos têm o mesmo DNA: aprendizado profundo, sem atalhos, com entendimento verificado a cada etapa.