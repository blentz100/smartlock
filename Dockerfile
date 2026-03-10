# syntax = docker/dockerfile:1

ARG ELIXIR_VERSION=1.15.7
ARG OTP_VERSION=26.1
ARG DEBIAN_VERSION=bullseye-20231009-slim

#ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG BUILDER_IMAGE="hexpm/elixir:1.20.0-rc.3-erlang-26.2.5.14-debian-bookworm-20260223"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# ---- Build Stage ----
FROM ${BUILDER_IMAGE} AS builder

RUN apt-get update -y && \
    apt-get install -y build-essential git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config config
COPY lib lib
COPY priv priv
COPY assets assets

RUN mix compile
RUN mix release

# ---- Runtime Stage ----
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
    apt-get install -y openssl libstdc++6 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/* ./

CMD ["bin/server"]

COPY --from=builder /app/_build/prod/rel/smartlock ./
CMD ["bin/smartlock", "start"]