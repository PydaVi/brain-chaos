# Fase 1 — Exercícios

## Exercício 1 — Rastrear cada componente do control plane

O que fazer:
1. Suba o cluster com `scripts/lab/bootstrap-cluster.sh`.
2. Liste os Pods do namespace `kube-system`.
3. Identifique onde estão `kube-apiserver`, `etcd`, `kube-scheduler` e `kube-controller-manager`.

O que observar:
- Quais componentes estão como pods estáticos.
- Em qual node o control plane está rodando.
- Logs iniciais de cada componente.

Perguntas para responder:
1. O que acontece com o cluster se o `kube-apiserver` parar?
2. O que quebra se o `etcd` ficar indisponível?

## Exercício 2 — Criar um Pod e acompanhar a sequência de eventos

O que fazer:
1. Crie um Pod simples com `kubectl run` ou um YAML mínimo.
2. Descreva o Pod com `kubectl describe pod`.
3. Observe o status de `Pending` para `Running`.

O que observar:
- Eventos emitidos pelo scheduler.
- Tempo entre criação e execução do container.
- Mudanças de status no `kubectl get pod -w`.

Perguntas para responder:
1. Qual etapa decide em qual node o Pod vai rodar?
2. Qual componente cria o container de fato?

## Exercício 3 — Matar o kubelet em um node e observar o control plane

O que fazer:
1. Em um node worker, pare o processo do kubelet.
2. Observe o status do node no control plane.
3. Espere o tempo de tolerância e observe a reação do scheduler.

O que observar:
- Quando o node muda para `NotReady`.
- Se Pods são reprogramados para outro node.
- Eventos de `NodeNotReady` no cluster.

Perguntas para responder:
1. Como o control plane detecta que o kubelet morreu?
2. O que acontece com Pods que estavam nesse node?

## Exercício 4 — Inspecionar o etcd diretamente

O que fazer:
1. Acesse o `etcd` (com `etcdctl`) dentro do container/pod correto.
2. Leia um recurso cru em formato key-value.

O que observar:
- Prefixos usados para armazenar recursos (`/registry/...`).
- Diferença entre o YAML do `kubectl` e o objeto armazenado.

Perguntas para responder:
1. Por que o `etcd` é considerado o coração do cluster?
2. O que acontece se o `etcd` corromper?
