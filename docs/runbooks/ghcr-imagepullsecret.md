# Runbook: GHCR imagePullSecret (fora do Git)

Objetivo: manter credenciais do registry fora do repositório, com processo reprodutível para qualquer cluster local.

## Pré-requisitos
- `kubectl` apontando para o cluster correto.
- PAT do GitHub com escopo mínimo `read:packages`.
- Namespace alvo (`lab-app` por padrão).

## Bootstrap / rotação do segredo

```bash
GHCR_USERNAME=PydaVi GHCR_TOKEN=<SEU_TOKEN> ./scripts/lab/bootstrap_ghcr_pull_secret.sh
```

Com variáveis opcionais:

```bash
NAMESPACE=lab-app SECRET_NAME=ghcr-pull-secret GHCR_USERNAME=PydaVi GHCR_TOKEN=<SEU_TOKEN> ./scripts/lab/bootstrap_ghcr_pull_secret.sh
```

## Verificação

```bash
kubectl get secret ghcr-pull-secret -n lab-app
kubectl get sa lab-app-sa -n lab-app -o yaml | rg imagePullSecrets -n
```

## Troubleshooting

### Erro `ImagePullBackOff`
1. Verificar se o secret existe no namespace correto.
2. Confirmar se o token ainda está válido.
3. Reexecutar bootstrap para rotacionar.
4. Reiniciar deployment afetado:

```bash
kubectl rollout restart deployment/web-frontend -n lab-app
```

## Política adotada no projeto
- Apenas o **nome do secret** é versionado no Git (`lab-app-sa`).
- O valor do token **nunca** entra em YAML versionado.
- Rotação de token é operacional (runbook + script), não via commit.
