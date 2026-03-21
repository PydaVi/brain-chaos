# Fase 3 — Segurança de Cluster

## Objetivo
Isolar workloads e reduzir privilégios no cluster, com políticas explícitas e verificáveis.

## PodSecurity Admission
- Aplicado via labels no namespace `lab-app`.
- Modo atual: `baseline` (enforce/audit/warn).
- Bloqueia privilegiados e acessos a host.

## NetworkPolicy
- Default deny criado para `lab-app`.
- Observação: Flannel não aplica NetworkPolicy (efeito só após Cilium).

## RBAC
- ServiceAccount dedicado (`lab-app-sa`).
- Role mínima (`get/list/watch` de pods no namespace).
- RoleBinding ligando SA ao Role (least privilege).

## Kyverno
- Instalado via manifesto oficial (release tag) no namespace `lab-security`.
- Políticas em `Audit` para observar violações:
  - runAsNonRoot
  - readOnlyRootFilesystem
  - disallow privileged
  - disallow :latest
  - restrict capabilities

## Decisões
- Policies começam em Audit, migram para Enforce após validação.
- Segurança de rede só será efetiva com Cilium (Fase 4).

## Próximos passos
- Subir Kyverno no cluster e validar eventos.
- Evoluir `baseline` -> `restricted` no `lab-app`.
