# README


# Running locally under Docker

### Build containers

There are two process types in this app - one for the web UI, and one for the
sidekiq worker(s). So we have two separate containers, built from a common base.

To build:

```bash
# from the root directory:
docker build -f ./docker/base/Dockerfile -t mhclg/foi-submissions-base .
docker build -f ./docker/web/Dockerfile -t mhclg/foi-submissions-web .
docker build -f ./docker/worker/Dockerfile -t mhclg/foi-submissions-worker .
```

### Run web UI

NOTE: these commands assume:

1. You are working on a Mac OSX, and Docker v18+.
If you are not, then you'll need to substitute your machine's IP address in
place of docker.for.mac.host.internal

2. You have PostgreSQL and Redis running on your host machine, on default ports
(5432 and 6379). If not, you'll need to provide your own REDIS_URL and
DATABASE_URL

```bash
docker run -d -e RAILS_SERVE_STATIC_FILES=true \
              -e RAILS_ENV=production \
              -e DATABASE_URL=postgresql://deploy:(deploy users postgresql password)@docker.for.mac.host.internal:5432/(database name) \
              -e REDIS_URL=redis://docker.for.mac.host.internal:6379 \
              -p 3000:3000 \
              mhclg/foi-submissions-web
```

### Run worker

```bash
docker run -d -e RAILS_ENV=production \
              -e DATABASE_URL=postgresql://deploy:(deploy users postgresql password)@docker.for.mac.host.internal:5432/(database name) \
              -e REDIS_URL=redis://docker.for.mac.host.internal:6379 \
              mhclg/foi-submissions-worker
