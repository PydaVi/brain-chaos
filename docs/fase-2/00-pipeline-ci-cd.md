# Fase 2 — CI/CD e Supply Chain Security

## Objetivo
Construir, escanear, assinar e publicar imagens com automação, deixando evidências auditáveis.

## O problema sem CI/CD
Sem pipeline, imagens vulneráveis ou adulteradas podem chegar ao cluster sem visibilidade.

## Fluxo do pipeline (resumo)
1. Build da imagem CI (ci/pipeline-image).
2. Scan de CVEs com Trivy (falha em HIGH/CRITICAL).
3. Geração de SBOM (CycloneDX) como artefato.
4. Push para GHCR (apenas em push na main).
5. Assinatura keyless com Cosign.

## Trivy (como funciona)
- Inspeciona camadas da imagem e pacotes instalados.
- Cruza com banco de CVEs e classifica severidade.
- Tradeoff: falsos positivos e visão pontual (point-in-time).

## SBOM
SBOM é a lista de dependências da imagem. Serve para auditoria e rastreio de CVEs futuros.

## Cosign keyless (autenticidade)
- Assina a imagem usando OIDC no GitHub Actions.
- Prova autenticidade, não segurança.
- Tradeoff: se o runner ou OIDC for comprometido, o atacante pode assinar.

## Limitações nesta fase
- Ainda não há validação de assinatura no cluster (isso entra na Fase 3 com Kyverno).
- Não há aplicação real (fase 7).

## Próximos passos
- Adicionar ArgoCD para CD.
- Preparar políticas de verificação de assinatura na Fase 3.
