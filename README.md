# Podcodar

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Docker (local)

Build and run with Docker Compose (SQLite persisted at `/data`):

```bash
docker compose up -d --build
```

Environment (compose sets defaults):

* `PHX_SERVER=true`
* `PHX_HOST=localhost`
* `PORT=4000`
* `DATABASE_PATH=/data/podcodar.db`
* `SECRET_KEY_BASE` (set a secure value for local use)

Stop:

```bash
docker compose down
```

## Fly.io (production)

Deploy using the included `fly.toml` and Dockerfile:

```bash
fly deploy
```

Key settings in `fly.toml`:

* `PORT=8080` env (Fly maps to container port)
* `internal_port = 4000` (Phoenix listens on 4000)
* SQLite file at `DATABASE_PATH=/data/podcodar.db`
* VM size: 256MB

## Assets

Build assets locally:

```bash
mix assets.build
```

## CI

See `docs/ci_pipelines.md` for details on the GitHub Actions workflow and how to run equivalent steps locally.

## Learn more

* Official website: [https://www.phoenixframework.org/](https://www.phoenixframework.org/)
* Guides: [https://hexdocs.pm/phoenix/overview.html](https://hexdocs.pm/phoenix/overview.html)
* Docs: [https://hexdocs.pm/phoenix](https://hexdocs.pm/phoenix)
* Forum: [https://elixirforum.com/c/phoenix-forum](https://elixirforum.com/c/phoenix-forum)
* Source: [https://github.com/phoenixframework/phoenix](https://github.com/phoenixframework/phoenix)
