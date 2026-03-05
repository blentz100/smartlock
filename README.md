## Development Setup

The project uses Postgres 15 running locally in Docker.

First-time setup (create container):

```
docker run --name smartlock-postgres \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASSWORD=postgres \
-e POSTGRES_DB=smartlock_dev \
-p 5432:5432 \
-d postgres:15
```

These credentials are for local development only.

Start Postgres:

```docker start smartlock-postgres```

Start the Phoenix server:

```mix phx.server```

Visit:
http://localhost:4000/locks