# Podcodar

Para iniciar o servidor Phoenix:

* Execute `mix setup` para instalar e configurar as dependências
* Inicie o endpoint do Phoenix com `mix phx.server` ou dentro do IEx com `iex -S mix phx.server`

Agora você pode visitar [`localhost:4000`](http://localhost:4000) no seu navegador.

## Docker (local)

Compile e execute com o Docker Compose (o banco de dados SQLite será salvo em `/data`):

```bash
docker compose up -d --build
```

Ambiente (o Compose define os padrões):

* `PHX_SERVER=true`
* `PHX_HOST=localhost`
* `PORT=4000`
* `DATABASE_PATH=/data/podcodar.db`
* `SECRET_KEY_BASE` (defina um valor seguro para uso local)

Parar:

```bash
docker compose down
```

## Fly.io (produção)

Faça o deploy usando o `fly.toml` e o Dockerfile incluídos:

```bash
fly deploy
```

Principais configurações em `fly.toml`:

* `PORT=8080` (o Fly mapeia para a porta do contêiner)
* `internal_port = 4000` (o Phoenix escuta na porta 4000)
* Arquivo SQLite em `DATABASE_PATH=/data/podcodar.db`
* Tamanho da VM: 256MB

## Assets

Compile os assets localmente:

```bash
mix assets.build
```

## CI

Consulte `docs/ci_pipelines.md` para obter detalhes sobre o workflow do GitHub Actions e como executar os passos equivalentes localmente.

## Saiba mais

* Site oficial: [https://www.phoenixframework.org/](https://www.phoenixframework.org/)
* Guias: [https://hexdocs.pm/phoenix/overview.html](https://hexdocs.pm/phoenix/overview.html)
* Documentação: [https://hexdocs.pm/phoenix](https://hexdocs.pm/phoenix)
* Fórum: [https://elixirforum.com/c/phoenix-forum](https://elixirforum.com/c/phoenix-forum)
* Código-fonte: [https://github.com/phoenixframework/phoenix](https://github.com/phoenixframework/phoenix)
