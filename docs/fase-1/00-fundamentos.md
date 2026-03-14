# Fase 1 — Fundamentos Kubernetes

## Control plane (arquitetura)

```text
+---------------------------+
|       kube-apiserver      |
|  (porta de entrada do API)|
+-------------+-------------+
              |
              v
+-------------+-------------+
|            etcd           |
|  (estado do cluster: Raft)|
+-------------+-------------+
              ^
              |
+-------------+-------------+
|       kube-scheduler      |
|  (decide em qual node)    |
+-------------+-------------+
              ^
              |
+-------------+-------------+
| kube-controller-manager   |
|  (reconcilia o desejado)  |
+---------------------------+
```

## Data plane (arquitetura)

```text
+---------------------------+
|          kubelet          |
|  (agente do node)         |
+-------------+-------------+
              |
              v
+-------------+-------------+
|        containerd         |
|  (runtime de containers)  |
+-------------+-------------+
              |
              v
+-------------+-------------+
|     Linux namespaces      |
|  (pid, net, mnt, ipc, uts)|
+-------------+-------------+
              |
              v
+-------------+-------------+
|        kube-proxy         |
|  (regras de Service)      |
+---------------------------+
```

## O que acontece em `kubectl apply -f pod.yaml`

1. O `kubectl` envia a requisição para o `kube-apiserver`.
2. O `kube-apiserver` valida o YAML (schema + admission) e grava o objeto no `etcd`.
3. O `kube-scheduler` observa o Pod em `Pending` e escolhe um node compatível.
4. O `kube-apiserver` atualiza o Pod com o `nodeName` escolhido.
5. O `kubelet` do node observa o Pod agendado para ele e cria o container via `containerd`.
6. O `containerd` cria o container e configura namespaces Linux e cgroups.
7. O `kubelet` reporta o status do Pod de volta ao `kube-apiserver`.
8. O `kube-proxy` programa regras de rede para Services relevantes.

## Namespace Linux vs Namespace Kubernetes

Namespace Linux isola recursos do kernel para processos. Exemplos: `pid`, `net`, `mnt`, `ipc`, `uts`.
Namespace Kubernetes é um escopo lógico dentro do cluster, usado para separar recursos e políticas.
Um Pod roda dentro de namespaces Linux, mas pertence a um namespace Kubernetes.

## cgroups (o que são e o que acontece no limite de memória)

cgroups são mecanismos do kernel que limitam e contabilizam recursos como CPU e memória.
Quando um container atinge o `memory limit`, o kernel pode disparar OOM e matar processos dentro do cgroup.
O kubelet percebe a saída do processo e marca o Pod como `OOMKilled`.
