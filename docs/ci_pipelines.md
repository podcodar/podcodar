# Pipelines de CI

Este repositório usa GitHub Actions para garantir a qualidade do código em pull requests e pushes para a branch `main`.

## Workflows

- Job Elixir: verifica a formatação, compila com warnings como erros e executa os testes.
- Validação Deno: valida o arquivo `priv/repo/data/courses.json` usando `scripts/validate.ts`.
- Build de assets: compila Tailwind e esbuild via `mix assets.build`.
  - Nota: O Dockerfile compila o código antes do build de assets para lançamentos de produção, garantindo que os módulos colocados pelo Phoenix existam quando o esbuild for executado.
- Gateway de qualidade: exige que todos os jobs acima passem antes do merge.

## Gatilhos

- Em `push` e `pull_request` direcionados à branch `main`.

## Desenvolvimento local

- Elixir:
  - Checagem de formatação: `mix format --check-formatted`
  - Lint/compilação estrita: `mix compile --warning-as-errors`
  - Executar testes (com alias de configuração do DB): `mix test`
  - Build de assets: `mix assets.build`
  - Pre-commit tudo-em-um: `mix precommit`
- Deno:
  - Validar JSON de cursos:
    ```bash
    # Requer Deno 2.x
    deno run --allow-read scripts/validate.ts priv/repo/data/courses.json
    ```

## Notas

- O CI armazena em cache os diretórios `_build` e `deps` do Mix para acelerar as execuções.
- O SQLite3 é instalado no CI para os testes Ecto SQL.
- O Deno usa o arquivo `deno.json` para importar o `zod` via npm.
