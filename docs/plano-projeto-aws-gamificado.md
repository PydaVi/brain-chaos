# Plano Ultra-Enxuto (Baixo Custo) — Chaos + Segurança Gamificada para Engenheiros Cloud

> Versão otimizada para gastar **muito pouco** (ou quase zero).
> Ambiente principal: **local**, rodando em máquina simples com **16GB RAM**.
> Nuvem vira opcional para validação pontual, não para uso contínuo.

## 1) Objetivo do projeto

Criar uma plataforma/lab de treino para engenheiros de nuvem com foco em:
- **Resiliência (chaos engineering)**
- **Cibersegurança defensiva**
- **Gamificação leve** (score, objetivos, tempo)

Sem depender de conta AWS cara para cada sessão.

---

## 2) Princípio econômico (regra de ouro)

1. **Local-first por padrão**.
2. **Nuvem só em “modo validação”** (1 ou 2 cenários críticos, esporadicamente).
3. **Tudo efêmero** (sobe, roda, derruba).
4. **Open source sempre que possível**.
5. **Sem serviços gerenciados caros no MVP**.

---

## 3) Estratégia de arquitetura (baixo custo)

## 3.1 Duas opções de execução

### Opção A — 100% Local (recomendada no início)
- Docker Compose
- k3d (Kubernetes leve em Docker) **opcional**
- PostgreSQL local
- Redis local
- Aplicações-alvo vulneráveis/simuladas em containers
- Chaos com ferramentas open source

Custo: praticamente zero (energia + internet).

### Opção B — Híbrida (local + nuvem mínima)
- 90% dos cenários local
- 10% em nuvem (AWS Free Tier/Lightsail/conta de sandbox) para validar “realismo cloud”

Custo: baixo e controlado por orçamento mensal.

---

## 4) Stack recomendada (simples e barata)

- **Backend/Engine:** Python + FastAPI
- **Frontend:** Next.js (ou até UI simples com HTMX/Tailwind)
- **Banco:** PostgreSQL local (Docker)
- **Fila (se precisar):** Redis + RQ/Celery (somente se necessário)
- **Observabilidade local:** Prometheus + Grafana + Loki (ou só logs JSON no MVP)
- **Orquestração de cenários:** scripts Python + Makefile
- **Infra local:** Docker Compose (Kubernetes só depois)

### Por que isso?
- Você roda tudo na sua máquina.
- Sem cobrança por recurso em cloud.
- Ferramentas maduras e fáceis de automatizar com IA.

---

## 5) Design do produto (MVP realista para 1 pessoa)

## 5.1 Módulos mínimos

1. **Scenario Catalog**: lista de desafios (incidente e invasão).
2. **Session Runner**: sobe cenário local, injeta falha/ataque, controla tempo.
3. **Scoring Engine**: pontuação por evidências técnicas.
4. **Player Dashboard**: objetivos, tempo, eventos, score.
5. **Report Generator**: relatório final com ações corretas/incorretas.

## 5.2 Fluxo de sessão

1. Jogador escolhe cenário.
2. Runner sobe containers do cenário.
3. Sistema dispara incidente/ataque programado.
4. Jogador responde via terminal/arquivos/config.
5. Engine valida evidências e atualiza score.
6. Relatório final + teardown automático.

---

## 6) Cenários de Chaos (baixo custo, alta utilidade)

## 6.1 Incidente/Resiliência (3 iniciais)

1. **API instável por latência artificial**
   - Objetivo: restaurar SLO (latência/erro).
2. **Banco indisponível temporariamente**
   - Objetivo: retry/circuit breaker/timeout correto.
3. **Config quebrada em serviço crítico**
   - Objetivo: detectar rápido e aplicar rollback seguro.

### Ferramentas sugeridas
- Toxiproxy (latência/falha de rede)
- Pumba ou Chaos Mesh (se usar k8s depois)
- Scripts bash/python para matar/reiniciar containers

---

## 7) Cenários de Segurança (baixo custo, defensivo)

## 7.1 Invasão/Defesa (3 iniciais)

1. **Credencial vazada em .env**
   - Objetivo: rotacionar segredo e bloquear uso indevido.
2. **Permissão excessiva em serviço interno simulado**
   - Objetivo: aplicar least privilege e impedir acesso indevido.
3. **Endpoint vulnerável a input malicioso (lab controlado)**
   - Objetivo: corrigir validação + bloquear exploração + evidenciar resposta.

### Ferramentas sugeridas
- Trivy (scan de imagens/deps)
- Semgrep (SAST simples)
- OWASP ZAP baseline (scan web controlado)
- Falco (opcional, detecção em runtime)

---

## 8) Gamificação simples (sem overengineering)

- Pontos por objetivo cumprido.
- Bônus por tempo de resolução.
- Penalidade por correção insegura.
- Níveis por trilha (Bronze, Prata, Ouro).
- Ranking local por sessão.

### Fórmula simples de score
`score = objetivos*100 + bonus_tempo - penalidades`

---

## 9) Requisitos para máquina 16GB RAM

## 9.1 Envelope de recursos

- 6 a 10 containers simultâneos no máximo.
- Sem cluster k8s completo no começo.
- Grafana/Prometheus opcionais (ativar só quando precisar).
- Limitar memória por container (`mem_limit`).

## 9.2 Perfil sugerido

- SO: Linux (ou WSL2 no Windows)
- Docker Desktop/Engine
- 30GB+ livres em disco (imagens + logs)
- CPU 4+ cores (ideal)

---

## 10) Estrutura de repositório (enxuta)

- `apps/api` (FastAPI)
- `apps/web` (Next.js)
- `scenarios/chaos/*`
- `scenarios/security/*`
- `engine/runner/*`
- `engine/scoring/*`
- `infra/local/docker-compose.yml`
- `infra/local/makefile`
- `docs/*`

---

## 11) Roadmap econômico (12 semanas)

## Semanas 1-2 — Fundação local
- Setup monorepo
- Compose base
- Sessão simples (start/stop)

## Semanas 3-4 — Primeiro modo Chaos
- 1 cenário incident
- Score básico
- Relatório textual

## Semanas 5-6 — Primeiro modo Segurança
- 1 cenário invasão/defesa
- Validação por evidências

## Semanas 7-8 — Gamificação mínima
- Ranking
- Níveis
- Dashboard simples

## Semanas 9-10 — Estabilidade
- Teardown robusto
- Coleta de métricas essencial
- Melhorar UX

## Semanas 11-12 — Piloto
- Pacote demo completo (3 + 3 cenários)
- Teste com 3-5 engenheiros
- Feedback + ajustes

---

## 12) Custos estimados

## 12.1 Modo local
- Cloud: **R$ 0**
- Ferramentas: **R$ 0** (open source)
- Possível custo: domínio/host de landing page

## 12.2 Modo híbrido (opcional)
- AWS validação pontual: limite de orçamento (ex.: R$ 100-300/mês)
- Só subir recurso cloud durante demo específica
- Destruição automática obrigatória após teste

---

## 13) Quando usar AWS mesmo assim?

Somente para:
1. Validar 1 cenário “real cloud IAM/network” antes de vender para empresa.
2. Fazer demo enterprise pontual.
3. Testar integração com serviços reais de monitoramento cloud.

Nunca usar AWS como ambiente padrão de desenvolvimento diário.

---

## 14) KPIs úteis (baixo custo)

- Tempo médio para subir cenário local.
- Taxa de sessões sem erro técnico.
- Tempo de detecção e resposta do jogador.
- Custo mensal da operação (meta: próximo de zero).
- Satisfação dos usuários do piloto.

---

## 15) Riscos e mitigação

- **Risco:** máquina local sofrer com performance.
  - **Mitigação:** poucos containers, limites de memória, cenários curtos.
- **Risco:** pouca aderência “enterprise cloud”.
  - **Mitigação:** trilha híbrida opcional com 1-2 cenários AWS.
- **Risco:** escopo crescer demais.
  - **Mitigação:** backlog strict MVP (3 caos + 3 segurança).

---

## 16) Backlog priorizado (MVP)

## Must-have
1. Runner local de sessões
2. 3 cenários de chaos
3. 3 cenários de segurança
4. Score engine simples
5. Relatório final

## Should-have
6. Dashboard web básico
7. Ranking por usuário
8. Export JSON/PDF

## Won’t-have agora
- Multi-tenant enterprise
- Multi-cloud
- SIEM avançado
- Cluster Kubernetes completo

---

## 17) Decisão final (recomendação direta)

Se você quer manter a essência de chaos + segurança gastando pouco:

- Comece **100% local com Docker Compose**.
- Foque em cenários de engenharia que treinam resposta real.
- Use gamificação leve para engajamento.
- Só leve parte para AWS quando precisar validar venda enterprise.

Assim, você aprende rápido, entrega valor prático para engenheiros cloud e evita que o projeto morra por custo de infraestrutura.
