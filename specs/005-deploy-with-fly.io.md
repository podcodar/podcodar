# Feature: Deploy with Fly.io

## Description

Set up a deployment pipeline using Fly.io to deploy the Elixir/Phoenix application to production.

## Tech Stack

- **Runtime**: Elixir 1.18.4, OTP 28
- **Framework**: Phoenix Framework
- **Database**: SQLite3
- **Memory Limit**: 256MB
- **Container**: Docker with docker-compose
- **Deployment**: Fly.io CLI
- **Validation**: Deno 2.5.0, TailwindCSS/DaisyUI

## Requirements

### 1. Dockerfile

Create `Dockerfile` with:

- Multi-stage build for Elixir/Phoenix application
- Base image: `elixir:1.18.4`
- SQLite3 database setup
- Memory limit: 256MB
- Production-optimized build

### 2. Docker Compose

Create `docker-compose.yml` with:

- Application service configuration
- Environment variables for production
- Port mapping (4000:4000)
- Volume mounts for SQLite data

### 3. Fly.io Configuration

Create `fly.toml` with:

- App name and region configuration
- Memory limit: 256MB
- Environment variables
- Health check endpoints
- Build and deploy settings

## Definition of Done

- [ ] `Dockerfile` created and builds successfully
- [ ] `docker-compose.yml` created and runs application locally
- [ ] `fly.toml` created with proper configuration
- [ ] Application deploys to Fly.io without errors
- [ ] Health checks pass in production
- [ ] Application accessible via Fly.io URL

## Testing Commands

```sh
docker compose up -d
```

```sh
fly deploy
```

```sh
fly logs
```

## Example fly.toml

This is an example of the `fly.toml` file for a `m3o` application that deploy a Golang application.

```toml
app = 'm3o'
primary_region = 'gru'

[build]
  build-target = "production"

[env]
  host = "0.0.0.0"
  port = "8080"
  env = "production"
  db_url="/data/test.db"

[http_service]
  internal_port = 8090
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1
  max_machines_running = 1
  processes = ['app']

[[vm]]
  memory = '256mb'
  cpu_kind = 'shared'
  cpus = 1
```
