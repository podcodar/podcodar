# CI Pipelines

This repository uses GitHub Actions to enforce quality gates on pull requests and pushes to `main`.

## Workflows

- Elixir job: checks formatting, compiles with warnings as errors, and runs tests.
- Deno validation: validates `priv/repo/data/courses.json` using `scripts/validate.ts`.
- Assets build: builds Tailwind and esbuild via `mix assets.build`.
  - Note: The Dockerfile compiles before asset build for production releases to ensure phoenix-colocated modules exist when esbuild runs.
- Quality gateway: requires all the above jobs to pass before merge.

## Triggers

- On `push` and `pull_request` targeting `main`.

## Local development

- Format check: `mix format --check-formatted`
- Lint/compile strictly: `mix compile --warning-as-errors`
- Run tests (with DB setup alias): `mix test`
- Build assets: `mix assets.build`
- Pre-commit all-in-one: `mix precommit`
- Validate courses JSON with Deno:

```bash
# Requires Deno 2.x
deno run --allow-read scripts/validate.ts priv/repo/data/courses.json
```

## Notes

- CI caches Mix `_build` and `deps` to speed up runs.
- SQLite3 is installed in CI for Ecto SQL tests.
- Deno uses `deno.json` for npm import of `zod`.
