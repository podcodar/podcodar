# Multi-stage Dockerfile for Podcodar (Phoenix) - Elixir 1.18.4, OTP 28

ARG ELIXIR_VERSION=1.18.4

FROM elixir:${ELIXIR_VERSION} AS build

ENV MIX_ENV=prod \
    LANG=C.UTF-8

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      curl \
      ca-certificates \
      pkg-config \
      libssl-dev \
      libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config ./config

RUN mix deps.get --only prod && \
    mix tailwind.install && \
    mix deps.compile

# Copy application source
COPY lib ./lib
COPY assets ./assets
COPY priv ./priv

# Compile first to generate phoenix-colocated modules, then build assets and release
RUN mix compile && \
    mix assets.deploy && \
    mix release

# Minimal runtime image
FROM debian:bookworm-slim AS runner

ENV LANG=C.UTF-8 \
    MIX_ENV=prod \
    SHELL=/bin/bash \
    PHX_SERVER=true

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      openssl \
      libstdc++6 \
      sqlite3 \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --create-home --shell /bin/bash app

WORKDIR /app

# Create data directory for SQLite database
RUN mkdir -p /data && chown -R app:app /data

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/podcodar ./

USER app

ENV DATABASE_PATH=${DATABASE_PATH:-/data/podcodar.db}

ENTRYPOINT ["/app/bin/podcodar"]

CMD ["start"]


