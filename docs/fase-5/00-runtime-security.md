# Fase 5 — Runtime Security (Falco)

## Objetivo
Detectar comportamento suspeito **dentro do container**, em tempo real, usando syscalls.

## Por que Falco existe
Kyverno e Trivy atuam antes do container existir:
- Trivy bloqueia no CI.
- Kyverno valida no admission.

Mas quando o container já está rodando:
- Um atacante pode abrir shell.
- Ler arquivos sensíveis.
- Executar ferramentas de rede.

Falco cobre esse gap observando syscalls no kernel e emitindo alertas.

## Como funciona por dentro
- Falco roda como DaemonSet (um por nó).
- Usa eBPF para observar syscalls.
- Compara eventos contra regras (conditions).
- Emite alertas (output) com contexto do pod.

## O que ele não faz
- Não bloqueia. Só detecta.
- Pode gerar ruído se regras forem genéricas.

## Arquitetura no lab
- Namespace: `lab-security`
- ServiceAccount + RBAC somente leitura
- Regras customizadas em `falco-rules-local`

## Perguntas de checagem
1. Por que Falco precisa rodar como DaemonSet?
2. Em que ponto do sistema ele observa eventos: no kube-apiserver, no kubelet ou no kernel?

