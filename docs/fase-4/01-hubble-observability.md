# Fase 4 — Hubble Observability (L3/L4 e L7)

## Objetivo
Entender o que o Hubble observa, como ele coleta flows e como distinguir tráfego L3/L4 de L7.

## O que é o Hubble
Hubble é a camada de observabilidade do Cilium. Ele usa os mesmos ganchos eBPF do datapath para registrar cada fluxo de rede:
- Quem falou com quem.
- Em qual porta e protocolo.
- Se foi permitido ou bloqueado.
- E, quando L7 está habilitado, qual método HTTP e path foram usados.

## Componentes
- `hubble-relay`: agrega flows de vários nós.
- `hubble-cli`: client local que consulta o relay.
- `hubble-ui`: visualização web dos flows.

O relay roda no cluster. A CLI conecta no relay via `port-forward`.

## L3/L4 vs L7 na prática
### L3/L4
Você enxerga:
- IP de origem e destino.
- Porta e protocolo.
- Resultado (FORWARDED ou DROPPED).

Exemplo típico:
```
default/curl:55406 -> default/echo:5678 to-endpoint FORWARDED (TCP)
```

### L7
Você enxerga:
- Método HTTP.
- Path.
- Resultado (FORWARDED ou DROPPED).

Exemplo típico:
```
default/curl -> default/httpbin http-request FORWARDED (GET /headers)
```

## O que significa "EVENTS LOST"
Quando o buffer de eventos do Hubble está cheio, ele descarta alguns flows. Isso não quebra a policy, só reduz a visibilidade.

Impacto prático:
- Para tráfego intenso, você perde amostras.
- Em laboratório, é aceitável, mas em produção isso precisa tuning.

## Perguntas de checagem
1. Por que o Hubble consegue ver L7 sem sidecar em cada Pod?
2. O que significa `DROPPED` em um flow? Em que ponto isso acontece?

