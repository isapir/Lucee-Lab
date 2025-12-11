Lucee Lab
=

Build images
==

To build all of the images:

```
docker compose build --progress=plain --no-cache
```

Alternatively, add service names after the `build` command to build specific images

Run services
==

- Adjust environment variables as needed in the `.env` file, `HOST_APP_WEBROOT`, `HOST_APP_LOGS`, versions, etc.

- Run Lucee and nginx with `docker compose up`

- Modify files in 

To run any of the other components use the `--profile` switch for each, e.g. to run with Postgres and Redis, run:

```
docker compose --profile=postgres --profile=redis up
```

Advanced
==

Multi-Arch Images:
===

To build `lucee-alpine` from the latest `tomcat-alpine`, make sure that ghcr.io has the `:latest` tomcat version at https://github.com/users/isapir/packages/container/tomcat-alpine/versions

To update the Tomcat version on ghcr.io:

1. Tag the newly built image with `latest`, e.g. `docker image tag ghcr.io/isapir/tomcat-alpine:9.0.113 ghcr.io/isapir/tomcat-alpine:latest`
2. Push the `latest` image, with `docker image push ghcr.io/isapir/tomcat-alpine:latest`

To build and push multi-arch images take the following steps:

1. Build the image, e.g. `docker compose build lucee`, on an AMD64 machine and tag it with a `-amd64` suffix
2. Build the image on an ARM64 machine and tag it with a `-arm64` suffix
3. Push both images to the container registry
4. Create a manifest referencing both images and push it to the registry

For example, to create lucee-alpine:5.4.1.8 and push it to the ghcr.io/isapir registry.  The example below assumes the Environment variable `LUCEE_VERSION=5.4.1.8`

On each architecture do the following:
======

Login to GitHub Container Registry using the username (in this example `isapir`) and access token created on https://github.com/settings/tokens

```
docker login ghcr.io
```

Build the image which will create locally (per build/lucee-alpine/Dockerfile) `ghcr.io/isapir/lucee-alpine:5.4.1.8`
```
docker compose build lucee
```

Tag the image with the architecture suffix on each machine and push it to ghcr.io, e.g. on amd64 CPU machine:

```
docker image tag ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION} \
    ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}-amd64

docker image push ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}-amd64
```

Do the same on the arm64 machine:

```
docker image tag ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION} \
    ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}-arm64

docker image push ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}-arm64
```

Once both are pushed we can create a manifest and upload it from either machine:

```
docker manifest create ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION} --amend \
    ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}-amd64 \
    ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}-arm64

docker manifest push ghcr.io/isapir/lucee-alpine:${LUCEE_VERSION}
```
