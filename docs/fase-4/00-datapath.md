# Fase 4 — Cilium Datapath (L3/L4 e eBPF)

## Objetivo
Entender como o Cilium substitui o caminho de rede tradicional (iptables + kube-proxy) por programas eBPF no kernel, e onde as decisões de tráfego são tomadas.

## Onde o CNI entra na criação do Pod
Quando o kubelet cria um Pod, ele chama o runtime (containerd). O runtime chama o plugin CNI para:
1. Criar o namespace de rede do container.
2. Criar e conectar a interface veth do Pod.
3. Atribuir IP e rotas.

Sem o CNI, o Pod até poderia nascer, mas sem rede funcional. Com Cilium, esse passo inclui a instalação de programas eBPF no caminho de rede do kernel.

## Datapath tradicional (iptables)
No caminho tradicional, cada Service gera regras iptables para:
- DNAT (endereçar o ClusterIP para um Pod real).
- Balancear entre endpoints.

Em clusters maiores, isso vira milhares de regras. O custo aparece em:
- Tempo de atualização.
- Dificuldade de depuração.
- Performance em regras lineares.

## Datapath Cilium (eBPF)
Com Cilium:
- O tráfego passa por ganchos eBPF no kernel.
- As decisões de policy, NAT e load balancing são feitas em mapas eBPF.
- As regras não são milhares de linhas de iptables, mas estruturas de dados no kernel.

### Impacto prático
- Menor overhead em grandes clusters.
- Observabilidade de fluxo sem sidecar.
- Políticas de rede mais expressivas (incluindo L7).

## Onde a policy é aplicada
Quando um pacote entra ou sai do Pod, o Cilium aplica policy no kernel:
- L3/L4: IP, porta, protocolo.
- L7: método HTTP, path, host (quando L7 está habilitado via Envoy).

Se a policy não casar, o pacote é dropado antes de chegar no container.

## Observação importante
No nosso cluster, `kube-proxy-replacement` está como `false`. Isso significa:
- O kube-proxy ainda existe.
- O Cilium está responsável pela policy e observabilidade, mas não substituiu o kube-proxy.

Isso é intencional nesta fase para separar conceitos: primeiro entender Cilium como CNI e policy engine, depois substituir o kube-proxy.

## Perguntas de checagem
1. Em que momento o CNI é chamado durante a criação de um Pod, e o que ele configura?
2. Qual é a diferença entre aplicar uma regra L3/L4 e uma regra L7 no caminho de rede?

