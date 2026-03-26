# Fase 5 — Exercicios (Falco)

## Exercício 1 — Validar DaemonSet
O que fazer:
1. Aplicar `k8s/security/falco`.
2. Verificar se o DaemonSet está `Ready` em todos os nós.

O que observar:
- 1 pod Falco por nó.
- Status `Running`.

Perguntas:
1. Por que o Falco precisa de `hostPID: true`?
2. O que acontece se ele não tiver acesso a `/proc`?

## Exercício 2 — Detectar shell em container
O que fazer:
1. Subir um pod simples no namespace `lab-app`.
2. Executar `/bin/sh` dentro dele.
3. Verificar o log do Falco.

O que observar:
- Alerta `Shell spawned in lab-app`.

Perguntas:
1. Qual syscall está sendo observada quando você executa `/bin/sh`?
2. Por que isso não aparece no kube-apiserver?

## Exercício 3 — Detectar leitura de /etc/shadow
O que fazer:
1. Dentro do mesmo pod, fazer `cat /etc/shadow`.
2. Verificar o log do Falco.

O que observar:
- Alerta `Sensitive file read in lab-app`.

Perguntas:
1. Esse alerta significa que o arquivo foi lido com sucesso ou só que houve tentativa?
2. O que você faria para bloquear isso, não apenas detectar?

