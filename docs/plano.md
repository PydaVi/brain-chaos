# Plano do lab brain-chaos

## Missão do lab

Você vai montar um mini-ambiente de produção em Kubernetes, com serviços, banco e observabilidade, e depois submeter esse ambiente a:
- **falhas operacionais propositalmente injetadas** (chaos engineering);
- **ataques cibernéticos simulados e controlados** (red team de laboratório).

A regra é simples: cada falha/ataque precisa terminar com:
1. detecção (como percebeu),
2. contenção (como parou o impacto),
3. correção (como evitou recorrência),
4. evidência (logs, métricas, diff em manifest, runbook).

---

## Arquitetura do lab

### Plataforma
- **Cluster local:** `k3d` (recomendado) com 1 control-plane + 2 workers.
- **SO host:** Linux, macOS ou WSL2.
- **Container runtime:** Docker.

### Aplicação sintética (domínio: e-commerce)

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

### Observabilidade e segurança
- `lab-observability`: Prometheus + Grafana + Loki + Promtail;
- `lab-chaos`: LitmusChaos;
- `lab-security`: Trivy + Kyverno;
- `lab-redteam`: pods/scripts de ataque controlado.

---

## Pipeline de referência (defesa + ataque + aprendizado)

```
pipeline CI/CD (defesa antes do deploy)
      ↓
cluster Kubernetes com app sintética
      ↓
chaos engineering injeta falhas operacionais  ←┐
red team simula ataques de segurança          ←┤  lab-chaos / lab-redteam
      ↓                                         │
observabilidade detecta (ou não detecta)        │
      ↓                                         │
você investiga, corrige, endurece               │
      ↓                                         │
gamificação mede o resultado ───────────────────┘
```

---

## Trilha de cenários unificada (chaos + cyber)

### Cenários de Chaos Engineering

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

### Cenários de Cybersecurity (ataque controlado)

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

## Gamificação

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

## Checklist vivo de sprints (Sprint 3 em diante)

### Sprint 3 — Segurança do pipeline + hardening base
- [ ] Trivy no CI — escanear imagem após build, bloquear se CVE CRITICAL
- [ ] Cosign — assinar imagem após scan passar
- [ ] Kyverno — verificar assinatura no deploy, bloquear imagem não assinada
- [ ] Kyverno — políticas adicionais: readOnlyRootFilesystem, no privileged, capabilities mínimas, no :latest tag
- [ ] NetworkPolicy default deny em todos os namespaces
- [ ] Allowlists mínimas de comunicação entre serviços
- [ ] RBAC review — remover permissões excessivas de service accounts

### Sprint 4 — Chaos Engineering básico
- [ ] LitmusChaos instalado no namespace lab-chaos
- [ ] Cenário 1: pod kill em orders-service — medir tempo de recuperação
- [ ] Cenário 2: latência entre api-gateway e postgres — timeout, retry, circuit breaker
- [ ] Runbooks com MTTD/MTTR e evidências para cada cenário
- [ ] Gamificação: registrar pontos do primeiro ciclo

### Sprint 5 — Runtime Security (Falco)
- [ ] Falco instalado via DaemonSet com driver eBPF
- [ ] Regras customizadas para o lab
- [ ] Alertas Falco integrados ao Loki/Grafana
- [ ] Exercício red team: simular cada ataque no lab-redteam e ver Falco alertar
- [ ] Documentar o que Falco detectou e o que passou despercebido

### Sprint 6 — Chaos Engineering avançado + Cyber ataques completos
- [ ] Cenário 3: CPU stress em catalog-service
- [ ] Cenário 4: erro de ConfigMap em produção
- [ ] Cenário 5: falha de DNS interno
- [ ] Cenário 6: node drain inesperado
- [ ] Cenário 1: container privilegiado / root (Kyverno deve bloquear)
- [ ] Cenário 2: segredo exposto em env/log
- [ ] Cenário 3: lateral movement entre namespaces (NetworkPolicy deve bloquear)
- [ ] Cenário 4: RBAC excessivo (cluster-admin indevido)
- [ ] Cenário 5: imagem com CVE crítica (Trivy deve bloquear)
- [ ] Cenário 6: exfiltração simulada de dados sintéticos

### Sprint 7 — Network Security (Cilium) — opcional/avançado
- [ ] Cilium como CNI (migração do CNI atual do k3d)
- [ ] CiliumNetworkPolicy com L7 — controlar por HTTP method/path
- [ ] Hubble habilitado — visualizar fluxo de rede entre pods
- [ ] NetworkPolicy entre lab-redteam e lab-app validada com Cilium

---

## Métricas de progresso pessoal

- **MTTD**: tempo médio para detectar;
- **MTTR**: tempo médio para recuperar;
- **Taxa de bloqueio**: % de ataques que deixam de funcionar após hardening;
- **Taxa de regressão**: % de cenários que voltam a falhar;
- **Cobertura de runbooks**: quantos cenários têm playbook pronto.
