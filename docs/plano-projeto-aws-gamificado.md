# Plano do Lab Pessoal — Kubernetes + Chaos Engineering + Cybersecurity (Local, Baixo Custo)

> **Contexto:** este plano é para **lab pessoal de aprendizado**, não para produto.
> **Objetivo:** aprender Kubernetes de verdade, com dados sintéticos, falhas reais (chaos) e ataques cibernéticos controlados.
> **Restrição:** rodar em máquina simples com **16GB RAM** e custo próximo de zero.

---

## 1) Missão do lab

Você vai montar um mini-ambiente de produção em Kubernetes, com serviços, banco e observabilidade, e depois submeter esse ambiente a:
- **falhas operacionais propositalmente injetadas** (chaos engineering);
- **ataques cibernéticos simulados e controlados** (red team de laboratório).

A regra é simples: cada falha/ataque precisa terminar com:
1. detecção (como percebeu),
2. contenção (como parou o impacto),
3. correção (como evitou recorrência),
4. evidência (logs, métricas, diff em manifest, runbook).

---

## 2) Objetivos de aprendizagem (K8s + Resiliência + Segurança)

Ao concluir, você deve dominar na prática:

### Kubernetes
- Deployments, StatefulSets, Services, Ingress;
- ConfigMaps, Secrets, Requests/Limits, HPA;
- probes (liveness/readiness/startup);
- RBAC, ServiceAccounts, NetworkPolicies;
- troubleshooting via `kubectl logs`, `describe`, `events`, `top`, `exec`.

### Resiliência
- comportamento sob perda de pod, latência, indisponibilidade e erro de configuração;
- rollback e hardening de config;
- melhoria de MTTD/MTTR com observabilidade.

### Segurança
- hardening de containers (não-root, capabilities mínimas, FS read-only);
- varredura de vulnerabilidades em imagens;
- segmentação por namespace e política default deny;
- mitigação de vazamento de segredos e permissões excessivas.

---

## 3) Arquitetura do lab (feita para 16GB)

## 3.1 Plataforma
- **Cluster local:** `k3d` (recomendado) com 1 control-plane + 2 workers.
- **SO host:** Linux, macOS ou WSL2.
- **Container runtime:** Docker.

## 3.2 Aplicação sintética (domínio: e-commerce)

Serviços em `lab-app`:
1. `web-frontend` (UI simples)
2. `api-gateway`
3. `orders-service`
4. `catalog-service`
5. `payments-mock`
6. `postgres` (stateful)
7. `redis`

Suporte:
- `synthetic-seeder` para gerar dados falsos diariamente;
- `job-traffic-generator` para gerar carga artificial (RPS baixo).

## 3.3 Observabilidade e segurança
- `lab-observability`: Prometheus + Grafana + Loki + Promtail;
- `lab-chaos`: LitmusChaos;
- `lab-security`: Trivy + Kyverno;
- `lab-redteam`: pods/scripts de ataque controlado.

---

## 4) Dados sintéticos (obrigatório)

Nunca usar dados reais. Use `Faker` para gerar:
- usuários fictícios,
- pedidos falsos,
- eventos de pagamento simulados,
- logs de auditoria sintéticos.

Padrões sensíveis também devem ser fictícios:
- CPF fake,
- email fake,
- token fake,
- cartão mascarado fake.

Regra do lab: **resetar e regerar dados** a cada ciclo grande (semanal ou por sprint).

---

## 5) Trilha de cenários (o coração do lab)

Cada cenário deve ter: objetivo, ataque/falha, sinais esperados, critérios de sucesso e evidências.

## 5.1 Cenários de Chaos Engineering

1. **Pod Kill em serviço crítico**
   - injeção: matar pods do `orders-service` aleatoriamente;
   - aprendizado: replicas, probes, tempo de recuperação.

2. **Latência e packet loss entre API e Postgres**
   - injeção: adicionar delay/perda de rede;
   - aprendizado: timeout, retry, circuit breaker, degradação graciosa.

3. **CPU stress no `catalog-service`**
   - injeção: carga artificial de CPU;
   - aprendizado: requests/limits e HPA corretamente ajustados.

4. **Erro de ConfigMap em produção**
   - injeção: config inválida;
   - aprendizado: rollback rápido e validação pré-deploy.

5. **Falha de DNS interno**
   - injeção: quebra de resolução de serviço por período curto;
   - aprendizado: diagnóstico de rede e fallback.

6. **Node drain inesperado**
   - injeção: simular indisponibilidade de worker;
   - aprendizado: agendamento, tolerations, anti-affinity.

## 5.2 Cenários de Cybersecurity (ataque controlado)

1. **Container privilegiado / root**
   - ataque: workload inseguro;
   - defesa: `securityContext` + policy Kyverno bloqueando.

2. **Segredo exposto em env/log**
   - ataque: token em variável e log;
   - defesa: rotação + remoção + redaction + externalização segura.

3. **Lateral movement entre namespaces**
   - ataque: tentativa de acesso de `lab-redteam` ao `lab-app`;
   - defesa: NetworkPolicy default deny + allowlist explícita.

4. **RBAC excessivo (cluster-admin indevido)**
   - ataque: exploração de ServiceAccount ampla;
   - defesa: least privilege + revisão de bindings.

5. **Imagem com CVE crítica**
   - ataque: deploy de imagem vulnerável;
   - defesa: scan no pipeline local + gate por severidade.

6. **Exfiltração simulada de dados sintéticos**
   - ataque: job tentando exportar dados para endpoint fake;
   - defesa: egress control + detecção + bloqueio.

---

## 6) Gamificação pessoal (simples, mas útil)

Você joga contra o relógio e contra a recorrência:

- +100: detectou rápido;
- +150: conteve sem derrubar o resto;
- +200: corrigiu causa raiz;
- +100: documentou runbook e prevenção;
- -150: correção que gera regressão;
- -200: solução sem RCA (Root Cause Analysis).

Fórmula:
`score = deteccao + contencao + correcao + documentacao - penalidades`

Níveis:
- Bronze: 0–999
- Prata: 1000–1999
- Ouro: 2000–2999
- Platina: 3000+

---

## 7) Roadmap prático (12 semanas)

## Semanas 1–2: Fundação do cluster
- subir k3d;
- criar namespaces, quotas e limites;
- publicar app mínima em K8s.

## Semanas 3–4: Observabilidade
- instalar Prometheus/Grafana/Loki;
- dashboards com latência, erro, reinício, CPU/memória;
- definir SLOs básicos.

## Semanas 5–6: Chaos básico
- executar cenários 1 e 2 de chaos;
- medir MTTD/MTTR;
- criar runbook dos incidentes.

## Semanas 7–8: Segurança de base
- aplicar RBAC mínimo e NetworkPolicy;
- hardening de pods;
- scan de imagens e correções.

## Semanas 9–10: Cyber ataques simulados
- executar 3 cenários cyber;
- gerar evidências e pós-mortem;
- repetir ataque após correção para validar mitigação.

## Semanas 11–12: Simulado final
- campeonato pessoal com 10 cenários mistos;
- metas: menor MTTR e zero regressão crítica;
- consolidar portfólio técnico (docs + manifests + lições aprendidas).

---

## 8) Rotina semanal (4 a 6 horas)

1. Subir ambiente limpo.
2. Rodar 1 cenário chaos.
3. Rodar 1 cenário cyber.
4. Corrigir e endurecer manifests/policies.
5. Repetir cenários para teste de regressão.
6. Atualizar placar e diário técnico.

---

## 9) Estrutura de repositório recomendada

- `k8s/base/` → namespaces, quotas, limites, policies base
- `k8s/apps/` → manifests/charts da app
- `k8s/observability/` → prometheus, grafana, loki
- `k8s/security/` → kyverno, rbac, network policies, pod security
- `scenarios/chaos/` → experimentos Litmus
- `scenarios/cyber/` → scripts de ataque controlado
- `data/synthetic/` → seeders e datasets
- `runbooks/` → guias de resposta
- `score/` → placar, métricas e evolução
- `docs/` → arquitetura, diário e retrospectivas

---

## 10) Guardrails (segurança e ética)

- executar apenas em ambiente local isolado;
- nunca expor serviços vulneráveis na internet pública;
- nunca reutilizar credenciais reais;
- não executar payload fora do escopo do lab;
- manter rastreabilidade de toda falha/ataque e correção.

---

## 11) Limites técnicos para 16GB RAM

Config sugerida:
- cluster pequeno (1 server + 2 agents);
- até 12–15 pods ativos simultâneos;
- observabilidade com retenção curta (24h–48h);
- desligar Grafana/Loki fora das sessões;
- requests/limits obrigatórios para todos os workloads.

Se pesar:
- reduzir réplicas para 1 em serviços não críticos;
- executar chaos e cyber em dias alternados;
- pausar stack de observabilidade fora de troubleshooting.

---

## 12) Fundação de CI/CD (antes da Sprint 1)

Decisões oficiais para este lab:
- **CI:** GitHub Actions;
- **CD:** GitOps com Argo CD;
- **Manifests:** Kustomize;
- **Registry de imagens:** GHCR (`ghcr.io`).

Objetivo da fundação:
- garantir que toda mudança em manifests, segurança e automação passe por validação antes de merge;
- manter rastreabilidade do estado desejado do cluster no Git;
- aprender fluxo de mercado de Kubernetes com baixo custo local.

### 12.1 Fluxo padrão (source of truth)

1. Dev abre PR.
2. GitHub Actions roda validações:
   - build de manifests com Kustomize;
   - validação de schema Kubernetes;
   - policy checks (Kyverno);
   - scan de segurança (Trivy).
3. Com merge em `main`, o pipeline:
   - builda imagem do `web-frontend`;
   - publica no GHCR com tag imutável (SHA curto);
   - propõe PR automático de atualização GitOps em `k8s/overlays/local/kustomization.yaml`.
4. Argo CD sincroniza o cluster local com estado do Git (`selfHeal` + `prune`).

### 12.2 Estrutura de CI/CD adotada no repositório

- `.github/workflows/ci-pr.yml`:
  - gate de PR para manifests, policy e segurança;
- `.github/workflows/build-publish.yml`:
  - build/push de imagem e PR automático de update GitOps;
- `.github/workflows/docs-guard.yml`:
  - bloqueia mudança de `k8s/`, `.github/` e `scripts/` sem atualizar este plano;
- `scripts/ci/`:
  - scripts versionados de validação, scan, policy e atualização de imagem;
- `k8s/argocd/`:
  - `AppProject` e `Application` para sincronizar overlay local.

### 12.3 Guardrails de qualidade e segurança

- Falha obrigatória no CI para:
  - manifest inválido;
  - policy Kyverno não atendida;
  - vulnerabilidade **CRITICAL** detectada pelo Trivy.
- Padrões de entrega:
  - não usar `latest` no GitOps;
  - promover imagem por tag imutável;
  - manter evidência de mudança por PR/commit.

### 12.4 Convenções obrigatórias de manutenção

- Toda mudança de plataforma (`k8s/`, `.github/`, `scripts/`) exige atualização deste documento;
- `k8s/overlays/local/kustomization.yaml` é o ponto de atualização automática de imagem;
- repositório configurado para integração Argo CD + GHCR: `PydaVi/brain-chaos`.

### 12.5 Critério de pronto para iniciar Sprint 1

Só iniciar “Semanas 1–2: Fundação do cluster” quando:
- CI de PR estiver verde com os gates ativos;
- workflow de build/publicação estiver enviando imagem para GHCR;
- Argo CD estiver aplicando o overlay local a partir de `main`;
- este documento estiver atualizado com qualquer ajuste de fluxo.

---

## 13) Métricas de progresso pessoal

- **MTTD**: tempo médio para detectar;
- **MTTR**: tempo médio para recuperar;
- **Taxa de bloqueio**: % de ataques que deixam de funcionar após hardening;
- **Taxa de regressão**: % de cenários que voltam a falhar;
- **Cobertura de runbooks**: quantos cenários têm playbook pronto.

Metas para 90 dias:
- reduzir MTTR em 40%;
- bloquear pelo menos 80% dos ataques da trilha inicial;
- manter regressão crítica abaixo de 10%.

---

## 14) Entrega final esperada (seu “portfólio de guerra”)

Ao final, você terá:
- ambiente Kubernetes funcional e resiliente;
- coleção de ataques simulados e respectivas defesas;
- runbooks e pós-mortems reutilizáveis;
- evidências concretas da sua evolução em cloud/k8s/security.

---

## 15) Próximos passos imediatos (esta semana)

1. Subir cluster k3d e validar saúde do cluster.
2. Concluir stack core do e-commerce no namespace `lab-app` (`api-gateway`, `orders-service`, `catalog-service`, `payments-mock`, `postgres`, `redis`).
3. Publicar dados sintéticos e validar fluxo mínimo ponta a ponta (`frontend -> api -> banco/cache`).
4. Só então criar namespaces dedicados (`lab-observability`, `lab-chaos`, `lab-security`, `lab-redteam`) com quotas/limites.
5. Iniciar observabilidade e depois cenários de chaos/cyber.

---

## 16) Checklist mestre de sprints (status em 24/02/2026)

Legenda:
- `[x]` concluído
- `[ ]` pendente

### Sprint 0 (pré-Semana 1) — Fundação de entrega
- [x] Definir padrão CI/CD: GitHub Actions + Argo CD + Kustomize + GHCR
- [x] Criar workflows (`ci-pr`, `build-publish`, `docs-guard`, `smoke-local`)
- [x] Criar scripts de validação (`kustomize`, `kubeconform`, Kyverno, Trivy)
- [x] Criar app mínima (`web-frontend`) com deploy em K8s
- [x] Integrar Argo CD com este repositório (`PydaVi/brain-chaos`)
- [x] Garantir app `brain-chaos-local` em `Synced` e `Healthy`
- [x] Atualizar este documento como guia oficial

### Sprint 1 (Semanas 1-2) — Fundação do cluster
- [x] Subir cluster `k3d` (1 server + 2 agents)
- [x] Publicar app mínima em Kubernetes (`web-frontend`)
- [x] Criar namespace `lab-app` com quota e limitrange
- [ ] Concluir stack core do e-commerce em `lab-app`: `api-gateway`, `orders-service`, `catalog-service`, `payments-mock`, `postgres`, `redis`
- [ ] Definir ConfigMaps/Secrets/ServiceAccounts da stack core
- [ ] Validar fluxo mínimo end-to-end com dados sintéticos
- [ ] Versionar `imagePullSecret` + `ServiceAccount` (evitar patch manual pós-deploy)
- [ ] Criar namespaces restantes: `lab-observability`, `lab-chaos`, `lab-security`, `lab-redteam`
- [ ] Definir quotas/limites para todos os namespaces do lab

### Sprint 2 (Semanas 3-4) — Observabilidade
- [ ] Instalar Prometheus
- [ ] Instalar Grafana
- [ ] Instalar Loki + Promtail
- [ ] Criar dashboards (latência, erro, reinício, CPU/memória)
- [ ] Definir SLOs básicos e alertas iniciais

### Sprint 3 (Semanas 5-6) — Chaos básico
- [ ] Executar cenário chaos 1 (pod kill em serviço crítico)
- [ ] Executar cenário chaos 2 (latência/perda entre API e Postgres)
- [ ] Medir MTTD/MTTR dos cenários
- [ ] Registrar runbooks e evidências

### Sprint 4 (Semanas 7-8) — Segurança de base
- [ ] Aplicar RBAC mínimo por serviço
- [ ] Aplicar NetworkPolicy (default deny + allowlist)
- [ ] Hardening de pods em todos os workloads
- [ ] Ativar e estabilizar gates de scan de imagem para stack completa

### Sprint 5 (Semanas 9-10) — Cyber ataques simulados
- [ ] Executar 3 cenários cyber controlados
- [ ] Documentar pós-mortem e evidências
- [ ] Reexecutar cenários após mitigação para validar bloqueio

### Sprint 6 (Semanas 11-12) — Simulado final
- [ ] Rodar campeonato com 10 cenários mistos
- [ ] Bater meta de MTTR e zero regressão crítica
- [ ] Consolidar portfólio final (`docs/`, manifests, runbooks, score)

### Destaque de amanhã (25/02/2026)

Objetivo: fechar a base funcional do e-commerce em `lab-app` antes de expandir para novos namespaces.

Checklist de amanhã:
- [ ] Criar manifests de `postgres` e `redis` em `k8s/apps/`
- [ ] Criar manifests de `api-gateway`, `orders-service`, `catalog-service`, `payments-mock`
- [ ] Montar overlay local com todas as dependências da stack core
- [ ] Validar fluxo mínimo (`frontend -> api -> postgres/redis`) com dados sintéticos
- [ ] Adicionar e versionar `imagePullSecret` + `ServiceAccount` dedicados (evitar patch manual)
- [ ] Executar PR de validação end-to-end (`ci-pr` verde + merge + `build-publish` + sync Argo)
- [ ] Depois da stack core estável, criar namespaces `lab-observability`, `lab-chaos`, `lab-security`, `lab-redteam` com quotas
