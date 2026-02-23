# Plano Solo Founder — Plataforma Gamificada AWS (Terraform + Incidente + Invasão)

> Versão refeita para execução por **1 pessoa** (você) com apoio de IA.
> Objetivo: lançar rápido, validar com clientes e só depois escalar complexidade.

## 1) Tese do produto (foco realista)

Você vai construir uma plataforma que cria ambientes AWS efêmeros via Terraform para treino técnico gamificado em 2 modos:

- **Modo Incidente:** o jogador precisa restaurar serviço, aumentar resiliência e automação.
- **Modo Invasão:** o jogador precisa bloquear cadeia de ataque e evitar vazamento de dados.

### Regra principal para solo founder
Se uma feature não ajudar a:
1) vender piloto,
2) provar resultado em segurança/confiabilidade,
3) reduzir custo operacional,
elas **não entra no MVP**.

---

## 2) Estratégia de execução solo (essencial)

## 2.1 Princípios de sobrevivência

1. **Um único cloud provider no início:** AWS apenas.
2. **Sem multi-tenant complexo no MVP:** 1 cliente por vez (tenant “semi-isolado”).
3. **Sem EKS no início:** usar ECS Fargate + Lambda para reduzir operação.
4. **Sem microserviços demais:** monolito modular no backend.
5. **Sem customização profunda na fase inicial:** catálogo pequeno de cenários padrão.
6. **Automatizar destruição de ambiente sempre:** custo e risco sob controle.

## 2.2 Meta de 90 dias

Entregar um produto funcional com:
- Provisionamento de laboratório em < 20 minutos.
- 3 cenários de Incidente + 3 cenários de Invasão.
- Score em tempo real.
- Relatório final com evidências.
- Painel simples para operar sessões manualmente.

---

## 3) Stack enxuta recomendada (para 1 pessoa)

## 3.1 Escolha final

- **Infra:** Terraform.
- **Backend/API + Orquestração leve:** Python (FastAPI).
- **Frontend:** Next.js (TypeScript).
- **Banco principal:** PostgreSQL (RDS ou Supabase no início, se preferir reduzir AWS).
- **Fila/eventos:** SQS + EventBridge (apenas o necessário).
- **Estado de sessão em tempo real:** Redis (ElastiCache) ou Postgres com polling no MVP.
- **Auth:** Auth0/Clerk/Cognito (não construir auth do zero).
- **Observabilidade:** CloudWatch + CloudTrail + GuardDuty + Security Hub.

## 3.2 Por que esse stack para solo founder

- Python acelera automação de segurança e scripting de cenários.
- FastAPI é simples e rápido para CRUD + jobs.
- Next.js entrega interface decente sem time de frontend.
- Terraform mantém tudo reproduzível e vendável para cliente enterprise.

---

## 4) Arquitetura MVP (simples e vendável)

## 4.1 Componentes mínimos

1. **Web App (Next.js):** login, criar sessão, iniciar cenário, ver score/eventos.
2. **API (FastAPI):** usuários, sessões, objetivos, placar, relatório.
3. **Scenario Runner (Python):** executa scripts de incidente/invasão.
4. **Terraform Runner:** sobe e derruba laboratórios efêmeros.
5. **Scoring Engine (no próprio backend):** calcula pontos por evidência.

## 4.2 Fluxo de execução

1. Você seleciona cenário no painel admin.
2. API dispara Terraform para criar ambiente da sessão.
3. Runner agenda eventos (incidentes ou ataques) com janelas de tempo.
4. Jogador atua no ambiente AWS sandbox.
5. Sistema coleta sinais (logs/eventos/alertas) e atualiza score.
6. Ao fim, gera relatório e destrói ambiente automaticamente.

---

## 5) Modos de jogo (MVP concreto)

## 5.1 Modo Incidente — 3 cenários iniciais

1. **Falha de serviço web:** task ECS parada; objetivo = restaurar saúde e uptime.
2. **Erro de segurança de rede:** regra SG bloqueando dependência crítica; objetivo = corrigir conectividade com mínimo risco.
3. **Saturação de recurso:** carga artificial em API; objetivo = auto-scaling + alerta útil.

### Critérios de pontuação (Incidente)
- Tempo de detecção.
- Tempo de recuperação.
- Qualidade da correção (evitou gambiarra insegura?).
- Se implementou automação/runbook reutilizável.

## 5.2 Modo Invasão — 3 cenários iniciais

1. **IAM excessivo:** política permissiva explorável; objetivo = conter escalonamento.
2. **S3 inseguro:** bucket com política ruim; objetivo = impedir leitura indevida/exfiltração.
3. **Secret exposto em app de laboratório:** objetivo = rotação + mitigação + bloqueio de uso.

### Critérios de pontuação (Invasão)
- Tempo até contenção.
- Etapas da kill chain interrompidas.
- Dados sensíveis preservados.
- Evidências geradas (forense mínima).

---

## 6) Modelo de dados mínimo (sem overengineering)

Tabelas principais:
- `users`
- `organizations`
- `sessions`
- `scenarios`
- `objectives`
- `signals`
- `score_events`
- `session_reports`

Armazenamento:
- **Postgres:** entidades transacionais.
- **S3:** artefatos de sessão, logs e relatórios em JSON/PDF.

---

## 7) Terraform para operar sem dor

## 7.1 Estrutura inicial

- `infra/terraform/modules/network`
- `infra/terraform/modules/iam`
- `infra/terraform/modules/ecs_lab`
- `infra/terraform/modules/observability`
- `infra/terraform/stacks/session_lab`

## 7.2 Regras práticas

- Um `stack/session_lab` parametrizado por `session_id`.
- TTL obrigatório por tag + job de limpeza.
- `terraform destroy` automático no encerramento ou timeout.
- Quotas por sessão (limites de custo).

---

## 8) Segurança e guardrails (obrigatório desde o dia 1)

1. Conta AWS dedicada para labs (nunca em produção).
2. IAM mínimo com permission boundaries.
3. SCP bloqueando serviços fora do escopo.
4. Bloqueio de regiões não usadas.
5. Logs de auditoria habilitados por padrão.
6. Dados de treino sintéticos (nunca PII real).
7. Chaves e segredos só via Secrets Manager.

---

## 9) “Espelhar” arquitetura do cliente sem se afogar

Você **não** vai clonar produção inteira no começo.

Use a abordagem de **clone funcional reduzido**:
- mapear apenas fluxo crítico (ex.: app → banco → fila),
- reproduzir padrões de risco,
- manter dados sintéticos,
- validar em workshop técnico com cliente.

### Processo simples
1. Entrevista técnica de 90 min.
2. Coleta de diagrama e IaC existente.
3. Seleção de 1 fluxo crítico.
4. Montagem do blueprint simplificado.
5. Aprovação e execução do piloto.

---

## 10) Roadmap solo founder (6 meses)

## Fase 1 — Semanas 1-4 (Fundação)
- Monorepo, CI básico, auth, CRUD de sessões.
- Runner Terraform funcional.
- Primeiro cenário de incidente end-to-end.

## Fase 2 — Semanas 5-8 (MVP técnico)
- Completar 3 cenários Incidente + 3 Invasão.
- Score engine simples e transparente.
- Relatório final de sessão.

## Fase 3 — Semanas 9-12 (MVP comercial)
- UX mínima para demo.
- Fluxo de onboarding manual de cliente.
- 2 pilotos pagos ou POC com chance real de contrato.

## Fase 4 — Semanas 13-24 (Tração)
- Melhorar estabilidade e observabilidade.
- Adicionar mais cenários por setor.
- Iniciar automação de onboarding.

---

## 11) Rotina semanal recomendada (solo)

- **Segunda:** produto + vendas (discovery com clientes).
- **Terça/Quarta:** desenvolvimento core.
- **Quinta:** cenários, testes de sessão, hardening.
- **Sexta:** conteúdo/demo, documentação e follow-up comercial.

Regra: 60% construir, 40% validar mercado.

---

## 12) KPIs que importam para 1 pessoa

## Produto/negócio
- Nº de pilotos ativos.
- Taxa de conversão piloto → contrato.
- Tempo para preparar uma sessão para cliente.

## Técnico
- Tempo de provisionamento do lab.
- Custo por sessão.
- Taxa de sessões concluídas sem erro crítico.

## Resultado do cliente
- Redução de MTTD/MTTR entre rodada 1 e 2.
- Nº de vulnerabilidades corrigidas após treino.

---

## 13) Custos e controle financeiro (essencial)

- Definir orçamento mensal fixo de AWS (ex.: US$ 300–800 no início).
- Encerrar labs automaticamente em 2h por padrão.
- Desligar recursos ociosos diariamente.
- Evitar serviços caros cedo (OpenSearch, EKS, NAT excessivo).
- Usar instâncias/serviços mínimos para demo.

---

## 14) Backlog priorizado (primeiros 45 dias)

## Must-have
1. Criar/destruir ambiente por sessão.
2. Login e gestão de sessões.
3. Runner de cenário com agenda de eventos.
4. Score básico por objetivos.
5. Relatório simples com timeline + pontos.

## Should-have
6. 3º cenário de cada modo.
7. Export de relatório em PDF.
8. Página de ranking da sessão.

## Won’t-have (agora)
- Marketplace de cenários.
- Multi-cloud.
- Clone automático completo da arquitetura do cliente.
- SIEM integrations complexas.

---

## 15) Estratégia comercial inicial (importantíssimo)

1. Escolher nicho único (ex.: SaaS B2B com time de 5-30 engenheiros).
2. Oferecer “Game Day de Segurança e Resiliência” como serviço piloto.
3. Entregar relatório executivo + técnico no mesmo dia.
4. Cobrar por sessão/pacote mensal.

### Oferta inicial sugerida
- **Plano Piloto (4 semanas):** 2 sessões + relatório + plano de melhoria.

---

## 16) Riscos reais do solo founder + mitigação

- **Risco:** tentar construir plataforma enterprise cedo demais.
  - **Mitigação:** escopo MVP estrito e backlog agressivo de corte.
- **Risco:** custo cloud sair de controle.
  - **Mitigação:** TTL, quotas e alertas de billing.
- **Risco:** pouca validação de mercado.
  - **Mitigação:** demos semanais e pilotos desde o mês 2.
- **Risco:** sobrecarga pessoal/burnout.
  - **Mitigação:** roadmap trimestral, rotina fixa e automação de tarefas repetitivas.

---

## 17) Decisão final objetiva (se fosse começar amanhã)

- **Backend único:** FastAPI + Postgres.
- **Frontend leve:** Next.js.
- **Infra lab:** Terraform + ECS Fargate + S3 + CloudWatch.
- **Orquestração:** Python runner + SQS/EventBridge.
- **Segurança:** GuardDuty + Security Hub + CloudTrail + IAM mínimo.
- **Produto:** 6 cenários totais (3 Incidente, 3 Invasão).

Com isso, você consegue lançar uma versão vendável sozinho, aprender com clientes reais e evoluir com segurança sem colapsar pela complexidade.
