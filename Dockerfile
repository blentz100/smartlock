# --- Builder stage ---
FROM hexpm/elixir:1.20.0-rc.3-erlang-26.2.5.14-debian-bookworm-20260223 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    inotify-tools \
    ca-certificates \
    openssl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Hex + Rebar
RUN mix local.hex --force && mix local.rebar --force

# Copy mix files and fetch deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy the rest of the app
COPY . .

# Compile assets (esbuild + tailwind + sass handled by Mix)
RUN MIX_ENV=prod mix assets.deploy

# Build release
RUN MIX_ENV=prod mix release

# --- Runtime stage ---
FROM debian:bookworm-slim AS runtime

# Install runtime deps (needed for SSL/certs)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    openssl \
 && rm -rf /var/lib/apt/lists/*

COPY priv/certs/prod-ca-2021.crt /etc/ssl/certs/prod-ca-2021.crt

WORKDIR /app

# Copy the built release
COPY --from=builder /app/_build/prod/rel/smartlock ./

# Set environment defaults
ENV HOME=/app
ENV MIX_ENV=prod
ENV REPLACE_OS_VARS=true
ENV LANG=C.UTF-8
ENV ELIXIR_ERL_OPTIONS="+fnu"

# Expose Phoenix port
EXPOSE 8080

# Launch the app
ENTRYPOINT ["bin/smartlock"]
CMD ["start"]