# Fase 4 — Exercicios (Cilium e Hubble)

## Exercício 1 — Validar datapath ativo
O que fazer:
1. Verificar `cilium status` e confirmar os DaemonSets.
2. Confirmar que o Cilium está gerenciando os pods (`Cluster Pods: X/Y managed by Cilium`).

O que observar:
- `cilium` e `cilium-envoy` em todos os nós.
- `cilium-operator` com 1 replica.

Perguntas:
1. Por que o Cilium precisa rodar como DaemonSet?
2. Por que o operator é Deployment e não DaemonSet?

## Exercício 2 — Hubble L3/L4
O que fazer:
1. Rodar `cilium hubble enable` e `cilium hubble port-forward`.
2. Executar tráfego simples entre dois pods.
3. Observar os flows com `hubble observe --protocol tcp`.

O que observar:
- Flows com `FORWARDED`.
- Eventuais `EVENTS LOST` por buffer.

Perguntas:
1. O que significa `FORWARDED` no flow?
2. Qual diferença entre observar L3/L4 e L7?

## Exercício 3 — L7 HTTP com CiliumNetworkPolicy
O que fazer:
1. Subir `httpbin` e `curl` no namespace `default`.
2. Aplicar a policy `k8s/security/cilium/httpbin-l7.yaml`.
3. Fazer duas requisições:
   - `GET /headers` (deve permitir).
   - `GET /status/403` (deve bloquear).
4. Observar no Hubble com `hubble observe --protocol http`.

O que observar:
- `FORWARDED` para `/headers`.
- `DROPPED` para `/status/403`.

Perguntas:
1. Em que ponto a requisição é bloqueada: no app ou antes de chegar no app?
2. O que muda se a policy estiver em `allow all` no L3, mas restrita no L7?

